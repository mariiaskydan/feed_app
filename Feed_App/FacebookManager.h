//
//  FacebookManager.h
//  Feed_App
//
//  Created by m dychko on 10/5/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ManagerProtocol.h"

@interface FacebookManager : NSObject

@property (nonatomic, weak) id <ManagerProtocol> delegate;

+ (id)sharedManager;

- (void)loginToFacebookFromViewController:(UIViewController *)viewController;
- (void)getNews;

@end
