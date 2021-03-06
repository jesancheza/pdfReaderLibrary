//
//  JESABook.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESABook.h"

@implementation JESABook

#pragma marl - Properties
-(UIImage *)photo{
    //  Averiguar la url a la carpeta Document
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    
    NSURL *url = [urls lastObject];
    
    NSString *titleImage = [NSString stringWithFormat:@"%@.jpg", self.title];
    url = [url URLByAppendingPathComponent:titleImage];
    
    NSError *err;
    NSData *data = [NSData dataWithContentsOfURL:url
                                         options:NSDataReadingMappedIfSafe
                                           error:&err];
    
    return [UIImage imageWithData:data];
}

-(NSString *) authorsList{
    return [self.authors componentsJoinedByString:@", "];
}

-(NSString *) tagsList{
    return [self.tags componentsJoinedByString:@", "];
}

#pragma mark - Class Methods
+(id) bookWithTitle:(NSString *) title
           imageURL:(NSURL *) imageURL
            bookURL:(NSURL *) bookURL
               tags:(NSArray *) tags
            authors:(NSArray *) authors
         isFavorite:(bool) isFavorite{
    
    return [[self alloc] initWithTitle:title
                              imageURL:imageURL
                               bookURL:bookURL
                                  tags:tags
                               authors:authors
                            isFavorite:isFavorite];
}

#pragma mark - Init
// Designado
-(id) initWithTitle:(NSString *) title
           imageURL:(NSURL *) imageURL
            bookURL:(NSURL *) bookURL
               tags:(NSArray *) tags
            authors:(NSArray *) authors
         isFavorite:(bool) isFavorite{
    
    if (self = [super init]) {
        _title = title;
        _imageURL = imageURL;
        _bookURL = bookURL;
        _tags = tags;
        _authors = authors;
        _isFavorite = isFavorite;
    }
    return self;
}

#pragma mark - JSON
-(id) initWithDictionary:(NSDictionary *) dic{
    
    return [self initWithTitle:[dic objectForKey:@"title"]
                      imageURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]]
                       bookURL:[NSURL URLWithString:[dic objectForKey:@"pdf_url"]]
                          tags:[self extractTagsFromJSON:[dic objectForKey:@"tags"]]
                       authors:[self extractAuthorsFromJSON:[dic objectForKey:@"authors"]]
                    isFavorite:NO];
}

-(NSArray *) extractTagsFromJSON:(NSString *) tagsJSON{
    
    
    NSArray *tags = [tagsJSON componentsSeparatedByString:@","];
    
    return tags;
}

-(NSArray *) extractAuthorsFromJSON:(NSString *) authorsJSON{
    
    NSArray *authors = [authorsJSON componentsSeparatedByString:@","];
    
    return authors;
}

@end
