#import "AppDelegate.h"
#import "FormularioContatoViewController.h"
#import "ListaContatosViewController.h"
#import "ContatosNoMapaViewController.h"

@implementation AppDelegate

@synthesize contexto = _contexto;

- (NSManagedObjectContext *)contexto {
    if (_contexto != nil) {
        return _contexto;
    }

    _contexto = [[NSManagedObjectContext alloc] init];
    [_contexto setPersistentStoreCoordinator:[self coordinator]];
    return _contexto;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [self inserirDados];
    [self buscarContatos];

//    NSArray *userDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    self.arquivoContatos = [NSString stringWithFormat:@"%@/ArquivoContatos", [userDirs objectAtIndex:0]];
//
//    self.contatos = [NSKeyedUnarchiver unarchiveObjectWithFile:self.arquivoContatos];
//    if (!self.contatos) {
//        self.contatos = [[NSMutableArray alloc] init];
//    }

    ListaContatosViewController *lista = [[ListaContatosViewController alloc] init];
    lista.contexto = self.contexto;
    lista.contatos = self.contatos;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lista];

    ContatosNoMapaViewController *contatosNoMapa = [[ContatosNoMapaViewController alloc] init];
    contatosNoMapa.contatos = self.contatos;
    UINavigationController *mapaNavigation = [[UINavigationController alloc] initWithRootViewController:contatosNoMapa];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[nav, mapaNavigation];

    self.window.rootViewController = tabBarController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Modelo_Contatos" withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

- (NSPersistentStoreCoordinator *)coordinator {
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]
            initWithManagedObjectModel:[self managedObjectModel]];

    NSURL *pastaDocuments = [self applicationDocumentsDirectory];
    NSURL *localBancoDeDados = [pastaDocuments URLByAppendingPathComponent:@"Contatos.sqlite"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:localBancoDeDados
                                    options:nil error:nil];
    return coordinator;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [NSKeyedArchiver archiveRootObject:self.contatos toFile:self.arquivoContatos];
    [self salvaContexto];
}

- (void)salvaContexto {
    NSError *error;
    if (![self.contexto save:&error]) {
        NSDictionary *informacoes = [error userInfo];
        NSArray *multiplosErros = [informacoes objectForKey:NSDetailedErrorsKey];
        if (multiplosErros) {
            for (NSError *erro in multiplosErros) {
                NSLog(@"Ocorreu um problema : %@", [erro userInfo]);
            }
        } else {
            NSLog(@"Ocorreu um problema %@", informacoes);
        }
    }
}

- (void)inserirDados {
    NSUserDefaults *configuracoes = [NSUserDefaults standardUserDefaults];
    BOOL dadosInseridos = [configuracoes boolForKey:@"dados_inseridos"];
    if (!dadosInseridos) {

        Contato *caelumRJ = [NSEntityDescription
                insertNewObjectForEntityForName:@"Contato"
                         inManagedObjectContext:self.contexto];

        caelumRJ.nome = @"Caelum";
        caelumRJ.email = @"contato@caleum.com.br";
        caelumRJ.endereco = @"Rua do Ouvidor, 50, Centro, Rio de Janeiro";
        caelumRJ.telefone = @"(21) 2220-4156";
        caelumRJ.site = @"http://www.caelum.com.br";
        caelumRJ.latitude = [NSNumber numberWithDouble:-22.902314];
        caelumRJ.longitude = [NSNumber numberWithDouble:-43.176064];

        Contato *grill22 = [NSEntityDescription
                insertNewObjectForEntityForName:@"Contato"
                         inManagedObjectContext:self.contexto];

        grill22.nome = @"Grill 22";
        grill22.email = nil;
        grill22.endereco = @"Rua Primeiro de Março, 22, Centro, Rio de Janeiro";
        grill22.telefone = @"(21) 2224-8207";
        grill22.site = @"https://plus.google.com/104369995672129385398/";
        grill22.latitude = [NSNumber numberWithDouble:-22.902501];
        grill22.longitude = [NSNumber numberWithDouble:-43.175534];

        [self salvaContexto];

        [configuracoes setBool:YES forKey:@"dados_inseridos"];
        [configuracoes synchronize];
    }
}

- (void)buscarContatos {
    NSFetchRequest *buscaContatos = [NSFetchRequest fetchRequestWithEntityName:@"Contato"];
    NSSortDescriptor *ordenarPorNome = [NSSortDescriptor sortDescriptorWithKey:@"nome" ascending:YES];
    [buscaContatos setSortDescriptors:@[ordenarPorNome]];
    NSArray *contatosImutaveis = [self.contexto executeFetchRequest:buscaContatos error:nil];
    self.contatos = [contatosImutaveis mutableCopy];
}

@end
