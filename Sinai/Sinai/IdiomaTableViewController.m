//
//  IdiomaTableViewController.m
//  Sinai
//
//  Created by Thiago Castro on 28/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "IdiomaTableViewController.h"
#import "Idioma.h"

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
    
    Idioma *portugues = [Idioma new];
    portugues.descricao = @"Português";
    portugues.sigla = @"PT";
    
    Idioma *english = [Idioma new];
    english.descricao = @"English";
    english.sigla = @"EN";
    
    Idioma *espanol = [Idioma new];
    espanol.descricao = @"Español";
    espanol.sigla = @"ES";
    
    Idioma *italiano = [Idioma new];
    italiano.descricao = @"Italiano";
    italiano.sigla = @"IT";
    
    arrayIdiomas = [[NSArray alloc]initWithObjects:portugues,english,espanol,italiano, nil];

#pragma inicializando labels
    _lblEnunciado.text = NSLocalizedString(@"Escolha o idioma dos pedidos que serão carregados",nil);
    
#pragma navigationbar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_nav.png"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [[self tableView]reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    Idioma *idioma = [arrayIdiomas objectAtIndex:indexPath.row];
    [[cell textLabel]setText:[idioma descricao]];
    
    //[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
    
    NSUserDefaults *prefIdioma = [NSUserDefaults standardUserDefaults];
    if ([[prefIdioma objectForKey:@"siglaIdioma"] isEqualToString:idioma.sigla]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        checkedIndexPath = indexPath;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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
    
    Idioma *idioma = [arrayIdiomas objectAtIndex:indexPath.row];
    
    NSUserDefaults *prefIdioma = [NSUserDefaults standardUserDefaults];
    [prefIdioma setObject:idioma.sigla forKey:@"siglaIdioma"];
    [prefIdioma synchronize];
}

@end
