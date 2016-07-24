//
//  ListViewController.m
//  Memo
//
//  Created by Richard on 16/7/14.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "XGGListViewController.h"
#import <Masonry.h>
#import "XGGListDataSource.h"
#import "XGGListTableViewCell.h"
#import "XGGNoteViewController.h"
#import "XGGAppDelegate.h"
#import "Note.h"
#import "XGGPassValueDelegate.h"

@interface XGGListViewController () <UITableViewDelegate, XGGPassValueDelegate>

@property(nonatomic, strong) UITableView *listTableView;
@property(nonatomic, strong) XGGListDataSource *listItems;
@property(nonatomic, strong) NSMutableArray *noteList;

@end

@implementation XGGListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.title = @"备忘录";

    // init the notelist
    [self fetchNotesListData];

    // UITableView
    TableViewCellConfigureBlock configureCell = ^(XGGListTableViewCell *cell, NSManagedObject *item) {
        cell.titleLabel.text = (NSString *)[item valueForKey:@"content"];
        cell.dateLabel.text = (NSString *)[item valueForKey:@"time"];
    };
    self.listItems = [[XGGListDataSource alloc]
                                    initWithItems:self.noteList
                                    cellIdentifer:@"XGGListTableViewCell"
                                    configureCellBlock:configureCell];

    _listTableView = [[UITableView alloc]
                      initWithFrame:CGRectZero
                      style:UITableViewStylePlain];
    _listTableView.dataSource = self.listItems;
    _listTableView.delegate = self;
    [_listTableView registerClass:[XGGListTableViewCell class]
           forCellReuseIdentifier:@"XGGListTableViewCell"];
    [self.view addSubview:_listTableView];

    // add ToolBar Button
    UIBarButtonItem *addNoteBarBtn = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"ic_add"]
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(onAddNewNoteAction:)];
/*  // 固定宽度占位按钮
    UIBarButtonItem *fixedBtn = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                 target:nil 
                                 action:nil];
    fixedBtn.width = 50;
*/
    UIBarButtonItem *flexibleBtn = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                    target:nil
                                    action:nil]; // 可拉伸占位按钮

    [self setToolbarItems:@[flexibleBtn, addNoteBarBtn, flexibleBtn]];
//    self.navigationItem.rightBarButtonItem = addNoteBarBtn;
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

- (void)onAddNewNoteAction: (UIBarButtonItem *)sender {
    NSLog(@"onAddNewNoteAction");

    XGGNoteViewController *noteVC = [[XGGNoteViewController alloc] init];
    noteVC.delegate = self;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:noteVC];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)onAddNewNoteFromNotification: (NSNotification *)notification {
    NSDictionary *theData = [notification userInfo];
    NSString *content = [theData objectForKey:@"content"];

    [self addNewNote:content];
    [self.listTableView reloadData];
}

#pragma mark for coredata

- (void)fetchNotesListData {
    NSLog(@"fetchNotesListData");
    NSManagedObjectContext *managedContext =
        ((XGGAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Note"];

    NSError *error;
    NSArray *fetchedResults = [managedContext executeFetchRequest:fetchRequest error:&error];

    if (fetchedResults != nil) {
        self.noteList = [[NSMutableArray alloc] initWithArray:fetchedResults];
    } else {
        NSLog(@"fetch Notes error: %@", error);
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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

//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *content = [info objectForKey:@"content"];
//        [self addNewNote:content];
//        [self.listTableView reloadData];
//    });
}

@end
