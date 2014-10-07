//
//  LanguageTableViewController.m
//  Sinai
//
//  Created by Thiago Castro on 14/09/14.
//  Copyright (c) 2014 Thiago Castro. All rights reserved.
//

#import "LanguageTableViewController.h"
#import "MsgPostViewController.h"

@interface LanguageTableViewController (){
    NSMutableArray *arrlanguages;
    NSIndexPath *checkedIndexPath;
}

@end

@implementation LanguageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma navigationbar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_nav.png"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    arrlanguages = [NSMutableArray arrayWithObjects:@"Português", @"English", @"Español", @"Italiano",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrlanguages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"languageCell" forIndexPath:indexPath];
    
    if([checkedIndexPath isEqual:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [arrlanguages objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(checkedIndexPath) {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    checkedIndexPath = indexPath;
    
    MsgPostViewController *msgPostVC = [self.navigationController.viewControllers objectAtIndex:0];
    msgPostVC.strIdioma = [arrlanguages objectAtIndex:indexPath.row];
    [self.navigationController popToViewController:msgPostVC animated:YES];
}

@end
