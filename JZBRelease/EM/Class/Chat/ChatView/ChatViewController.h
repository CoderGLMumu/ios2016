/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface ChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

/** ispresentVC */
@property (nonatomic, assign) BOOL ispresentVC;

///** 自定义聊天室自己名称 */
//@property (nonatomic, strong) NSString *from;
//
///** 自定义聊天室对象名称 */
//@property (nonatomic, strong) NSString *to;

///** 自定义聊天室title */
@property (nonatomic, strong) NSString *Ttitle;

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

@end
