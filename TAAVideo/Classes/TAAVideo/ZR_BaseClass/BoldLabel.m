//
//  BoldLabel.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/6.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "BoldLabel.h"

@implementation BoldLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = TextColor;
        self.font = [UIFont boldSystemFontOfSize:22];
       
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = TextColor;
        self.font = NormalFont;
    }
    return self;
}
@end
