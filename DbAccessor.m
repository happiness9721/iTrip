//
//  DbAccessor.m
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "DbAccessor.h"

@implementation DbAccessor



- (void) createDb
{
    //設定資料庫檔案的路徑
    NSString *url = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"iTrip.sqlite"];
    sqlite3 *database = nil;
    
//    NSArray *documentsPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *databaseFilePath=[[documentsPath objectAtIndex:0] stringByAppendingPathComponent:@"Exam"];
//    if (sqlite3_open([databaseFilePath UTF8String], &database)==SQLITE_OK) {
//    }
    
    if (sqlite3_open([url UTF8String], &database) == SQLITE_OK) {
        NSLog(@"DB OK");
        //這裡寫入要對資料庫操作的程式碼
        
        //建立表格
        const char *createTripSql="create table if not exists Trip (tid integer primary key autoincrement, name text, detail text, date date,budget integer, location text, latitude real, longitude real)";
        
        const char *createChargeSql="create table if not exists Charge (tid integer, name text, pay integer)";
        
        const char *createTripLogSql="create table if not exists TripLog (tid integer, text text, pid integer, location text, latitude real, longitude real, date date, FOREIGN KEY(pid) REFERENCES TripLogPicture(pid))";
        
        const char *createTripLogPicture="create table if not exists TripLogPicture (pid integer primary key autoincrement, picture blob)";
        
        [self tableCreate :database andSqlStatement : createTripSql ];
        [self tableCreate :database andSqlStatement : createChargeSql];
        [self tableCreate :database andSqlStatement : createTripLogSql];
        [self tableCreate :database andSqlStatement : createTripLogPicture];

        
        //使用完畢後關閉資料庫聯繫
        sqlite3_close(database);
    }
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

@end
