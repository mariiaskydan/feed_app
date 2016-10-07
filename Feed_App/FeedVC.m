//
//  FeedVC.m
//  Feed_App
//
//  Created by m dychko on 10/7/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import "FeedVC.h"
#import "FeedCell.h"

static NSString *simpleTableIdentifier = @"feedCell";

@interface FeedVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation FeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    self.tableDataSource = [self.tableDataSource sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *simpleCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if ([simpleCell isKindOfClass:[FeedCell class]]) {
        FeedCell *cell = (FeedCell *)simpleCell;
        Feed *feed = [self.tableDataSource objectAtIndex:indexPath.row];
        cell.feedText.text = feed.title;
        NSString *feedDate = [NSString stringWithFormat:@"%@", feed.date];
        cell.feedDate.text = [feedDate substringToIndex:[feedDate length] - 5];
        cell.socialType.text = feed.type;
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}
/*
#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
