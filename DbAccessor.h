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

@interface DbAccessor : NSObject
{
    sqlite3 * db;
}

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
-(void) removeAllCharges;



-(void)close;

@end
