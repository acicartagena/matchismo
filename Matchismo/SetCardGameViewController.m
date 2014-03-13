//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by it_admin on 1/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"
#import "SetCard.h"
#import "Card.h"
#import "SetCardView.h"

#define SET_CARD_GAME_INIT_COUNT 12

@interface SetCardGameViewController ()

@property (nonatomic) NSInteger cardCount;

@end

@implementation SetCardGameViewController

#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cardCount =SET_CARD_GAME_INIT_COUNT;
    
    self.grid.size = self.gameCardsView.frame.size;
    self.grid.cellAspectRatio = [CardView cardViewDefaultAspectRatio];
    self.grid.minimumNumberOfCells = self.cardCount;
    
    [self game];
    [self updateUINewGame];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self updateUI];
    [self setGameType:GAME_TYPE_SET];
    
}

#pragma mark - 
-(Deck*) createDeck{
    return [[SetCardDeck alloc] init];
    
}

- (CardMatchingGame *)createGame
{
    if ([self.cardViews count]>0){
        [self.cardViews removeAllObjects];
    }
    if ([[self.gameCardsView subviews] count]>0){
        for (UIView *cardView in [self.gameCardsView subviews]){
            [cardView removeFromSuperview];
        }
    }
    
    NSLog(@"center x:%f y:%f",self.view.center.x,self.view.center.y);
    
    int x = 0;
    for (int i=0; i<self.grid.rowCount; i++){
        for (int j=0; j<self.grid.columnCount; j++){
            x +=1;
            if (x> self.cardCount){
                break;
            }
            CGRect frame =[self.grid frameOfCellAtRow:i inColumn:j];
            SetCardView *cardView =[[SetCardView alloc] initWithFrame:CGRectMake(self.view.center.x - frame.size.width + x*1.0f, self.view.center.y - frame.size.height*2 + x*1.f, frame.size.width, frame.size.height)];
            cardView.delegate = self;
            [UIView animateWithDuration:0.5f delay:x*0.2f options:0 animations:^{
                cardView.frame = frame;
            } completion:^(BOOL finished) {
                [self.gameCardsView sendSubviewToBack:cardView];
            }];
            
            [self.cardViews addObject:cardView];
            if (x==1){
                [self.gameCardsView addSubview:cardView];
            }else{
                [self.gameCardsView insertSubview:cardView belowSubview:self.cardViews[x-2]];
            }
            
        }
        if (x> self.cardCount){
            break;
        }
    }
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count] usingDeck:[self createDeck]];
}


-(UIImage *) backgroundImageForCard:(Card *)card{
    //NSLog(@"card is chosen: %i ui image: %@",card.isChosen, temp);
    return [UIImage imageNamed:card.isChosen ? @"matchedSetCard" : @"cardFront"];
}

-(NSAttributedString *) attributedTitleForCard:(Card *)card{
    NSMutableAttributedString *temp;
//    SetCard *setCard = (SetCard*)card;
//    if (card.contentsDictionary){
//        NSString *stringTemp = @"";
//        for (int i=1;i<=setCard.rank;i++){
//            stringTemp = [stringTemp stringByAppendingString:[NSString stringWithFormat:@"%@ ",setCard.symbol]];
//        }
//        temp = [[NSMutableAttributedString alloc] initWithString:stringTemp];
//        
//        if (setCard.shading == SetCardShadingOpen){
//            [temp addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, stringTemp.length)];
//            
//            [temp addAttribute:NSStrokeWidthAttributeName value:@-4 range:NSMakeRange(0, stringTemp.length)];
//            if ([setCard.color isEqualToString:RED_COLOR]){
//                [temp addAttribute:NSStrokeColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, stringTemp.length)];
//            }else if ([setCard.color isEqualToString:GREEN_COLOR]){
//                [temp addAttribute:NSStrokeColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, stringTemp.length)];
//            }else if ([setCard.color isEqualToString:PURPLE_COLOR]){
//                [temp addAttribute:NSStrokeColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, stringTemp.length)];
//            }
//        }
//        else if (setCard.shading == SetCardShadingStriped){
//            NSLog(@"stripe:%@",[setCard contents]);
//            if ([setCard.color isEqualToString:RED_COLOR]){
//                [temp addAttribute:NSForegroundColorAttributeName value:[[UIColor redColor] colorWithAlphaComponent:0.3f] range:NSMakeRange(0, stringTemp.length)];
//            }else if ([setCard.color isEqualToString:GREEN_COLOR]){
//                [temp addAttribute:NSForegroundColorAttributeName value:[[UIColor greenColor] colorWithAlphaComponent:0.3f] range:NSMakeRange(0, stringTemp.length)];
//            }else if ([setCard.color isEqualToString:PURPLE_COLOR]){
//                [temp addAttribute:NSForegroundColorAttributeName value:[[UIColor purpleColor] colorWithAlphaComponent:0.3f] range:NSMakeRange(0, stringTemp.length)];
//            }
//            
//        }
//        else{
//            
//            if ([setCard.color isEqualToString:RED_COLOR]){
//                [temp addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, stringTemp.length)];
//            }else if ([setCard.color isEqualToString:GREEN_COLOR]){
//                [temp addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, stringTemp.length)];
//            }else if ([setCard.color isEqualToString:PURPLE_COLOR]){
//                [temp addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, stringTemp.length)];
//            }
//        }
//    }
    return temp;
}

- (void)updateUINewGame
{
    int i=0;
    for (SetCardView *cardView in self.cardViews){
        SetCard  *card = (SetCard *)[self.game cardAtIndex:i++];
        [self updateView:cardView forCard:card defaultEnable:NO];
    }
}

- (void)updateView:(CardView *)cardView forCard:(Card *)card defaultEnable:(BOOL)defaultEnable
{
    
    SetCard* setCard = (SetCard *)card;
    SetCardView *setCardView = (SetCardView *)cardView;
    
    [setCardView setRank:setCard.rank];
    [setCardView setShade:setCard.shading];
    [setCardView setShape:setCard.symbol];
    [setCardView setColor:setCard.color];
    [setCardView setEnable:YES];
}

@end
