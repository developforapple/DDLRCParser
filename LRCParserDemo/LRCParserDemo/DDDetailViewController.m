//
//  DDDetailViewController.m
//  LRCParserDemo
//
//  Created by Normal on 16/2/25.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "DDDetailViewController.h"

@interface DDDetailViewController ()

@end

@implementation DDDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSTimeInterval start = 20.f;
    NSTimeInterval end = 46.f;
    
    NSArray *lrcs = [self.lrc LRCUnitsAtTimeSecondFrom:start to:end];
    NSLog(@"lrcs");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrc.units.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    DDAudioLRCUnit *unit = [self.lrc LRCUnitAtLine:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%.0f",unit.sec];
    cell.detailTextLabel.text = unit.lrc;
    return cell;
}

@end
