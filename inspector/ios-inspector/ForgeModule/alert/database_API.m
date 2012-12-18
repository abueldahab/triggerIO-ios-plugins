//
//  alert_API.m
//  ForgeInspector
//
//  Created by Connor Dunn on 27/07/2012.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import "database_API.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

@implementation database_API

// Returns the JSON array of note objects that match the passed in query
+ (void)query:(ForgeTask*)task query:(NSString *)query {
	if ([query length] == 0) {
		[task error:@"Empty sql statement"];
		return;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"query statement"
                                                       message:query
												   delegate:nil
										  cancelButtonTitle:@"Super"
										  otherButtonTitles:nil];
	[alert show];
	[task success:nil];
}

// Takes a string query as well as query type (either 'tag' or 'contact') & passes
//  back a JSON array of strings
//+ (void)entityQuery:(ForgeTask*)task query:(NSString *)query {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsPath = [paths objectAtIndex:0];
//    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
//    FMDatabase *database = [FMDatabase databaseWithPath:path];
//    
//    [database open];
//    [database executeUpdate:@"INSERT INTO NoteTag VALUES (?, ?)", [NSNumber numberWithInt:0], @"note0"
//     ];
//    [database close];
//}

@end
