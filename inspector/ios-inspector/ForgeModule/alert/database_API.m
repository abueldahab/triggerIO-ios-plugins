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
    
    // Error checking
    if ([queryString length] == 0) {
        [task error: @"Query is 0 characters long"];
        return;
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Hi there"
//                                                    message: queryString
//                                                   delegate: nil
//                                          cancelButtonTitle: @"sweet"
//                                          otherButtonTitles: nil];
//    [alert show];
    
    // Locate Documents directory and open database.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    // Query db for queryString and store results in a JSON array of objects
    FMResultSet *results = [database executeQuery:queryString];
    while ([results next]) {
        
    }
    
    [database close];
    
    [task success:nil];
}

// Takes a string query as well as query type (either 'tag' or 'contact') & passes
//  back a JSON array of strings

@end
