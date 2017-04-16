#import "Contato.h"

@implementation Contato

@dynamic nome, telefone, email, endereco, site, latitude, longitude;
@synthesize foto;

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title {
    return self.nome;
}

- (NSString *)subtitle {
    return self.email;
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    if (self) {
//        [self setNome:[aDecoder decodeObjectForKey:@"nome"]];
//        [self setTelefone:[aDecoder decodeObjectForKey:@"telefone"]];
//        [self setEmail:[aDecoder decodeObjectForKey:@"email"]];
//        [self setEndereco:[aDecoder decodeObjectForKey:@"endereco"]];
//        [self setSite:[aDecoder decodeObjectForKey:@"site"]];
//        [self setFoto:[aDecoder decodeObjectForKey:@"foto"]];
//        [self setLatitude:[aDecoder decodeObjectForKey:@"latitude"]];
//        [self setLongitude:[aDecoder decodeObjectForKey:@"longitude"]];
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.nome forKey:@"nome"];
//    [aCoder encodeObject:self.telefone forKey:@"telefone"];
//    [aCoder encodeObject:self.email forKey:@"email"];
//    [aCoder encodeObject:self.endereco forKey:@"endereco"];
//    [aCoder encodeObject:self.site forKey:@"site"];
//    [aCoder encodeObject:self.foto forKey:@"foto"];
//    [aCoder encodeObject:self.latitude forKey:@"latitude"];
//    [aCoder encodeObject:self.longitude forKey:@"longitude"];
//}

@end
