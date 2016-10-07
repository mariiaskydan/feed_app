//
//  Feed.m
//  Feed_App
//
//  Created by m dychko on 10/7/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (instancetype)initFeedWithTitle:(NSString *)title date:(NSDate *)date type:(NSString *)type {
    if (self = [super init]) {
        _title = title;
        _date = date;
        _type = type;
    }
    return self;
}


@end
