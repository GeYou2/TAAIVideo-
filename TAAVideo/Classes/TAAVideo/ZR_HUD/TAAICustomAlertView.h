//
//  TAAICustomAlertView.h
//  TutorABC
//
//  Created by Slark on 2020/5/8.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIAlertView.h"

typedef void(^TAAIBackAlertViewButtonClick)(NSString *title, NSInteger index);

@interface TAAIBackAlertView : TAAIAlertView

@property (nonatomic, copy) TAAIBackAlertViewButtonClick click;

- (void)showWithButtonTitles:(NSArray*)titles
                headTitle:(NSString*)title
                littleHeadTitle:(NSString*)littleTitle;


@end
