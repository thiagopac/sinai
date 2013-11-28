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
#import <SVProgressHUD.h>
#import "MsgGet.h"
#import "MinhaMsgCell.h"

@interface MinhasMsgsTableViewController ()

@property (nonatomic, strong) NSArray *minhasMsgs;

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
    [SVProgressHUD show];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadMinhasMsgs];
    });
}

- (void)loadMinhasMsgs {
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [MappingProvider msgGetMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:false pathPattern:nil keyPath:nil statusCodes:statusCodeSet];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/sinai/webservice/msgs/iduser/%d",[def integerForKey:@"iduser"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        self.minhasMsgs = mappingResult.array;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Request failed"];
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
        cell.lblPublicacao.text = @"Em publicação";
    else if(result==NSOrderedDescending)
        cell.lblPublicacao.text = @"Vencido";
    else
        cell.lblPublicacao.text = @"Em publicação";
    
    [[cell lblMsg] setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:13]];
}

@end
