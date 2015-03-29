//
//  JESABookViewController.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 29/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import UIKit;
@class JESABook;
#import "JESALibraryTableViewController.h"

@interface JESABookViewController : UIViewController <UISplitViewControllerDelegate, JESALibraryTableViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UILabel *titleView;
@property(nonatomic, weak) IBOutlet UIImageView *photoView;
@property(nonatomic, weak) IBOutlet UILabel *authorsView;
@property(nonatomic, weak) IBOutlet UILabel *tagsView;

@property(nonatomic,strong) JESABook *model;

-(id) initWithModel:(JESABook *) model;

@end
