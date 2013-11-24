//
//  MsgGetViewController.m
//  Sinai
//
//  Created by Thiago Castro on 18/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "MsgGetViewController.h"
#import <Restkit/RestKit.h>
#import "MsgGet.h"
#import "Output.h"
#import "OracaoFeita.h"
#import "MappingProvider.h"
#import <SVProgressHUD.h>

@interface MsgGetViewController (){
    MsgGet *msgget;
}

@property (strong, nonatomic) Output *outputObj;

@end

@implementation MsgGetViewController

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
    [SVProgressHUD show];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadMsgGet];
    });
}

- (void)loadMsgGet {
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [MappingProvider msgGetMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:false pathPattern:nil keyPath:nil statusCodes:statusCodeSet];
    
    //COLOCAR ABAIXO A VARIÁVEL DE IDIOMA PARA TRAZER DINAMICAMENTE APÓS O USUÁRIO TER SELECIONADO O IDIOMA NO APP
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/sinai/webservice/msg/pt"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        msgget = mappingResult.firstObject;
        NSLog(@"msg = %@",msgget.descricao);
        self.lblMsgGet.text = msgget.descricao;
        [[self lblMsgGet] setFont:[UIFont fontWithName:@"TrebuchetMS" size:17]];
        [[self lblMsgGet]setTextAlignment:NSTextAlignmentCenter];
        [[self lblMsgGet] setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]];
        [SVProgressHUD dismiss];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Request failed"];
    }];
    
    [operation start];
}

-(void)orei{
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"idmsg"]];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Output class]];
    [responseMapping addAttributeMappingsFromArray:@[@"output"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[OracaoFeita class] rootKeyPath:nil method:RKRequestMethodPUT];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPUT
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURL *url = [NSURL URLWithString:@"http://localhost/"];
    NSString  *path= @"sinai/webservice/updateoracao";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    OracaoFeita *oracao = [OracaoFeita new];

    oracao.idmsg = msgget.idmsg;
    
    [objectManager putObject:oracao
                         path:path
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          if(mappingResult != nil){
                              Output *success = [mappingResult firstObject];
                              NSLog(@"msg : %@",success.output);
                              [SVProgressHUD dismiss];
                              [self dismissViewControllerAnimated:YES completion:nil];
                          }else{
                              [SVProgressHUD dismiss];
                              NSLog(@"Erro, nenhuma resposta!");
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

- (IBAction)btnAtualizar:(UIButton *)sender {
    [SVProgressHUD show];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadMsgGet];
    });
}

- (IBAction)btnOrei:(UIButton *)sender {
    [SVProgressHUD showSuccessWithStatus:@""];
    [self orei];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadMsgGet];
    });
}
@end
