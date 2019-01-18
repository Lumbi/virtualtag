//
//  VirtualTagsMapViewController.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-10.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class LoadingView;

@interface VirtualTagsMapViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic, weak) IBOutlet MKMapView* mapView;
@property(nonatomic, weak) IBOutlet LoadingView* loadingView;
@property(nonatomic, weak) IBOutlet UIButton* backButton;

-(IBAction)dismiss:(id)sender;

@end
