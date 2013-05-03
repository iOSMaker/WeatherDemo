//
//  DataCenter.m
//  weather
//
//  Created by word on 13-4-8.
//  Copyright (c) 2013年 com. a. All rights reserved.
//

#import "DataCenter.h"

static DataCenter *_sharedDataCenter = nil;

@implementation DataCenter

// 默认数据中心
+ (DataCenter *)defaultCenter
{
    if (_sharedDataCenter == nil)
        _sharedDataCenter = [[DataCenter alloc] init];
    
    return _sharedDataCenter;
}

- (id)init
{
    [super init];
    
    return self;
}


- (void)downloadWeatherInfoWithCity:(NSString *)cityID withRealtime:(NSString *)realtime{
    NSString *urlStr = [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",cityID];
    
    if ([self weatherWith:urlStr]) {
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        NSMutableDictionary *realtimeInfoDict = [NSMutableDictionary dictionaryWithDictionary:[parser objectWithString:[self weatherWith:urlStr]]];
        [realtimeInfoDict setObject:realtime forKey:@"realtime"];
        
        NSString *path = [NSString stringWithFormat:@"%@/Documents/%@_weather_realtime.plist",NSHomeDirectory(),cityID];
        [realtimeInfoDict writeToFile:path atomically:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeatherInfoFinish" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeatherInfoError" object:nil];
    }
}

- (NSString *)weatherWith:(NSString *)urlStr{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request startSynchronous];
    
    NSString *response;
    if (ASIHTTP_SUCCESS(request)) {
        response = [request responseString];
    }
    return response;
}

- (NSDictionary *)realtimeWeatherWithCity:(NSString *)cityID{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@_weather_realtime.plist",NSHomeDirectory(), cityID];
    NSDictionary *realtimeInfodict = [NSDictionary dictionaryWithContentsOfFile:path];
    return realtimeInfodict;
}

@end
