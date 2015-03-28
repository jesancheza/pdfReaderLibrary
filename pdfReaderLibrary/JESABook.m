//
//  JESABook.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESABook.h"

@implementation JESABook

#pragma mark - Class Methods
+(id) bookWithTitle:(NSString *) title
           imageURL:(NSURL *) imageURL
            bookURL:(NSURL *) bookURL
               tags:(NSArray *) tags
            authors:(NSArray *) authors{
    
    return [[self alloc] initWithTitle:title
                              imageURL:imageURL
                               bookURL:bookURL
                                  tags:tags
                               authors:authors];
}

#pragma mark - Init
// Designado
-(id) initWithTitle:(NSString *) title
           imageURL:(NSURL *) imageURL
            bookURL:(NSURL *) bookURL
               tags:(NSArray *) tags
            authors:(NSArray *) authors{
    if (self = [super init]) {
        _title = title;
        _imageURL = imageURL;
        _bookURL = bookURL;
        _tags = tags;
        _authors = authors;
    }
    return self;
}

@end
