//
//  DDDetailViewController.m
//  LRCParserDemo
//
//  Created by Normal on 16/2/25.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "DDDetailViewController.h"
#import "LRCParser/DDAudioLRCParser.h"

@interface DDDetailViewController ()<DDAudioLRCParserDelegate>

@property (nonatomic,strong)DDAudioLRCParser * lrcParser;
@end

@implementation DDDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.lrcParser = [[DDAudioLRCParser alloc] init];
    
    [self.lrcParser parserLRCTextAtFilePath:self.lrcPath WithDelegate:self];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcParser.AudioLRC.units.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    DDAudioLRCUnit *unit = [self.lrcParser.AudioLRC LRCUnitAtLine:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%.3f",unit.sec];
    cell.detailTextLabel.text = unit.lrc;
    return cell;
}

#pragma mark - lrc parser delegate
- (void)parserDidFinishWithLRC:(DDAudioLRC *)AudioLRC{

    [self.tableView reloadData];
}

@end
