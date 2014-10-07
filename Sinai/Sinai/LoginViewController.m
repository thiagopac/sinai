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
#import "SVProgressHUD.h"
#import "ControleTeclado.h"

@interface LoginViewController ()<ControleTecladoDelegate>

@property (strong, nonatomic) ControleTeclado *controleTeclado;

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

-(NSArray *)inputsTextFieldAndTextViews
{
    return @[_txtEmail, _txtPassword];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    [self setControleTeclado:[[ControleTeclado alloc] init]];
    
    [[self controleTeclado]setDelegate:self];
    
#pragma inicializando labels
    [_btnLoginOutlet setTitle:@"login" forState:UIControlStateNormal];
    [_btnCancelarOutlet setTitle:NSLocalizedString(@"voltar",nil) forState:UIControlStateNormal];
    [_btnEsqueciSenhaOutlet setTitle:NSLocalizedString(@"esqueci a senha",nil) forState:UIControlStateNormal];
    [_btnNotUserYetOutlet setTitle:NSLocalizedString(@"não tenho usuário",nil) forState:UIControlStateNormal];
    _txtEmail.placeholder = @"e-mail";
    _txtPassword.placeholder = NSLocalizedString(@"senha",nil);
    
#pragma c
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:75/255.0f green:193/255.0f blue:210/255.0f alpha:1.0f];
    
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
    NSURL *url = [NSURL URLWithString:API];
    NSString  *path= @"validauser";
    
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
                              [self alert:NSLocalizedString(@"E-mail e/ou senha incorretos",nil) :NSLocalizedString(@"Erro",nil)];
                              [self.view endEditing:YES];
                          }
                          
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@", error);
                          [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Ocorreu um erro",nil)];
                      }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLogin:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self login];
    //[self.view endEditing:YES];
}

- (IBAction)btnCancelar:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alert:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}


- (IBAction)btnEsqueciSenha:(UIButton *)sender {
}

- (IBAction)btnNotUserYet:(UIButton *)sender {
}
@end
