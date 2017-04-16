#import "ListaContatosViewController.h"
#import "FormularioContatoViewController.h"

@implementation ListaContatosViewController

- (id)init {
    self = [super init];
    if (self) {
        UIImage *imageTabItem = [UIImage imageNamed:@"lista-contatos.png"];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"Contatos" image:imageTabItem tag:0];
        self.tabBarItem = tabItem;

        self.linhaDestaque = -1;
        self.navigationItem.title = @"Contatos";

        UIBarButtonItem *botaoExibirFormulario = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self action:@selector(exibeFormulario)];

        self.navigationItem.rightBarButtonItem = botaoExibirFormulario;
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (void)exibeFormulario {
    FormularioContatoViewController *form = [[FormularioContatoViewController alloc] init];
    form.delegate = self;
    form.contexto = self.contexto;
    [self.navigationController pushViewController:form animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contatos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:cellIdentifier];
    }

    Contato *contato = [self.contatos objectAtIndex:indexPath.row];
    cell.textLabel.text = contato.nome;

    return cell;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.contatos removeObjectAtIndex:indexPath.row];
        [self.contexto deleteObject:_contatos[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Contato *contato = [self.contatos objectAtIndex:indexPath.row];

    FormularioContatoViewController *form = [[FormularioContatoViewController alloc] initWithContato:contato];
    form.delegate = self;

    [self.navigationController pushViewController:form animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
            initWithTarget:self action:@selector(exibeMaisAcoes:)];

    [self.tableView addGestureRecognizer:longPress];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.linhaDestaque >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.linhaDestaque inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionNone
                                      animated:YES];
        self.linhaDestaque = -1;
    }
}

- (void)contatoAtualizado:(Contato *)contato {
    self.linhaDestaque = [self.contatos indexOfObject:contato];
}

- (void)contatoAdicionado:(Contato *)contato {
    [self.contatos addObject:contato];
    self.linhaDestaque = [self.contatos indexOfObject:contato];
    [self.tableView reloadData];
}

- (void)exibeMaisAcoes:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint ponto = [gesture locationInView:self.tableView];
        NSIndexPath *index = [self.tableView indexPathForRowAtPoint:ponto];

        _contatoSelecionado = self.contatos[index.row];

        UIActionSheet *opcoes = [[UIActionSheet alloc]
                initWithTitle:_contatoSelecionado.nome
                     delegate:self
            cancelButtonTitle:@"Cancelar"
       destructiveButtonTitle:nil
            otherButtonTitles:@"Ligar", @"Enviar Email", @"Visualizar site",
                              @"Abrir Mapa", nil];

        [opcoes showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self ligar];
            break;
        case 1:
            [self enviarEmail];
            break;
        case 2:
            [self abrirSite];
            break;
        case 3:
            [self mostrarMapa];
            break;
        default:
            break;
    }
}

- (void)abrirAplicativoComURL:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)ligar {
    UIDevice *device = [UIDevice currentDevice];
    if ([device.model isEqualToString:@"iPhone"]) {
        NSString *numero = [NSString stringWithFormat:@"tel:%@",
                                                      _contatoSelecionado.telefone];
        [self abrirAplicativoComURL:numero];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Impossível fazer ligação"
                                    message:@"Seu dispositivo não é um iPhone" delegate:nil
                          cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)abrirSite {
    NSString *url = _contatoSelecionado.site;
    [self abrirAplicativoComURL:url];
}

- (void)mostrarMapa {
    NSString *url = [[NSString stringWithFormat:
            @"http://maps.google.com/maps?q=%@", _contatoSelecionado.endereco]
            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self abrirAplicativoComURL:url];
}

- (void)enviarEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *enviadorEmail =
                [[MFMailComposeViewController alloc] init];
        enviadorEmail.mailComposeDelegate = self;

        [enviadorEmail setToRecipients:@[_contatoSelecionado.email]];
        [enviadorEmail setSubject:@"Caelum"];

        [self presentViewController:enviadorEmail animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Não é possível enviar email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
