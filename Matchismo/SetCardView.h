//
//  SetCardView.h
//  Matchismo
//
//  Created by Angela Cartagena on 2/19/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "CardView.h"
#import "SetCard.h"

@interface SetCardView : CardView

@property (nonatomic) SetCardShapeType shape;
@property (nonatomic) SetCardColorType color;
@property (nonatomic) SetCardShadingType shade;
@property (nonatomic) NSInteger rank;

@end
