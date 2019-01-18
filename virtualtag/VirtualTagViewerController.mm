//
//  VirtualTagViewerController.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-08.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "VirtualTagViewerController.h"
#import <QCAR/QCAR.h>
#import <QCAR/QCAR_iOS.h>
#import <QCAR/QCAR.h>
#import <QCAR/TrackerManager.h>
#import <QCAR/ObjectTracker.h>
#import <QCAR/Trackable.h>
#import <QCAR/DataSet.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/UpdateCallback.h>
#import <QCAR/TargetFinder.h>
#import <QCAR/ImageTarget.h>
#import "NSString+Localized.h"
#import "ARSession.h"
#import "ARView.h"
#import "VirtualTag.h"
#import "Marker.h"
#import "VirtualTagRenderer.h"
#import "WebService.h"
#import "VirtualTagsMapViewController.h"
#import "VirtualTagInfoViewController.h"

const char* kAccessKey = "";
const char* kSecretKey = "";

const CGFloat kInitialMarkerImageWidth = 80;
const CGFloat kInitialMarkerImageHeight = 80;

@interface VirtualTagViewerController () <ARSessionDelegate>
{
    // QCAR initialisation flags (passed to QCAR before initialising)
    int mQCARInitFlags;
    QCAR::DataSet*  markerDataSet;
}

@property(nonatomic, strong) ARSession* arSession;
@property(nonatomic, assign) BOOL isActivityInPortraitMode;
@property(nonatomic, strong) UIImage* virtualTagRender;

@end

@implementation VirtualTagViewerController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arSession = [[ARSession alloc] initWithDelegate:self];
    
    ARView* arView = [[ARView alloc] initWithFrame:self.view.bounds usingARSession:self.arSession];
    [self.view insertSubview:arView atIndex:0];
    
    markerDataSet = nil;
    
    [self.backButton setTitle:[@"kBack" localized] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize arViewBoundsSize;
    arViewBoundsSize.width = self.view.frame.size.width * [UIScreen mainScreen].scale;
    arViewBoundsSize.height = self.view.frame.size.height * [UIScreen mainScreen].scale;
    
    [self.arSession initAR:QCAR::GL_20
          ARViewBoundsSize:arViewBoundsSize
               orientation:UIInterfaceOrientationPortrait];
    
    self.markerImageView.image = self.virtualTag.marker.image;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSError* error;
    [self.arSession stopAR:&error];
    if(error)
    {
        NSLog(@"%@",error);
    }
}

#pragma mark -
#pragma mark User Actions

-(IBAction)back:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(IBAction)like:(id)sender
{
    //TODO:
}

-(IBAction)showMarkerImage:(id)sender
{
    BOOL shouldEnlarge = self.markerImageWidthConstraint.constant == kInitialMarkerImageWidth;
    [[self.markerImageView superview] layoutIfNeeded];
    if(shouldEnlarge)
    {
        self.markerImageWidthConstraint.constant = self.view.frame.size.width;
        self.markerImageHeightConstraint.constant = self.view.frame.size.height;
    } else {
        self.markerImageWidthConstraint.constant = kInitialMarkerImageWidth;
        self.markerImageHeightConstraint.constant = kInitialMarkerImageHeight;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [[self.markerImageView superview] layoutIfNeeded];
        self.markerImageView.alpha = shouldEnlarge ? 0.6 : 1.0;
    }];
}

#pragma mark -
#pragma mark Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[VirtualTagsMapViewController class]])
    {
        //TODO: set the virtualTag identifier to focus
    } else if([segue.destinationViewController isKindOfClass:[VirtualTagInfoViewController class]])
    {
        VirtualTagInfoViewController* infoViewController = (VirtualTagInfoViewController*)segue.destinationViewController;
        infoViewController.virtualTag = self.virtualTag;
    }
}

#pragma mark -
#pragma mark Customization

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark AR Session Delegation

-(bool)doInitTrackers
{
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker* trackerBase = trackerManager.initTracker(QCAR::ObjectTracker::getClassType());
    // Set the visual search credentials:
    QCAR::TargetFinder* targetFinder = static_cast<QCAR::ObjectTracker*>(trackerBase)->getTargetFinder();
    if (targetFinder == NULL)
    {
        NSLog(@"Failed to get target finder.");
        return NO;
    }
    
    NSLog(@"Successfully initialized ObjectTracker.");
    return YES;
}

- (bool) doDeinitTrackers {
    return YES;
}

- (void) onInitARDone:(NSError *)initError
{
    if (initError == nil)
    {
        NSError * error = nil;
        [self.arSession startAR:QCAR::CameraDevice::CAMERA_BACK error:&error];
    } else {
        NSLog(@"Error initializing AR:%@", [initError description]);
        dispatch_async( dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"kARInitErrorTitle" localized]
                                                            message:[@"kARInitErrorMessage" localized]
                                                           delegate:nil
                                                  cancelButtonTitle:[@"kDismiss" localized]
                                                  otherButtonTitles:nil];
            [alert show];
        });
    }
}

