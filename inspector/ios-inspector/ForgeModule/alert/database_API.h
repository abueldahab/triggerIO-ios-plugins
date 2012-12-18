//
//  database_API.h
//  ForgeInspector
//
//  Created by Connor Dunn on 27/07/2012.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface database_API : NSObject

+ (void)query:(ForgeTask*)task query:(NSString *)query;
//+ (void)entityQuery:(ForgeTask*)task query:(NSString *)query;

@end

