//
//  QSYView.m
//  RAC
//
//  Created by SL on 16/8/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "QSYView.h"

@implementation QSYView

- (RACSubject *)btnSubject
{
    if (_btnSubject == nil)
    {
        _btnSubject = [RACSubject subject];
    }
    
    return _btnSubject;
}

- (IBAction)btnClick:(id)sender
{
    [self.btnSubject sendNext:@"按钮被点击了"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
