//
//  VkManager.h
//  Feed_App
//
//  Created by m dychko on 10/6/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerProtocol.h"

@interface VkManager :NSObject
@property (nonatomic, weak) id <ManagerProtocol> delegate;

+ (id)sharedManager;

- (void)loginToVkFromViewController:(UIViewController *)viewController ;
@end
