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

@interface SetCard : Card

@property (nonatomic) NSUInteger rank;
@property (strong,nonatomic) NSString *symbol;
@property (strong,nonatomic) NSString *color;

typedef enum SetCardShadingTypes{
    SetCardShadingSolid,
    SetCardShadingStriped,
    SetCardShadingOpen
} SetCardShadingType;
@property (nonatomic) SetCardShadingType shading;

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

+(NSUInteger) maxRank;
+(NSArray *) validSymbols;
+(NSArray *) validColors;
+(NSArray *) validShades;


@end
