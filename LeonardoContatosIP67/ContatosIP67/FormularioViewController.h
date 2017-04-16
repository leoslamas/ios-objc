//
//  FormularioViewController.h
//  ContatosIP67
//
//  Created by ios3873 on 23/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contato.h"
#import "ListaContatosProtocol.h"

@interface FormularioViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
    @property (weak, nonatomic) IBOutlet UITextField *nome;
    @property (weak, nonatomic) IBOutlet UITextField *telefone;
    @property (weak, nonatomic) IBOutlet UITextField *email;
    @property (weak, nonatomic) IBOutlet UITextField *endereco;
    @property (weak, nonatomic) IBOutlet UITextField *site;
    @property (weak) id<ListaContatosProtocol> delegate;
    @property (strong) NSMutableArray *contatos;
    @property (strong) Contato *contato; 
    @property (weak, nonatomic) IBOutlet UIButton *botaoFoto;
    @property (weak, nonatomic) IBOutlet UITextField *latitude;
    @property (weak, nonatomic) IBOutlet UITextField *longitude;
    @property (weak) UITextField *campoAtual;
    @property (weak, nonatomic) IBOutlet UIButton *botaoCoordenadas;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
    

    - (IBAction)selecionaFoto:(id)sender;
    - (IBAction)buscaCoordenadas:(id)sender;
    - (IBAction)proximoElemento:(id)campoTexto;
    - (id) initWithContato:(Contato *) umContato;

@end
