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
#pragma c
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:75/255.0f green:193/255.0f blue:210/255.0f alpha:1.0f];
}

- (void)resetDefaults {
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [def dictionaryRepresentation];
    for (id key in dict) {
        [def removeObjectForKey:key];
    }
    [def synchronize];
    [self.btnLoginOutlet setTitle:@"FAZER LOGIN" forState:UIControlStateNormal];
    _btnMeusPedidos.enabled = NO;
    _btnMeusPedidos.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    self.lblEmail.text = nil;
    [SVProgressHUD dismiss];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if([def objectForKey:@"email"]){
        [self.btnLoginOutlet setTitle:@"LOGOUT" forState:UIControlStateNormal];
        _btnMeusPedidos.backgroundColor = [UIColor colorWithRed:0.20 green:0.60 blue:0.80 alpha:1.0];
        _btnMeusPedidos.enabled = YES;
        _btnMeusPedidos.alpha = 1;
        self.lblEmail.text = [def objectForKey:@"email"];
    }else{
        [self.btnLoginOutlet setTitle:@"FAZER LOGIN" forState:UIControlStateNormal];
        _btnMeusPedidos.enabled = NO;
        _btnMeusPedidos.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        self.lblEmail.text = nil;
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
