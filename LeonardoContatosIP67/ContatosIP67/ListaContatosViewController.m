#import "ListaContatosViewController.h"
#import "FormularioViewController.h"
#import "Contato.h"

@implementation ListaContatosViewController
@synthesize contatos;
@synthesize linhaDestaque;

- (id) init {
    self = [super init];
    if(self){
        UIImage *tabItemImage = [UIImage imageNamed:@"lista-contatos.png"];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"Contatos" image:tabItemImage tag:0];
        self.tabBarItem = tabItem;
        
        self.navigationItem.title = @"Contatos";
        
        UIBarButtonItem *botaoExibirFormulario = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
            target: self action:@selector(exibeFormulario)];
        
        self.navigationItem.rightBarButtonItem = botaoExibirFormulario;
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        self.linhaDestaque = -1;
        
    }
    return self;
}

- (void) exibeFormulario{
    FormularioViewController *formulario = [[FormularioViewController alloc] init];
    
    //formulario.contatos = self.contatos;
    formulario.delegate = self;
    
    [self.navigationController pushViewController:formulario animated:YES];
}

- (void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contatos count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Contato *contato = [self.contatos objectAtIndex: indexPath.row];
    
    FormularioViewController *form = [[FormularioViewController alloc] initWithContato: contato];
    
    //form.contatos = self.contatos;
    form.delegate = self;
    
    [self.navigationController pushViewController:form animated:YES];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:cellIdentifier];
    }
    
    Contato *contato = [self.contatos objectAtIndex:indexPath.row];
    cell.textLabel.text = contato.nome;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.contatos removeObjectAtIndex: indexPath.row];
         
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void) contatoAtualizado:(Contato *)contato{
    NSLog(@"Contato atualizado: %d", [self.contatos indexOfObject:contato]);
    self.linhaDestaque = [self.contatos indexOfObject:contato];
}

- (void) contatoAdicionado:(Contato *)contato{
     NSLog(@"Contato adicionado: %d", [self.contatos indexOfObject:contato]);
    [self.contatos addObject:contato];
    self.linhaDestaque = [self.contatos indexOfObject:contato];
    [self.tableView reloadData];
}

-(void) viewDidAppear:(BOOL)animated
{
    if(self.linhaDestaque>=0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.linhaDestaque inSection:0];
        [self.tableView 
            selectRowAtIndexPath:indexPath 
            animated:YES 
            scrollPosition:UITableViewScrollPositionNone];
        [self.tableView 
            scrollToRowAtIndexPath:indexPath 
            atScrollPosition:UITableViewScrollPositionNone 
            animated:YES];
        
        self.linhaDestaque = -1;
    }

}

-(void) viewDidLoad
{
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(exibeMaisAcoes:)];
    [self.tableView addGestureRecognizer:longPress];
}

-(void) exibeMaisAcoes:(UIGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint ponto = [gesture locationInView:self.tableView];
        NSIndexPath *index = [self.tableView indexPathForRowAtPoint:ponto];
        
        Contato *contato = [self.contatos objectAtIndex:index.row];
        
        contatoSelecionado = contato;
        
        UIActionSheet *opcoes = [[UIActionSheet alloc] initWithTitle:contato.nome delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Ligar", @"Enviar Email", @"Visualizar site", @"Abrir Mapa", nil];
        [opcoes showInView:self.view];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
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

-(void) abrirAplicativoComUrl:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

}

-(void) ligar
{
    UIDevice *device = [UIDevice currentDevice];
    if([device.model isEqualToString:@"iPhone"]){
        NSString *numero = [NSString stringWithFormat:@"tel:%@", contatoSelecionado.telefone];
        [self abrirAplicativoComUrl:numero];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Impossivel fazer ligacao" message:@"Seu dispositivo nao e um iPhone" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

-(void) abrirSite
{
    NSString *url = contatoSelecionado.site;
    [self abrirAplicativoComUrl:url];
}

-(void) mostrarMapa
{
    NSString *url = [[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", contatoSelecionado.endereco] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self abrirAplicativoComUrl:url];
}

-(void) enviarEmail
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *enviadorEmail = [[MFMailComposeViewController alloc] init];
        enviadorEmail.mailComposeDelegate = self;
        
        NSArray *emails = [[NSArray alloc] initWithObjects:contatoSelecionado.email,nil];
        [enviadorEmail setToRecipients:emails];
        [enviadorEmail setSubject:@"Caelum"];
        
        [self presentViewController:enviadorEmail animated:YES completion:nil];
    
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Nao e possivel enviar email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
