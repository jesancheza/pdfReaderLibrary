//
//  JESASimplePDFViewController.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 31/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESASimplePDFViewController.h"
#import "JESABook.h"
#import "Settings.h"

@interface JESASimplePDFViewController ()

@end

@implementation JESASimplePDFViewController

#pragma mark - Init
-(id) initWithModel:(JESABook *)model{
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
    
    // Asegurarse que no se ocupa toda la pantalla cuando estás en un combinador
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self displayURL];
    
    // Nos damos de alta en la notificación
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatCharacterDidChange:)
                   name:BOOK_DID_CHANGE_NOTIFICATION_NAME
                 object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Damos de baja la notificación
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

#pragma mark - Notifications
// CHARACTER_DID_CHANGE_NOTIFICATION_NAME
-(void)notifyThatCharacterDidChange:(NSNotification *) notification{
    
    // Sacamos el personaje
    NSDictionary *dic = [notification userInfo];
    JESABook *book = [dic objectForKey:BOOK_KEY];
    
    // Actualizamos el modelo
    self.model = book;
    
    // Sincronizar modelo -> vista
    [self displayURL];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    // Paro y oculto el activity
    [self.activityView stopAnimating];
    [self.activityView setHidden:YES];
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    // Ocultar Activity
    [self.activityView stopAnimating];
    [self.activityView setHidden:YES];
    
    // Mostrar mensaje de error NSLog
    NSLog(@"Se ha producido un error al intentar descargar el libro.");
}


-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked ||
        navigationType == UIWebViewNavigationTypeFormSubmitted) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - Utils
-(void) displayURL{
    // Asignar delegados
    self.browser.delegate = self;
    
    // Sincronizar modelo -> vista
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    
    [self.browser loadRequest:[NSURLRequest requestWithURL:self.model.bookURL]];
    
}


@end
