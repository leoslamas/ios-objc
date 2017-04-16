#import <Foundation/Foundation.h>
#import  "Contato.h"

@protocol ListaContatosProtocol <NSObject>

- (void)contatoAtualizado:(Contato *)contato;

- (void)contatoAdicionado:(Contato *)contato;

@end

