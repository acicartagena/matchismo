//
//  HighScoresViewController.h
//  Matchismo
//
//  Created by Aci Cartagena on 2/10/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SAVE_KEY_NAME @"name"
#define SAVE_KEY_SCORE @"score"
#define SAVE_KEY_GAME_TYPE @"game"
#define SAVE_KEY_TIME @"time"

#define SAVE_KEY @"scoreData"

@interface HighScoresViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@end
