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
#import "JESASandboxAndUserDefaultUtils.h"

@interface JESALibraryTableViewController ()

@property(nonatomic) int libraryOrder;

@end

@implementation JESALibraryTableViewController

#pragma mark - Init
-(id) initWithModel:(JESALibrary *) model
              style:(UITableViewStyle) style
              order:(int) order{
    
    if (self = [super initWithStyle:style]) {
        _model = model;
        _libraryOrder = order;
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
    
    // Nos damos de alta en la notificación
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatBookDidFavorite:)
                   name:BOOK_DID_FAVORITE_NOTIFICATION_NAME
                 object:nil];
    
}

-(void)dealloc {
    
    // Damos de baja la notificación
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
}


#pragma mark - Notifications
// BOOK_DID_FAVORITE_NOTIFICATION_NAME
-(void)notifyThatBookDidFavorite:(NSNotification *) notification{
    
    // Sacamos el personaje
    NSDictionary *dic = [notification userInfo];
    JESABook *book = [dic objectForKey:FAVORITE_KEY];
    
    if (book.isFavorite == YES) {
        // Añadimos el libro a favoritos
        [self.model addFavoriteBook:book];
    }else{
        // Eliminamos el libro de favoritos
        [self.model deleteFavoriteBook:book];
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - Actions
-(void)orderLibraryAlphabetically{
    self.libraryOrder = LIBRARY_ORDER_ALFABETICALLY;
    
    NSLog(@"Ordenamos alfabéticamente.");
    
    // Guardamos la ordenación de la tabla
    JESASandboxAndUserDefaultUtils *utilSandbox = [JESASandboxAndUserDefaultUtils new];
    NSString *order = [NSString stringWithFormat:@"%d",self.libraryOrder];
    [utilSandbox saveInUserDefaultName:ORDER_LIBRARY value:order];

    
    [self.tableView reloadData];
}

-(void)orderLibraryByTags{
    self.libraryOrder = LIBRARY_ORDER_TAGS;
    
    NSLog(@"Ordenamos por temática.");
    
    // Guardamos la ordenación de la tabla
    JESASandboxAndUserDefaultUtils *utilSandbox = [JESASandboxAndUserDefaultUtils new];
    NSString *order = [NSString stringWithFormat:@"%d",self.libraryOrder];
    [utilSandbox saveInUserDefaultName:ORDER_LIBRARY value:order];

    
    [self.tableView reloadData];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    if(self.libraryOrder == LIBRARY_ORDER_ALFABETICALLY){
        return 2;
    }else{
        return [self.model tagsCount];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (self.libraryOrder == LIBRARY_ORDER_ALFABETICALLY) {
        if (section == SECTION_ALL) {
            return [self.model booksCount];
        }else{
            return [self.model bookCountForTagInt:section];
        }
    }else{
        return [self.model bookCountForTagInt:section];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Recuperamos el modelo
    JESABook *book;
    if (self.libraryOrder == LIBRARY_ORDER_ALFABETICALLY) {
        if (indexPath.section == SECTION_ALL) {
            book = [self.model libraryAtIndex:indexPath.row];
        }else{
            book = [self.model bookForTagPos:indexPath.section atIndex:indexPath.row];
        }
    }else{
        book = [self.model bookForTagPos:indexPath.section atIndex:indexPath.row];
    }
    
    
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
 
    JESABook *book;
    if (self.libraryOrder == LIBRARY_ORDER_ALFABETICALLY) {
        if (indexPath.section == SECTION_ALL) {
            book = [self.model libraryAtIndex:indexPath.row];
        }else{
            book = [self.model bookForTagPos:indexPath.section atIndex:indexPath.row];
        }
    }else{
        book = [self.model bookForTagPos:indexPath.section atIndex:indexPath.row];
    }
    
    // Guardamos el último libro seleccionado
    JESASandboxAndUserDefaultUtils *utilSandbox = [JESASandboxAndUserDefaultUtils new];
    
    NSArray *coord = @[@(indexPath.section),@(indexPath.row),@(self.libraryOrder)];
    [utilSandbox saveInUserDefaultName:LAST_SELECTED_BOOK value:coord];
    
    // mandamos una notificación
    NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:@[book]
                                                          forKeys:@[BOOK_KEY]];
    
    // Creamos la notificación
    NSNotification *note = [NSNotification notificationWithName:BOOK_DID_CHANGE_NOTIFICATION_NAME
                                                         object:self
                                                       userInfo:extraInfo];
    
    // Mandamos la notificación
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
    // Mandamos el mensaje al delegado si lo entiende
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
        [self.delegate libraryTableViewController:self
                                    didSelectBook:book];
    }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.libraryOrder == LIBRARY_ORDER_ALFABETICALLY) {
        if (section == SECTION_FAVOURITE) {
            return [self.model tagNameSection:section];
        }else{
            return @"Todos";
        }
    }else{
        return [self.model tagNameSection:section];
    }
}

#pragma mark - TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JESABookCellView cellHeight];
}

#pragma mark - JESALibraryTableViewControllerDelegate
-(void) libraryTableViewController:(JESALibraryTableViewController *) uVC didSelectBook:(JESABook *) book{
    // Creamos un bookVC
    JESABookViewController *bookVC = [[JESABookViewController alloc] initWithModel:book];
    
    // Hago un push
    [self.navigationController pushViewController:bookVC
                                         animated:YES];
}

@end
