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
        [homeViewNavController popToRootViewControllerAnimated:NO];
    }
}

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return viewController != tabBarController.selectedViewController;
}

@end
