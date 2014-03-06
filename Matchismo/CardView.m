//
//  CardView.m
//  Matchismo
//
//  Created by Angela Cartagena on 2/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "CardView.h"

@implementation CardView



+ (CGFloat)cardViewDefaultAspectRatio
{
    return DEFAULT_CARD_WIDTH/DEFAULT_CARD_HEIGHT;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, DEFAULT_CARD_WIDTH, DEFAULT_CARD_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        tap.delegate = self;
        
    }
    return self;
}

- (void)tapCard:(UIGestureRecognizer *)tapGestureRecognizer
{
    [self.delegate cardSelected:self];
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
