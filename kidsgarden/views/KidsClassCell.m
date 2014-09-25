//
//  KidsClassCell.m
//  kidsgarden
//
//  Created by apple on 14/6/24.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsClassCell.h"
#import "KidsClass.h"
@implementation KidsClassCell{
    UILabel *label;
    KidsClass *_class;
}

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(5,frameRect.size.height/2-20, frameRect.size.width-5, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Arial" size:15];
        [[self contentView] addSubview:label];
        self.selectedBackgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_class_check.png"]];
        self.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_class_add.png"]];
    }
    return self;
}
-(void)setClass:(KidsClass *)class{
    if(class==nil||_class.class_id!=class.class_id){
        _class=class;
        label.text=class.class_name;
    }
}
@end
