//
//  CusSearchVC.m
//  JZBRelease
//
//  Created by cl z on 16/10/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#import "CusSearchVC.h"
#import "LocalDataRW.h"
#import "CusSearchViewCell.h"

@interface CusSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITextField *textField;
}
@property (nonatomic, strong) NSMutableArray *searchKeyWordAry;
@property (nonatomic, strong) UIView *clearView;

@end

@implementation CusSearchVC


- (instancetype)initWithplaceholder:(NSString *)placeholder
                      WithAdresaName:(NSString *)adressName
             WithParentOrDeleagteVC:(UIViewController<CusSearchDelegate> *)parentVC{
    self = [super init];
    if (self) {
        self.cusSearchModel = [[CusSearchModel alloc]init];
        self.cusSearchModel.placeholder = placeholder;
        self.cusSearchModel.adressName = adressName;
        self.delegate = parentVC;
        self.view.frame = parentVC.view.frame;
        [parentVC.view addSubview:self.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
    [nav setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color_new" WithKind:XMLTypeColors]]];
    [self.view addSubview:nav];
    UIButton *cancle = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width - 40 - 17, 6 + 20, 50, 32)];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [cancle.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [nav addSubview:cancle];
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(16, 8 + 20, Screen_Width - 16 - 50 - 14, 28)];
    searchView.layer.cornerRadius = 4.0;
    [searchView setBackgroundColor:[UIColor whiteColor]];
    [nav addSubview:searchView];
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 7, 14, 14)];
    [searchImageView setImage:[UIImage imageNamed:@"bangba_seek_sk"]];
    [searchView addSubview:searchImageView];
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(20 + 14, 0, searchView.frame.size.width - 20 - 14, searchView.frame.size.height)];
    [textField setFont:[UIFont systemFontOfSize:13]];
    [textField setTextColor:[UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1]];
    textField.tintColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]];
    [textField setReturnKeyType:UIReturnKeySearch];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.placeholder = self.cusSearchModel.placeholder;
    textField.delegate = self;
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField addTarget:self action:@selector(textChanges:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:textField];
    [textField becomeFirstResponder];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.searchKeyWordAry = [LocalDataRW readDataFromLocalOfDocument:self.cusSearchModel.adressName WithDirectory_Type:Directory_BB];
    
    if (self.searchKeyWordAry && self.searchKeyWordAry.count > 0) {
        [self.keyWordTableView reloadData];
    }

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
}


- (void)textChanges:(UITextField *)textfield{
    if (!textField.clearsOnBeginEditing) {
        if (textField.text.length == 0) {
            if ([self.delegate respondsToSelector:@selector(clearBtnAction)]) {
                [self.delegate clearBtnAction];
            }
        }
    }
}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(clearBtnAction)]) {
        [self.delegate clearBtnAction];
    }
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    
}


