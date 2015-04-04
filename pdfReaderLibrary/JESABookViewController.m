//
//  JESABookViewController.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 29/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESABookViewController.h"
#import "JESABook.h"
#import "JESASimplePDFViewController.h"
#import "Settings.h"
#import "JESALibrary.h"
#import "JESASandboxAndUserDefaultUtils.h"

@interface JESABookViewController ()

@end

@implementation JESABookViewController

#pragma mark - Init
-(id) initWithModel:(JESABook *) model{
    NSString *nibName = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        nibName = @"JESABookViewController~iphone";
    }
    if (self = [super initWithNibName:nibName
                               bundle:nil]) {
        _model = model;
        self.title = [model title];
    }
    return self;
}

#pragma mark - Actions
- (IBAction)displaySimplePDF:(id)sender {
    // Crear un simplePDFVC
    JESASimplePDFViewController *pVC = [[JESASimplePDFViewController alloc] initWithModel:self.model];
    
    // Hacer un push
    [self.navigationController pushViewController:pVC animated:YES];
}

- (IBAction)changeFavorite:(id)sender {
    
    // Recuperamos favoritos del sandbox
    JESASandboxAndUserDefaultUtils *utilsSandbox = [JESASandboxAndUserDefaultUtils new];
    NSMutableArray *favorites = [[utilsSandbox loadFileSandboxName:FAVORITES_BOOKS] mutableCopy];
    
    if (self.isFavorite.on) {
        self.model.isFavorite = YES;
        // Añadimos el libro al sandbox
        if (favorites) {
            [favorites addObject:self.model];
        }else{
            favorites = [@[self.model] mutableCopy];
        }
    }else{
        self.model.isFavorite = NO;
        // Eliminamos el libro del sandbox
        [favorites removeObject:self.model];
    }
    
    // Guardamos array en el sandbox
#warning hay que comprobar en el método si es un NSData o NSArray
    //[utilsSandbox saveFileInSandboxName:FAVORITES_BOOKS data:[favorites copy]];
    
    // mandamos una notificación
    NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:@[self.model]
                                                          forKeys:@[FAVORITE_KEY]];
    
    // Creamos la notificación
    NSNotification *note = [NSNotification notificationWithName:BOOK_DID_FAVORITE_NOTIFICATION_NAME
                                                         object:self
                                                       userInfo:extraInfo];
    
    // Mandamos la notificación
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

#pragma mark - View Lifecycle
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Ocultamos el Toolbar
    [self.navigationController setToolbarHidden:YES];
    
    // Sincronizamos modelo -> vista
    [self syncViewWithModel];
    
    // Si estoy dentro de un SplitVC me pongo el botón
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
    // si estamos en landscape, añadimos la vista que tenemos para landscape
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        [self addPortraitViewWithProperFrame];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation)) {
        // estamos en portrait
        [self.portraitView removeFromSuperview];
    }
    else {
        // estamos en landscape
        [self addPortraitViewWithProperFrame];
    }
}

- (void)addPortraitViewWithProperFrame
{
    // asignamos el frame a la vista en portrait para que se redimensione
    // si la añadimos directamente como view, al no estar dentro de un VC, no se va a redimensionar
    CGRect iPhoneScreen = [[UIScreen mainScreen] bounds];
    CGRect portraitRect = CGRectMake(0, 0, iPhoneScreen.size.height, iPhoneScreen.size.width);
    self.portraitView.frame = portraitRect;
    [self.view addSubview:self.portraitView];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utils
-(void) syncViewWithModel{
    self.titleView.text = self.model.title;
    self.photoView.image = self.model.photo;
    self.authorsView.text = self.model.authorsList;
    self.tagsView.text = self.model.tagsList;
    if (self.model.isFavorite) {
        [self.isFavorite setOn:YES];
    }else{
        [self.isFavorite setOn:NO];
    }
    
    // Landscape
    self.titleViewLandscape.text = self.model.title;
    self.photoViewLandscape.image = self.model.photo;
    self.authorsViewLandscape.text = self.model.authorsList;
    self.tagsViewLandscape.text = self.model.tagsList;
    if (self.model.isFavorite) {
        [self.isFavoriteLandscape setOn:YES];
    }else{
        [self.isFavoriteLandscape setOn:NO];
    }
}

#pragma mark - UISplitViewControllerDelegate
-(void) splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    // Averiguar si la tabla se ve o no
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        // La tabla está oculta y cuelga del botón
        // Ponemos ese botón en mi barra de navegación
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }else{
        // Se muestra la tabla: oculto el botón de la barra de navegación
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - JESALibraryTableViewControllerDelegate
-(void) libraryTableViewController:(JESALibraryTableViewController *) uVC
                     didSelectBook:(JESABook *) book{
    
    // Sincronizo el modelo
    self.model = book;
    
    // Sincornizo el modelo con la vista
    [self syncViewWithModel];
}

@end
