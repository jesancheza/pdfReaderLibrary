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

@end

@implementation JESALibrary

#pragma mark - Properties
-(NSUInteger) booksCount{
    return [self.library count];
}

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
                    
                }
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

@end
