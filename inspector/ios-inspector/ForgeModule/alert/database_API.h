//
//  database_API.h
//  ForgeModule
//
//  Created by explhorak on 12/17/12.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface database_API : NSObject

+ (void)query:(ForgeTask *)task text:(NSString *)queryString;
+ (void)entityQuery:(ForgeTask *)task text:(NSString *)queryString type:(NSString *)queryType;

@end
