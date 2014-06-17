//
//  Weather.h
//  iTrip
//
//  Created by 楊凱霖 on 6/17/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@interface Weather : NSObject

-(void) currentWeatherByTrip:(Trip*) trip andCallBack: (void(^)(NSString* cityName, NSNumber* temp)) callback;

@end
