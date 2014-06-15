//
//  DbAccessor.m
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "DbAccessor.h"

@interface DbAccessor ()

@end

@implementation DbAccessor
NSString * dbDateFormatString = @"yyyy-MM-dd HH:mm:ss";
NSString * dbFileName = @"iTrip.sqlite";

- (id) init
{
    self = [super init];
    if(self){
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: dbFileName]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath: databasePath ] == NO) {
            const char *dbpath = [databasePath UTF8String];
            
            if (sqlite3_open(dbpath, &db) == SQLITE_OK) {
                const char *createTripSql="create table if not exists Trip (tid integer primary key autoincrement, name text, detail text, date date,budget integer, location text, latitude real, longitude real)";
                
                const char *createChargeSql="create table if not exists Charge (tid integer, name text, pay integer, time date)";
                
                const char *createTripLogSql="create table if not exists TripLog (tid integer, text text, pid integer, location text, latitude real, longitude real, date date, FOREIGN KEY(pid) REFERENCES TripLogPicture(pid))";
                
                const char *createTripLogPicture="create table if not exists TripLogPicture (pid integer primary key autoincrement, picture blob)";
                
                [self tableCreate :db andSqlStatement : createTripSql];
                [self tableCreate :db andSqlStatement : createChargeSql];
                [self tableCreate :db andSqlStatement : createTripLogSql];
                [self tableCreate :db andSqlStatement : createTripLogPicture];
                
                //sqlite3_close(db);
            }
            else {
                NSLog(@"Failed to open/create database");
            }
        }else{
            if(sqlite3_open([databasePath UTF8String], &db)!=SQLITE_OK){
                db = nil;
                NSLog(@"資料庫連線失敗");
            }else{
                NSLog(@"資料庫連線成功");
            }
        }
    }
    return self;
}

-(void) resetDb
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: dbFileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:databasePath error:nil];
    if(db!=NULL){
        [self close];
    }
    db = NULL;
}

- (BOOL) tableCreate :(sqlite3*) database andSqlStatement:(const char *) sql
{
    char *errorMsg;
    if (sqlite3_exec(database, sql, NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"TABLE OK");
        //建立成功之後要對資料庫操作的程式碼
    } else {
        //建立失敗時的處理
        NSLog(@"error: %s",errorMsg);
        //清空錯誤訊息
        sqlite3_free(errorMsg);
    }
    return YES;
}

- (Trip*)addTrip: (Trip*) trip
{
    if(db!=nil){
        NSString * budget = [NSString stringWithFormat:@"%d",trip.budget];
        NSString * latitude = [NSString stringWithFormat:@"%lf",trip.latitude];
        NSString * longitude = [NSString stringWithFormat:@"%lf",trip.longitude];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: dbDateFormatString];
        NSString *date=[dateFormat stringFromDate:trip.date];
        
        NSString * sqlStr = [NSString stringWithFormat:@"insert into Trip (name, detail, date, budget, location, latitude, longitude) Values ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", trip.name, trip.detail, date, budget, trip.location, latitude, longitude];
        NSLog(@"sqlstr = %@", sqlStr);
        sqlite3_stmt * statement;
        sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"成功加入一筆Trip資料");
        }else{
            NSLog(@"加入Trip失敗");
        }
        sqlite3_finalize(statement);
        sqlite3_int64 lastRowId = sqlite3_last_insert_rowid(db);
        trip.tid = lastRowId;
    }
    return trip;
}


-(Trip*) getTrip :(int) tid{
    if(db!=nil){
        NSString * sqlStr = [NSString stringWithFormat:@"select * from Trip where tid = %d", tid];
        
        sqlite3_stmt * statement;
        sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL);
        while(sqlite3_step(statement)==SQLITE_ROW){
            NSLog(@"成功查詢Trip資料");
            Trip* trip = [self statementToTrip:statement];
            sqlite3_finalize(statement);
            return trip;
        }
        sqlite3_finalize(statement);
    }
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
    [dateFormat setDateFormat:dbDateFormatString];
    
    
    trip.tid = tid;
    trip.name = [NSString stringWithFormat:@"%s", name];
    trip.detail = [NSString stringWithFormat:@"%s", detail];
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
    sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL);
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

-(void) removeAllTrips{
    const char *sqlStatement = "delete from Trip";
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


-(void) addCharge : (Charge*) charge
{
    if(db!=nil){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: dbDateFormatString];
        NSString *time=[dateFormat stringFromDate:charge.time];
        NSString * sqlStr = [NSString stringWithFormat:@"insert into Charge (tid, name, pay, time) Values ('%d', '%@', '%d', '%@')", charge.tid, charge.name, charge.pay, time];
        NSLog(@"sqlstr = %@", sqlStr);
        sqlite3_stmt * statement;
        sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"成功加入一筆Charge資料");
        }else{
            NSLog(@"加入Charge失敗");
        }
        sqlite3_finalize(statement);
    }
}

-(NSMutableArray*) getCharges:(int) tid
{
    NSLog(@"查詢Charges");
    NSMutableArray * charges = [[NSMutableArray alloc] init];
    NSString * sqlStr = [NSString stringWithFormat:@"select * from Charge where tid = %d", tid];
    
    sqlite3_stmt * statement;
    sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL);
    while(sqlite3_step(statement)==SQLITE_ROW){
        Charge* charge = [self statementToCharge:statement];
        [charges addObject:charge];
    }
    return charges;
}


-(Charge*) statementToCharge: (sqlite3_stmt*) statement
{
    Charge * charge = [[Charge alloc] init];
    int tid = sqlite3_column_int(statement, 0);
    char *name = (char*)sqlite3_column_text(statement, 1);
    int pay = sqlite3_column_int(statement, 2);
    char *date = (char*)sqlite3_column_text(statement, 3);
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:dbDateFormatString];
    charge.time = [dateFormat dateFromString:[NSString stringWithFormat:@"%s", date]];

    
    
    NSLog(@"tid=%d", tid);
    NSLog(@"name=%s", name);
    NSLog(@"pay=%d", pay);
    NSLog(@"date=%s", date);
    
    charge.tid = tid;
    charge.name = [NSString stringWithFormat:@"%s", name];
    charge.pay = pay;
    return charge;
}


-(int) getChargeCount :(int) tid
{
    NSString * sqlStr = [NSString stringWithFormat:@"select COUNT(*) from Charge where tid = %d", tid];
    
    const char* sqlStatement = [sqlStr UTF8String];//"SELECT COUNT(*) FROM Charge where tid = %d";
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(db, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
    {
        //Loop through all the returned rows (should be just one)
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            NSInteger count = sqlite3_column_int(statement, 0);
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

-(void) removeAllCharges
{
    const char *sqlStatement = "delete from Charge";
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


-(void) close
{
    sqlite3_close(db);
}

@end
