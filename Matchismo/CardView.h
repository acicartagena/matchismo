//
//  CardView.h
//  Matchismo
//
//  Created by Angela Cartagena on 2/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardViewDelegate

- (void)cardSelected:(id)sender;

@end

@interface CardView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,weak) id<CardViewDelegate> delegate;

@end
