//
//  FormularioViewController.m
//  ContatosIP67
//
//  Created by ios3873 on 23/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FormularioViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface FormularioViewController ()

@end

@implementation FormularioViewController
@synthesize nome;
@synthesize telefone;
@synthesize email;
@synthesize endereco;
@synthesize site;
@synthesize contatos;
@synthesize contato;
@synthesize botaoFoto;
@synthesize delegate;
@synthesize latitude;
@synthesize longitude;
@synthesize campoAtual;
@synthesize botaoCoordenadas;
@synthesize loading;


- (id)init {
    self = [super init];
    if(self){
        
        self.navigationItem.title =@"Contatos";
        
        UIBarButtonItem *cancela = [[UIBarButtonItem alloc] 
                                    initWithTitle:@"Cancela" 
                                    style:UIBarButtonItemStylePlain 
                                    target:self 
                                    action:@selector(escondeFormulario)];
        
        UIBarButtonItem *adiciona = [[UIBarButtonItem alloc] 
                                    initWithTitle:@"Adiciona" 
                                    style:UIBarButtonItemStylePlain 
                                    target:self 
                                    action:@selector(criaContato)];
        
        self.navigationItem.leftBarButtonItem = cancela;
        self.navigationItem.rightBarButtonItem = adiciona;
        
    }
    return self;
}

-(IBAction)buscaCoordenadas:(id)sender
{
    self.botaoCoordenadas.enabled = NO;
    [self.loading startAnimating];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.endereco.text
                 completionHandler:
                         ^(NSArray *resultados, NSError *error) {
                             if (error == nil && [resultados count] > 0) {
                                 CLPlacemark *resultado = resultados[0];
                                 CLLocationCoordinate2D coordenada = resultado.location.coordinate;
                                 self.latitude.text = [NSString stringWithFormat:@"%f", coordenada.latitude];
                                 self.longitude.text = [NSString stringWithFormat:@"%f", coordenada.longitude];
                             } else {
                                 self.botaoCoordenadas.enabled = YES;
                             }
                             [self.loading stopAnimating];
                         }
    ];
}

- (id)initWithContato:(Contato *)umcontato{
    self = [super init];
    if(self){
        self.contato = umcontato;
        UIBarButtonItem *confirmar = [[UIBarButtonItem alloc] initWithTitle:@"Confirmar" 
                        style:UIBarButtonItemStylePlain target:self action:@selector(atualizaContato)];
        
        self.navigationItem.rightBarButtonItem = confirmar;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(self.contato){
        self.nome.text = self.contato.nome;
        self.telefone.text = self.contato.telefone;
        self.email.text = self.contato.email;
        self.endereco.text = self.contato.endereco;
        self.site.text = self.contato.site;
        self.latitude.text = [self.contato.latitude stringValue];
        self.longitude.text = [self.contato.longitude stringValue];
        
        if(self.contato.foto){
            [self.botaoFoto setImage:self.contato.foto forState:UIControlStateNormal];
        }
        
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tecladoApareceu:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tecladoSumiu:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setNome:nil];
    [self setTelefone:nil];
    [self setEmail:nil];
    [self setEndereco:nil];
    [self setSite:nil];
    [self setBotaoFoto:nil];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (Contato *) pegaDadosDoFormulario {
    
    if(!self.contato) {
      self.contato = [[Contato alloc] init];
    }
    
    if(self.botaoFoto.imageView.image){
        self.contato.foto = self.botaoFoto.imageView.image;
    }
    
    self.contato.nome = self.nome.text;
    self.contato.telefone = self.telefone.text;
    self.contato.email = self.email.text;
    self.contato.endereco = self.endereco.text;
    self.contato.site = self.site.text;
    self.contato.latitude = [NSNumber numberWithFloat:[self.latitude.text floatValue]];
    self.contato.longitude = [NSNumber numberWithFloat:[self.longitude.text floatValue]];
    
    return self.contato;
    
}

- (IBAction)selecionaFoto:(id)sender
{
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imagemSelecionada = [info valueForKey:UIImagePickerControllerEditedImage];
    [self.botaoFoto setImage:imagemSelecionada forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)proximoElemento:(id)campoTexto{
    
    if(campoTexto == self.nome){
        [self.telefone becomeFirstResponder];
    }else if (campoTexto == self.telefone){
        [self.email becomeFirstResponder];
    }else if (campoTexto == self.email){
        [self.endereco becomeFirstResponder];
    }else if (campoTexto == self.endereco){
        [self.site becomeFirstResponder];
    }else if (campoTexto == self.site){
        [self.site resignFirstResponder];
    }
    
}

- (void)escondeFormulario {
    [self.navigationController popViewControllerAnimated:YES];  
}

- (void)criaContato{
    Contato *novoContato = [self pegaDadosDoFormulario];
    [self.contatos addObject:novoContato];
    
    NSLog(@"Contatos cadastros: %d", [self.contatos count]);
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
    
    if(self.delegate){
        [self.delegate contatoAdicionado:novoContato];
    }
}

-(void) atualizaContato{
    Contato *contatoAtualizado = [self pegaDadosDoFormulario];
    [self.navigationController popViewControllerAnimated:YES];
    if(self.delegate){
        [self.delegate contatoAtualizado:contatoAtualizado];
    }
}

-(void)tecladoApareceu:(NSNotification *)notification
{
    NSLog(@"Um teclado qualquer apareceu na tela");
    NSDictionary *info = [notification userInfo];
    
    //acessando o tamanho e a altura do teclado
    CGRect areaDoTeclado = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGSize tamanhoTeclado = areaDoTeclado.size;
    
    UIScrollView *scroll = (UIScrollView *)self.view;
    
    //calculando a margem que daremos para o scroll
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0,0.0, tamanhoTeclado.height, 0.0);
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    
    if(self.campoAtual){
        //calculando o tamanho adicional dos elementos
        //no caso do teclado e a navigation bar
        CGFloat tamanhoDosElementos = tamanhoTeclado.height + self.navigationController.navigationBar.frame.size.height;
        //removendo o espaço extra dos elementos
        CGRect tamanhoDaTela = self.view.frame;
        tamanhoDaTela.size.height -= tamanhoDosElementos;
        
        //validando se o teclado foi escondido
        BOOL campoAtualSumiu = !CGRectContainsPoint(tamanhoDaTela,self.campoAtual.frame.origin);
        
        if(campoAtualSumiu){
            //caso o teclado tenha sido escondido, vamos, adicionar, o tamanho do rteclado adicional ao ::scroll view::
            CGFloat tamanhoAdicional = tamanhoTeclado.height - self.navigationController.navigationBar.frame.size.height;
            
            CGPoint pontoVisivel = CGPointMake(0.0, self.campoAtual.frame.origin.y - tamanhoAdicional);
            [scroll setContentOffset:pontoVisivel animated:YES];
        }
    }
}

-(void)tecladoSumiu:(NSNotification *)notification
{
    NSLog(@"Um teclado qualquer sumiu da tela");
    UIScrollView *scroll = (UIScrollView *)self.view;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    [scroll setContentOffset:CGPointZero animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.campoAtual = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.campoAtual = nil;
}

@end
