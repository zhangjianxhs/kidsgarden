//
//  KidsADView.m
//  kidsgarden
//
//  Created by apple on 14/7/18.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsADView.h"
#import "ALImageView.h"
@implementation KidsADView{
    
    KidsArticle *_current_article;
    NSArray *_articles;
    NSTimer *_timer;
    int nextIndex;
    int topIndex;
}
- (id)initWithFrame:(CGRect)frame articles:(NSArray *)articles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        if(articles!=nil && [articles count]>0){
            for(KidsArticle *article in articles){
                ALImageView *_ad_view = [[ALImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
                _ad_view.imageURL=article.thumbnail_url;
                _ad_view.userInteractionEnabled=YES;
                UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArticle)];
                [_ad_view addGestureRecognizer:singleTap];
                [self addSubview:_ad_view];
            };
            _articles=articles;
            topIndex=[articles count]-1;
            _current_article=_articles[topIndex];
            nextIndex=0;
            if(topIndex>0)
                _timer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(playNext) userInfo:nil repeats:YES];
        }
    }
    return self;
}
-(void)playNext{
    [self exchangeSubviewAtIndex:topIndex withSubviewAtIndex:nextIndex];
    //UIView开始动画，第一个参数是动画的标识，第二个参数附加的应用程序信息用来传递给动画代理消息
    [UIView beginAnimations:@"View Flip" context:nil];
    //动画持续时间
    [UIView setAnimationDuration:1.25];
    //设置动画的回调函数，设置后可以使用回调方法
    [UIView setAnimationDelegate:self];
    //设置动画曲线，控制动画速度
    [UIView  setAnimationCurve: UIViewAnimationCurveEaseInOut];
    //设置动画方式，并指出动画发生的位置
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    //提交UIView动画
    [UIView commitAnimations];
    _current_article=_articles[nextIndex];
    nextIndex++;
    nextIndex=nextIndex%topIndex;
}

-(void)openArticle{
    if([self.delegate respondsToSelector:@selector(clickedWithArticle:)]){
        [self.delegate clickedWithArticle:_current_article];
    }
}

@end
