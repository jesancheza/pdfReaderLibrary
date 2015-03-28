//
//  JESALibraryTableViewController.m
//  pdfReaderLibrary
//
//  Created by José Enrique Sanchez on 28/3/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESALibraryTableViewController.h"
#import "JESALibrary.h"
#import "JESABook.h"

@interface JESALibraryTableViewController ()

@end

@implementation JESALibraryTableViewController

#pragma mark - Init
-(id) initWithModel:(JESALibrary *) model{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
        self.title = @"Library";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.model booksCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Recuperamos el modelo
    JESABook *book = [self.model libraryAtIndex:indexPath.row];
    
    static NSString *cellId = @"libraryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellId];
    }

    cell.textLabel.text = book.title;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:book.imageURL]];
    
    return cell;
}



@end
