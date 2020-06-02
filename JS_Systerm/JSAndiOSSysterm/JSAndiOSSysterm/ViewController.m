//
//  ViewController.m
//  JSAndiOSSysterm
//
//  Created by admin on 2020/6/2.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()
//<WKScriptMessageHandler, WKUIDelegate>
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
//    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    //4.Html的加载
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"JSAndNASysterm" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlStr baseURL:nil];
}


@end
