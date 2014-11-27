//
//  ViewController.m
//  XMDotProgressView
//
//  Created by xiaoming on 14/11/27.
//  Copyright (c) 2014年 XiaoMing. All rights reserved.
//

#import "ViewController.h"
#import "XMDotProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) XMDotProgressView *progressView;
@property (nonatomic, assign) NSInteger testIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.testIndex = 0;
    XMDotProgressView *progressView = [[XMDotProgressView alloc] initWithFrame:CGRectMake(50, 100, 220, 100)];
    progressView.backgroundColor = [UIColor yellowColor];
    progressView.dotDiameter = 20;
    progressView.seletedCount = 3;
    progressView.dotDiameter = 20;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        XMDotItem *item = [[XMDotItem alloc] init];
        item.dotDescription = [NSString stringWithFormat:@"第%d天",i];
        
        [array addObject:item];
    }
    [self.progressView setupWithDotItem:array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - buttonAction

- (IBAction)handleLeftButtonTapped:(id)sender {
    if (self.testIndex > self.progressView.dotItemArray.count) {
        self.testIndex = 0;
    }
    [self.progressView setSeletedCount:self.testIndex animated:YES];
    self.testIndex ++;
}

- (IBAction)handleRightButtonTapped:(id)sender {
    if (self.testIndex > self.progressView.dotItemArray.count) {
        self.testIndex = 0;
    }
    [self.progressView setSeletedCount:self.testIndex];
    self.testIndex ++;
}


@end
