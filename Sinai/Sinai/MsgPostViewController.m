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
#import <SVProgressHUD.h>
#import "ControleTeclado.h"
#import "LoginViewController.h"

@interface MsgPostViewController ()<ControleTecladoDelegate, UITextViewDelegate>{
    int valorValidade;
    IBOutlet UISegmentedControl *opcoesIdioma;
    IBOutlet UILabel *lblCharCounter;
    IBOutlet UISlider *sliderValidade;
    NSString *stringIdioma;
    NSString *dias;
}
@property (nonatomic, strong) ControleTeclado *controleTeclado;
@end

@implementation MsgPostViewController

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_lblMsgPost.text isEqualToString:@"Digite seu pedido..."]) {
        _lblMsgPost.text = @"";
        _lblMsgPost.textColor = [UIColor grayColor];
    }
    [_lblMsgPost becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_lblMsgPost.text isEqualToString:@""]) {
        _lblMsgPost.text = @"Digite seu pedido...";
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

#pragma navigationbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:75/255.0f green:193/255.0f blue:210/255.0f alpha:1.0f];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

#pragma uitextview fake placeholder
    _lblMsgPost.delegate = self;
    _lblMsgPost.text = @"Digite seu pedido...";
    _lblMsgPost.textColor = [UIColor grayColor];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if([def objectForKey:@"email"]){
        self.viewBloqueio.hidden = YES;
    }else{
        self.viewBloqueio.hidden = NO;
    }
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
    NSURL *url = [NSURL URLWithString:@"http://localhost/"];
    NSString  *path= @"sinai/webservice/addoracao";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    MsgPost *msgpost = [MsgPost new];
    msgpost.descricao = self.lblMsgPost.text;
    msgpost.validade = [self checaValidade];
    [self checaIdioma:opcoesIdioma];
    msgpost.idioma = stringIdioma;
    msgpost.iduser = [def integerForKey:@"iduser"];
    
    [objectManager postObject:msgpost
                        path:path
                  parameters:nil
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         if(mappingResult != nil){
                             MsgPost *msgRecebida = [mappingResult firstObject];
                             NSLog(@"msg : %d",msgRecebida.idmsg);
                             [SVProgressHUD showSuccessWithStatus:@"Enviado com sucesso!"];
                             [NSTimer scheduledTimerWithTimeInterval:3 target:self
                                                            selector:@selector(dismissAfterSuccess:) userInfo:nil repeats:NO];
                             [self.lblMsgPost setText:@""];
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

-(void)dismissAfterSuccess:(NSTimer*)timer {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnEnviaMsg:(UIButton *)sender {
    [SVProgressHUD showSuccessWithStatus:@""];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self enviaMsg];
    });
}

- (IBAction)btnIdioma:(UISegmentedControl *)sender {
    [self checaIdioma:sender];
}

- (void)checaIdioma:(UISegmentedControl *)indexIdioma{
    switch (indexIdioma.selectedSegmentIndex){
        case 0:
            stringIdioma = @"PT";
            _lblIdiomaEscolhido.text = @"Português";
            break;
        case 1:
            stringIdioma = @"EN";
            _lblIdiomaEscolhido.text = @"English";
            break;
        
        case 2:
            stringIdioma = @"ES";
            _lblIdiomaEscolhido.text = @"Español";
            break;
            
        default:
            break;
    }
}

- (IBAction)btnValidade:(UISlider *)sender {
    [self checaValidade];
}

-(int)checaValidade{
    valorValidade = round(self.btnValidade.value);
    [self alteraLabelDias];
    return valorValidade;
}

-(void)alteraLabelDias{
    if(((int)round(sliderValidade.value))>1){
        dias = @"dias";
    }else{
        dias = @"dia";
    }
    [[self lblDiasValidade]setText:[NSString stringWithFormat:@"%d %@",(int)round(sliderValidade.value),dias]];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    //create NSString containing the text from the UITextView
    NSString *substring = [NSString stringWithString:_lblMsgPost.text];
    
    //if message has text show label and update with number of characters using the NSString.length function
    if (substring.length > 0) {
        lblCharCounter.hidden = NO;
        lblCharCounter.text = [NSString stringWithFormat:@"%d", substring.length];
    }
    
    //if message has no text hide label
    if (substring.length == 0) {
        lblCharCounter.hidden = YES;
    }
    
    //if message length is equal to 15 characters display alert view
    if (substring.length == 141) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Limite de 140 caracteres" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        //if character count is over max number change label to red text
        lblCharCounter.textColor = [UIColor redColor];
    }
    
    //if message is less than 512 characters change font to black
    if (substring.length < 141) {
        lblCharCounter.textColor = [UIColor grayColor];
    }
}

- (IBAction)btnLogin:(UIButton *)sender {
    UIStoryboard *storyBoard = [self storyboard];
    LoginViewController *loginVC  = [storyBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
