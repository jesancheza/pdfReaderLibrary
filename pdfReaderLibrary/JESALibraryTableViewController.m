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
#import "JESABookCellView.h"
#import "JESABookViewController.h"
#import "Settings.h"

@interface JESALibraryTableViewController ()

@end

@implementation JESALibraryTableViewController

#pragma mark - Init
-(id) initWithModel:(JESALibrary *) model
              style:(UITableViewStyle) style{
    
    if (self = [super initWithStyle:style]) {
        _model = model;
        self.title = @"Library";
    }
    return self;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Toolbar
    [self.navigationController setToolbarHidden:NO];
    
    // Creamos botones para el toolbar
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle: @"Order Alfabético"
                                                                   style: UIBarButtonItemStyleDone
                                                                  target: self
                                                                  action: @selector(orderLibraryAlphabetically)];
    
    UIBarButtonItem *buttonNext = [[UIBarButtonItem alloc] initWithTitle:@"Por temas"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(orderLibraryByTags)];
    
    // Botón de espacio
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    
    // Añadimos botones al toolbar
    self.toolbarItems = @[buttonItem, space, buttonNext];
    
    // Registramos en nib
    UINib *cellNib = [UINib nibWithNibName:@"JESABookCellView"
                                    bundle:nil];
    
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:[JESABookCellView cellId]];
}

#pragma mark - Actions
-(void)orderLibraryAlphabetically{
    
}

-(void)orderLibraryByTags{
    
}

#pragma mark - Memory
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
    
    // Creamos una celda
    JESABookCellView *cell = [tableView dequeueReusableCellWithIdentifier:[JESABookCellView cellId]];
    if (cell == nil) {
        // La tenemos que crear nosotros desde cero.
        [tableView registerNib:[UINib nibWithNibName:@"JESABookCellView" bundle:nil]
        forCellReuseIdentifier:[JESABookCellView cellId]];
        cell = [tableView dequeueReusableCellWithIdentifier:[JESABookCellView cellId]];
    }
    
    // Sincronizamos library -> Celda
    cell.title.text = book.title;
    cell.photoView.image = book.photo;
    cell.authors.text = book.authorsList;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    JESABook *book = [self.model libraryAtIndex:indexPath.row];
    
    // Guardamos el último libro seleccionado
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *coord = @[@(indexPath.section),@(indexPath.row)];
    [defaults setObject:coord forKey:LAST_SELECTED_BOOK];
    
    [defaults synchronize];
    
    // Mandamos el mensaje al delegado si lo entiende
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
        [self.delegate libraryTableViewController:self
                                    didSelectBook:book];
    }
}

#pragma mark - TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JESABookCellView cellHeight];
}


@end
