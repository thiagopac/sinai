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
#import "SVProgressHUD.h"
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
    return @[_txtPrimeiroNome, _txtUltimoNome, _txtEmail, _txtPassword, _txtPassword2];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setControleTeclado:[[ControleTeclado alloc] init]];
    [[self controleTeclado]setDelegate:self];

#pragma Google Analytics
    self.screenName = @"Cadastrando";
    
#pragma inicialiando labels
    [_btnRegistrarOutlet setTitle:NSLocalizedString(@"registrar",nil) forState:UIControlStateNormal];
    [_btnCancelarOutlet setTitle:NSLocalizedString(@"voltar",nil) forState:UIControlStateNormal];
    _txtPrimeiroNome.placeholder = NSLocalizedString(@"primeiro nome",nil);
    _txtUltimoNome.placeholder = NSLocalizedString(@"último nome",nil);
    _txtEmail.placeholder = @"e-mail";
    _txtPassword.placeholder = NSLocalizedString(@"senha",nil);
    _txtPassword2.placeholder = NSLocalizedString(@"repita a senha",nil);
}


-(void)verificar{
    if(![_txtPrimeiroNome.text isEqualToString:@""]){
        if(![_txtUltimoNome.text isEqualToString:@""]){
            if([_txtPassword.text length] > 5){
                if ([_txtPassword.text isEqualToString:[_txtPassword2 text]]) {
                    [self registrar];
                }else{
                    [self alert:NSLocalizedString(@"Os campos com senha devem ser idênticos",nil) :NSLocalizedString(@"Erro",nil)];
                    [SVProgressHUD dismiss];
                }
            }else{
                [self alert:NSLocalizedString(@"A senha deve ter no mínimo 6 caracteres",nil) :NSLocalizedString(@"Erro",nil)];
                [SVProgressHUD dismiss];
            }
        }else{
            [self alert:NSLocalizedString(@"O campo Último Nome está em branco",nil) :NSLocalizedString(@"Erro",nil)];
            [SVProgressHUD dismiss];
        }
     }else{
         [self alert:NSLocalizedString(@"O campo Primeiro Nome está em branco",nil) :NSLocalizedString(@"Erro",nil)];
         [SVProgressHUD dismiss];
    }
}

-(void)registrar{
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"email", @"password", @"nome", @"sobrenome"]];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
    [responseMapping addAttributeMappingsFromArray:@[@"iduser", @"email", @"nome", @"sobrenome", @"erro"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Login class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURL *url = [NSURL URLWithString:API];
    NSString  *path= @"adduser";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    Login *login = [Login new];
    
    login.email = _txtEmail.text;
    login.password = _txtPassword.text;
    login.nome = _txtPrimeiroNome.text;
    login.sobrenome = _txtUltimoNome.text;
    
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
                                  [self alert:NSLocalizedString(@"Este e-mail já está cadastrado",nil) :NSLocalizedString(@"Erro",nil)];
                              }else{
                                  [SVProgressHUD dismiss];
                                  [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Cadastrado com sucesso!",nil)];
                                  [NSTimer scheduledTimerWithTimeInterval:3 target:self
                                                                 selector:@selector(dismissAfterSuccess:) userInfo:nil repeats:NO];
                                  
                                  [self dismissViewControllerAnimated:YES completion:nil];
                              }
                              
                          }else{
                              [SVProgressHUD dismiss];
                              [self alert:NSLocalizedString(@"Tente novamente mais tarde",nil) :NSLocalizedString(@"Erro",nil)];
                              [self.view endEditing:YES];
                          }
                          
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@", error);
                          [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Ocorreu um erro",nil)];
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
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
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
