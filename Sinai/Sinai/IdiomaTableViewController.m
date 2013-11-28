//
//  IdiomaTableViewController.m
//  Sinai
//
//  Created by Thiago Castro on 28/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "IdiomaTableViewController.h"

@interface IdiomaTableViewController (){
    NSArray *arrayIdiomas;
    NSIndexPath *checkedIndexPath;
}

@end

@implementation IdiomaTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayIdiomas = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"Português", @"descricao", @"PT", @"sigla", @"1", @"id"
                     , nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"English", @"descricao", @"EN", @"sigla", @"2", @"id"
                     , nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"Español", @"descricao", @"ES", @"sigla", @"3", @"id"
                     , nil]
                    , nil
                    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayIdiomas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IdiomaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if([checkedIndexPath isEqual:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [[cell textLabel] setText:[[arrayIdiomas objectAtIndex:indexPath.row] objectForKey:@"descricao"]];
    
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
    
//    Cidade *cidade = [self.cidades objectAtIndex:indexPath.row];
//    arrayIdiomas *
//    
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setInteger:cidade.id forKey:@"idCidade"];
//    [def setObject:cidade.descricao forKey:@"descricaoCidade"];
//    [def synchronize];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
