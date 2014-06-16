//
//  TripLog.h
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripLog : NSObject
@property int tid;
@property NSString * type;
@property NSString* text;
@property UIImage * image;
@property int iid;
@property NSString * location;
@property double latitude;
@property double longitude;
@property NSDate * time;

-(void)printTripLog;

@end
