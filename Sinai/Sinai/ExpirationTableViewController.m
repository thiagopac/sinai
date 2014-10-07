//
//  ExpirationTableViewController.m
//  Sinai
//
//  Created by Thiago Castro on 15/09/14.
//  Copyright (c) 2014 Thiago Castro. All rights reserved.
//

#import "ExpirationTableViewController.h"
#import "MsgPostViewController.h"

@interface ExpirationTableViewController (){
    NSMutableArray *arrValidades;
    NSIndexPath *checkedIndexPath;
}

@end

@implementation ExpirationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma navigationbar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_nav.png"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    arrValidades = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"5 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"10 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"20 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"30 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"60 %@",NSLocalizedString(@"dias",nil)], nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrValidades count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"languageCell" forIndexPath:indexPath];
    
    if([checkedIndexPath isEqual:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [arrValidades objectAtIndex:indexPath.row];
    
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
    msgPostVC.strValidade = [arrValidades objectAtIndex:indexPath.row];
    [self.navigationController popToViewController:msgPostVC animated:YES];
}

@end
