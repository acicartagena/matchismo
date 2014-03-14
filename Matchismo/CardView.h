//
//  CardView.h
//  Matchismo
//
//  Created by Angela Cartagena on 2/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

static const CGFloat DEFAULT_CARD_WIDTH = 40.0f;
static const CGFloat DEFAULT_CARD_HEIGHT = 60.0f;

@protocol CardViewDelegate

- (void)cardSelected:(id)sender;

@end

@interface CardView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,weak) id<CardViewDelegate> delegate;
@property (nonatomic) BOOL enable;

+ (CGFloat)cardViewDefaultAspectRatio;
+ (NSInteger)initialNumberOfCards;

- (void)drawCard;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;
- (void)setCard:(Card *)card defaultEnable:(BOOL)defaultEnable;

@end
