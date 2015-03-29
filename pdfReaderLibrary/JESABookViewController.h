//
//  JESABookViewController.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 29/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import UIKit;
@class JESABook;

@interface JESABookViewController : UIViewController

@property(nonatomic, weak) IBOutlet UILabel *titleView;
@property(nonatomic, weak) IBOutlet UIImageView *photoView;

@property(nonatomic,strong) JESABook *model;

-(id) initWithModel:(JESABook *) model;

@end
