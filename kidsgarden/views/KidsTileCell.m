//
//  KidsTileCellCollectionViewCell.m
//  kidsgarden
//
//  Created by apple on 14/6/13.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsTileCell.h"

@implementation KidsTileCell{
    ALImageView *alImageView;
    UILabel *label;
    KidsArticle *_article;
}

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        alImageView = [[ALImageView alloc] initWithFrame:CGRectMake(0,0 , frameRect.size.width , frameRect.size.height)];
        alImageView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        alImageView.imageURL = @"";
        [[self contentView] addSubview:alImageView];
        UIImageView* imv = [[UIImageView alloc] initWithFrame:CGRectMake(0,frameRect.size.height-20 , frameRect.size.width , 20)];
        imv.image = [UIImage imageNamed:@"heise.png"];
        label = [[UILabel alloc] initWithFrame:CGRectMake(5,0 , frameRect.size.width-5, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Arial" size:15];
        [imv addSubview:label];
        [[self contentView] addSubview:imv];

    }
    return self;
}
-(void)setArticle:(KidsArticle *)article{
    if(_article==nil||![_article.article_id isEqualToString:article.article_id]){
        _article=article;
        label.text=article.title;
        if(article.cover_images==nil||[article.cover_images count]==0){
            alImageView.imageURL=@"";
        }else{
            alImageView.imageURL=article.cover_images[0];
        }
    }
}

@end
