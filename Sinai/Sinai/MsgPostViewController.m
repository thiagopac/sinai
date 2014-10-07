//
//  MsgPostViewController.m
//  Sinai
//
//  Created by Thiago Castro on 20/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "MsgPostViewController.h"
#import <Restkit/RestKit.h>
#import "MsgPost.h"
#import "MappingProvider.h"
#import "SVProgressHUD.h"
#import "ControleTeclado.h"
#import "LoginViewController.h"
#import "LanguageTableViewController.h"
#import "ExpirationTableViewController.h"

@interface MsgPostViewController ()<ControleTecladoDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>{
}
@property (nonatomic, strong) ControleTeclado *controleTeclado;
@property  IBOutlet UILabel *lblCharCounter;
@property (nonatomic, strong) UIView *viewBloqueio;
@end

@implementation MsgPostViewController

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_lblMsgPost.text isEqualToString:NSLocalizedString(@"Digite seu pedido...", nil)]) {
        _lblMsgPost.text = @"";
        _lblMsgPost.textColor = [UIColor grayColor];
    }
    [_lblMsgPost becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_lblMsgPost.text isEqualToString:@""]) {
        _lblMsgPost.text = NSLocalizedString(@"Digite seu pedido...", nil);
        _lblMsgPost.textColor = [UIColor lightTextColor];
    }
    [_lblMsgPost resignFirstResponder];
}

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
    return @[_lblMsgPost];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setControleTeclado:[[ControleTeclado alloc] init]];
    
    [[self controleTeclado]setDelegate:self];
    
    [self.lblCharCounter setFrame:CGRectMake(270,-27,37,21)];
    
#pragma Tela de login
    
    self.viewBloqueio = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.viewBloqueio.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnLogin = [[UIButton alloc]initWithFrame:CGRectMake(0, 180, 320, 49)];
    [btnLogin setTitle:NSLocalizedString(@"fazer login",nil) forState:UIControlStateNormal];
    [btnLogin.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:22.0]];
    [btnLogin setBackgroundColor:[UIColor colorWithRed:46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0f]];
    [btnLogin addTarget:self action:@selector(showLoginView) forControlEvents:UIControlEventTouchUpInside];
    UIImage *imgLogin = [UIImage imageNamed:@"login.png"];
    UIImageView *imgViewLogin = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 53, 49)];
    [imgViewLogin setImage:imgLogin];
    [btnLogin addSubview:imgViewLogin];
    
    [self.viewBloqueio addSubview:btnLogin];
    
    [self.view addSubview:self.viewBloqueio];
    
#pragma Google Analytics
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Escrevendo"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
#pragma navigationbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:75/255.0f green:193/255.0f blue:210/255.0f alpha:1.0f];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_nav.png"]];

#pragma uitextview fake placeholder
    _lblMsgPost.delegate = self;
    _lblMsgPost.text = NSLocalizedString(@"Digite seu pedido...",nil);
    _lblMsgPost.textColor = [UIColor grayColor];
}

