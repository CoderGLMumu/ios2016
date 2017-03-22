//
//  MessageTableViewController.m
//  EmotionKeyboard
//
//  Created by CoderXu on 16/8/11.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

#import "MessageTableViewController.h"
#import "TYAttributedLabel.h"
#import "RegexKitLite.h"
#import "AutoLayoutAttributedLabelCell.h"

#import "DanmuItem.h"

static NSString *cellId = @"AutoLayoutAttributedLabelCell";
@interface MessageTableViewController ()<TYAttributedLabelDelegate>

@end

@implementation MessageTableViewController

-(void)setMsgList:(NSMutableArray *)msgList {
    _msgList = msgList;
    [self.tableView reloadData];
    NSUInteger rowCount = msgList.count;
    if (rowCount > 0 && [self.tableView numberOfSections] > 0) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(rowCount-1) inSection:0];
        NSLog(@"%@",msgList);
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell,设置tableView
    [self.tableView registerClass:[AutoLayoutAttributedLabelCell class] forCellReuseIdentifier:cellId];
    self.tableView.estimatedRowHeight = 220;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 消息列表的DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AutoLayoutAttributedLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // Configure the cell...
    cell.label.delegate = self;
    
    DanmuItem *message=self.msgList[indexPath.row];
    
//    NSString *message=self.msgList[indexPath.row];
    
    cell.label.textContainer = [self creatTextContainerByjzb_Message:message]; //创建文本容器
    
    [cell.label setBackgroundColor:[UIColor clearColor]];
    // 如果是直接赋值textContainer ，可以不用设置preferredMaxLayoutWidth，因为创建textContainer时，必须传正确的textwidth，即 preferredMaxLayoutWidth
    cell.label.preferredMaxLayoutWidth = CGRectGetWidth(tableView.frame);
    cell.label.linkColor = [UIColor redColor];
//    cell.label.strokeWidth = 2;
    [ cell setBackgroundColor:[UIColor clearColor]];
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    return cell;
    
}
#pragma 消息列表delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {//iOS8以上cell高度可自动估算
//        return UITableViewAutomaticDimension;
//    }
    //iOS8以下计算高度
//    NSString *message = self.msgList[indexPath.row];
    DanmuItem *message=self.msgList[indexPath.row];
    
    TYTextContainer *textContaner = [self creatTextContainerByMessage:message.allstring];//创建文本容器
    textContaner = [textContaner createTextContainerWithTextWidth:GLScreenW - 20];
    return textContaner.textHeight+8 - 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //单击退键盘
    [self.view endEditing:YES];
}
//滚动到底部
-(void)scrollviewToEnd{
    NSUInteger rowCount = [self.tableView numberOfSections];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:rowCount-1];
    
    [self.tableView scrollToRowAtIndexPath:indexPath
     
                             atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
#pragma mark 消息聊天部分
#pragma mark 消息窗体部分
- (TYTextContainer *)creatTextContainerByjzb_Message:(DanmuItem *)message {
    //     属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
//    textContainer.text = message.allstring;
    
    if (self.isMobShow) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSStrokeWidthAttributeName] = @(-1);
        dict[NSStrokeColorAttributeName] = [UIColor blackColor];
        
        textContainer.attributedText = [[NSAttributedString alloc]initWithString:message.allstring attributes:dict];
    }else {
        textContainer.text = message.allstring;
    }
    
    
    
    // 正则匹配图片信息
//    [message enumerateStringsMatchedByRegex:@"\\[(emoji_\\d+?)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//        
//        if (captureCount > 1) {
//            // 图片信息储存
//            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
//            imageStorage.cacheImageOnMemory = YES;
//            imageStorage.imageName = capturedStrings[1];
//            imageStorage.range = capturedRanges[0];
//            imageStorage.size = CGSizeMake(25, 25);
//            
//            [tmpArray addObject:imageStorage];
//        }
//    }];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    if (message.isvip) {
        // 图片信息储存
        TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
        imageStorage.cacheImageOnMemory = YES;
        imageStorage.imageName = @"ZB_HY";
        imageStorage.range = NSMakeRange(0, 0);
        imageStorage.size = CGSizeMake(30, 15);
        
        [tmpArray addObject:imageStorage];
        
//        // 图片信息储存
//        TYImageStorage *imageStorage1 = [[TYImageStorage alloc]init];
//        imageStorage1.cacheImageOnMemory = YES;
//        imageStorage1.imageName = @"";
//        imageStorage1.range = NSMakeRange(0, 1);
//        imageStorage1.size = CGSizeMake(10, 15);
//        
//        [tmpArray addObject:imageStorage];
        
//        TYTextStorage *textStorage = [[TYTextStorage alloc]init];
//        NSRange range = [message.allstring rangeOfString:message.userName];
//        textStorage.range = range;
        
//        TYTextStorage *textStorage1 = [[TYTextStorage alloc]init];
//        [textStorage1 ]
//        
//        textStorage1.text = @"111";
//        textStorage1.range = NSMakeRange(0, 1);
//        [tmpArray addObject:textStorage1];
    }
    
    // 添加图片信息数组到label
    [textContainer addTextStorageArray:tmpArray];
    
    //文本中的"haha"则变ff9800
    TYTextStorage *textStorage = [[TYTextStorage alloc]init];

    if (message.userName) {
        NSRange range = [message.allstring rangeOfString:message.userName];
        textStorage.range = range;
    }
    
    textStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"];
    textStorage.font = [UIFont systemFontOfSize:16];
