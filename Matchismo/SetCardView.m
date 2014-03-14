//
//  SetCardView.m
//  Matchismo
//
//  Created by Angela Cartagena on 2/19/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

+ (NSInteger)initialNumberOfCards
{
    return 12;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)setCard:(Card *)card defaultEnable:(BOOL)defaultEnable
{
    
    SetCard* setCard = (SetCard *)card;
    
    [self setRank:setCard.rank];
    [self setShade:setCard.shading];
    [self setShape:setCard.symbol];
    [self setColor:setCard.color];
    [self setEnable:!card.isChosen];
}

- (void)setShade:(SetCardShadingType)shade
{
    _shade = shade;
    [self setNeedsDisplay];
}

- (void)setColor:(SetCardColorType)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShape:(SetCardShapeType)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setRank:(NSInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self drawCard];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *shape;
    for (int rankCounter=0; rankCounter<self.rank; rankCounter++){
        
        switch (self.shape) {
            case SetCardShapeDiamond:
                shape = [self drawDiamondForCount:rankCounter];
                break;
            case SetCardShapeSquiggle:
                shape = [self drawSquiggleForCount:rankCounter];
                break;
            case SetCardShapeOval:
                shape =[self drawOvalForCount:rankCounter];
                break;
        }
        
        [[self getColorForType] setStroke];
        [shape stroke];
        
        CGContextSaveGState(context);
        [shape addClip];
        switch (self.shade) {
            case SetCardShadingOpen:
                break;
            case SetCardShadingSolid:
                [[self getColorForType] setFill];
                [shape fill];
                //[shape fillWithBlendMode:kCGBlendModeNormal alpha:self.enable ? 1.0f:0.5f];
                break;
            case SetCardShadingStriped:
                [self stripShapeForCount:rankCounter];
                break;
        }
        CGContextRestoreGState(context);
    }
}


- (UIColor *)getColorForType
{
    switch (self.color) {
        case SetCardColorRed:
            return [UIColor redColor];
        case SetCardColorPurple:
            return [UIColor purpleColor];
        case SetCardColorGreen:
            return [UIColor greenColor];
    }
}

- (void)stripShapeForCount:(NSInteger)count
{
    CGRect referenceRect = [self getRectForCount:count];
    
    for (int i=1; i<11; i++){
        UIBezierPath *line = [UIBezierPath bezierPath];
        [line moveToPoint:CGPointMake(referenceRect.origin.x + i*referenceRect.size.width*0.1f, referenceRect.origin.y)];
        [line addLineToPoint:CGPointMake(referenceRect.origin.x + i*referenceRect.size.width*0.1f, referenceRect.origin.y + referenceRect.size.height)];
        
        [[self getColorForType] setStroke];
        [line stroke];
    }
}

- (UIBezierPath *)drawOvalForCount:(NSInteger )count
{
    UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:[self getRectForCount:count]];
    return oval;
}

- (UIBezierPath *)drawDiamondForCount:(NSInteger )count
{
    UIBezierPath *diamond = [UIBezierPath bezierPath];
    CGRect referenceRect = [self getRectForCount:count];
    
    [diamond moveToPoint:CGPointMake(referenceRect.origin.x, referenceRect.origin.y + referenceRect.size.height*0.5f)];
    
    [diamond addLineToPoint:CGPointMake(referenceRect.origin.x + referenceRect.size.width*0.5f, referenceRect.origin.y)];
    [diamond addLineToPoint:CGPointMake(referenceRect.origin.x + referenceRect.size.width, referenceRect.origin.y + referenceRect.size.height*0.5f)];
    [diamond addLineToPoint:CGPointMake(referenceRect.origin.x + referenceRect.size.width*0.5f, referenceRect.origin.y + referenceRect.size.height)];
    [diamond closePath];
    
    return diamond;
}

- (UIBezierPath *)drawSquiggleForCount:(NSInteger )count
{
    UIBezierPath *squiggle = [UIBezierPath bezierPathWithRect:[self getRectForCount:count]];
    return squiggle;
}

- (CGRect)getRectForCount:(NSInteger)count
{

    CGFloat y;
    if (self.rank == 1){
        y = self.bounds.size.height*0.5f - self.bounds.size.width*0.25f*0.25f;
    }else if (self.rank == 2){
        if (count == 0){
            y = self.bounds.size.height*0.5f - self.bounds.size.width*0.25f*0.75f;
        }else{
            y = self.bounds.size.height*0.5f + self.bounds.size.width*0.25f*0.5f;
        }
    }else{
        if (count == 0){
            y = self.bounds.size.height*0.5f - self.bounds.size.width*0.25f*1.5f;
        }else if (count == 1){
            y = self.bounds.size.height*0.5f - self.bounds.size.width*0.25f*0.25f;
        }else {
            y = self.bounds.size.height*0.5f + self.bounds.size.width*0.25f;
        }
    }
    CGFloat x = self.bounds.size.width*0.5f - self.bounds.size.height*0.25f*0.5f;
    CGFloat width = self.bounds.size.height*0.25f;
    CGFloat height = self.bounds.size.width*0.25f;
    return CGRectMake(x,y,width,height);
}

@end
