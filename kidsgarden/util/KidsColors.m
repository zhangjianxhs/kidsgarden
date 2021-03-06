//
//  Colors.m
//  XinHuaDailyXib
//
//  Created by apple on 13-8-15.
//
//

#import "KidsColors.h"

@implementation KidsColors{
    NSMutableArray *colors;
    NSMutableArray *images;
    int ind;
}
-(id)init{
    if(self){
        self=[super init];
        colors=[NSMutableArray arrayWithObjects:
                [UIColor colorWithRed:0xaf/255.0 green:0x00/255.0 blue:0x08/255.0 alpha:1],
                [UIColor colorWithRed:0xff/255.0 green:0x66/255.0 blue:0x00/255.0 alpha:1],
                [UIColor colorWithRed:0x7b/255.0 green:0x18/255.0 blue:0x73/255.0 alpha:1],
                [UIColor colorWithRed:0x72/255.0 green:0xac/255.0 blue:0x20/255.0 alpha:1],
                [UIColor colorWithRed:0xe5/255.0 green:0xaf/255.0 blue:0x03/255.0 alpha:1],
                [UIColor colorWithRed:0x8f/255.0 green:0x8f/255.0 blue:0x8f/255.0 alpha:1],
                [UIColor colorWithRed:0x65/255.0 green:0x3f/255.0 blue:0xaf/255.0 alpha:1],
                nil];
        images=[NSMutableArray arrayWithObjects:
                [UIImage imageNamed:@"arrow_01.png"],
                [UIImage imageNamed:@"arrow_02.png"],
                [UIImage imageNamed:@"arrow_03.png"],
                [UIImage imageNamed:@"arrow_04.png"],
                [UIImage imageNamed:@"arrow_05.png"],
                [UIImage imageNamed:@"arrow_06.png"],
                nil];
        ind=0;
    }
    return self;
}
-(void)reset{
    ind=0;
}
-(UIColor *)getAColor{
    return colors[(ind++)%[colors count]];
}
@end
