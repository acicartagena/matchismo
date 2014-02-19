//
//  CardView.m
//  Matchismo
//
//  Created by Angela Cartagena on 2/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    tap.delegate = self;

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
