//
//  VirtualTagsMapViewController.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-10.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "VirtualTagsMapViewController.h"
#import "VirtualTag.h"
#import "User.h"
#import "VirtualTagViewerController.h"
#import "WebService.h"
#import "LoadingView.h"
#import "NSString+Localized.h"

#define kAnnotionReuseVirtualTag @"virtual_tag"

@interface VirtualTagsMapViewController ()

@property(nonatomic, strong) VirtualTag* selectedVirtualTag;

@end

@implementation VirtualTagsMapViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.backButton setTitle:[@"kBack" localized] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.loadingView startAnimating];
    [[WebService sharedInstance]
     fetchVirtualTagsWithCompletion:^(NSArray *objects, NSInteger statusCode)
     {
         [self.mapView removeAnnotations:self.mapView.annotations];
         [self.mapView addAnnotations:objects];
         [self.mapView showAnnotations:self.mapView.annotations animated:YES];
     } error:^(NSError *error) {
         [self.mapView removeAnnotations:self.mapView.annotations];
     } finally:^{
         [self.loadingView stopAnimating];
     }];
}

#pragma mark -
#pragma mark Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[VirtualTagViewerController class]])
    {
        VirtualTagViewerController* virtualTagViewerController = (VirtualTagViewerController*)segue.destinationViewController;
        virtualTagViewerController.virtualTag = self.selectedVirtualTag;
    }
}

#pragma mark -
#pragma mark Map View Delegation

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotionReuseVirtualTag];
    if(!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:kAnnotionReuseVirtualTag];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView
annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedVirtualTag = (VirtualTag*)view.annotation;
    
    [self.loadingView startAnimating];
    [[WebService sharedInstance]
     fetchVirtualTagWithId:self.selectedVirtualTag.identifier
     completion:^(id object, NSInteger statusCode)
     {
         if(statusCode == 200)
         {
             self.selectedVirtualTag = object;
             [self performSegueWithIdentifier:@"segueToVirtualTagViewer" sender:self];
         }
     } error:^(NSError *error) {
     } finally:^{
         [self.loadingView stopAnimating];
     }];
}

#pragma mark -
#pragma mark User Actions

-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Customization

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
