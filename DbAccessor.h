//
//  DbAccessor.h
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Trip.h"
#import "Charge.h"
#import "TripLog.h"

@interface DbAccessor : NSObject
{
    sqlite3 * db;
}

FOUNDATION_EXPORT NSString * const dbDateFormatString;
FOUNDATION_EXPORT NSString * const dbFileName;
FOUNDATION_EXPORT NSString * const TYPE_TEXT;
FOUNDATION_EXPORT NSString * const TYPE_IMAGE;
FOUNDATION_EXPORT NSString * const TYPE_LOCATION;

-(id) init;
-(void) resetDb;

-(Trip*) addTrip :(Trip*) trip;
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


-(void)close;

@end
