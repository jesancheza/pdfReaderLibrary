// S//
//  JESALibrary.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESALibrary.h"
#import "JESABook.h"
#import "JESASandboxAndUserDefaultUtils.h"
#import "Settings.h"

@interface JESALibrary ()

@property(nonatomic, strong) NSMutableArray *library;
@property(nonatomic, strong) NSMutableDictionary *booksForTags;

@end

@implementation JESALibrary

#pragma mark - Init
-(id) initWithModel:(NSData *) data{
    if (self = [super init]) {
        if (data != nil) {
            NSError *err;
            NSArray * JSONObjects = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
            if (JSONObjects != nil) {

                // Recuperamos favoritos si los hay
                JESASandboxAndUserDefaultUtils *utilsSandbox = [JESASandboxAndUserDefaultUtils new];
                NSString *favorites = [utilsSandbox isUserDefaultName:FAVORITES_BOOKS];
                
                NSArray *arrayFavorites = [favorites componentsSeparatedByString:@","];
                
                NSMutableArray *favoritos = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dic in JSONObjects) {
                    
                    JESABook *book = [[JESABook alloc] initWithDictionary:dic];
                    
                    if (!self.library) {
                        self.library = [NSMutableArray arrayWithObject:book];
                    }else{
                        [self.library addObject:book];
                    }
                    
                    for (NSString *tag in book.tags) {
                        NSMutableArray *books;
                        if ((books = [[self.booksForTags objectForKey:tag] mutableCopy])) {
                            // Ya tengo el tag
                            [books addObject:book];
                            [self.booksForTags setObject:books forKey:tag];
                        }else{
                            // Es un nuevo tag
                            if (!self.booksForTags) {
                                self.booksForTags = [NSMutableDictionary dictionaryWithObject:@[book]
                                                                                       forKey:tag];
                            }else{
                                [self.booksForTags setObject:@[book] forKey:[tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                            }
                        }
                    }
                    
                    // Añadimos favoritos
                    if ([arrayFavorites containsObject:book.title]) {
                        book.isFavorite = YES;
                        [favoritos addObject:book];
                    }
                    
                }
                
                // Ordenamos la librería
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
                self.library = [[self.library sortedArrayUsingDescriptors:@[sort]]mutableCopy];
                
                // Añado array al dictionary para favoritos si los hay
                if (favoritos) {
                    [self.booksForTags setObject:favoritos
                                          forKey:@"Favoritos"];
                }
                
                
            }else{
                NSLog(@"Error al parsear el JSON: %@", err.userInfo);
            }
        }else{
            NSLog(@"Fichero vacío");
        }
    }
    return self;
}

#pragma mark - Actions
-(void) addFavoriteBook:(JESABook *) book{
    
    NSMutableArray *books = [[self.booksForTags objectForKey:[self tagNameSection:0]] mutableCopy];
    
    // Añadimos el libro a favoritos
    if (books) {
        [books addObject:book];
    }else{
        books = [@[book] mutableCopy];
    }

    
    // Ordenamos el array
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    books = [[books sortedArrayUsingDescriptors:@[sort]]mutableCopy];
    
    // Añado array al dictionary
    [self.booksForTags setObject:books
                          forKey:[self tagNameSection:0]];
    
}

-(void) deleteFavoriteBook:(JESABook *) book{
    NSMutableArray *books;
    if ((books = [[self.booksForTags objectForKey:[self tagNameSection:0]] mutableCopy])) {
        [books removeObject:book];
        // Añado array al dictionary
        [self.booksForTags setObject:books
                              forKey:[[self tagNameSection:0]
                                      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
}

#pragma mark - Accessors
-(JESABook *) libraryAtIndex:(NSUInteger) index{
    return [self.library objectAtIndex:index];
}

-(NSUInteger) booksCount{
    return [self.library count];
}

-(NSArray *) tags{
    NSArray *tags = [self.booksForTags allKeys];
    
    // Ordenamos los tags
    tags = [tags sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // Insertamos el tag Favoritos
    NSMutableArray *mutableTags = [tags mutableCopy];
    if ([tags containsObject:@"Favoritos"]) {
        [mutableTags removeObject:@"Favoritos"];
    }
    [mutableTags insertObject:@"Favoritos" atIndex:0];
    
    return mutableTags;
}

-(NSUInteger) bookCountForTag:(NSString *) tag{
    
    NSArray *books =[self.booksForTags objectForKey:tag];
    
    if (books != nil) {
        return [books count];
    }else{
        return 0;
    }
    
}

-(NSArray *) booksForTag:(NSString *) tag{
    NSArray *books = [self.booksForTags objectForKey:tag];
    
    if (books == nil || ([books count] == 0)) {
        return nil;
    }else{
        return books;
    }

}

-(JESABook *) bookForTag:(NSString *) tag atIndex:(NSUInteger) index{
    NSArray *tags = [self booksForTag:tag];
    
    return [tags objectAtIndex:index];
}

-(NSUInteger) tagsCount{
    return [self.tags count];
}

-(NSUInteger) bookCountForTagInt:(NSUInteger) tagPos{
    NSString *tagName = [self.tags objectAtIndex:tagPos];
    return [self bookCountForTag:tagName];
}

-(NSString *) tagNameSection:(NSUInteger) section{
    NSArray *tags = [self tags];
    NSString *tagName = [tags objectAtIndex:section];
    
    return tagName;
}

-(JESABook *) bookForTagPos:(NSUInteger) tagPos atIndex:(NSUInteger) index{
    NSString *tagName = [self tagNameSection:tagPos];
    return [self bookForTag:tagName atIndex:index];
    
}

@end
