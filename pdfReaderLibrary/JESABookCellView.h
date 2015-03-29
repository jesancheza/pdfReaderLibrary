//
//  JESABookCellView.h
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 29/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import UIKit;

@interface JESABookCellView : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *title;
@property(nonatomic, weak) IBOutlet UILabel *authors;
@property(nonatomic, weak) IBOutlet UIImageView *photoView;

+(NSString *) cellId;
+(CGFloat) cellHeight;
@end
