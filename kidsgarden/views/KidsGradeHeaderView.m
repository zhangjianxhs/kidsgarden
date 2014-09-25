//
//  KidsGradeHeaderView.m
//  kidsgarden
//
//  Created by apple on 14/6/24.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsGradeHeaderView.h"
#import "KidsGrade.h"
@implementation KidsGradeHeaderView{
    UILabel *label;
    KidsGrade *_grade;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(5,5 , frame.size.width-5, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Arial" size:20];
        [self  addSubview:label];
        self.backgroundColor=[UIColor lightGrayColor];
    }
    return self;
}

-(void)setGrade:(KidsGrade *)grade{
    if(grade==nil||_grade.grade_id!=grade.grade_id){
        _grade=grade;
        label.text=grade.grade_name;
    }
}

@end
