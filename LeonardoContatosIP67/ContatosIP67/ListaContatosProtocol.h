//
//  ListaContatosProtocol.h
//  ContatosIP67
//
//  Created by ios3873 on 07/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contato.h"

@protocol ListaContatosProtocol <NSObject>
-(void)contatoAtualizado:(Contato *)contato;
-(void)contatoAdicionado:(Contato *)contato;
@end
