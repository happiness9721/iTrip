//
//  DbAccessor.m
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "DbAccessor.h"

@implementation DbAccessor
NSString * const dbDateFormatString = @"yyyy-MM-dd HH:mm:ss";
NSString * const dbFileName = @"iTrip.sqlite";
NSString * const TYPE_TEXT = @"text";
NSString * const TYPE_IMAGE = @"image";
NSString * const TYPE_LOCATION = @"position";

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
                
                const char *createTripLogSql="create table if not exists TripLog (tid integer, type text, text text, iid integer, location text, latitude real, longitude real, time date)";//, FOREIGN KEY(pid) REFERENCES TripLogPicture(pid))";
                
                const char *createTripLogPicture="create table if not exists TripLogImage (iid integer primary key autoincrement, image blob)";
                
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
        
        sqlite3_stmt * statement;
        NSString * sqlStr = [NSString stringWithFormat:@"insert into Trip (name, detail, date, budget, location, latitude, longitude) Values ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", trip.name, trip.detail, date, budget, trip.location, latitude, longitude];
        NSLog(@"addtrip sql = %@", sqlStr);
        sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"成功加入一筆Trip資料");
        }else{
            NSLog(@"加入Trip失敗");
        }
        sqlite3_finalize(statement);
        sqlite3_int64 lastRowId = sqlite3_last_insert_rowid(db);
        trip.tid = (int)lastRowId;
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
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:dbDateFormatString];
    
    trip.tid = tid;
    trip.name = [NSString stringWithUTF8String: name];
    trip.detail = [NSString stringWithUTF8String: detail];
    trip.date = [dateFormat dateFromString:[NSString stringWithFormat:@"%s", date]];
    trip.budget = budget;
    trip.location =[NSString stringWithFormat:@"%s", location];
    trip.latitude = latitude;
    trip.longitude = longitude;
    return trip;
}

-(NSMutableArray*) getTrips
{
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
            int count = sqlite3_column_int(statement, 0);
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
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            NSLog(@"result is here");
        }
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
    charge.tid = tid;
    charge.name = [NSString stringWithUTF8String:name];
    charge.pay = pay;
    return charge;
}


-(int) getChargeCount :(int) tid
{
    NSString * sqlStr = [NSString stringWithFormat:@"select COUNT(*) from Charge where tid = %d", tid];
    const char* sqlStatement = [sqlStr UTF8String];
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(db, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
    {
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            int count = sqlite3_column_int(statement, 0);
            sqlite3_finalize(statement);
            return count;
        }
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) );
    }
    sqlite3_finalize(statement);
    return 0;
}

-(void) removeAllCharges
{
    const char *sqlStatement = "delete from Charge";
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(db, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            NSLog(@"result is here");
        }
        sqlite3_finalize(compiledStatement);
    }
}

-(void) addTripLog : (TripLog*) tripLog{
    if(db!=nil){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: dbDateFormatString];
        NSString *time=[dateFormat stringFromDate:tripLog.time];
        
        NSString * sqlStr;
        if(tripLog.type==TYPE_IMAGE){
            int iid = [self addImage: tripLog.image];
            sqlStr = [NSString stringWithFormat:@"insert into TripLog (tid, type, iid, time) Values ('%d', '%@', '%d', '%@')", tripLog.tid, tripLog.type, iid, time];
        }else if(tripLog.type== TYPE_TEXT){
            sqlStr = [NSString stringWithFormat:@"insert into TripLog (tid, type, text, time) Values ('%d', '%@', '%@', '%@')", tripLog.tid, tripLog.type, tripLog.text, time];
        }else if(tripLog.type==TYPE_LOCATION){
            sqlStr = [NSString stringWithFormat:@"insert into TripLog (tid, type, location, latitude, longitude, time) Values ('%d', '%@', '%@', '%lf', '%lf', '%@')", tripLog.tid, tripLog.type, tripLog.location, tripLog.latitude, tripLog.longitude, time];
        }
        NSLog(@"addTripLog sqlstr = %@", sqlStr);
        sqlite3_stmt * statement;
        sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"成功加入一筆TripLog資料");
        }else{
            NSLog(@"加入TripLog失敗");
            NSLog( @"add trip log err = %s", sqlite3_errmsg(db) );
            
        }
        sqlite3_finalize(statement);
    }

}

-(int) addImage:(UIImage*) image
{
    return 0;
}

-(TripLog*) statementToTripLog: (sqlite3_stmt*) statement
{
    TripLog * tripLog = [[TripLog alloc] init];
    int tid = sqlite3_column_int(statement, 0);
    char *type = (char*)sqlite3_column_text(statement, 1);
    char *time = (char*)sqlite3_column_text(statement, 7);
    NSString * typeStr = [NSString stringWithFormat:@"%s", type];
    
    tripLog.tid = tid;
    tripLog.type = [NSString stringWithUTF8String:type];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:dbDateFormatString];
    tripLog.time = [dateFormat dateFromString:[NSString stringWithFormat:@"%s", time]];
    
    
    if(typeStr==TYPE_TEXT){
        char *text = (char*)sqlite3_column_text(statement, 2);
        tripLog.text =[NSString stringWithUTF8String:text];
    }else if(typeStr == TYPE_IMAGE){
        int length = sqlite3_column_bytes(statement, 3);
        NSData* data = [NSData dataWithBytes:sqlite3_column_blob(statement, 3) length:length];
        tripLog.image = [UIImage imageWithData:data];
    }else if(typeStr == TYPE_LOCATION){
        char *location = (char*)sqlite3_column_text(statement, 4);
        double latitude = sqlite3_column_double(statement, 5);
        double longitude = sqlite3_column_double(statement, 6);
        tripLog.location =[NSString stringWithUTF8String:location];
        tripLog.latitude = latitude;
        tripLog.longitude = longitude;
    }
    return tripLog;
}


-(NSMutableArray*) getTripLogs:(int) tid
{
    NSLog(@"查詢TripLogs");
    NSMutableArray * tripLogs = [[NSMutableArray alloc] init];
    NSString * sqlStr = [NSString stringWithFormat:@"select * from TripLog where tid = %d", tid];
    
    sqlite3_stmt * statement;
    sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL);
    while(sqlite3_step(statement)==SQLITE_ROW){
        TripLog* tripLog = [self statementToTripLog:statement];
        [tripLogs addObject:tripLog];
    }
    return tripLogs;
}

-(int) getTripLogCount :(int) tid
{
    NSString * sqlStr = [NSString stringWithFormat:@"select COUNT(*) from TripLog where tid = %d", tid];
    
    const char* sqlStatement = [sqlStr UTF8String];
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
    sqlite3_finalize(statement);
    return 0;
}

-(void) removeAllTripLogs
{
    const char *sqlStatement = "delete from TripLog";
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(db, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            NSLog(@"result is here");
        }
        sqlite3_finalize(compiledStatement);
    }}

-(void) close
{
    sqlite3_close(db);
}

@end
