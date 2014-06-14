//
//  AppDelegate.m
//  iTrip
//
//  Created by 楊凱霖 on 6/13/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "AppDelegate.h"
#import "Trip.h"

@implementation AppDelegate

NSString * dateFormatString = @"yyyy-MM-dd HH:mm:ss";

-(sqlite3*) getDB
{
    return db;
}

-(void) removeAllTrips{
    NSString *query = @"delete from Trip";
    const char *sqlStatement = [query UTF8String];
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(db, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
        // Loop through the results and add them to the feeds array
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            // Read the data from the result row
            NSLog(@"result is here");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // 將資料庫檔案複製到具有寫入權限的目錄
    NSFileManager * fm = [[NSFileManager alloc] init];
    NSString *src = [[NSBundle mainBundle] pathForResource:@"iTrip" ofType:@"sqlite"];
    NSString *dst = [NSString stringWithFormat:@"%@/Documents/iTrip.sqlite", NSHomeDirectory()];
    
    // 檢查目的檔案是否存在，如果不存在則複製資料庫
    if(![fm fileExistsAtPath:dst]){
        [fm copyItemAtPath:src toPath:dst error:nil];
    }
    
    // 與資料庫連線，並將連線結果存入db變數中
    if(sqlite3_open([dst UTF8String], &db)!=SQLITE_OK){
        db = nil;
        NSLog(@"資料庫連線失敗");
    }else{
        NSLog(@"資料庫連線成功");
    }
    
    
    
    Trip * trip = [[Trip alloc] init];
    trip.name = @"trip name";
    trip.detail = @"trip detail";
    trip.date = [NSDate date];
    trip.budget = 500;
    trip.location = @"location";
    trip.latitude = 23.55;
    trip.longitude = 123.5555;
    
    
    [self addTrip:trip];
    [self getTrip:1];
    [self getTrips];
    //[self removeAllTrips];
    [self getTripCount];
    
    return YES;
}

- (void)addTrip: (Trip*) trip
{
    if(db!=nil){
        NSString * budget = [NSString stringWithFormat:@"%d",trip.budget];
        NSString * latitude = [NSString stringWithFormat:@"%lf",trip.latitude];
        NSString * longitude = [NSString stringWithFormat:@"%lf",trip.longitude];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: dateFormatString];
        NSString *date=[dateFormat stringFromDate:trip.date];

        NSString * sqlStr = [NSString stringWithFormat:@"insert into Trip (name, detail, date, budget, location, latitude, longitude) Values ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", trip.name, trip.detail, date, budget, trip.location, latitude, longitude];
        NSLog(@"sqlstr = %@", sqlStr);
        sqlite3_stmt * statement;
        sqlite3_prepare(db, [sqlStr UTF8String], -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"成功加入一筆Trip資料");
        }else{
            NSLog(@"加入Trip失敗");
        }
        sqlite3_finalize(statement);
        
    }
}


-(Trip*) getTrip :(int) tid{
    NSString * sqlStr = [NSString stringWithFormat:@"select * from Trip where tid = %d", tid];
    
    sqlite3_stmt * statement;
    sqlite3_prepare(db, [sqlStr UTF8String], -1, &statement, NULL);
    while(sqlite3_step(statement)==SQLITE_ROW){
        NSLog(@"成功查詢Trip資料");
        Trip* trip = [self statementToTrip:statement];
        sqlite3_finalize(statement);
        return trip;
    }
    sqlite3_finalize(statement);
    return nil;
}

-(Trip*) statementToTrip: (sqlite3_stmt*) statement
{
    Trip * trip = [[Trip alloc] init];
    int tid = sqlite3_column_int(statement, 0);
    char *name = (char*)sqlite3_column_text(statement, 1);
    char *detail = (char*)sqlite3_column_text(statement, 2);
    char *date = (char*)sqlite3_column_text(statement, 3);
    int budget = sqlite3_column_int(statement, 4);
    char *location = (char*)sqlite3_column_text(statement, 5);
    double latitude = sqlite3_column_double(statement, 6);
    double longitude = sqlite3_column_double(statement, 7);
    trip.tid = tid;
    trip.name = [NSString stringWithFormat:@"%s", name];
    trip.detail = [NSString stringWithFormat:@"%s", detail];
    
    NSLog(@"tid=%d", tid);
    NSLog(@"name=%s", name);
    NSLog(@"detail=%s", detail);
    NSLog(@"date=%s", date);
    NSLog(@"budget=%d", budget);
    NSLog(@"location=%s", location);
    NSLog(@"latitude=%lf", latitude);
    NSLog(@"longitude=%lf", longitude);
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:dateFormatString];
    trip.date = [dateFormat dateFromString:[NSString stringWithFormat:@"%s", date]];
    
    trip.budget = budget;
    trip.location =[NSString stringWithFormat:@"%s", location];
    trip.latitude = latitude;
    trip.longitude = longitude;
    return trip;
}

-(NSMutableArray*) getTrips
{
    NSLog(@"查詢所有Trip");
    NSMutableArray * trips = [[NSMutableArray alloc] init];
    
    NSString * sqlStr = @"select * from Trip";
    
    sqlite3_stmt * statement;
    sqlite3_prepare(db, [sqlStr UTF8String], -1, &statement, NULL);
    while(sqlite3_step(statement)==SQLITE_ROW){
        NSLog(@"成功查詢一筆Trip資料");
        Trip* trip = [self statementToTrip:statement];
        [trips addObject:trip];
    }
    return trips;
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
            NSInteger count = sqlite3_column_int(statement, 0);
            NSLog(@"Rowcount is %d",count);
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
    sqlite3_close(db);
}

@end
