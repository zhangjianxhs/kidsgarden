//
//  KidsTouchEnrollView.m
//  kidsgarden
//
//  Created by apple on 14/7/1.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsTouchEnrollView.h"

@implementation KidsTouchEnrollView
@synthesize touchView;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        touchView = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2-100, frame.size.height/2-200, 200.0f, 200.0f)];
        touchView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"click_select_class.png"]];
        [touchView addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:touchView];
        self.hidden=YES;
    }
    return self;
}

-(void)click{
    [self.delegate clicked];
}
-(void)hide{
    self.hidden=YES;
}
-(void)show{
    self.hidden=NO;
}
@end
