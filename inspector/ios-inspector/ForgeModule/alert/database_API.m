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
    
    // Pop all query results into an NSDictionary
    NSMutableArray *resultsArray = [NSMutableArray array];
    FMResultSet *resultsSet = [database executeQuery:queryString];
    while ([resultsSet next]) {
        [resultsArray addObject:[resultsSet resultDictionary]];
    }
    
    // Now parse that dictionary into a JSON array
    
    
    
    
    [database close];
    
    [task success:nil];
}

// Takes a string query as well as query type (either 'tag' or 'contact') & passes
//  back a JSON array of strings

@end
