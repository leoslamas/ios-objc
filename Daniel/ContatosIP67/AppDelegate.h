#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(strong) NSMutableArray *contatos;
@property(strong) NSString *arquivoContatos;
@property(strong, readonly) NSManagedObjectContext *contexto;

@end
