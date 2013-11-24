//
//  ConfigViewController.m
//  Sinai
//
//  Created by Thiago Castro on 24/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "ConfigViewController.h"
#import "LoginViewController.h"

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
}

- (void)resetDefaults {
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [def dictionaryRepresentation];
    for (id key in dict) {
        [def removeObjectForKey:key];
    }
    [def synchronize];
        [self.btnLoginOutlet setTitle:@"Fazer login" forState:UIControlStateNormal];
    self.lblEmail.text = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if([def objectForKey:@"email"]){
        [self.btnLoginOutlet setTitle:@"Logout" forState:UIControlStateNormal];
        self.lblEmail.text = [def objectForKey:@"email"];
    }else{
        [self.btnLoginOutlet setTitle:@"Fazer login" forState:UIControlStateNormal];
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
        [self resetDefaults];
    }
}
@end
