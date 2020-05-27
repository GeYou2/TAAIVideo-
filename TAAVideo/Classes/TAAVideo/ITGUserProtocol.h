//
//  ITGUserProtocol.h
//  ITGInterface
//
//  Created by dennis on 2018/8/24.
//  Copyright © 2018年 iTutorGroup. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ITGUserDidLoginNotification         @"ITGUserDidLoginNotification"
#define ITGUserDidLoginFailedNotification   @"ITGUserDidLoginFailedNotification"
#define ITGUserFromPageKey                  @"ITGUserFromPageKey"   // 标识登录路由来源，添加到Notification中
#define ITGUserDidLogoutNotification        @"ITGUserDidLogoutNotification"
#define ITGUserDidUpdateNotification        @"ITGUserDidUpdateNotification"
#define ITGUserDidLogoutReasonKey           @"ITGUserDidLogoutReasonKey" // value of ITGUserDidLogoutReason
#define ITGUserCancelLoginNotification      @"ITGUserCancelLoginNotification"
#define ITGUserModifyNotification           @"ITGUserModifyNotification"
#define ITGUserDidLoginAnimationEndNotification       @"ITGUserDidLoginAnimationEndNotification"//用来标识登录成功之后，页面动画结束之后的会调

typedef NS_ENUM(NSInteger, ITGUserStatus) {
    ITGUserStatusUnknow         = 0,
    ITGUserStatusInService      = 1,        //在期用户
    ITGUserStatusExpireService  = 2,        //过期用户
    ITGUserStatusNoService      = 3,        //仅注册用户(无合约)
    ITGUserStatusTourist        = 4,        //游客
    ITGUserStatusFutureService  = 5,        //有未来合约的用户
};

typedef NS_ENUM(NSInteger, ITGUserDidLogoutReason) {
    ITGUserDidLogoutReasonUnknown       = 0, // 未知原因
    ITGUserDidLogoutReasonUserLogout    = 1, // 用户主动退出
    ITGUserDidLogoutReasonTokenInvalid  = 2, // 用户 token 失效
};

@protocol ITGUserProtocol <NSObject>

// MARK: User Info
/**
 *  @brief 获取会员账号
 */
- (nullable NSString *)account;

/**
 *  @brief 获取会员中文名称
 */
- (nullable NSString *)chineseName;

/**
 *  @brief 获取会员英文名称
 */
- (nullable NSString *)englishName;

/**
 *  @brief 获取会员品牌ID
 */
- (NSInteger)getBrandId;

/**
 *  @brief 获取mobcommon token
 */
- (nullable NSString *)getToken;

/**
 *  @brief 获取会员编号
 */
- (nullable NSString *)getClientSn;

/**
 *  @brief 获取加密会员编号
 */
- (nullable NSString *)encryptedClientSn;

/**
 *  @brief 获取会员状态
 */
- (ITGUserStatus)clientStatus;

/**
 *  @brief 用户头像URLString
 */
- (nullable NSString *)userIconURLString;

/**
 *  @brief 获取leadSn(暂不清楚这个是做什么的)
 */
- (nullable NSString *)leadSn;

/**
 *  @brief 获取createdAt生成会员账号时间
 */
- (nullable NSString *)createdAt;

/**
 *  @brief 是否为在期用户(status == inservice || future)
 */
- (BOOL)isInservice;

/**
 *  @brief 获取会员标识
 */
- (NSInteger)identity;

/**
 *  @brief 英语等级
 */
- (NSInteger)englishLevel;

/**
 *  @brief 数学等级
 */
- (NSInteger)mathLevel;

/**
 监护人 client SN，用户旁听
 
 @return 监护人 client SN
 */
- (nullable NSString *)guardianClientSN;

/**
 * @brief 用户信息简介
 */
- (NSString *)userDescription;

/**
 * @brief 年龄
 */
- (NSInteger)age;

/**
 * @brief 生日
 */
- (NSTimeInterval)birthday;

/**
 * @brief 性别
 */
- (NSInteger)gender;

/**
 * @brief JR 星旅程
 */
- (NSInteger)stars;

/**
 * @brief 我关注的顾问数量
 */
- (NSInteger)followingConsultants;

