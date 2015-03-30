// S//
//  JESALibrary.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESALibrary.h"
#import "JESABook.h"

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
                for (NSDictionary *dic in JSONObjects) {
                    
                    JESABook *book = [[JESABook alloc] initWithDictionary:dic];
                    
                    if (!self.library) {
                        self.library = [NSMutableArray arrayWithObject:book];
                    }else{
                        [self.library addObject:book];
                    }
                    
                    // Añado el tag Favoritos
                    self.booksForTags = [NSMutableDictionary dictionaryWithObject:@[]
                                                                           forKey:@"Favoritos"];
                    
                    for (NSString *tag in book.tags) {
                        NSArray *books;
                        if ((books = [self.booksForTags objectForKey:tag])) {
                            // Ya tengo el tag
                            [books arrayByAddingObject:book];
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
                    
                }
                
                NSLog(@"La lista única de tags es: %@", [self tags]);
                
                // Ordenamos la librería
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
                self.library = [[self.library sortedArrayUsingDescriptors:@[sort]]mutableCopy];
                
            }else{
                NSLog(@"Error al parsear el JSON: %@", err.userInfo);
            }
        }else{
            NSLog(@"Fichero vacío");
        }
    }
    return self;
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
    
    return tags;
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

@end
