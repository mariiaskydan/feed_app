//
//  FeedVC.h
//  Feed_App
//
//  Created by m dychko on 10/7/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface FeedVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray<Feed *> *tableDataSource;

@end
