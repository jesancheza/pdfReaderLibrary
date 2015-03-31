//
//  JESASimplePDFViewController.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 31/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import UIKit;
@class JESABook;

@interface JESASimplePDFViewController : UIViewController <UIWebViewDelegate>

@property(nonatomic, weak) IBOutlet UIWebView *browser;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityView;

@property(nonatomic, strong) JESABook *model;

-(id) initWithModel:(JESABook *)model;

@end
