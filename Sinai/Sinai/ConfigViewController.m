//
//  ConfigViewController.m
//  Sinai
//
//  Created by Thiago Castro on 24/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "ConfigViewController.h"
#import "LoginViewController.h"
#import <SVProgressHUD.h>

@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

#pragma Google Analytics
    self.screenName = @"Configurando";
    
#pragma navigationbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:75/255.0f green:193/255.0f blue:210/255.0f alpha:1.0f];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_nav.png"]];
   
#pragma inicializando labels
    [_btnLoginOutlet setTitle:NSLocalizedString(@"fazer login",nil) forState:UIControlStateNormal];
    [_btnMeusPedidos setTitle:NSLocalizedString(@"meus pedidos",nil) forState:UIControlStateNormal];
    [_btnIdiomaOutlet setTitle:NSLocalizedString(@"idioma",nil) forState:UIControlStateNormal];
    _lblEmail.text = NSLocalizedString(@"identifique-se",nil);
}

- (void)resetDefaults {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iduser"];
//    
//    
//    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
//    NSDictionary * dict = [def dictionaryRepresentation];
//    for (id key in dict) {
//        [def removeObjectForKey:key];
//    }
//    [def synchronize];
    
    [self.btnLoginOutlet setTitle:NSLocalizedString(@"fazer login",nil) forState:UIControlStateNormal];
    _btnMeusPedidos.enabled = NO;
    _btnMeusPedidos.alpha = 0.6;
    _lblEmail.text = NSLocalizedString(@"identifique-se",nil);
    [SVProgressHUD dismiss];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if([def objectForKey:@"email"]){
        [self.btnLoginOutlet setTitle:@"logout" forState:UIControlStateNormal];
        _btnMeusPedidos.alpha = 1.0;
        _btnMeusPedidos.enabled = YES;
        _btnMeusPedidos.alpha = 1;
        self.lblEmail.text = [def objectForKey:@"email"];
    }else{
        [self.btnLoginOutlet setTitle:NSLocalizedString(@"fazer login",nil) forState:UIControlStateNormal];
        _btnMeusPedidos.enabled = NO;
        _btnMeusPedidos.alpha = 0.6;
        _lblEmail.text = NSLocalizedString(@"identifique-se",nil);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginLogout:(UIButton *)sender {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if(![def objectForKey:@"email"]){
        UIStoryboard *storyBoard = [self storyboard];
        LoginViewController *loginVC  = [storyBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:loginVC animated:YES completion:nil];
    }else{
        [SVProgressHUD show];
        [self resetDefaults];
    }
}
@end
