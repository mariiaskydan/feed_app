//
//  TwitterManager.h
//  Feed_App
//
//  Created by m dychko on 10/6/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "ManagerProtocol.h"

@interface TwitterManager : NSObject

@property (nonatomic, weak) id <ManagerProtocol> delegate;

+ (id)sharedManager;

- (void)loginToTwitterFromViewController:(UIViewController *)viewController;
@end