//    textStorage.font = [UIFont systemFontOfSize:16 weight:10];
    
    [textContainer addTextStorage:textStorage];
    textContainer.linesSpacing = 2;
    
    if (message.is_bluecontent) {
        TYTextStorage *textStorage = [[TYTextStorage alloc]init];
        if (message.content_blue) {
            NSRange range = [message.allstring rangeOfString:message.content_blue];
            textStorage.range = range;
        }
        
        textStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
        textStorage.font = [UIFont systemFontOfSize:16];
        //    textStorage.font = [UIFont systemFontOfSize:16 weight:10];

        [textContainer addTextStorage:textStorage];
        textContainer.linesSpacing = 2;
    }
    
    if (message.is_redcontent) {
        TYTextStorage *textStorage = [[TYTextStorage alloc]init];
        if (message.content_red) {
            NSRange range = [message.allstring rangeOfString:message.content_red];
            textStorage.range = range;
        }
        
        textStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"ff0202"];
        textStorage.font = [UIFont systemFontOfSize:16];
        //    textStorage.font = [UIFont systemFontOfSize:16 weight:10];
        
        [textContainer addTextStorage:textStorage];
        textContainer.linesSpacing = 2;
    }
    
    if (message.is_whitecontent_mob) {
        TYTextStorage *textStorage = [[TYTextStorage alloc]init];
        if (message.content_white_mob) {
            NSRange range = [message.allstring rangeOfString:message.content_white_mob];
            textStorage.range = range;
        }
        
        textStorage.textColor = [UIColor whiteColor];
        textStorage.font = [UIFont systemFontOfSize:16];
        //    textStorage.font = [UIFont systemFontOfSize:16 weight:10];
        
        [textContainer addTextStorage:textStorage];
        textContainer.linesSpacing = 2;
    }
    
    if (message.is_bluecontent_mob) {
        TYTextStorage *textStorage = [[TYTextStorage alloc]init];
        if (message.content_blue_mob) {
            NSRange range = [message.allstring rangeOfString:message.content_blue_mob];
            textStorage.range = range;
        }
        
        textStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"00f2f3"];
        textStorage.font = [UIFont systemFontOfSize:16];
        //    textStorage.font = [UIFont systemFontOfSize:16 weight:10];
        
        [textContainer addTextStorage:textStorage];
        textContainer.linesSpacing = 2;
    }
    
    if (message.is_greencontent_mob) {
        TYTextStorage *textStorage = [[TYTextStorage alloc]init];
        if (message.content_green_mob) {
            NSRange range = [message.allstring rangeOfString:message.content_green_mob];
            textStorage.range = range;
        }
        
        textStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"53ffb9"];
        textStorage.font = [UIFont systemFontOfSize:16];
        //    textStorage.font = [UIFont systemFontOfSize:16 weight:10];
        
        [textContainer addTextStorage:textStorage];
        textContainer.linesSpacing = 2;
    }
    
    
//    
//    TYTextStorage *textStorage2 = [[TYTextStorage alloc]init];
////    ;
//    NSRange range2 = [message.allstring rangeOfString:message.userName];
//    
//    
//    NSMutableAttributedString *straa = [[NSMutableAttributedString alloc]initWithString:@"111111"];
//    
//    [textStorage2 addTextStorageWithAttributedString:straa];
//    
//    textStorage2.range = range2;
//    textStorage2.text = @"111111";
//    
//    [textContainer addTextStorage:textStorage2];
    
    
    return textContainer;
}


- (TYTextContainer *)creatTextContainerByMessage:(NSString *)message {
    //     属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = message;
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // 正则匹配图片信息
    [message enumerateStringsMatchedByRegex:@"\\[(emoji_\\d+?)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 1) {
            // 图片信息储存
            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
            imageStorage.cacheImageOnMemory = YES;
            imageStorage.imageName = capturedStrings[1];
            imageStorage.range = capturedRanges[0];
            imageStorage.size = CGSizeMake(25, 25);
            
            [tmpArray addObject:imageStorage];
        }
    }];
    
    // 添加图片信息数组到label
    [textContainer addTextStorageArray:tmpArray];
    //文本中的"haha"则变红
    NSRange range = [message rangeOfString:@"haha"];
    TYTextStorage *textStorage = [[TYTextStorage alloc]init];
    textStorage.range = range;
    textStorage.textColor = [UIColor redColor];
    textStorage.font = [UIFont systemFontOfSize:16 weight:10];
    
    [textContainer addTextStorage:textStorage];
    textContainer.linesSpacing = 2;
    
    return textContainer;
}

#pragma mark - TYAttributedLabelDelegate
/******************该点击事件可通过代理形式传到主控制器,由外界处理,此处仅为演示**********************/

//点击了特殊文本或图片
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    NSLog(@"textStorageClickedAtPoint");
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        
        id linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isKindOfClass:[NSString class]]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:linkStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }else if ([TextRun isKindOfClass:[TYImageStorage class]]) {
        TYImageStorage *imageStorage = (TYImageStorage *)TextRun;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:[NSString stringWithFormat:@"你点击了%@图片",imageStorage.imageName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


@end
