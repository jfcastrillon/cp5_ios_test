//
//  CPTabBarDelegate.m
//  CommunityPointMobile
//
//  Created by John Cannon on 5/26/11.
//  Copyright 2011 Bowman Systems, LLC. All rights reserved.
//

#import "CPTabBarDelegate.h"



@implementation CPTabBarDelegate

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == [[tabBarController viewControllers] objectAtIndex:HOME_VIEW_CONTROLLER_INDEX]) {
        UINavigationController* homeViewNavController = (UINavigationController*) viewController;
        homeViewNavController.navigationBar.hidden = YES;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        }
        [homeViewNavController popToRootViewControllerAnimated:NO];
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
}

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return viewController != tabBarController.selectedViewController;
}

@end
