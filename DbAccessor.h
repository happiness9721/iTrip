//
//  DbAccessor.h
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DbAccessor : NSObject

- (BOOL) tableCreate :(sqlite3*) database andSqlStatement:(const char *) sql;
@end
