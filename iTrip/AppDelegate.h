//
//  AppDelegate.h
//  iTrip
//
//  Created by 楊凱霖 on 6/13/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "DbAccessor.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DbAccessor * db;
}

-(void) addTrip :(Trip*) trip;
-(Trip*) getTrip :(int) tid;
-(NSMutableArray*) getTrips;
-(int) getTripCount;
-(void) removeAllTrips;

-(void) addCharge : (Charge*) charge;
-(NSMutableArray*) getCharges:(int) tid;
-(int) getChargeCount :(int) tid;
-(int) getChargePaySum :(int) tid;
-(void) removeAllCharges;

-(void) addTripLog : (TripLog*) tripLog;
-(NSMutableArray*) getTripLogs:(int) tid;
-(int) getTripLogCount :(int) tid;
-(void) removeAllTripLogs;

@property (strong, nonatomic) UIWindow *window;

@end
