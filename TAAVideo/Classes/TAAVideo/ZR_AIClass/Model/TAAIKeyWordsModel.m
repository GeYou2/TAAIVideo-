//
//  TAAIKeyWordsModel.m
//  TutorABC
//
//  Created by Slark on 2020/5/17.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIKeyWordsModel.h"

@implementation TAAIKeyWordsModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"DDescription":@"description"
             };
    
}

- (NSArray *)keywordExtList {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in _keywordExtList) {
        TAAIKeyWordsModel *model = [TAAIKeyWordsModel mj_objectWithKeyValues:dict];
//        if (model.extDescription == nil ||model.extDescription.length==0) {
//            model.extDescription = model.DDescription;
//        }
        [tempArray addObject:model];
    }
     return tempArray;
}
@end
