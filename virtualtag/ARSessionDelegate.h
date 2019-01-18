//
//  ARSessionDelegate.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-09.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QCAR/State.h>

// An AR application must implement this protocol in order to be notified of
// the different events during the life cycle of an AR application
@protocol ARSessionDelegate

@required
// this method is called to notify the application that the initialization (initAR) is complete
// usually the application then starts the AR through a call to startAR
- (void) onInitARDone:(NSError *)error;

// the application must initialize its tracker(s)
- (bool) doInitTrackers;

// the application must initialize the data associated to its tracker(s)
- (bool) doLoadTrackersData;

// the application must starts its tracker(s)
- (bool) doStartTrackers;

// the application must stop its tracker(s)
- (bool) doStopTrackers;

// the application must unload the data associated its tracker(s)
- (bool) doUnloadTrackersData;

// the application must deinititalize its tracker(s)
- (bool) doDeinitTrackers;

-(UIImage*)imageToRender;

@optional
// optional method to handle the QCAR callback - can be used to swap dataset for instance
- (void) onQCARUpdate: (QCAR::State *) state;

@end