-(void) backAction{
    if ([self.delegate respondsToSelector:@selector(gobackAction)]) {
        [self.keyWordTableView removeFromSuperview];
        [self.searchKeyWordAry removeAllObjects];
        self.searchKeyWordAry = nil;
        self.keyWordTableView = nil;
        [self.delegate gobackAction];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textFields{
    if (self.keyWordTableView) {
        self.keyWordTableView.hidden = YES;
        [self.keyWordTableView removeFromSuperview];
        self.keyWordTableView = nil;
    }
    
    if (textFields.text.length >= 15) {
        [Toast makeShowCommen:@"您的搜索字数 " ShowHighlight:@"太长" HowLong:1.1];
        return NO;
    }else{
        if (textFields.text.length <= 0) {
            //[Toast makeShowCommen:@"您的搜索字数 " ShowHighlight:@"太短" HowLong:1.1];
            return NO;
        }else{
            [textField resignFirstResponder];
            if (!self.searchKeyWordAry) {
                self.searchKeyWordAry = [[NSMutableArray alloc]init];
            }
//            int num = 0;
//            BOOL isExist;
//            for (int i = 0; i < self.searchKeyWordAry.count; i ++) {
//                NSString *word = [self.searchKeyWordAry objectAtIndex:i];
//                if ([word isEqualToString:textField.text]) {
//                    isExist = YES;
//                    num = i;
//                    break;
//                }
//            }
//            if (isExist) {
//                
//               // [self.searchKeyWordAry exchangeObjectAtIndex:0 withObjectAtIndex:num];
//                NSString *zeroword = [self.searchKeyWordAry objectAtIndex:0];
//                NSString *numword = [self.searchKeyWordAry objectAtIndex:num];
//                NSString *temp  = [zeroword copy];
//                self.searchKeyWordAry[0] = numword;
//                self.searchKeyWordAry[num] = temp;
//                [self.keyWordTableView reloadData];
//                [LocalDataRW writeDataToLocaOfDocument:self.searchKeyWordAry WithDirectory_Type:Directory_BB AtFileName:self.cusSearchModel.adressName];
//                if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
//                    [self.delegate beginSearch:textField.text];
//                }
//                return YES;
//            }
            
            if (self.searchKeyWordAry.count == 10) {
                [self.searchKeyWordAry removeObjectAtIndex:9];
            }
            [self.searchKeyWordAry insertObject:textField.text atIndex:0];
            [LocalDataRW writeDataToLocaOfDocument:self.searchKeyWordAry WithDirectory_Type:Directory_BB AtFileName:self.cusSearchModel.adressName];
            if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
                [self.delegate beginSearch:textField.text];
            }
            return YES;
        }
    }
}

- (UITableView *) keyWordTableView{
    if (!_keyWordTableView) {
        _keyWordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        _keyWordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _keyWordTableView.delegate = self;
        _keyWordTableView.dataSource = self;
        _keyWordTableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_keyWordTableView];
    }
    return _keyWordTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.searchKeyWordAry || self.searchKeyWordAry.count == 0) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchKeyWordAry) {
        
        /** 全部列表页面的空数据占位图片 */
        notDataShowView *view;
        
        if (self.searchKeyWordAry.count) {
            if ([notDataShowView sharenotDataShowView].superview) {
                [[notDataShowView sharenotDataShowView] removeFromSuperview];
            }
        }else {
            view = [notDataShowView sharenotDataShowView:tableView];
            [tableView addSubview:view];
            
        }
        
        return self.searchKeyWordAry.count;
    }
    return 0;
}

- (UIView *)clearView{
    if (!_clearView) {
        _clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
        [_clearView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
        [clearBtn setTitle:@"清除所有历史" forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearALLRecord) forControlEvents:UIControlEventTouchUpInside];
        [clearBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"2196f0"] forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"787878"] forState:UIControlStateHighlighted];
        [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_clearView addSubview:clearBtn];
    }
    return _clearView;
}

- (void) clearALLRecord{
    [self.searchKeyWordAry removeAllObjects];
     [LocalDataRW writeDataToLocaOfDocument:self.searchKeyWordAry WithDirectory_Type:Directory_BB AtFileName:self.cusSearchModel.adressName];
    [self.keyWordTableView reloadData];
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.clearView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* SearchKeyWordCellIdentifier = @"SearchKeyWordCellIdentifier";
    CusSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchKeyWordCellIdentifier];
    if (!cell) {
        cell = [[CusSearchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchKeyWordCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setTitleStr:[self.searchKeyWordAry objectAtIndex:indexPath.row]];
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)btnAction:(UIButton *)btn{
    if (self.searchKeyWordAry.count > btn.tag) {
        [self.searchKeyWordAry removeObjectAtIndex:btn.tag];
        [self.keyWordTableView reloadData];
        [LocalDataRW writeDataToLocaOfDocument:self.searchKeyWordAry WithDirectory_Type:Directory_BB AtFileName:self.cusSearchModel.adressName];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
        [textField setText:[self.searchKeyWordAry objectAtIndex:indexPath.row]];
        [self.delegate beginSearch:textField.text];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

@end
