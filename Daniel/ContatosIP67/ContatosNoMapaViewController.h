#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>

@interface ContatosNoMapaViewController : UIViewController <MKMapViewDelegate>

@property(weak, nonatomic) IBOutlet MKMapView *mapa;
@property(weak, nonatomic) NSMutableArray *contatos;

@end
