//
//  JESALibraryTableViewController.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import UIKit;
@class JESALibrary;
@class JESABook;

@class JESALibraryTableViewController;

@protocol JESALibraryTableViewControllerDelegate <NSObject>

@optional
-(void) libraryTableViewController:(JESALibraryTableViewController *) uVC didSelectBook:(JESABook *) book;

@end

@interface JESALibraryTableViewController : UITableViewController

@property(nonatomic, strong) JESALibrary *model;
@property(weak, nonatomic) id<JESALibraryTableViewControllerDelegate> delegate;

-(id) initWithModel:(JESALibrary *) model style:(UITableViewStyle) style;

@end
