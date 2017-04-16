//
//  ContatosNoMapaViewController.m
//  ContatosIP67
//
//  Created by ios3873 on 21/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ContatosNoMapaViewController.h"
#import "Contato.h"
#import <MapKit/MapKit.h>

@interface ContatosNoMapaViewController ()

@end

@implementation ContatosNoMapaViewController

@synthesize mapa;
@synthesize contatos;

-(id)init
{
    self = [super init];
    if(self)
    {
        UIImage *tabImage = [UIImage imageNamed:@"mapa-contatos.png"];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"Mapa" image:tabImage tag:0];
        self.tabBarItem = tabItem;
        self.navigationItem.title = @"Localizacao";
    }
    return self;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    static NSString *identifier = @"pino";
    MKPinAnnotationView * pino = (MKPinAnnotationView *)[mapa dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if(!pino){
        pino = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }else{
        pino.annotation = annotation;
    }
    
    Contato *contato = (Contato *)annotation;
    pino.pinColor = MKPinAnnotationColorRed;
    pino.canShowCallout = YES;
    
    if(contato.foto){
        UIImageView *imagemContato = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
        imagemContato.image = contato.foto;
        pino.leftCalloutAccessoryView = imagemContato;
    }
    return pino;
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    MKUserTrackingBarButtonItem *botaoLocalizacao = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapa];
    self.navigationItem.leftBarButtonItem = botaoLocalizacao;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapa addAnnotations:self.contatos];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapa removeAnnotations:self.contatos];
}



@end
