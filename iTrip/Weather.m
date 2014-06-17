//
//  Weather.m
//  iTrip
//
//  Created by 楊凱霖 on 6/17/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "Weather.h"
#import "OWMWeatherAPI.h"

@interface Weather()
{
    OWMWeatherAPI * api;
}
@end

@implementation Weather

-(id) init
{
    self = [super init];
    if(self){
        api = [[OWMWeatherAPI alloc] initWithAPIKey:@"59f1e1643da80f33a41b24931fd8da47"];
        [api setLangWithPreferedLanguage];
        [api setTemperatureFormat:kOWMTempCelcius];
    }
    return self;
}

-(void) currentWeatherByTrip:(Trip*) trip andCallBack: (void(^)(NSString* cityName, NSNumber* temp)) callback
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(trip.latitude, trip.longitude);
    
    [api currentWeatherByCoordinate:coordinate withCallback:^(NSError *error, NSDictionary *result) {
        NSString *cityName = result[@"name"];
        NSNumber *currentTemp = result[@"main"][@"temp"];
        callback(cityName, currentTemp);
    }];
}
@end
