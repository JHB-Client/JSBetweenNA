//
//  ViewController.m
//  JSBridgeAndiOS
//
//  Created by admin on 2020/6/1.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.config
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 25;
    config.preferences.javaScriptCanOpenWindowsAutomatically = true;
    //2.webView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:config];
    //4.Html的加载
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"JSBridge" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlStr baseURL:nil];
    //
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}

#pragma mark -- WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *scheme = [navigationAction.request.URL scheme];
//    NSString *host = [navigationAction.request.URL host];
    NSLog(@"---scheme--:%@", scheme);
//    NSLog(@"---host--:%@", host);
    
    if ([scheme isEqualToString:@"test"]) {
        NSString *urlStr = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
        NSString *passJsonStr = [urlStr substringFromIndex:7];
        
        NSData *jsonData = [passJsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"--sel----:%@", dict[@"sel"]);
        //
        NSString *jsAction = [NSString stringWithFormat:@"%@('%@')", dict[@"sel"], [self convertToJsonData:dict[@"model"]]];
        
        [webView evaluateJavaScript:jsAction completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"-------:%@", error);
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// JSON字符串转化为字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {

    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}

@end
