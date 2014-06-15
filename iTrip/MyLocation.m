//
//  MyLocation.m
//  iTrip
//
//  Created by 江承諭 on 6/15/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "MyLocation.h"
#import <MapKit/MapKit.h>

@implementation MyLocation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id) initWithCoordinate: (CLLocationCoordinate2D) the_coordinate
{
    if (self = [super init])
    {
        coordinate = the_coordinate;
    }
    return self;
}

-(void) dealloc
{
    self.title = nil;
    self.subtitle = nil;
}

@end