#import <UIKit/UIKit.h>
#import "Contato.h"
#import "ListaContatosProtocol.h"

@class TPKeyboardAvoidingScrollView;

@interface FormularioContatoViewController : UIViewController <UIImagePickerControllerDelegate,
        UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>

@property(strong) NSManagedObjectContext *contexto;

@property(nonatomic, weak) IBOutlet UITextField *nome;
@property(nonatomic, weak) IBOutlet UITextField *telefone;
@property(nonatomic, weak) IBOutlet UITextField *endereco;
@property(nonatomic, weak) IBOutlet UITextField *latitude;
@property(nonatomic, weak) IBOutlet UITextField *longitude;
@property(nonatomic, weak) IBOutlet UITextField *email;
@property(nonatomic, weak) IBOutlet UITextField *site;
@property(nonatomic, weak) IBOutlet UIButton *botaoFoto;
@property(nonatomic, weak) IBOutlet UIButton *botaoBuscaLocalizacao;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *loading;

@property(strong) Contato *contato;
@property(weak) id <ListaContatosProtocol> delegate;

@property(weak) UITextField *campoAtual;

- (Contato *)pegaDadosDoFormulario;

- (IBAction)proximoElemento:(UITextField *)textField;

- (id)initWithContato:(Contato *)umContato;

- (IBAction)selecionaFoto:(id)sender;

- (IBAction)buscarCoordenadas:(id)sender;

@end
