//
//  ViewController.m
//  JSAndiOS
//
//  Created by admin on 2020/5/28.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<WKScriptMessageHandler, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    [self setWKWebView];
}



- (void)setWKWebView {
    //1.引入<WebKit/WebKit.h>
    //2.config
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 25;
    config.preferences.javaScriptCanOpenWindowsAutomatically = true;
    //3.webView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:config];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    //4.Html的加载
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"JSAndNA" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlStr baseURL:nil];
}


#pragma mark -- WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"noParamsFunction"]) {
        NSLog(@"--noParamsFunction--message.body:---%@", message.body);
    } else if([message.name isEqualToString:@"haveParamsFunction"]) {
        NSLog(@"--haveParamsFunction--message.body:---%@", message.body);
    } else if([message.name isEqualToString:@"showAlert"]) {
        NSLog(@"--showAlert--message.body:---%@", message.body);
        [self alert:@"OC调用JS:alert"];
    } else if([message.name isEqualToString:@"postString"]) {
        NSLog(@"--postString--message.body:---%@", message.body);
    } else if([message.name isEqualToString:@"postArray"]) {
        NSLog(@"--postArray--message.body:---%@", message.body);
    } else if([message.name isEqualToString:@"postDictionary"]) {
        NSLog(@"--postDictionary--message.body:---%@", message.body);
    }
    
}


#pragma mark -- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertCrontroller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertCrontroller addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertCrontroller animated:YES completion:nil];
}


- (void)alert:(NSString *)str {
    NSString *jsActionAction = [NSString stringWithFormat:@"alertWithStr('%@')", str];
    [self.webView evaluateJavaScript:jsActionAction completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"---OC调用JS的error---:%@", error);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"noParamsFunction"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"haveParamsFunction"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"showAlert"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"postString"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"postArray"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"postDictionary"];
}

- (void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"noParamsFunction"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"haveParamsFunction"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"showAlert"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"postString"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"postArray"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"postDictionary"];
}

