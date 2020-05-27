//
//  TAAILearnListCell.h
//  TutorABC
//
//  Created by Slark on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TAAILearnListModel.h"

@interface TAAILearnListCell : BaseTableViewCell

- (void)loadDataFromModel:(TAAILearnListModel*)model;

@end

