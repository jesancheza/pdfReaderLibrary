//
//  JESASandboxAndUserDefaultUtils.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 31/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import Foundation;

@interface JESASandboxAndUserDefaultUtils : NSObject

-(NSData *) loadFileSandboxName:(NSString *) name;
-(void) saveFileInSandboxName:(NSString *) name data:(NSData *) data;

@end