-(void)showLoginView{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if(![def objectForKey:@"email"]){
        UIStoryboard *storyBoard = [self storyboard];
        LoginViewController *loginVC  = [storyBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
#pragma Tela de login
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if(![def objectForKey:@"email"]){
        self.viewBloqueio.hidden = NO;
    }else{
        self.viewBloqueio.hidden = YES;
    }
    
#pragma inicializando labels
   
    if (self.strIdioma == nil) {
        [self.btnIdiomas setTitle:NSLocalizedString(@"Selecione o idioma deste pedido",nil) forState:UIControlStateNormal];
    }else{
        [self.btnIdiomas setTitle:self.strIdioma forState:UIControlStateNormal];
    }
    
    if (self.strValidade == nil) {
        [self.btnValidade setTitle:NSLocalizedString(@"Selecione a validade (em dias)",nil) forState:UIControlStateNormal];
    }else{
        [self.btnValidade setTitle:self.strValidade forState:UIControlStateNormal];
    }
    
    [_btnEnviaMsgOutlet setTitle:NSLocalizedString(@"enviar",nil) forState:UIControlStateNormal];
    
}

-(void)enviaMsg{
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"descricao", @"validade", @"idioma", @"iduser"]];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MsgPost class]];
    [responseMapping addAttributeMappingsFromArray:@[@"descricao", @"validade", @"idioma", @"iduser", @"idmsg"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[MsgPost class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURL *url = [NSURL URLWithString:API];
    NSString  *path= @"addoracao";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    MsgPost *msgpost = [MsgPost new];
    msgpost.descricao = self.lblMsgPost.text;
    [self checaIdioma:self.strIdioma];
    [self checaValidade:self.strValidade];
    msgpost.validade = self.strValidade;
    msgpost.idioma = self.strIdioma;
    msgpost.iduser = [def integerForKey:@"iduser"];
    
    [objectManager postObject:msgpost
                        path:path
                  parameters:nil
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         if(mappingResult != nil){
                             MsgPost *msgRecebida = [mappingResult firstObject];
                             NSLog(@"msg : %d",(int)msgRecebida.idmsg);
                             [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Enviado com sucesso!",nil)];
                             [NSTimer scheduledTimerWithTimeInterval:3 target:self
                                                            selector:@selector(dismissAfterSuccess:) userInfo:nil repeats:NO];
                             [self.lblMsgPost setText:@""];
                             self.strIdioma = nil;
                             self.strIdioma = nil;
                             [self.btnIdiomas setTitle:NSLocalizedString(@"Selecione o idioma deste pedido",nil) forState:UIControlStateNormal];
                             [self.btnValidade setTitle:NSLocalizedString(@"Selecione a validade (em dias)",nil) forState:UIControlStateNormal];
                             [self.lblCharCounter setText:@"140"];

                         }else{
                             [SVProgressHUD dismiss];
                             NSLog(@"Erro, nenhuma resposta!");
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

- (IBAction)btnIdiomas:(id)sender {
    LanguageTableViewController *languageTVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"LanguageTableViewController"];
    [[self navigationController]pushViewController:languageTVC animated:YES];
}

- (IBAction)btnEnviaMsg:(UIButton *)sender {
    [SVProgressHUD showSuccessWithStatus:@""];
    [self checaValores];
}

- (IBAction)btnValidade:(id)sender {
    ExpirationTableViewController *expirationTVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"ExpirationTableViewController"];
    [[self navigationController]pushViewController:expirationTVC animated:YES];
}

-(void)checaValores{
    if(self.lblMsgPost.text.length < 141){
        if (self.strIdioma.length > 0) {
            if (self.strValidade.length >0) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    [self enviaMsg];
                });
            }else{
                 [self alert:NSLocalizedString(@"Preencha todos os dados",nil) :NSLocalizedString(@"Erro",nil)];
            }
        }
        else
        {
            [self alert:NSLocalizedString(@"Preencha todos os dados",nil) :NSLocalizedString(@"Erro",nil)];
        }
    }
    else{
        [self alert:NSLocalizedString(@"A mensagem deve ter apenas 140 caracteres",nil) :NSLocalizedString(@"Erro",nil)];
    }
}

- (void)alert:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void)checaIdioma:(NSString *)idioma{
    if ([idioma isEqualToString:@"Português"]) {
        self.strIdioma = @"PT";
    }else if ([idioma isEqualToString:@"English"]){
        self.strIdioma = @"EN";
    }else if ([idioma isEqualToString:@"Español"]){
        self.strIdioma = @"ES";
    }else if ([idioma isEqualToString:@"Italiano"]){
        self.strIdioma = @"IT";
    }
}

- (void)checaValidade:(NSString *)validade{
    
    NSString *originalString = self.strValidade;
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        }
        else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    NSLog(@"%@", strippedString);
    
    self.strValidade = strippedString;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    //create NSString containing the text from the UITextView
    NSString *substring = [NSString stringWithString:_lblMsgPost.text];
    
    //if message has text show label and update with number of characters using the NSString.length function
    if (substring.length > 0) {
        _lblCharCounter.hidden = NO;
        _lblCharCounter.text = [NSString stringWithFormat:@"%d",140-(int)substring.length];
    }
    
    //if message has no text hide label
    if (substring.length == 0) {
        _lblCharCounter.hidden = YES;
    }
    
    //if message length is equal to 15 characters display alert view
    if (substring.length == 140) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"Limite de 140 caracteres",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    if (substring.length > 140) {
        //if character count is over max number change label to red text
        _lblCharCounter.textColor = [UIColor redColor];
    }
    //if message is less than 512 characters change font to black
    if (substring.length < 141) {
        _lblCharCounter.textColor = [UIColor grayColor];
    }

}

@end
