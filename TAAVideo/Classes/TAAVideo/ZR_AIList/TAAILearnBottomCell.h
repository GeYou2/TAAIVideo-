//
//  TAAILearnBottomCell.h
//  TutorABC
//
//  Created by Slark on 2020/5/15.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TAAILearnListBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TAAILearnBottomCell : BaseTableViewCell
//填充数据
- (void)fetchDataWithModel:(TAAILearnListBannerModel *)model;
@end

NS_ASSUME_NONNULL_END
