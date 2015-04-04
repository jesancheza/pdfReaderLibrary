//
//  JESASandboxAndUserDefaultUtils.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 31/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import Foundation;

@interface JESASandboxAndUserDefaultUtils : NSObject

-(id) loadFileSandboxName:(NSString *) name;
-(void) saveFileInSandboxName:(NSString *) name data:(id) data;

-(id) isUserDefaultName:(NSString *) name;
-(void) saveInUserDefaultName:(NSString *) name value:(id) value;

@end
