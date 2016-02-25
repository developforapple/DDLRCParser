//
//  DDDetailViewController.h
//  LRCParserDemo
//
//  Created by Normal on 16/2/25.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAudioLRCParser.h"

@interface DDDetailViewController : UITableViewController
@property (strong, nonatomic) DDAudioLRC *lrc;
@end
