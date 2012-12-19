//
//  database_API.m
//  ForgeModule
//
//  Created by explhorak on 12/17/12.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import "database_API.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@implementation database_API

// Returns the JSON array of note objects that match the passed in query.
+ (void)query:(ForgeTask *)task text:(NSString *)queryString {
    
    // Error handling.
    if ([queryString length] == 0) {
        [task error: @"Query is 0 characters long"];
        return;
    }
    
    // Locate Documents directory and open database.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    // Pop all query results into an NSArray & close database.
    NSMutableArray *resultsArray = [NSMutableArray array];
    FMResultSet *resultsSet = [database executeQuery:queryString];
    while ([resultsSet next]) {
        [resultsArray addObject:[resultsSet resultDictionary]];
    }
    [database close];
    
    // Serialize array data into a JSON object.
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:resultsArray
                                                        options:kNilOptions
                                                          error:nil];
    
    // Logging out the finalized, stringified key value pairs
    NSString *strData = [[NSString alloc]initWithData:JSONData encoding:NSUTF8StringEncoding];
    NSLog(@"Returning this shit: %@", strData);
    
    [task success:JSONData];
}

// Takes a string query as well as query type (either 'tag' or 'contact') & passes back a JSON array of strings

@end
