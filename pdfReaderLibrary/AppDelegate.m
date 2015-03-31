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
#import "JESABookViewController.h"
#import "Settings.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:FIRST_TIME]) {
        
        [defaults setObject:@"1"
                     forKey:FIRST_TIME];
        
        [defaults synchronize];
        
        [self downloadData];
    }
    
    NSData *data = [self loadJSON];
    
    // Creamos el modelo
    JESALibrary *model = [[JESALibrary alloc] initWithModel:data];
    
    
    // Identificamos si usamos pantalla grande o pequeña
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self configureForPadWithModel:model];
    }else{
        [self configureForPhoneWithModel:model];
    }
    
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

-(void) configureForPadWithModel:(JESALibrary *) model{
    // Creamos los controladores
    JESALibraryTableViewController *lVC = [[JESALibraryTableViewController alloc]
                                           initWithModel:model
                                           style:UITableViewStylePlain
                                           order:[self lastLibraryOrderSelected]];
    
    JESABookViewController *bVC = [[JESABookViewController alloc] initWithModel:[self lastSelectedBookInModel:model]];
    
    // Creamos los navigations
    UINavigationController *lNav = [[UINavigationController alloc] initWithRootViewController:lVC];
    UINavigationController *bNav = [[UINavigationController alloc] initWithRootViewController:bVC];
    
    // Creamos un combinador
    UISplitViewController *spltVC = [[UISplitViewController alloc] init];
    spltVC.viewControllers = @[lNav, bNav];
    
    spltVC.delegate = bVC;
    lVC.delegate = bVC;
    
    self.window.rootViewController = spltVC;
}

-(JESABook *) lastSelectedBookInModel:(JESALibrary *) library{
    
    // Obtengo el NSUserDefault
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    // Saco las coordenadas
    JESABook *book;
    if (![userDef objectForKey:LAST_SELECTED_BOOK]) {
        book = [library libraryAtIndex:0];
    }else{
        NSArray *coord = [userDef objectForKey:LAST_SELECTED_BOOK];
        NSUInteger section = [[coord objectAtIndex:0] integerValue];
        NSUInteger pos = [[coord objectAtIndex:1] integerValue];
        NSUInteger order = [[coord objectAtIndex:2] integerValue];
    
    
        if (order == LIBRARY_ORDER_ALFABETICALLY) {
            book = [library libraryAtIndex:pos];
        }else{
            book = [library bookForTagPos:section
                              atIndex:pos];
        }
    }
    
    return book;
    
}

-(void) configureForPhoneWithModel:(JESALibrary *) model{
    // Creamos el controlador
    JESALibraryTableViewController *lVC = [[JESALibraryTableViewController alloc]
                                           initWithModel:model
                                           style:UITableViewStylePlain
                                           order:[self lastLibraryOrderSelected]];
    // Creamos un combinador
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lVC];
    
    // Asignamos delegados
    lVC.delegate = lVC;
    
    self.window.rootViewController = nav;
}

-(int) lastLibraryOrderSelected{
    // Obtengo el NSUserDefault
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    // Saco las coordenadas
    if (![userDef objectForKey:ORDER_LIBRARY]) {
        return 0;
    }else{
        NSString *order = [userDef objectForKey:ORDER_LIBRARY];
        return [order intValue];
    }
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
