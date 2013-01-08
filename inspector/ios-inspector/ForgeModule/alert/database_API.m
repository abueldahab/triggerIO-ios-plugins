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

// Basic CUD query that returns the note id of the CUDed note
+ (void)cudQuery:(ForgeTask *)task text:(NSString *)queryString {
    
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
    
    [database executeUpdate:queryString];
    
    // Will grab the last inserted row id - this is what we want to return
    int lastId = [database lastInsertRowId];
    NSLog(@"row id: %d", lastId);
    
    [database commit];
    
    [database close];
    
}

// Takes a stringQuery as well as query type (either 'tag' or 'contact') & passes back a JSON array of strings of that type
+ (void)entityQuery:(ForgeTask *)task text:(NSString *)queryString type:(NSString *)queryType {
    //reads a list of all tags or contacts and then returns that, returns just an array of strings
    
}

@end
