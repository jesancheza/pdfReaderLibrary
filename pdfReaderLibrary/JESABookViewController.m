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
}

@end
