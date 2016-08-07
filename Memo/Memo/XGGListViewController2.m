//
//  XGGListViewController2.m
//  Memo
//
//  Created by Richard on 16/7/24.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "XGGListViewController2.h"
#import "CoreData/CoreData.h"
#import <Masonry.h>
#import "XGGNoteViewController.h"
#import "XGGPassValueDelegate.h"
#import "XGGListDataSource.h"
#import "XGGListTableViewCell.h"
#import "XGGAppDelegate.h"
#import "Note.h"

@interface XGGListViewController2 () <UITableViewDelegate, UITableViewDataSource ,XGGPassValueDelegate, NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) UITableView * listTableView;
@property(nonatomic, strong) XGGListDataSource *listItems;
@property(nonatomic, strong) NSFetchedResultsController * resultsController;
@property(nonatomic, strong) NSMutableArray * noteList;

@end


@implementation XGGListViewController2

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.title = @"备忘录";

    // init the notelist
    [self fetchNotesListData];

    self.listTableView = [[UITableView alloc]
                      initWithFrame:CGRectZero
                      style:UITableViewStylePlain];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [self.listTableView registerClass:[XGGListTableViewCell class]
           forCellReuseIdentifier:@"XGGListTableViewCell"];
    [self.view addSubview:_listTableView];

    // add ToolBar Button
    UIBarButtonItem *addNoteBarBtn = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"ic_add"]
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(onAddNewNoteAction:)];

    UIBarButtonItem *flexibleBtn = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                    target:nil
                                    action:nil]; // 可拉伸占位按钮

    [self setToolbarItems:@[flexibleBtn, addNoteBarBtn, flexibleBtn]];
    [self.navigationController setToolbarHidden:NO];

    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    // pass value way 1
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onAddNewNoteFromNotification:)
     name:@"AddNewNote"
     object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAddNewNoteAction:(UIBarButtonItem *)sender {
    NSLog(@"onAddNewNoteAction");

    XGGNoteViewController *noteVC = [[XGGNoteViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:noteVC];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)onAddNewNoteFromNotification:(NSNotification *)notification {
    NSDictionary *theData = [notification userInfo];
    NSString *content = [theData objectForKey:@"content"];

    [self addNewNote:content];
    [self.listTableView reloadData];
}

#pragma mark for coredata

- (void)fetchNotesListData {

    NSManagedObjectContext *managedContext =
        ((XGGAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Note"];

    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:true];
    fetchRequest.sortDescriptors = @[descriptor];

    _resultsController = [[NSFetchedResultsController alloc]
                          initWithFetchRequest:fetchRequest
                          managedObjectContext:managedContext
                          sectionNameKeyPath:nil
                          cacheName:nil];
    _resultsController.delegate = self;

    NSError *error;
    if (![_resultsController performFetch:&error]) {
        NSLog(@"performFetch error %@", error);
    }

}

- (void)addNewNote: (NSString *)noteContent {
    NSManagedObjectContext *managedContext = ((XGGAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    /*  // #1
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:managedContext];
     NSManagedObject *note = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
     [note setValue:noteContent forKey:@"content"];
     */
    // #2
    Note *note = (Note *)[NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:managedContext];
    note.content = noteContent;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    note.time = currentDateStr;

    NSError *error;
    if (![managedContext save:&error]) {
        NSLog(@"save context error! %@", error);
    }

    [self.noteList addObject:note];

}

- (void)deleteData {
    NSManagedObjectContext *managedContext = ((XGGAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:managedContext];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];

    NSError *error = nil;
    NSArray *datas = [managedContext executeFetchRequest:request error:&error];
    if (!error && datas && [datas count]) {
        for (NSManagedObject *obj in datas) {  // delete all objects
            [managedContext deleteObject:obj];
        }
        if (![managedContext save:&error]) {
            NSLog(@"save error!");
        }
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected %ld", (long)indexPath.row);
}


// #2 pass value to last viewcontroller
- (void)passValue: (NSDictionary *)info {

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *content = [info objectForKey:@"content"];
        [self addNewNote:content];
        [self.listTableView reloadData];
    });
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_resultsController.sections objectAtIndex:section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _resultsController.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XGGListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XGGListTableViewCell" forIndexPath:indexPath];
    Note *note = [_resultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = (NSString *)[note valueForKey:@"content"];
    cell.dateLabel.text = (NSString *)[note valueForKey:@"time"];
    return cell;
}


#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
//    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

//    UITableView *tableView = self.tableView;
//
//    switch(type) {
//
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray
//                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray
//                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//
//    switch(type) {
//
//        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//
//        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
//    [self.tableView endUpdates];
}

@end
