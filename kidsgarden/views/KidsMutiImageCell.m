//
//  KidsMutiImageCellTableViewCell.m
//  kidsgarden
//
//  Created by apple on 14/7/17.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsMutiImageCell.h"
#import "ALImageView.h"
@implementation KidsMutiImageCell{
    KidsArticle *_article;
    UILabel *title_label;
    ALImageView *coverimage_view_l;
    ALImageView *coverimage_view_m;
    ALImageView *coverimage_view_r;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.bounds.size.width-10, 20)];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont fontWithName:@"Arial" size:17];
        title_label.numberOfLines=2;
        [[self contentView] addSubview:title_label];
        float image_witdh=(self.bounds.size.width-10-2*2)/3;
        coverimage_view_l = [[ALImageView alloc] initWithFrame:CGRectMake(5, 20, image_witdh, 80)];
        coverimage_view_l.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:coverimage_view_l];
        
        coverimage_view_m = [[ALImageView alloc] initWithFrame:CGRectMake(5+image_witdh+2, 20, image_witdh, 80)];
        coverimage_view_m.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:coverimage_view_m];
        
        coverimage_view_r = [[ALImageView alloc] initWithFrame:CGRectMake(5+image_witdh*2+4, 20, image_witdh, 80)];
        coverimage_view_r.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:coverimage_view_r];
    }
    return self;
}

-(void)setArticle:(KidsArticle *)article{
    if(_article==nil||![_article.article_id isEqualToString:article.article_id]){
        _article=article;
        title_label.text=article.title;
        coverimage_view_l.imageURL=article.cover_images[0];
        coverimage_view_m.imageURL=article.cover_images[1];
        coverimage_view_r.imageURL=article.cover_images[2];
    }
}

@end
