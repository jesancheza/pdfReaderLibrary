//
//  JESALibrary.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESALibrary.h"

@interface JESALibrary ()

@property(nonatomic, strong) NSMutableArray *library;

@end

@implementation JESALibrary

-(NSUInteger) booksCount{
    return [self.library count];
}


@end
