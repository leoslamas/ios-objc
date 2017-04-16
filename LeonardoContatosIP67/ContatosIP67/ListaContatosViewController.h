//
//  ListaContatosViewController.h
//  ContatosIP67
//
//  Created by ios3873 on 30/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ListaContatosProtocol.h"

@interface ListaContatosViewController : UITableViewController<ListaContatosProtocol, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    Contato *contatoSelecionado;
}

@property (strong) NSMutableArray *contatos;
@property NSInteger linhaDestaque;

-(void) exibeMaisAcoes:(UIGestureRecognizer*)gesture;

@end
