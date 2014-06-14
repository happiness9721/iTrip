//
//  AppDelegate.h
//  iTrip
//
//  Created by 楊凱霖 on 6/13/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Trip.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    sqlite3 * db;
}

-(sqlite3*) getDB;
-(void) addTrip :(Trip*) trip;
-(Trip*) getTrip :(int) tid;
-(NSMutableArray*) getTrips;
-(int) getTripCount;
-(void) removeAllTrips;

@property (strong, nonatomic) UIWindow *window;

@end
