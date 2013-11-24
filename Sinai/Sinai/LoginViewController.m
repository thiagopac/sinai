//
//  LoginViewController.m
//  Sinai
//
//  Created by Thiago Castro on 24/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "LoginViewController.h"
#import "Login.h"
#import "User.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import <SVProgressHUD.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,-110,320,590)];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,320,480)];
}

-(void)login{
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"email", @"password"]];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
    [responseMapping addAttributeMappingsFromArray:@[@"iduser", @"email"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Login class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURL *url = [NSURL URLWithString:@"http://localhost/"];
    NSString  *path= @"sinai/webservice/validauser";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    Login *login = [Login new];
    
    login.email = self.txtEmail.text;
    login.password = self.txtPassword.text;
    
    [objectManager postObject:login
                         path:path
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          if(mappingResult != nil){
                              User *userLogged = [mappingResult firstObject];
                              NSLog(@"email : %@",userLogged.email);
                              NSUserDefaults  *def = [NSUserDefaults standardUserDefaults ];
                              [def setObject:userLogged.email forKey:@"email"];
                              [def setInteger:userLogged.iduser forKey:@"iduser"];
                              [def synchronize];
                              
                              [SVProgressHUD dismiss];
                              [self dismissViewControllerAnimated:YES completion:nil];
                          }else{
                              [SVProgressHUD dismiss];
                              [self alert:@"E-mail e/ou senha incorretos" :@"Erro"];
                              [self.view endEditing:YES];
                          }
                          
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@", error);
                          [SVProgressHUD showErrorWithStatus:@"Ocorreu um erro"];
                      }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLogin:(UIButton *)sender {
    [SVProgressHUD show];
    [self login];
    //[self.view endEditing:YES];
}

- (IBAction)btnCancelar:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) alert:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}


- (IBAction)btnEsqueciSenha:(UIButton *)sender {
}

- (IBAction)btnNotUserYet:(UIButton *)sender {
}
@end
