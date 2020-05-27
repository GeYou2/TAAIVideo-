//
//  TAAILearnListModel.m
//  TutorABC
//
//  Created by Slark on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAILearnListModel.h"

@implementation TAAILearnListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"DDescription":@"description"
             };
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@::%@",key,value);
    if ([key isEqualToString:@"description"]) {
        self.DDescription = (NSString*)value;
    }
}

- (NSString *)level {
    NSArray *levelarr = [_level componentsSeparatedByString:@"-"];
    if (levelarr.count == 2) {
        if ([levelarr[0] isEqual:levelarr[1]]) {
            _level = levelarr[0];
        }
    }
    return _level;
}
@end
