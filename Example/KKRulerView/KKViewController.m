//
//  KKViewController.m
//  KKRulerView
//
//  Created by kkwong90@163.com on 01/26/2022.
//  Copyright (c) 2022 kkwong90@163.com. All rights reserved.
//

#import "KKViewController.h"
#import <KKRulerView/KKRulerView.h>
@interface KKViewController ()<KKRulerViewDelegate>

@end

@implementation KKViewController
{
    KKRulerView *_rulerView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage * background = [UIImage imageNamed:@"background"];
    
    KKRulerView * defaultRulerView = [[KKRulerView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 90)];
    defaultRulerView.delegate = self;
    defaultRulerView.backgroundImageView.image = background;
    [self.view addSubview:defaultRulerView];
    
    KKRulerView * customRulerView = [[KKRulerView alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, 90)];
    customRulerView.delegate = self;
    customRulerView.backgroundImageView.image = background;
    customRulerView.minimum = 10;
    customRulerView.maximum = 150;
    customRulerView.selectValue = 50;
    customRulerView.lineSpacingToScrollView = 20;
    [self.view addSubview:customRulerView];
    _rulerView = customRulerView;
    
    KKRulerView * reversalRulerView = [[KKRulerView alloc] initWithFrame:CGRectMake(10, 300, self.view.frame.size.width - 20, 90)];
    reversalRulerView.delegate = self;
    reversalRulerView.backgroundImageView.image = background;
    reversalRulerView.minimum = 10;
    reversalRulerView.maximum = 150;
    reversalRulerView.reversal = YES;
    reversalRulerView.textSpacingToLine = 20;
    [self.view addSubview:reversalRulerView];
    
}


- (void)rulerViwe:(KKRulerView *)rulerView didUpdateSelectValue:(int)value {
    NSLog(@"did update seclect value = %ld",(long)value);
}


- (void)rulerView:(KKRulerView *)rulerView didCreateTextLabel:(UILabel *)textLabel value:(int)value {
    if ([rulerView isEqual:_rulerView]) {
        NSString * string = [NSString stringWithFormat:@"%ld厘米",(long)value];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:string];
        [att addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : UIColor.redColor} range:NSMakeRange(0, string.length - 2)];
        [att addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : UIColor.blackColor} range:NSMakeRange(string.length - 2, 2)];
        textLabel.attributedText = att;
    } else {
        textLabel.text = [NSString stringWithFormat:@"%ld",(long)value];
        textLabel.font = [UIFont systemFontOfSize:18];
        textLabel.textColor = UIColor.blackColor;
        textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
