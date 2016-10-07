//
//  VkManager.m
//  Feed_App
//
//  Created by m dychko on 10/6/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import "VkManager.h"
#import "VKSdk.h" 

@interface VkManager () <VKSdkDelegate, VKSdkUIDelegate>
@property (strong, nonatomic) VKSdk *vkSdk;
@property (weak, nonatomic) UIViewController *controllerToPresent;
@end

@implementation VkManager

+ (id)sharedManager {
    static VkManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(instancetype)init{
    if (self = [super init]) {
        _vkSdk = [VKSdk initializeWithAppId:@"5657771"];
        [_vkSdk registerDelegate:self];
        [_vkSdk setUiDelegate:self];
    }
    return self;
}

- (void)loginToVkFromViewController:(UIViewController *)viewController {
    self.controllerToPresent = viewController;
    NSArray *permissions = @[VK_PER_WALL,VK_PER_FRIENDS,VK_PER_OFFLINE];
    [VKSdk wakeUpSession:permissions completeBlock:^(VKAuthorizationState state, NSError *error) {
        switch (state) {
            case VKAuthorizationAuthorized:
                [self getNews];
                break;
                
            case VKAuthorizationInitialized:
                [VKSdk authorize:permissions];
                break;
                
            default:
                // Probably, network error occured, try call +[VKSdk wakeUpSession:completeBlock:] later
                break;
        }
    }];
}

- (void)getNews {
    VKRequest *request = [VKRequest requestWithMethod:@"newsfeed.get" parameters:
                          @{@"filters"          : @[@"post",@"friend"],
                            @"return_banned"    : @"0",
                            @"count"            : @"100"}];
    [request executeWithResultBlock:^(VKResponse *response) {
        [self handleContent:response.json[@"items"]];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - VKSdkDelegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.state == VKAuthorizationAuthorized) {
        [self getNews];
    }
}

- (void)vkSdkUserAuthorizationFailed {

}

#pragma mark - VKSdkUIDelegate

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {

    if (self.controllerToPresent) {
        [self.controllerToPresent presentViewController:controller animated:YES completion:nil];
    }
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    
}

- (void)handleContent:(NSArray *)content {
    if (content) {
        NSMutableArray <Feed *> *contentArray = [NSMutableArray array];
        for (NSDictionary *item in content) {
            Feed *feed = [[Feed alloc] initFeedWithTitle:item[@"text"] date:[self convertDate:item[@"date"]] type:@"VK"];
            [contentArray addObject:feed];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(contentLoaded:fromManager:)]) {
            [self.delegate contentLoaded:[contentArray copy] fromManager:ManagerTypeVK];
        }
    }
}


- (NSDate *)convertDate:(NSString *)stringDate {
    
    return [NSDate dateWithTimeIntervalSince1970:[stringDate longLongValue]];
}
@end
