//
//  KidsFooterView.m
//  kidsgarden
//
//  Created by apple on 14/6/18.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsFooterView.h"

@implementation KidsFooterView{
    UIButton *loadBtn;
    UIActivityIndicatorView *tableFooterActivityIndicator;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        loadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        loadBtn.frame=CGRectMake(0, 10, 320, 20);
        [loadBtn setTitle:@"正在载入" forState:UIControlStateNormal];
        [loadBtn addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loadBtn];
        tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(70.0f, 5.0f, 20.0f, 10.0f)];
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [tableFooterActivityIndicator startAnimating];
        [loadBtn addSubview:tableFooterActivityIndicator];
        self.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1 ];
        [self setStatus:buzy];
    }
    return self;
}
-(void)loadMore{
    if([self.delegate respondsToSelector:@selector(loadMoreData)]){
        [self.delegate loadMoreData];
    }
}
-(void)setStatus:(FooterViewStatus)status{
    if(status==buzy){
        [loadBtn setTitle:@"正在载入" forState:UIControlStateNormal];
        [tableFooterActivityIndicator startAnimating];
        loadBtn.enabled=NO;
        [self loadMore];
    }else{
        [loadBtn setTitle:@"显示下20条" forState:UIControlStateNormal];
        [tableFooterActivityIndicator stopAnimating];
        loadBtn.enabled=YES;
    }
}
@end
