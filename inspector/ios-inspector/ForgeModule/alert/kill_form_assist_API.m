//
//  kill_form_assist_API.m
//  ForgeModule
//
//  Created by explhorak on 1/14/13.
//  Copyright (c) 2013 Trigger Corp. All rights reserved.
//

#import "kill_form_assist_API.h"

@implementation kill_form_assist_API

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
