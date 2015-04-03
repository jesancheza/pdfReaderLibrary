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

@interface JESABookViewController ()

@end

@implementation JESABookViewController

#pragma mark - Init
-(id) initWithModel:(JESABook *) model{
    if (self = [super initWithNibName:nil
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
    
    if (self.isFavorite.on) {
        self.model.isFavorite = YES;
    }else{
        self.model.isFavorite = NO;
    }
    
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
