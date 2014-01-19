//
//  SetCard.m
//  Matchismo
//
//  Created by it_admin on 1/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "SetCard.h"

@interface SetCard ()

@end

@implementation SetCard

@synthesize symbol = _symbol;
@synthesize color = _color;
@synthesize contentsDictionary = _contentsDictionary;

-(instancetype) init{
    self = [super init];
    if (self){
        
    }
    return self;
}

+(NSArray*) validSymbols{
    return @[@"▲",@"●",@"■"];
}

+(NSArray*) validShades{
    return @[@(SetCardShadingOpen),@(SetCardShadingStriped),@(SetCardShadingSolid)];
}

+(NSArray*) validColors{
    return @[RED_COLOR,GREEN_COLOR,PURPLE_COLOR];
}

+(NSUInteger) maxRank{
    return 3;
}

-(NSDictionary*) contentsDictionary{
    if (!_contentsDictionary){
        _contentsDictionary = @{@"color":self.color, @"rank":@(self.rank),@"shading":@(self.shading),@"symbol":self.symbol};
    }
    return _contentsDictionary;
}

//format for contents <rank><color><symbol><shading>
-(NSString *)contents{
    //return [NSString stringWithFormat:@"%i%@%@%i",[self rank],[self color],[self symbol],[self shading]];
    return nil;
}

-(NSAttributedString*) attributedContents{
    NSMutableAttributedString *temp;
    return temp;
}

-(NSString *)symbol{
    return _symbol ? _symbol:@"?";
}

-(void) setSymbol:(NSString *)symbol{
    if ([[SetCard validSymbols] containsObject:symbol]){
        _symbol = symbol;
    }
}

-(NSString *)color{
    return _color ? _color:@"?";
}

-(void) setColor:(NSString *)color{
    if ([[SetCard validColors] containsObject:color]){
        _color = color;
    }
}

-(void) setRank:(NSUInteger)rank{
    if (rank<= [SetCard maxRank]){
        _rank = rank;
    }
}

-(int) match:(NSArray *)otherCards{
    int score = 0;
    int partial =0;
    
    //check for same cards
    NSEnumerator *keyEnum = [self.contentsDictionary keyEnumerator];
    NSString *key = nil;
    while (key = (NSString*) [keyEnum nextObject]){
        //NSLog(@"check key:%@",key);
        partial = [self checkProperty:key OfCards:otherCards forSameValue:YES];
        //NSLog(@"partial after check same value: %i",partial);
        if (partial != 2){
            partial = [self checkProperty:key OfCards:otherCards forSameValue:NO];
        }
        //NSLog(@"partial after check different value: %i",partial);
        if (partial != 2){
            score = 0;
            break;
        }else{
            score = 8;
        }
    }
    //NSLog(@"score:%i",score);
    return score;
}

-(int) checkProperty:(NSString*)property OfCards:(NSArray*)otherCards forSameValue:(BOOL)isSame{
    
    int score = 0;
    //NSLog(@"predicate: %@ == %@",property,self.contentsDictionary[property]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" self.%@ == %@",property,self.contentsDictionary[property]];
    NSArray* filteredArray = [otherCards filteredArrayUsingPredicate:predicate];
    //NSLog(@"filtered array count:%i, otherCards count:%i",filteredArray.count,otherCards.count);
    if (isSame && (filteredArray.count == otherCards.count)){
        score = 1;
        //NSLog(@"1score:%i",score);
        if (otherCards.count == 2){
            //NSLog(@"check 2 cards");
            score += [otherCards[0] checkProperty:property OfCards:@[otherCards[1]] forSameValue:isSame];
            //NSLog(@"2score:%i",score);
        }
        
    }else if (!isSame && (filteredArray.count == 0)){
        score = 1;
        //NSLog(@"1score:%i",score);
        if (otherCards.count == 2){
            //NSLog(@"check 2 cards");
            score += [otherCards[0] checkProperty:property OfCards:@[otherCards[1]] forSameValue:isSame];
            //NSLog(@"2score:%i",score);
        }
    }
    
    return score;
}
@end
