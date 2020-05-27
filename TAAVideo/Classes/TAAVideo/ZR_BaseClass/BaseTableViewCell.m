//
//  BaseTableViewCell.m
//  Abroad-agent
//
//  Created by Slark on 17/5/15.
//  Copyright © 2017年 Slark. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

/**
 *  快速创建一个不是从xib中加载的tableview cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView{
        if (tableView == nil) {
            return [[self alloc] init];
        }
        NSString *classname = NSStringFromClass([self class]);
        NSString *identifier = [classname stringByAppendingString:@"CellID"];
        [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
        return [tableView dequeueReusableCellWithIdentifier:identifier];
}

+ (instancetype)nibCellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"nibCellID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}
@end
