//
//  SUNTextFieldDemoViewController.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-8-21.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNTextField.h"

@interface CommonViewController : UIViewController
{
    SUNTextField *_textFieldName;
    
}

@property (nonatomic, strong) SUNTextField *textFieldName;

@end
