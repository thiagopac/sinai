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

@interface MsgPostViewController ()<ControleTecladoDelegate, UITextViewDelegate>{
    int valorValidade;
    IBOutlet UISegmentedControl *opcoesIdioma;
    IBOutlet UILabel *lblCharCounter;
    IBOutlet UISlider *sliderValidade;
    NSString *stringIdioma;
}
@property (nonatomic, strong) ControleTeclado *controleTeclado;
@end

@implementation MsgPostViewController

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
            break;
        case 1:
            stringIdioma = @"EN";
            break;
        
        case 2:
            stringIdioma = @"ES";
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
    [[self lblDiasValidade]setText:[NSString stringWithFormat:@"%d",(int)round(sliderValidade.value)]];
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
        lblCharCounter.textColor = [UIColor blackColor];
    }
}

@end
