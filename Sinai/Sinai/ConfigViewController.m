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
    
#pragma Container com sombra
    //Adds a shadow to sampleView
    CALayer *layer = self.containerShadow.layer;
    
    //changed to zero for the new fancy shadow
    layer.shadowOffset = CGSizeZero;
    
    layer.shadowColor = [[UIColor blackColor] CGColor];
    
    //changed for the fancy shadow
    layer.shadowRadius = 2.0f;
    
    layer.shadowOpacity = 0.50f;
    
    //call our new fancy shadow method
    layer.shadowPath = [self fancyShadowForRect:layer.bounds];
}

- (CGPathRef)fancyShadowForRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    //right
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + 5.0f)];
    
    //curved bottom
    [path addCurveToPoint:CGPointMake(0.0, size.height + 5.0f)
            controlPoint1:CGPointMake(size.width - 5.0f, size.height)
            controlPoint2:CGPointMake(5.0f, size.height)];
    
    [path closePath];
    
    return path.CGPath;
}

- (void)resetDefaults {
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [def dictionaryRepresentation];
    for (id key in dict) {
        [def removeObjectForKey:key];
    }
    [def synchronize];
    [self.btnLoginOutlet setTitle:@"fazer login" forState:UIControlStateNormal];
    _btnMeusPedidos.enabled = NO;
    _btnMeusPedidos.alpha = 0.6;
    self.lblEmail.text = nil;
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
        [self.btnLoginOutlet setTitle:@"fazer login" forState:UIControlStateNormal];
        _btnMeusPedidos.enabled = NO;
        _btnMeusPedidos.alpha = 0.6;
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
