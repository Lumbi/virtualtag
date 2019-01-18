//
//  CanvasCaptureViewController.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-05.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "CanvasCaptureViewController.h"
#import "VirtualTagCreationViewController.h"
#import "CanvasCropView.h"
#import "User.h"
#import "WebService.h"
#import "NSString+Localized.h"

@interface CanvasCaptureViewController ()

@property(nonatomic, strong) AVCaptureSession* session;
@property(nonatomic, strong) UIImage* captureImage;

@property(nonatomic, strong) AVCaptureStillImageOutput* captureStillImageOutput;

@end

@implementation CanvasCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.findPiecesButton.text = [@"kFindPieces" localized];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self beginCameraPreview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    User* currentUser = [User loadFromUserDefaults];
    if(currentUser)
    {
        [[WebService sharedInstance] setBasicAuthWithUsername:currentUser.name
                                                  andPassword:currentUser.password];
    } else {
        [self performSegueWithIdentifier:@"segueToLogin" sender:self];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self endCameraPreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[VirtualTagCreationViewController class]])
    {
        VirtualTagCreationViewController* virtualTagCreationViewController = [segue destinationViewController];
        virtualTagCreationViewController.captureImage = self.captureImage;
    }
}

-(IBAction)capture:(id)sender
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureStillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                              completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
    {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.captureImage = [[UIImage alloc] initWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"segueToVirtualTagCreation" sender:self];
        });
    }];
}

-(void)beginCameraPreview
{
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]
                                                            initWithSession:self.session];
    
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    captureVideoPreviewLayer.frame = self.cameraPreviewView.bounds;
    [self.cameraPreviewView.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"ERROR: trying to open camera: %@", error);
        return;
    }else{
        [self.session addInput:input];
    }

    self.captureStillImageOutput = [AVCaptureStillImageOutput new];
    if([self.session canAddOutput:self.captureStillImageOutput])
    {
        [self.session addOutput:self.captureStillImageOutput];
    }
    
    [self.session startRunning];
}

-(void)endCameraPreview
{
    [self.session stopRunning];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
