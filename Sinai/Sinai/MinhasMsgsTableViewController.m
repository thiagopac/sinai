//
//  MinhasMsgsTableViewController.m
//  Sinai
//
//  Created by Thiago Castro on 27/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "MinhasMsgsTableViewController.h"
#import <Restkit/RestKit.h>
#import "MappingProvider.h"
#import "SVProgressHUD.h"
#import "MsgGet.h"
#import "MinhaMsgCell.h"
#import "Output.h"
#import "OracaoFeita.h"

@interface MinhasMsgsTableViewController ()

@property (nonatomic, strong) NSMutableArray *minhasMsgs;

@end

@implementation MinhasMsgsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadMinhasMsgs];
    });
    
#pragma navigationbar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_nav.png"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)loadMinhasMsgs {
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [MappingProvider msgGetMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:false pathPattern:nil keyPath:nil statusCodes:statusCodeSet];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@msgs/iduser/%d",API,[def integerForKey:@"iduser"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        self.minhasMsgs = [NSMutableArray arrayWithArray:mappingResult.array];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Ocorreu um erro",nil)];
    }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.minhasMsgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MsgCell";
    MinhaMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    MsgGet *msgget = [self.minhasMsgs objectAtIndex:indexPath.row];

    [self configureCell:cell withMsgGet:msgget];
   
    return cell;
}

- (void)configureCell:(MinhaMsgCell *)cell withMsgGet:(MsgGet *)msgget {

    cell.lblMsg.text = msgget.descricao;
    
    NSDateFormatter *dtf = [NSDateFormatter new];
    [dtf setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dtf dateFromString:[msgget criacao]];
    
    dtf = [NSDateFormatter new];
    [dtf setDateFormat:@"dd/MM/yyyy"];
    
    NSString *criacaoDDMMYYYY = [dtf stringFromDate:date];
    cell.lblCriacao.text = criacaoDDMMYYYY;

    cell.lblOracoes.text = [NSString stringWithFormat:@"%@",[msgget oracoes]];
    
    //Comparação de datas
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *hoje = [NSDate date];
    NSDate *dataValidade = [dateFormatter dateFromString:[msgget validade]];
    
    NSComparisonResult result = [hoje compare:dataValidade];
    
    if(result == NSOrderedAscending)
        cell.lblPublicacao.text = NSLocalizedString(@"Ativo",nil);
    else if(result==NSOrderedDescending)
        cell.lblPublicacao.text = NSLocalizedString(@"Inativo",nil);
    else
        cell.lblPublicacao.text = NSLocalizedString(@"Ativo",nil);
    
    [[cell lblMsg] setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:12]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MsgGet *msgget = [self.minhasMsgs objectAtIndex:indexPath.row];
        [self deleteMsgPorIdmsg:msgget];
        
        [self.minhasMsgs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}

-(void)deleteMsgPorIdmsg:(MsgGet *)msgget{
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"idmsg"]];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Output class]];
    [responseMapping addAttributeMappingsFromArray:@[@"output"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[OracaoFeita class] rootKeyPath:nil method:RKRequestMethodDELETE];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodDELETE
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURL *url = [NSURL URLWithString:API];
    NSString  *path= [NSString stringWithFormat:@"deletemsg/%d",msgget.idmsg];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    OracaoFeita *msg = [OracaoFeita new];
    
    msg.idmsg = msgget.idmsg;
    
    [objectManager deleteObject:msg
                        path:path
                  parameters:nil
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         if(mappingResult != nil){
                             Output *success = [mappingResult firstObject];
                             NSLog(@"msg : %@",success.output);
                             [SVProgressHUD dismiss];
                         }else{
                             [SVProgressHUD dismiss];
                             NSLog(@"Erro, nenhuma resposta!");
                         }
                         
                     }
                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     }];
}

@end