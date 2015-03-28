//
//  JESALibrary.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import Foundation;
@class JESABook;

@interface JESALibrary : NSObject

@property(nonatomic, readonly) NSUInteger booksCount;

-(id) initWithModel:(NSData *) data;
-(JESABook *) libraryAtIndex:(NSUInteger) index;

//-(NSArray *) tags;
//-(NSUInteger) bookCountForTag:(NSString *) tag;
//-(NSArray *) booksForTag:(NSString *) tag;
//-(JESABook *) bookForTag:(NSString *) tag atIndex:(NSUInteger) index;

@end
