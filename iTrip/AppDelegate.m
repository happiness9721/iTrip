//
//  AppDelegate.m
//  iTrip
//
//  Created by 楊凱霖 on 6/13/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

-(void) removeAllTrips{
    [db removeAllTrips];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    db = [[DbAccessor alloc] init];
//    [db resetDb];
    db = [[DbAccessor alloc] init];
    [db removeAllTrips];
    [db removeAllCharges];
    
    Trip * trip = [[Trip alloc] init];
    trip.name = @"trip name";
    trip.detail = @"trip detail";
    trip.date = [NSDate date];
    trip.budget = 500;
    trip.location = @"location";
    trip.latitude = 23.55;
    trip.longitude = 123.5555;
    
    
    trip = [db addTrip:trip];
    
    [trip printTrip];
    [db getTrip:1];
    [db getTrips];
    [db getTripCount];
    
    Charge * charge = [[Charge alloc]init];
    charge.tid = trip.tid;
    charge.name = @"charge name";
    charge.pay = 500;
    charge.time = [NSDate date];
    [charge printCharge];
    [db addCharge:charge];
    [db addCharge:charge];
    [db getCharges:trip.tid];
    int sum = [db getChargePaySum:trip.tid];
    NSLog(@"Sum = %d", sum);
    
    [db getChargeCount: charge.tid];
    
    TripLog* tripLog = [[TripLog alloc]init];
    tripLog.tid = trip.tid;
    tripLog.type = TYPE_TEXT;
    tripLog.text = @"text message";
    tripLog.time = [NSDate date];
    
    [tripLog printTripLog];
    [db addTripLog:tripLog];
    [db addTripLog:tripLog];
    [db getTripLogs:trip.tid];
    [db getTripLogCount:trip.tid];
    
    return YES;
}

- (void)addTrip: (Trip*) trip
{
    [db addTrip:trip];
}


-(Trip*) getTrip :(int) tid{
    return [db getTrip:tid];
}

-(NSMutableArray*) getTrips
{
    return [db getTrips];
}

-(int) getTripCount
{
    return [db getTripCount];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [db close];
}

@end
