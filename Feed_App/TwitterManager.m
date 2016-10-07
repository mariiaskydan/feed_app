//
//  TwitterManager.m
//  Feed_App
//
//  Created by m dychko on 10/6/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import "TwitterManager.h"

@interface TwitterManager ()
@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic, strong) UIViewController *currentController;
@end

@implementation TwitterManager

+ (id)sharedManager {
    static TwitterManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginToTwitterFromViewController:(UIViewController *)viewController {
    
    if (viewController != nil) {
        self.currentController = viewController;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Username"
                                      message:@"Enter Your Twitter name, to see your feed:)"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self loginWithUsername:alert.textFields.lastObject.text];
                                                       
                                                   }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Username";
        }];
        [self.currentController presentViewController:alert animated:YES completion:nil];
    }
    else {
        SLComposeViewController *twitterSignInDialog = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [viewController presentViewController:twitterSignInDialog animated:NO completion:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(loginAgain:)
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    }
}


- (void)loginWithUsername:(NSString *)username {
    
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/home_timeline.json"];
            NSDictionary *params = @{
                                     
                                     @"trim_user" : @"1",
                                     @"count" : @"0"};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
            
            [request setAccount:[twitterAccounts lastObject]];
            
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (responseData) {
                    if (urlResponse.statusCode >= 200 && urlResponse.statusCode <300) {
                        NSError *jsonError;
                        NSArray *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                        
                        if (timelineData) {
                            [self handleContent:timelineData];
                            NSLog(@"Timeline response: %@\n", timelineData);
                        }
                        else {
                            NSLog(@"JSON Error : %@", [jsonError localizedDescription]);
                        }
                    }
                    else {
                        NSLog(@"The response status code is %ld", (long)urlResponse.statusCode);
                    }
                }
            }];
        }
        else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    
    
}

- (void)loginAgain:(id)selector {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self loginToTwitterFromViewController:nil];
}


- (void)handleContent:(NSArray *)content {
    if (content) {
        NSMutableArray <Feed *> *contentArray = [NSMutableArray array];
        for (NSDictionary *item in content) {
            Feed *feed = [[Feed alloc] initFeedWithTitle:item[@"text"] date:[self convertDate:item[@"created_at"]] type:@"Twitter"];
            [contentArray addObject:feed];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(contentLoaded:fromManager:)]) {
            [self.delegate contentLoaded:[contentArray copy] fromManager:ManagerTypeTwitter];
        }
    }
}


- (NSDate *)convertDate:(NSString *)stringDate {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"E MMM dd HH:mm:ss Z yyyy"];
    
    return [dateFormatter dateFromString:stringDate];
}

@end
