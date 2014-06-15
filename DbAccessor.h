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

@interface DbAccessor : NSObject
{
    sqlite3 * db;
}

-(id) init;
-(void) addTrip :(Trip*) trip;
-(Trip*) getTrip :(int) tid;
-(NSMutableArray*) getTrips;
-(int) getTripCount;
-(void) removeAllTrips;

-(void)close;

@end
