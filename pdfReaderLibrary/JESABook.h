//
//  JESABook.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface JESABook : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSURL *imageURL;
@property(nonatomic, strong) NSURL *bookURL;
@property(nonatomic, strong) NSArray *tags;
@property(nonatomic, strong) NSArray *authors;

@property(nonatomic, strong) UIImage *photo;
@property(nonatomic, copy) NSString *authorsList;

// Métodos de clase
+(id) bookWithTitle:(NSString *) title
           imageURL:(NSURL *) imageURL
            bookURL:(NSURL *) bookURL
               tags:(NSArray *) tags
            authors:(NSArray *) authors;

// Designado
-(id) initWithTitle:(NSString *) title
           imageURL:(NSURL *) imageURL
            bookURL:(NSURL *) bookURL
               tags:(NSArray *) tags
            authors:(NSArray *) authors;

-(id) initWithDictionary:(NSDictionary *) dic;
@end
