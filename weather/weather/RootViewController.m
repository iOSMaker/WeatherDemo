//
//  RootViewController.m
//  weather
//
//  Created by word on 13-4-8.
//  Copyright (c) 2013年 com. a. All rights reserved.
//

#import "RootViewController.h"
#import "ASIHTTPRequest/ASIHTTPRequest.h"
#import "JSON/JSON.h"
#import "DataCenter.h"

@interface RootViewController ()

@property (nonatomic, retain) UIScrollView *myScrollView;
@property (nonatomic, retain) UILabel *realTimeLabel;
@property (nonatomic, retain) UIView *cityView;
@property (nonatomic, retain) UILabel *cityLabel;
@property (nonatomic, retain) UILabel *weatherLabel;
@property (nonatomic, retain) UILabel *tempLabel;
@property (nonatomic, retain) UILabel *windLabel;
@property (nonatomic, retain) UILabel *infoLabel;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_myScrollView release];
    [_realTimeLabel release];
    [_cityView release];
    [_cityLabel release];
    [_weatherLabel release];
    [_tempLabel release];
    [_windLabel release];
    [_infoLabel release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:@"天气通"];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
//    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [activity setCenter:CGPointMake(100, 150)];
//    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [self.view addSubview:activity];
//    [activity release];
//    [activity startAnimating];
//    
//    [self performSelector:@selector(begainDownloadInfo) withObject:nil afterDelay:5];
       
    [self begainDownloadInfo];
}

- (void)begainDownloadInfo{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherInfoDidFinish:) name:@"WeatherInfoFinish" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherInfoError:) name:@"WeatherInfoError" object:nil];
    
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *realTime = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",realTime);

    
    [[DataCenter defaultCenter] downloadWeatherInfoWithCity:beijing withRealtime:realTime];
    [[DataCenter defaultCenter] downloadWeatherInfoWithCity:shanghai withRealtime:realTime];
    [[DataCenter defaultCenter] downloadWeatherInfoWithCity:guangzhou withRealtime:realTime];
    [[DataCenter defaultCenter] downloadWeatherInfoWithCity:shengzhen withRealtime:realTime];
}

- (void)viewLoaded{
        
    self.realTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 250, 30)];
    [self.realTimeLabel setBackgroundColor:[UIColor clearColor]];
    [self.realTimeLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [self.realTimeLabel setTextColor:[UIColor redColor]];
    [self.realTimeLabel setTextAlignment:UITextAlignmentRight];
    [self.view addSubview:self.realTimeLabel];
    [self.realTimeLabel release];
    
    CGSize size = CGSizeMake(320, 1200);
    self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, 320, 400)];
    [self.myScrollView setContentSize:size];
    [self.myScrollView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.myScrollView];
    [self.myScrollView release];
    
    [self loadCityViewWithCity:beijing withFrame:CGRectMake(0, 0, 320, 300)];
    [self loadCityViewWithCity:shanghai withFrame:CGRectMake(0,300, 320, 300)];
    [self loadCityViewWithCity:guangzhou withFrame:CGRectMake(0, 600, 320, 300)];
    [self loadCityViewWithCity:shengzhen withFrame:CGRectMake(0, 900, 320, 300)];
}

- (void)loadCityViewWithCity:(NSString *)cityID withFrame:(CGRect)frame{
    
    NSMutableDictionary *cityWeatherDict = [[[DataCenter defaultCenter] realtimeWeatherWithCity:cityID] objectForKey:@"weatherinfo"];
    
    self.cityView = [[UIView alloc] initWithFrame:frame];
    [self.cityView setBackgroundColor:[UIColor orangeColor]];
    [self.myScrollView addSubview:self.cityView];
    
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.cityLabel setBackgroundColor:[UIColor blueColor]];
    [self.cityView addSubview:self.cityLabel];

    self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 30)];
    [self.weatherLabel setBackgroundColor:[UIColor clearColor]];
    [self.weatherLabel setTextAlignment:UITextAlignmentCenter];
    [self.cityView addSubview:self.weatherLabel];
    
    self.tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, 100, 30)];
    [self.tempLabel setBackgroundColor:[UIColor clearColor]];
    [self.tempLabel setTextAlignment:UITextAlignmentCenter];
    [self.cityView addSubview:self.tempLabel];
    
    self.windLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 320, 30)];
    [self.windLabel setBackgroundColor:[UIColor clearColor]];
    [self.windLabel setTextAlignment:UITextAlignmentCenter];
    [self.cityView addSubview:self.windLabel];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 320, 150)];
    [self.infoLabel setBackgroundColor:[UIColor clearColor]];
    [self.infoLabel setLineBreakMode:UILineBreakModeWordWrap];
    [self.infoLabel setNumberOfLines:0];
    [self.cityView addSubview:self.infoLabel];
    
    NSString *temp1 = [cityWeatherDict objectForKey:@"temp1"];
    NSString *temp2 = [cityWeatherDict objectForKey:@"temp2"];
    
    NSString *minTemp1 = [[temp1 componentsSeparatedByString:@"~"] objectAtIndex:1];
    NSString *maxTemp2 = [[temp2 componentsSeparatedByString:@"~"] objectAtIndex:0];
    NSString *weather1 = [cityWeatherDict objectForKey:@"weather1"];
    
    NSString *infoStr = [NSString stringWithFormat:@"       今天%@，最低气温%@，明天白天%@，最高气温%@，出行%@市气象局%@时发布",
                         [cityWeatherDict objectForKey:@"weather1"],
                         minTemp1,
                         [cityWeatherDict objectForKey:@"weather2"],
                         maxTemp2,
                         [cityWeatherDict objectForKey:@"index_d"],
                         [cityWeatherDict objectForKey:@"fchh"]];
    
    [self.cityLabel setText:[cityWeatherDict objectForKey:@"city"]];
    [self.weatherLabel setText:weather1];
    [self.tempLabel setText:temp1];
    [self.windLabel setText:[cityWeatherDict objectForKey:@"wind1"]];
    [self.infoLabel setText:infoStr];
    
    [self.realTimeLabel setText:[NSString stringWithFormat:@"更新时间：%@",[[[DataCenter defaultCenter] realtimeWeatherWithCity:cityID] objectForKey:@"realtime"]]];
    
    for (int i = 0; i < weather1.length; i ++) {
        NSString *temp = [weather1 substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@"晴"]) {
            [self.cityView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"晴.png"]]];
        }else if([temp isEqualToString:@"阴"]){
            [self.cityView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"阴.png"]]];
        }else if([temp isEqualToString:@"雨"]){
            [self.cityView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"雨.png"]]];
        }else if (![temp isEqualToString:@"晴"] && ![temp isEqualToString:@"阴"] && ![temp isEqualToString:@"雨"]){
            [self.cityView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"晴.png"]]];
        }
    }

    
    [self.cityView release];
    [self.cityLabel release];
    [self.weatherLabel release];
    [self.tempLabel release];
    [self.windLabel release];
    [self.infoLabel release];
}

// 天气信息下载完成
- (void)weatherInfoDidFinish:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self viewLoaded];
}

// 天气信息下载失败
- (void)weatherInfoError:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络错误，用上一次数据" delegate:self cancelButtonTitle:@"好" otherButtonTitles:@"不，重试", nil];
    
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self viewLoaded];
    }else{
        [self begainDownloadInfo];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
