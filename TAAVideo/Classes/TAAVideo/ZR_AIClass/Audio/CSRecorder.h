//
//  CSRecorder.h
//  hellostream
//
//  Created by 陈松 on 2019/10/9.
//

#import <Foundation/Foundation.h>


@interface CSRecorder : NSObject

//struct airecorder;

// 录音回调
typedef int (CSRecorder_callback)(const void * usrdata, const void * data, int size);

/*
 * 创建一个新的录音机
 */
struct airecorder * airecorder_new(void);

/*
 * 删除已有的录音机对象
 */
int airecorder_delete(struct airecorder * recorder);

/*
 * 开始录音
 */
int airecorder_start(struct airecorder * recorder, const char* wav_path,
                     CSRecorder_callback callback, const void * usrdata, int callback_interval);

/*
 * 停止录音
 */
int airecorder_stop(struct airecorder *recorder);


@end
