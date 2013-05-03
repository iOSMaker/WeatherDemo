//
//  DataCenter.h
//  weather
//
//  Created by word on 13-4-8.
//  Copyright (c) 2013年 com. a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest/ASIHTTPRequest.h"
#import "JSON.h"

// HTTP返回成功
#define HTTP_SUCCESS(status_code) (status_code >= 200 && status_code < 300)
// ASIHTTP成功
#define ASIHTTP_SUCCESS(request) ( HTTP_SUCCESS(request.responseStatusCode) && request.responseData != nil )
// ASIHTTP失败
#define ASIHTTP_ERROR(request) !ASIHTTP_SUCCESS(request)

@interface DataCenter : NSObject

// 默认数据中心
+ (DataCenter *)defaultCenter;

// 下载天气信息
- (void)downloadWeatherInfoWithCity:(NSString *)cityID withRealtime:(NSString *)realtime;

- (NSDictionary *)realtimeWeatherWithCity:(NSString *)cityID;

@end
