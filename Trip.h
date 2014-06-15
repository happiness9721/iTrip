//
//  Trip.h
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject

@property int tid;
@property NSString * name;
@property NSString * detail;
@property NSDate * date;
@property int budget;
@property NSString * location;
@property double latitude;
@property double longitude;

-(void) printTrip;

@end