- (bool) doLoadTrackersData {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    if (objectTracker == NULL)
    {
        NSLog(@">doLoadTrackersData>Failed to load tracking data set because the ImageTracker has not been initialized.");
        return NO;
        
    }
    
    // Initialize visual search:
    QCAR::TargetFinder* targetFinder = objectTracker->getTargetFinder();
    if (targetFinder == NULL)
    {
        NSLog(@">doLoadTrackersData>Failed to get target finder.");
        return NO;
    }
    
    NSDate *start = [NSDate date];
    
    // Start initialization:
    if (targetFinder->startInit(kAccessKey, kSecretKey))
    {
        targetFinder->waitUntilInitFinished();
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
        
        NSLog(@"waitUntilInitFinished Execution Time: %lf", executionTime);
    }
    
    int resultCode = targetFinder->getInitState();
    if ( resultCode != QCAR::TargetFinder::INIT_SUCCESS)
    {
        NSLog(@">doLoadTrackersData>Failed to initialize target finder.");
        if (resultCode == QCAR::TargetFinder::INIT_ERROR_NO_NETWORK_CONNECTION) {
            NSLog(@"CloudReco error:QCAR::TargetFinder::INIT_ERROR_NO_NETWORK_CONNECTION");
        } else if (resultCode == QCAR::TargetFinder::INIT_ERROR_SERVICE_NOT_AVAILABLE) {
            NSLog(@"CloudReco error:QCAR::TargetFinder::INIT_ERROR_SERVICE_NOT_AVAILABLE");
        } else {
            NSLog(@"CloudReco error:%d", resultCode);
        }
        return NO;
    } else {
        NSLog(@">doLoadTrackersData>target finder initialized");
    }
    
    return YES;
}

- (bool) doStartTrackers
{
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(
                                                                           trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    assert(objectTracker != 0);
    objectTracker->start();
    
    QCAR::TargetFinder* targetFinder = objectTracker->getTargetFinder();
    assert (targetFinder != 0);
    /*bool isVisualSearchOn = */targetFinder->startRecognition();
    
    return YES;
}

- (bool) doStopTrackers
{
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(
                                                                           trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    if(objectTracker != 0) {
        objectTracker->stop();
        
        // Stop cloud based recognition:
        QCAR::TargetFinder* targetFinder = objectTracker->getTargetFinder();
        if (targetFinder != 0) {
            /*bool isVisualSearchOn = !*/ targetFinder->stop();
        }
    }
    return YES;
}

- (bool) doUnloadTrackersData
{
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    if (objectTracker == NULL)
    {
        NSLog(@"Failed to unload tracking data set because the ObjectTracker has not been initialized.");
        return NO;
    }
    
    // Deinitialize visual search:
    QCAR::TargetFinder* finder = objectTracker->getTargetFinder();
    finder->deinit();
    return YES;
}

- (void) onQCARUpdate: (QCAR::State *) state
{
    //TODO: ONLY ENABLE THE TRACKABLE WITH THE RIGHT NAME (i.e. dataset)
    
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    QCAR::TargetFinder* finder = objectTracker->getTargetFinder();
    
    const int statusCode = finder->updateSearchResults();
    if (statusCode < 0)
    {
        // Show a message if we encountered an error:
        NSLog(@"update search result failed:%d", statusCode);
    }
    else if (statusCode == QCAR::TargetFinder::UPDATE_RESULTS_AVAILABLE)
    {
        // Iterate through the new results:
        for (int i = 0; i < finder->getResultCount(); ++i)
        {
            const QCAR::TargetSearchResult* result = finder->getResult(i);
            NSString* targetName = [NSString stringWithUTF8String:result->getTargetName()];
            if([self.virtualTag.marker.dataset isEqualToString:targetName])
            {
                // Create a new Trackable from the result:
                QCAR::Trackable* newTrackable = finder->enableTracking(*result);
                if (newTrackable == 0)
                {
                    NSLog(@"Failed to create new trackable.");
                    
                }
            }
        }
    }
}


- (QCAR::DataSet *)loadObjectTrackerDataSet:(NSString*)dataFile
{
    QCAR::DataSet * dataSet = NULL;
    
    // Get the QCAR tracker manager image tracker
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    if (NULL == objectTracker) {
        NSLog(@"ERROR: failed to get the ObjectTracker from the tracker manager");
        return NULL;
    } else {
        dataSet = objectTracker->createDataSet();
        
        if (NULL != dataSet) {
            NSLog(@"INFO: successfully loaded data set");
            
            // Load the data set from the app's resources location
            if (!dataSet->load([dataFile cStringUsingEncoding:NSASCIIStringEncoding], QCAR::STORAGE_APPRESOURCE)) {
                NSLog(@"ERROR: failed to load data set");
                objectTracker->destroyDataSet(dataSet);
                dataSet = NULL;
            }
        }
        else {
            NSLog(@"ERROR: failed to create data set");
        }
    }
    
    return dataSet;
}

-(UIImage *)imageToRender
{
    if(!self.virtualTagRender)
    {
        VirtualTagRenderer* renderer = [VirtualTagRenderer new];
        self.virtualTagRender = [renderer renderTag:self.virtualTag];
    }
    return self.virtualTagRender;
}

@end
