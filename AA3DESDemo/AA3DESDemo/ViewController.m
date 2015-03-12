//
//  ViewController.m
//  AA3DESDemo
//
//  Created by Arlexovincy on 15/3/12.
//  Copyright (c) 2015年 Arlexovincy. All rights reserved.
//

#import "ViewController.h"
#import "AA3DESManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *beMakeString = @"33addkkAF中国人kjwiJKfs123";
    
    NSString *encrypptString = [AA3DESManager getEncryptWithString:beMakeString keyString:@"fuck_ss" ivString:nil];
    NSString *decryptString = [AA3DESManager getDecryptWithString:encrypptString keyString:@"fuck_ss" ivString:nil];
    
    NSLog(@"3des加密:%@",encrypptString);
    NSLog(@"3des解密:%@",decryptString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
