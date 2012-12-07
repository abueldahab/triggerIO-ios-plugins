//
//  alert_API.m
//  ForgeInspector
//
//  Created by Connor Dunn on 27/07/2012.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import "database_API.h"

@implementation database_API

+ (void)show:(ForgeTask*)task text:(NSString *)text {
	if ([text length] == 0) {
		[task error:@"You must enter a message"];
		return;
	}
	UIAlertView *database = [[UIAlertView alloc] initWithTitle:@"database"
													message:text
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[database show];
	[task success:nil];
}

@end
