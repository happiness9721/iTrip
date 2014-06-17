//
//  AppDelegate.m
//  iTrip
//
//  Created by 楊凱霖 on 6/13/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    db = [[DbAccessor alloc] init];
    self.weather = [[Weather alloc] init];
//    [db resetDb];
//    db = [[DbAccessor alloc] init];
//    [db addDefaultData];
      return YES;
}

-(void) removeAllTrips{
    [db removeAllTrips];
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



-(void) addCharge : (Charge*) charge
{
    [db addCharge:charge];
}

-(NSMutableArray*) getCharges:(int) tid
{
    return [db getCharges:tid];
}

-(int) getChargeCount :(int) tid
{
    return [db getChargeCount:tid];
}

-(int) getChargePaySum :(int) tid
{
    return [db getChargePaySum:tid];
}

-(void) removeAllCharges
{
    [db removeAllCharges];
}

-(void) addTripLog : (TripLog*) tripLog
{
    [db addTripLog:tripLog];
}

-(NSMutableArray*) getTripLogs:(int) tid
{
    return [db getTripLogs:tid];
}

-(int) getTripLogCount :(int) tid
{
    return [db getTripLogCount:tid];
}

-(void) removeAllTripLogs
{
    [db removeAllTripLogs];
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
