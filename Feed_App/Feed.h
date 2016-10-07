//
//  Feed.h
//  Feed_App
//
//  Created by m dychko on 10/7/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject
@property (strong, readonly) NSString *title;
@property (strong, readonly) NSDate *date;
@property (strong, readonly) NSString *type;

- (instancetype)initFeedWithTitle:(NSString *)title date:(NSDate *)date type:(NSString *)type;
@end
