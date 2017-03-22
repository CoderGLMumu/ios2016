//
//  HomeTabBarVM.m
//  JZBRelease
//
//  Created by zjapple on 16/8/31.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "HomeTabBarVM.h"

@implementation HomeTabBarVM

#pragma mark -  设置按钮
+ (void)setUpButtons:(NSUInteger)index :(UINavigationController *)nav
{
    
    switch (index) {
        case 2:
            // 设置"帮吧"按钮样式
            nav.tabBarItem.title = @"帮吧";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table-_heart"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table-_heart_choose"];
            break;
            // 设置"消息"按钮样式
        case 3:
            nav.tabBarItem.title = @"聊吧";
//            nav.tabBarItem.badgeValue = @"N";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table-_talk"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table-_talk_choose"];
            break;
        case 1:
            // 设置"资讯"按钮样式
            nav.tabBarItem.title = @"智库";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table-_NEWS"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table-_NEWS_choose"];
            break;
            // 设置"学吧"按钮样式
        case 0:
            nav.tabBarItem.title = @"学吧";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table-_book"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table-_book_choose"];
            break;
            // 设置"我的"按钮样式
        case 4:
            nav.tabBarItem.title = @"我的";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table-_mine"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table-_mine_choose"];
            break;
            
        default:
            break;
    }
}

@end
