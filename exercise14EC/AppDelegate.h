//
//  AppDelegate.m
//  Exercise
//
//  Created by cpl on 10/30/13.
//  Copyright (c) 2013 cpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
