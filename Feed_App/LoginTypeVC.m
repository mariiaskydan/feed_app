//
//  LoginTypeVC.m
//  Feed_App
//
//  Created by m dychko on 10/4/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import "LoginTypeVC.h"
#import "LoginTypeCell.h"
#import "FacebookManager.h"
#import "TwitterManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "VkManager.h"
#import "FeedVC.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString *simpleTableIdentifier = @"LoginCell";

@interface LoginTypeVC () <ManagerProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger socialCounter;

@property (nonatomic, assign) BOOL facebookSelected;
@property (nonatomic, assign) BOOL twitterSelected;
@property (nonatomic, assign) BOOL vkSelected;

@property (nonatomic, assign) ManagerType needToLogin;

@property (nonatomic, strong) NSMutableArray<Feed *> *dataSource;

@end

@implementation LoginTypeVC {
    NSArray *loginTypes;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.facebookSelected = NO;
    self.twitterSelected = NO;
    self.vkSelected = NO;
    
    loginTypes = [NSArray arrayWithObjects:@"FaceBook", @"Twitter", @"Vk", nil];
    self.socialCounter = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"LoginTypeCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
    [[VkManager sharedManager] setDelegate:self];
    [[TwitterManager sharedManager] setDelegate:self];
    [[FacebookManager sharedManager]  setDelegate:self];
    
    self.dataSource = [NSMutableArray array];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)feedFromSelectedSocial{
    
    if (self.facebookSelected) {
        [[FacebookManager sharedManager] loginToFacebookFromViewController:self];
        return;
    } else if (self.twitterSelected) {
        [[TwitterManager sharedManager] loginToTwitterFromViewController:self];
        return;
    } else if (self.vkSelected) {
        [[VkManager sharedManager] loginToVkFromViewController:self];
        return;
    } else if (self.dataSource.count > 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       [self performSegueWithIdentifier:@"showFeed" sender:self];
    }
}

- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return loginTypes.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *simpleCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if ([simpleCell isKindOfClass:[LoginTypeCell class]]) {
        LoginTypeCell *cell = (LoginTypeCell *)simpleCell;
        cell.loginTypeName.text = [loginTypes objectAtIndex:indexPath.row];
        cell.checkMarkImg.hidden = YES;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *simpleCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([simpleCell isKindOfClass:[LoginTypeCell class]]) {
        LoginTypeCell *cell = (LoginTypeCell *)simpleCell;
        cell.checkMarkImg.hidden = NO;
        self.socialCounter = self.socialCounter + 1;
        
        if (indexPath.row == 0) {
            self.facebookSelected = [self setSelected:self.facebookSelected cell:cell];
        }else if (indexPath.row == 1){
            self.twitterSelected = [self setSelected:self.twitterSelected cell:cell];
        }else if (indexPath.row == 2){
            self.vkSelected = [self setSelected:self.vkSelected cell:cell];
        }
        
        if (self.socialCounter == 2) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self feedFromSelectedSocial];
            
        }
    }
}

- (BOOL)setSelected:(BOOL)isSelected cell:(LoginTypeCell *)cell {
    if (isSelected) {
        self.socialCounter -= 2;
        cell.checkMarkImg.hidden = YES;
    }
    return !isSelected;
}

#pragma mark - ManagerProtocol

- (void)contentLoaded:(NSArray *)content fromManager:(ManagerType)managerType {
    if (managerType == ManagerTypeVK) {
        self.vkSelected = NO;
    } else if (managerType == ManagerTypeTwitter) {
        self.twitterSelected = NO;
    } else if (managerType == ManagerTypeFacebook){
        self.facebookSelected = NO;
    }
    [self.dataSource addObjectsFromArray:content];
    [self feedFromSelectedSocial];

}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showFeed"]) {
        FeedVC *destanitionController = [segue destinationViewController];
        destanitionController.tableDataSource = self.dataSource;
    }

}
@end
