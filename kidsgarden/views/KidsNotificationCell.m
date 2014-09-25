//
//  KidsNotificationCell.m
//  kidsgarden
//
//  Created by apple on 14/8/22.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsNotificationCell.h"

@implementation KidsNotificationCell{
    UILabel *title_label;
    KidsArticle *_article;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bgleft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
        bgleft.image=[UIImage imageNamed:@"notify1.png"];
        [[self contentView] addSubview:bgleft];
        UIImageView *bgRight=[[UIImageView alloc]initWithFrame:CGRectMake(70, 10, 245, 50)];
        bgRight.image=[UIImage imageNamed:@"notify_bg.png"];
        [[self contentView] addSubview:bgRight];
        
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 225, 30)];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont fontWithName:@"Arial" size:17];
        title_label.numberOfLines=1;
        title_label.textColor=[UIColor whiteColor];
        [bgRight addSubview:title_label];
    }
    return self;
}

-(void)setArticle:(KidsArticle *)article{
    if(_article==nil||![_article.article_id isEqualToString:article.article_id]){
        title_label.text=article.title;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
