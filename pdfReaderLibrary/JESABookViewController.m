//
//  JESABookViewController.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 29/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESABookViewController.h"
#import "JESABook.h"

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

#pragma mark - View Lifecycle
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Ocultamos el Toolbar
    [self.navigationController setToolbarHidden:YES];
    
    // Sincronizamos modelo -> vista
    [self syncViewWithModel];
    
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