/**
 * @brief 总出席数
 */
- (NSInteger)totalAttendances;

/**
 * @brief 总上课时长(分钟)
 */
- (double)totalClassMins;

/**
 * @brief 平均分
 */
- (double)averageScores;

/**
 * @brief 总开口时长
 */
- (double)totalSpeakingDuration;

/**
 * @brief 加入天數(首份合約至今的日期)
 */
- (NSInteger)joinDays;

/**
 * @brief 用户是否有 Demo 课历史
 */
- (BOOL)hasDemoHistory;

/**
 * @brief 成人积分商城积分数
 */
- (NSInteger)mallPoint;

/**
 * @brief 语文年级，未设置是为 0，设置的范围 [1, 6]
 */
- (NSInteger)chineseGrade;

// MARK: DCGS and Level Testing
/**
 *  @brief 是否完成英语程度分析测试
 */
- (BOOL)englishLevelTestComplete;

/**
 *  @brief 是否完成英语DCGS测试
 */
- (BOOL)englishDcgsTestComplete;

/**
 *  @brief 是否完成语文程度分析测试
 */
- (BOOL)chineseLevelTestComplete;

/**
 *  @brief 是否完成语文DCGS测试
 */
- (BOOL)chineseDcgsTestComplete;

/**
 *  @brief 是否完成数学程度分析测试
 */
- (BOOL)mathLevelTestComplete;

/**
 *  @brief 是否完成数学DCGS测试
 */
- (BOOL)mathDcgsTestComplete;

// MARK: Contracts
/**
 *  @brief 是否有数学合约
 */
- (BOOL)isMathContract;

/**
 *  @brief 是否有语文合约
 */
- (BOOL)isChineseContract;

/**
 *  @brief 是否有英语合约
 */
- (BOOL)isEnglishContract;

/**
 *  @brief 是否有牛津合约，包括牛津 Plus 合约和牛津 Pro 合约
 */
- (BOOL)isOxfordContract;

/**
 *  @brief 是否有普通牛津合约
 */
- (BOOL)isOxfordNormalContract;

/**
 *  @brief 是否有牛津 Pro 合约
 */
- (BOOL)isOxfordProContract;

/**
 *  @brief 是否有牛津 Plus 合约
 */
- (BOOL)isOxfordPlusContract;

/**
 *  @brief 是否有泛型英语合约，包活牛津 Plus 合约、牛津 Pro 合约和普通英语合约
 */
- (BOOL)isGenericEnglishContract;

// MARK: User Action
/**
 *  @brief 用户登录,弹出loginModule
 */
- (void)login;

/**
 *  @brief 用户登出,清除用户信息,模块间发送登出信号,非模块发送登出通知
 */
- (void)logout;

/**
 *  @brief 注销账户
 */
- (void)deleteAccount;

/**
 * @brief 账户安全
 */
- (void)security;

/**
 *  @brief 绑定家长关系，爸爸、妈妈或者其他监护人
 */
- (void)bindGuardianWithCompletion:(nullable void(^)(BOOL isSuccess))completion;

/**
 *  @brief 判断用户是否已登录
 */
- (BOOL)isLogin;

/**
 *  @brief 更新用户信息,模块间发送登出信号,非模块发送登出通知
 */
- (void)updateCompletion:(void(^)(NSError * _Nullable error))completion;

/**
 *  @brief push注册页
 */
- (void)showRegister;

/**
 *  @brief 如果已登录执行access()函数,否则打开usermodule登录页
 *
 *  TODO: 登陆成功执行access()的步骤待以后需要此需求再加,暂时没有此逻辑
 */
- (void)loginAuthentication:(void(^)(void))access;

/**
*  @brief 主动设置登录注册 fromWhere
*/
- (void)setFromWhere:(NSString *)fromWhere;

// MARK: Deprecated
/**
 *  @brief 在3.0之前采用BBMUser作为存储源,3.0之后采用ITG存储,
 *         此方法仅为3.0前后版本模型衔接判断方法,避免版本过度引起用户重新登录
 */
- (BOOL)hasBBMOrITGUserCaches __attribute__((deprecated("History")));

@end

NS_ASSUME_NONNULL_END
