//
//  CadastrarViewController.m
//  Sinai
//
//  Created by Thiago Castro on 24/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "CadastrarViewController.h"
#import "Login.h"
#import "User.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import <SVProgressHUD.h>
#import "ControleTeclado.h"

@interface CadastrarViewController ()<ControleTecladoDelegate, UITextFieldDelegate>

@property (strong, nonatomic) ControleTeclado *controleTeclado;

@end

@implementation CadastrarViewController

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
    return @[_txtEmail, _txtPassword, _txtPassword2];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    [self setControleTeclado:[[ControleTeclado alloc] init]];
    [[self controleTeclado]setDelegate:self];
}


-(void)verificar{
    if([_txtPassword.text length] > 5){
        if ([_txtPassword.text isEqualToString:[_txtPassword2 text]]) {
            [self registrar];
        }else{
            [self alert:@"Os campos com senha devem ser idênticos" :@"Erro"];
            [SVProgressHUD dismiss];
        }
    }else{
        [self alert:@"A senha deve ter no mínimo 6 caracteres" :@"Erro"];
        [SVProgressHUD dismiss];
    }
}

-(void)registrar{
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"email", @"password"]];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
    [responseMapping addAttributeMappingsFromArray:@[@"iduser", @"email", @"erro"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Login class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURL *url = [NSURL URLWithString:@"http://localhost/"];
    NSString  *path= @"sinai/webservice/adduser";
    
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
                              NSLog(@"erro : %@",userLogged.erro);
                              if (userLogged.erro != nil) {
                                  [SVProgressHUD dismiss];
                                  [self alert:@"Este e-mail já está cadastrado" :@"Erro"];
                              }else{
                                  [SVProgressHUD dismiss];
                                  [SVProgressHUD showSuccessWithStatus:@"Cadastrado com sucesso!"];
                                  [NSTimer scheduledTimerWithTimeInterval:3 target:self
                                                                 selector:@selector(dismissAfterSuccess:) userInfo:nil repeats:NO];
                                  
                                  [self dismissViewControllerAnimated:YES completion:nil];
                              }
                              
                          }else{
                              [SVProgressHUD dismiss];
                              [self alert:@"Tente novamente mais tarde" :@"Erro"];
                              [self.view endEditing:YES];
                          }
                          
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@", error);
                          [SVProgressHUD showErrorWithStatus:@"Ocorreu um erro"];
                      }];
    
    
    
}

-(void)dismissAfterSuccess:(NSTimer*)timer {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRegistrar:(UIButton *)sender {
    [SVProgressHUD show];
    [self verificar];
}

- (IBAction)btnCancelar:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) alert:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}


@end
