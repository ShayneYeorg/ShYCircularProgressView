//
//  ViewController.m
//  ShYCircularProgressView
//
//  Created by 杨淳引 on 16/10/8.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "ViewController.h"
#import "ShYCircularProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) ShYCircularProgressView *circularProgressView1; //静态
@property (nonatomic, strong) ShYCircularProgressView *circularProgressView2; //动态
@property (nonatomic, strong) UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化的时候height可以传0，控件会根据width计算height
    self.circularProgressView1 = [[ShYCircularProgressView alloc]initWithFrame:CGRectMake(50, 50, 100, 0)];
    [self.view addSubview:self.circularProgressView1];
    
    self.circularProgressView2 = [[ShYCircularProgressView alloc]initWithFrame:CGRectMake(50, 150, 150, 0)];
    [self.view addSubview:self.circularProgressView2];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(50, 300, 230, 20)];
    [self.view addSubview:self.slider];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 350, 50, 30)];
    [btn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"走你" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:btn];
}

- (void)refresh {
    [self.circularProgressView1 setProgress:self.slider.value animated:NO];
    [self.circularProgressView2 setProgress:self.slider.value animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
