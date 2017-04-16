#import <Foundation/Foundation.h>
#import "ListaContatosProtocol.h"
#import <MessageUI/MessageUI.h>

@interface ListaContatosViewController : UITableViewController <ListaContatosProtocol, UIActionSheetDelegate,
        MFMailComposeViewControllerDelegate>

@property(strong) NSManagedObjectContext *contexto;

@property(strong) NSMutableArray *contatos;
@property NSInteger linhaDestaque;
@property Contato *contatoSelecionado;

- (void)exibeMaisAcoes:(UIGestureRecognizer *)gesture;

@end
