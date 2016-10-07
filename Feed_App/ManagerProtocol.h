//
//  ManagerProtocol.h
//  Feed_App
//
//  Created by m dychko on 10/7/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//
#import "Feed.h"

typedef NS_ENUM(NSUInteger, ManagerType) {
    ManagerTypeNone,
    ManagerTypeFacebook,
    ManagerTypeVK,
    ManagerTypeTwitter
};

@protocol ManagerProtocol <NSObject>

- (void)contentLoaded:(NSArray<Feed *> *)content fromManager:(ManagerType) managerType;
@end
