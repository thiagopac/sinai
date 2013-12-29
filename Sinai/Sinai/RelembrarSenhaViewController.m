//
//  RelembrarSenhaViewController.m
//  Sinai
//
//  Created by Thiago Castro on 02/12/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "RelembrarSenhaViewController.h"
#import "Login.h"
#import "Output.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import <SVProgressHUD.h>
#import "ControleTeclado.h"

@interface RelembrarSenhaViewController ()<ControleTecladoDelegate>

@property (strong, nonatomic) ControleTeclado *controleTeclado;

@end

@implementation RelembrarSenhaViewController

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
    return @[_txtEmail];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setControleTeclado:[[ControleTeclado alloc] init]];
    
    [[self controleTeclado]setDelegate:self];
#pragma inicializando labels
    [_btnEnviarOutlet setTitle:NSLocalizedString(@"redefinir senha",nil) forState:UIControlStateNormal];
    [_btnAlterarSenhaOutlet setTitle:NSLocalizedString(@"alterar senha",nil) forState:UIControlStateNormal];
    [_btnCancelarOutlet setTitle:NSLocalizedString(@"voltar",nil) forState:UIControlStateNormal];
    _txtEmail.placeholder = NSLocalizedString(@"e-mail",nil);
}

-(void)verificar{
    if(![_txtEmail.text isEqualToString:@""]){
      [self redefinir];
    }else{
      [self alert:NSLocalizedString(@"O campo de e-mail está vazio",nil) :NSLocalizedString(@"Erro",nil)];
      [SVProgressHUD dismiss];
    }
}

-(void)redefinir{
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"email"]];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Output class]];
    [responseMapping addAttributeMappingsFromArray:@[@"output"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Login class] rootKeyPath:nil method:RKRequestMethodPUT];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPUT
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURL *url = [NSURL URLWithString:API];
    NSString  *path= @"relembrarsenha";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    Login *login = [Login new];
    
    login.email = self.txtEmail.text;
    login.password = @"teste";
    
    [objectManager putObject:login
                         path:path
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          if(mappingResult != nil){
                              Output *resposta = [mappingResult firstObject];
                              NSLog(@"output : %@",resposta.output);
                              [self alert:NSLocalizedString(@"Sua senha foi redefinida. Verifique seu e-mail.",nil) :NSLocalizedString(@"Alerta",nil)];
                              [SVProgressHUD dismiss];
                          }else{
                              [SVProgressHUD dismiss];
                              [self alert:NSLocalizedString(@"E-mail não cadastrado!",nil) :NSLocalizedString(@"Erro",nil)];
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

- (void) alert:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (IBAction)btnEnviar:(UIButton *)sender {
    [SVProgressHUD show];
    [self verificar];
}

- (IBAction)btnCancelar:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
