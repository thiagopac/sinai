//
//  EditarSenhaViewController.m
//  Sinai
//
//  Created by Thiago Castro on 16/12/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "EditarSenhaViewController.h"
#import "Login.h"
#import "Output.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import <SVProgressHUD.h>
#import "ControleTeclado.h"

@interface EditarSenhaViewController ()<ControleTecladoDelegate>

@property (strong, nonatomic) ControleTeclado *controleTeclado;

@end

@implementation EditarSenhaViewController

-(NSArray *)inputsTextFieldAndTextViews
{
    return @[_txtEmail, _txtSenhaAtual, _txtNovaSenha];
}

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
    [self setControleTeclado:[[ControleTeclado alloc] init]];
    
    [[self controleTeclado]setDelegate:self];
}

-(void)editar{
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"email", @"password", @"passwordatual"]];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Output class]];
    [responseMapping addAttributeMappingsFromArray:@[@"output"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Login class] rootKeyPath:nil method:RKRequestMethodPUT];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPUT
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURL *url = [NSURL URLWithString:@"http://localhost/"];
    NSString  *path= @"sinai/webservice/setarnovasenha";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    Login *login = [Login new];
    
    login.email = self.txtEmail.text;
    login.password = self.txtNovaSenha.text;
    login.passwordatual = self.txtSenhaAtual.text;
    
    [objectManager putObject:login
                        path:path
                  parameters:nil
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         if(mappingResult != nil){
                             Output *resposta = [mappingResult firstObject];
                             NSLog(@"output : %@",resposta.output);
                             [self alert:@"Sua senha foi alterada com êxito!" :@"Sucesso"];
                             [SVProgressHUD dismiss];
                         }else{
                             [SVProgressHUD dismiss];
                             [self alert:@"Ocorreu um erro! Verifique os dados preenchidos." :@"Erro"];
                             [self.view endEditing:YES];
                         }
                         
                     }
                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         [SVProgressHUD showErrorWithStatus:@"Ocorreu um erro"];
                     }];
}

- (void) alert:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnEnviar:(UIButton *)sender {
    [SVProgressHUD show];
    [self editar];
}

- (IBAction)btnCancelar:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
