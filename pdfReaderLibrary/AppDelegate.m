//
//  AppDelegate.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "AppDelegate.h"
#import "JESALibrary.h"
#import "JESALibraryTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"first"]) {
        
        [defaults setObject:@"1"
                     forKey:@"first"];
        
        [defaults synchronize];
        
        [self downloadData];
    }
    
    NSData *data = [self loadJSON];
    
    // Creamos el modelo
    JESALibrary *model = [[JESALibrary alloc] initWithModel:data];
    
    // Creamos el controlador
    JESALibraryTableViewController *lVC = [[JESALibraryTableViewController alloc] initWithModel:model];
    
    // Creamos un combinador
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lVC];
    
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) downloadData{
    // Descargo el JSON
    NSURL *urlJSON = [NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"];

    NSData *data = [NSData dataWithContentsOfURL:urlJSON];
    
    //  Averiguar la url a la carpeta Document
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    
    NSURL *url = nil;
    
    // Recuperamos JSON
    NSError *err;
    NSArray * JSONObjects = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    if (JSONObjects != nil) {
        // Recorremos el JSON
        for (NSDictionary *dic in JSONObjects) {
            
            // Recumeramos la imagen
            NSURL *image = [NSURL URLWithString:[dic objectForKey:@"image_url"]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:image];
            
            
            // Guardamos la imagen en Document
            NSString *titleImage = [NSString stringWithFormat:@"%@.jpg", [dic objectForKey:@"title"]];
            url = [urls lastObject];
            url = [url URLByAppendingPathComponent:titleImage];
            BOOL rcI = [imageData writeToURL:url
                                     options:NSDataWritingAtomic
                                       error:&err];
            
            // Comprobamos si ha ocurrido algún error
            if (rcI == NO) {
                // Error
                NSLog(@"Error al guardar la imagen: %@", err.userInfo);
            }else{
                // No ocurrio error
                NSLog(@"Imagen guardado correctamente.");
            }
            
            /*
            NSURL *pdf = [NSURL URLWithString:[dic objectForKey:@"pdf_url"]];
             
            NSData *pdfData = [NSData dataWithContentsOfURL:pdf];
             
            NSString *titlePdf = [NSString stringWithFormat:@"%@.pdf", [dic objectForKey:@"title"]];
            url = [urls lastObject];
            url = [url URLByAppendingPathComponent:titlePdf];
            BOOL rcP = [pdfData writeToURL:url
                                   options:NSDataWritingAtomic
                                     error:&err];
            
            if (rcP == NO) {
                NSLog(@"Error al guardar el pdf: %@", err.userInfo);
            }else{
                NSLog(@"PDF guardado correctamente.");
            }*/
        }
    }
    
    url = [urls lastObject];
    
    url = [url URLByAppendingPathComponent:@"books.json"];
    // Guardamos el JSON en Documents
    BOOL rc = [data writeToURL:url
                       options:NSDataWritingAtomic
                         error:&err];
    
    // Comprobar que se guarda
    if (rc == NO) {
        // Error!
        NSLog(@"Error al guardar el fichero JSON: %@", err.userInfo);
    }else{
        // No hubo error
        NSLog(@"Se ha cargado correctamente");
    }

}

-(NSData *) loadJSON{
    //  Averiguar la url a la carpeta Document
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    
    NSURL *url = [urls lastObject];
    
    url = [url URLByAppendingPathComponent:@"books.json"];
    
    NSError *err;
    NSData *data = [NSData dataWithContentsOfURL:url
                                         options:NSDataReadingMappedIfSafe
                                           error:&err];
    
    return data;
}

@end
