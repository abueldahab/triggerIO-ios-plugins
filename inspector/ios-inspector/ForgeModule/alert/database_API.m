//
//  database_API.m
//  ForgeModule
//
//  Created by explhorak on 12/17/12.
//  Fetchnotes
//

#import "database_API.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@implementation database_API

// Takes JSONArray that contains strings to construct the database schema
+ (void)createTables:(ForgeTask *)task schema:(NSArray *)schema {
    
    // Locate Documents directory and open database.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    
    if (![database open]) {
        [task error: @"ERROR: createTables() was unable to open or create a database."];
    }
    
    [database open];
    
    // Iterate through the array and create a table with each name and then run the query
    for (NSDictionary * dataDict in schema) {
        NSString * NAME = [dataDict objectForKey:@"name"];
        NSString * SCHEMA = [dataDict objectForKey:@"schema"];
        NSString * QUERY = [NSString stringWithFormat:@"CREATE TABLE %@ %@", NAME, SCHEMA];
        [database executeUpdate:QUERY];
        NSLog(@"database.sql: %@", QUERY);
    }
    
    [database close];
    
    [task success: nil];
}

// CUD notes based on given query.
// Basic CUD query that returns the note id(s) of the CUDed note.
// Can also handle array of queries and returns array of ints

// Takes array of JSON objects with one attribute called query (string), and args (array of strings - only ever be of length 1))
+ (void)writeAll:(ForgeTask *)task queries:(NSArray *)queryStrings {
    
    // Locate Documents directory and open database.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    
    if (![database open]) {
        [task error: @"ERROR: createTables() was unable to open or create a database."];
    }
    
    [database open];
    
    for (NSDictionary * dataDict in queryStrings) {
        NSArray *args = [dataDict objectForKey:@"args"];
        NSString *query = [dataDict objectForKey:@"query"];
        
        for (id item in args) {
            [database executeUpdate:query withArgumentsInArray:args];
            NSLog(@"database.sql: %@ with args: %@", query, item);
        }
    }
    
    [database close];

    [task success: nil];
}

// Just drops all the tables in database, given an array of tables 
+ (void)dropTables:(ForgeTask *)task tables:(NSArray *)tables {
    // Locate Documents directory and open database.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    
    if (![database open]) {
        [task error: @"ERROR: createTables() was unable to open or create a database."];
    }
    
    [database open];
    
    // Iterate through the array and drop each table
    for (id item in tables) {
        NSString * query = [NSString stringWithFormat:@"DROP TABLE %@", item];
        [database executeUpdate:query];
        NSLog(@"database.sql: %@", query);
    }

    [database close];
    
    [task success: nil];
}

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
    
    // Pop all query results into an NSMutableArray & close database.
    NSMutableArray *resultsArray = [NSMutableArray array];
    FMResultSet *resultsSet = [database executeQuery:queryString];
    while ([resultsSet next]) {
        [resultsArray addObject:[resultsSet resultDictionary]];
    }
    [database close];
    
    //Convert NSMutableArray into NSArray or NSDictionary/NSNumber/NSString
    NSArray *resultsArrayImutable = [[NSArray alloc] initWithArray:resultsArray];
    
    // Serialize array data into a JSON object.
    //    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:resultsArray
    //                                                        options:kNilOptions
    //                                                          error:nil];
    
    // Logging out the finalized, stringified key value pairs
    //    NSString *strData = [[NSString alloc]initWithData:JSONData encoding:NSUTF8StringEncoding];
    //    NSLog(@"********Array*of*notes*******: %@", resultsArray);
    
    [task success:resultsArrayImutable]; //JSONArray of JSON objects
}

// Takes a stringQuery as well as query type (either 'tag' or 'contact') & passes back a JSON array of strings of that type
+ (void)entityQuery:(ForgeTask *)task text:(NSString *)queryString type:(NSString *)queryType {
    //reads a list of all tags or contacts and then returns that, returns just an array of strings
    
}

@end
