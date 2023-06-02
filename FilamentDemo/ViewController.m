//
//  ViewController.m
//  FilamentDemo
//
//  Created by wyan on 2023/6/2.
//

#import "ViewController.h"
#import "FilamentViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    {
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(100, 100, 100, 30);
        [btn setBackgroundColor:UIColor.redColor];
        [btn setTitle:@"Start" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)onClickButton:(UIButton *)sender
{
    FilamentViewController *vc = [[FilamentViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

@end
