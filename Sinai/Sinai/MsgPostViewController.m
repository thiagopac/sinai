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
#import "ActionSheetPicker.h"

@interface MsgPostViewController ()<ControleTecladoDelegate, UITextViewDelegate>{
    NSString *valorValidade;
    NSString *stringIdioma;
}
@property (nonatomic, strong) ControleTeclado *controleTeclado;
@property  IBOutlet UILabel *lblCharCounter;
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
    
#pragma Google Analytics
    self.screenName = @"Escrevendo";
    
    
#pragma inicializando labels
    [_btnEnviaMsgOutlet setTitle:NSLocalizedString(@"enviar",nil) forState:UIControlStateNormal];
    [_btnLogin setTitle:NSLocalizedString(@"fazer login",nil) forState:UIControlStateNormal];
    _txtIdiomaOutlet.placeholder = NSLocalizedString(@"Selecione o idioma deste pedido",nil);
    _txtValidadeOutlet.placeholder = NSLocalizedString(@"Selecione a validade (em dias)",nil);
    
#pragma navigationbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:75/255.0f green:193/255.0f blue:210/255.0f alpha:1.0f];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_nav.png"]];

#pragma uitextview fake placeholder
    _lblMsgPost.delegate = self;
    _lblMsgPost.text = NSLocalizedString(@"Digite seu pedido...",nil);
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
    NSURL *url = [NSURL URLWithString:API];
    NSString  *path= @"addoracao";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    MsgPost *msgpost = [MsgPost new];
    msgpost.descricao = self.lblMsgPost.text;
    msgpost.validade = [self checaValidade];
    [self checaIdioma:_txtIdiomaOutlet.text];
    msgpost.idioma = stringIdioma;
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
                             [self.txtValidadeOutlet setText:@""];
                             [self.txtIdiomaOutlet setText:@""];
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

- (IBAction)btnEnviaMsg:(UIButton *)sender {
    [SVProgressHUD showSuccessWithStatus:@""];
    [self checaValores];
}

-(void)checaValores{
    if(_lblMsgPost.text.length < 141){
        if (_txtIdiomaOutlet.text.length > 0) {
            if (_txtValidadeOutlet.text.length >0) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    [self enviaMsg];
                });
            }else{
                 [self alert:NSLocalizedString(@"Preencha todos os dados",nil) :NSLocalizedString(@"Erro",nil)];
            }
        }else{
            [self alert:NSLocalizedString(@"Preencha todos os dados",nil) :NSLocalizedString(@"Erro",nil)];
        }
    }else{
        [self alert:NSLocalizedString(@"A mensagem deve ter apenas 140 caracteres",nil) :NSLocalizedString(@"Erro",nil)];
    }
}

- (void) alert:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void)checaIdioma:(NSString *)idioma{
    if ([idioma isEqualToString:@"Português"]) {
        stringIdioma = @"PT";
    }else if ([idioma isEqualToString:@"English"]){
        stringIdioma = @"EN";
    }else if ([idioma isEqualToString:@"Spañol"]){
        stringIdioma = @"ES";
    }else if ([idioma isEqualToString:@"Italiano"]){
        stringIdioma = @"IT";
    }
}

-(NSString *)checaValidade{
    valorValidade = _txtValidadeOutlet.text;
    return valorValidade;
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
    if (substring.length == 141) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"Limite de 140 caracteres",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        //if character count is over max number change label to red text
        _lblCharCounter.textColor = [UIColor redColor];
    }
    
    //if message is less than 512 characters change font to black
    if (substring.length < 141) {
        _lblCharCounter.textColor = [UIColor grayColor];
    }
}

- (IBAction)btnLogin:(UIButton *)sender {
    UIStoryboard *storyBoard = [self storyboard];
    LoginViewController *loginVC  = [storyBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (IBAction)txtIdioma:(UITextField *)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Cancelado");
    };
    NSArray *idiomas = [NSArray arrayWithObjects:@"Português", @"English", @"Español", @"Italiano", nil];
    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Selecione o idioma",nil) rows:idiomas initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)txtValidade:(UITextField *)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Cancelado");
    };
    NSArray *idiomas = [NSArray arrayWithObjects:[NSString stringWithFormat:@"1 %@",NSLocalizedString(@"dia",nil)], [NSString stringWithFormat:@"2 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"3 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"4 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"5 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"6 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"7 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"8 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"9 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"10 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"11 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"12 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"13 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"14 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"15 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"16 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"17 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"18 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"19 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"20 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"21 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"22 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"23 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"24 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"25 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"26 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"27 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"28 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"29 %@",NSLocalizedString(@"dias",nil)],[NSString stringWithFormat:@"30 %@",NSLocalizedString(@"dias",nil)], nil];
    
    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Selecione o prazo",nil) rows:idiomas initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}
@end
