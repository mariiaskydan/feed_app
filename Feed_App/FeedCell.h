//
//  FeedCell.h
//  Feed_App
//
//  Created by m dychko on 10/7/16.
//  Copyright © 2016 Mariya Dychko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *socialType;
@property (weak, nonatomic) IBOutlet UILabel *feedText;
@property (weak, nonatomic) IBOutlet UILabel *feedDate;

@end
