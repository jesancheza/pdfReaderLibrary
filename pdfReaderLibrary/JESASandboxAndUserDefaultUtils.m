//
//  JESASandboxAndUserDefaultUtils.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 31/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESASandboxAndUserDefaultUtils.h"

@implementation JESASandboxAndUserDefaultUtils

#pragma mark - Sandbox
-(NSData *) loadFileSandboxName:(NSString *) name{
    //  Averiguar la url a la carpeta Document
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    
    NSURL *url = [urls lastObject];
    
    url = [url URLByAppendingPathComponent:name];
    
    NSError *err;
    NSData *data = [NSData dataWithContentsOfURL:url
                                         options:NSDataReadingMappedIfSafe
                                           error:&err];
    
    return data;
}


-(void) saveFileInSandboxName:(NSString *) name data:(NSData *) data{

    //  Averiguar la url a la carpeta Document
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    
    // Guardamos los datos en Document
    NSURL *url = [urls lastObject];
    url = [url URLByAppendingPathComponent:name];
    NSError *err;
    BOOL rcI = [data writeToURL:url
                             options:NSDataWritingAtomic
                               error:&err];
    
    // Comprobamos si ha ocurrido algún error
    if (rcI == NO) {
        // Error
        NSLog(@"Error al guardar el archivo: %@", err.userInfo);
    }else{
        // No ocurrio error
        NSLog(@"Archivo guardado correctamente.");
    }
}

#pragma mark - UserDefault
-(id) isUserDefaultName:(NSString *) name{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:name];
}

-(void) saveInUserDefaultName:(NSString *) name value:(id) value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:value
                 forKey:name];
    
    [defaults synchronize];
}

@end
