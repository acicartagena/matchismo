//
//  SetCard.h
//  Matchismo
//
//  Created by it_admin on 1/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Card.h"

#define RED_COLOR @"R"
#define GREEN_COLOR @"G"
#define PURPLE_COLOR @"P"

typedef enum SetCardShadingTypes{
    SetCardShadingSolid,
    SetCardShadingStriped,
    SetCardShadingOpen
} SetCardShadingType;

typedef enum SetCardColorTypes{
    SetCardColorRed,
    SetCardColorGreen,
    SetCardColorPurple
} SetCardColorType;

typedef enum SetCardShapeTypes{
    SetCardShapeDiamond,
    SetCardShapeOval,
    SetCardShapeSquiggle
} SetCardShapeType;

@interface SetCard : Card

@property (nonatomic) NSUInteger rank;
@property (nonatomic) SetCardShapeType symbol;
@property (nonatomic) SetCardColorType color;
@property (nonatomic) SetCardShadingType shading;

+(NSUInteger) maxRank;
+(NSArray *) validSymbols;
+(NSArray *) validColors;
+(NSArray *) validShades;

@end
