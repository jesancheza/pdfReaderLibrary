//
//  JESALibraryTableViewController.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import UIKit;
@class JESALibrary;

@interface JESALibraryTableViewController : UITableViewController

@property(nonatomic, strong) JESALibrary *model;

-(id) initWithModel:(JESALibrary *) model style:(UITableViewStyle) style;

@end
