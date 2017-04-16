//
//  Contato.h
//  ContatosIP67
//
//  Created by ios3873 on 30/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Contato : NSObject<NSCoding, MKAnnotation>

@property (strong) NSString *nome;
@property (strong) NSString *telefone;
@property (strong) NSString *email;
@property (strong) NSString *endereco;
@property (strong) NSString *site;
@property (strong) UIImage *foto;
@property (strong) NSNumber * latitude;
@property (strong) NSNumber * longitude;

@end
