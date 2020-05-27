//
//  TAAILearnBottomCell.m
//  TutorABC
//
//  Created by Slark on 2020/5/15.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAILearnBottomCell.h"

@interface TAAILearnBottomCell()

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation TAAILearnBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.coverImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
}

- (void)fetchDataWithModel:(TAAILearnListBannerModel *)model {
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.bannerImage]];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
