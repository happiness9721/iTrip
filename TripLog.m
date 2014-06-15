//
//  TripLog.m
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "TripLog.h"

@implementation TripLog
/*
@property int tid;
@property NSString * type;
@property NSString* text;
@property UIImage * image;
@property NSString * location;
@property double latitude;
@property double longitude;
@property NSDate * time;*/

-(void)printTripLog{
    
    NSString* string = [NSString stringWithFormat:@"TripLog: tid=%d, text=%@, image=%@, location=%@, latitude=%g, longitude=%g, time=%@", self.tid, self.type, self.text, self.image, self.location, self.latitude, self.longitude, self.time];
    NSLog(@"%@", string);
}

@end
