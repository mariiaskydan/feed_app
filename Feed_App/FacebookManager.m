//
//  FacebookManager.m
//  Feed_App
//
//  Created by m dychko on 10/5/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import "FacebookManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FacebookManager ()

@property (strong, nonatomic) FBSDKLoginManager *loginManager;
@property (strong, nonatomic) NSArray *readPermissions;
@end

@implementation FacebookManager

+ (id)sharedManager {
    static FacebookManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _loginManager =  [FBSDKLoginManager new];
        _readPermissions = [NSArray arrayWithObjects:@"public_profile", @"email", @"user_friends",@"user_posts", nil];
    }
    return self;
}

- (void)loginToFacebookFromViewController:(UIViewController *)viewController {

    if ([FBSDKAccessToken currentAccessToken]) {
        [self getNews];
    } else {
        self.loginManager = [FBSDKLoginManager new];
        [self.loginManager logInWithReadPermissions:self.readPermissions fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (!error) {
                [FBSDKAccessToken setCurrentAccessToken:result.token];
                [self getNews];
            }
        }];
    }
}

- (void)getNews {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/feed"
                                  parameters:nil
                                  HTTPMethod:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        [self handleContent:result];
    }];
}

- (void)handleContent:(NSDictionary *)content {
    if (content[@"data"]) {
        NSMutableArray <Feed *> *contentArray = [NSMutableArray array];
        for (NSDictionary *item in content[@"data"]) {
            Feed *feed = [[Feed alloc] initFeedWithTitle:item[@"message"] ? item[@"message"] : item[@"story"] date:[self convertDate:item[@"created_time"]] type:@"Facebook"];
            [contentArray addObject:feed];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(contentLoaded:fromManager:)]) {
            [self.delegate contentLoaded:[contentArray copy] fromManager:ManagerTypeFacebook];
        }
    }
}


- (NSDate *)convertDate:(NSString *)stringDate {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    return [dateFormatter dateFromString:stringDate];
}

@end
