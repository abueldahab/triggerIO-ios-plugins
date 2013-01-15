//
//  alert_API.m
//  ForgeInspector
//
//  Created by Connor Dunn on 27/07/2012.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import "alert_API.h"

@implementation alert_API

+ (void)show:(ForgeTask*)task text:(NSString *)text {
	if ([text length] == 0) {
		[task error:@"You must enter a message"];
		return;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerts on alerts"
													message:text
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[task success:nil];
}

+ (void)killBar:(ForgeTask *)task text:(NSString *)text {
    
    NSLog(@"hi********************");
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"UIKeyboardCandidateCorrectionDidChangeNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        UIWindow *keyboardWindow = nil;
        for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
            if (![[testWindow class] isEqual:[UIWindow class]]) {
                keyboardWindow = testWindow;
            }
        }
        
        // Locate UIWebFormView.
        for (UIView *possibleFormView in [keyboardWindow subviews]) {
            // iOS 5 sticks the UIWebFormView inside a UIPeripheralHostView.
            if ([[possibleFormView description] rangeOfString:@"UIPeripheralHostView"].location != NSNotFound) {
                for (UIView *subviewWhichIsPossibleFormView in [possibleFormView subviews]) {
                    if ([[subviewWhichIsPossibleFormView description] rangeOfString:@"UIWebFormAccessory"].location != NSNotFound) {
                        [subviewWhichIsPossibleFormView removeFromSuperview];
                    }
                }
            }
        }
    }];
}

@end
