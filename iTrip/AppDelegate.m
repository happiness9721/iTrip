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
    
//    Trip * trip = [[Trip alloc] init];
//    trip.name = @"trip name";
//    trip.detail = @"trip detail";
//    trip.date = [NSDate date];
//    trip.budget = 500;
//    trip.location = @"location";
//    trip.latitude = 23.55;
//    trip.longitude = 123.5555;
//    
//    
//    [self addTrip:trip];
//    [self getTrip:1];
//    [self getTrips];
//    //[self removeAllTrips];
//    [self getTripCount];
    
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
    const char* sqlStatement = "SELECT COUNT(*) FROM Trip";
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(db, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
    {
        //Loop through all the returned rows (should be just one)
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            int count = sqlite3_column_int(statement, 0);
            NSLog(@"Rowcount is %d",count);
            sqlite3_finalize(statement);
            return count;
        }
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) );
    }
    
    // Finalize and close database.
    sqlite3_finalize(statement);

    return 0;
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
