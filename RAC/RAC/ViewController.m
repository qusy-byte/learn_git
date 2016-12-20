//
//  ViewController.m
//  RAC
//
//  Created by SL on 16/8/26.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "ViewController.h"
#import "QSYGlobeHeader.h"
#import "QSYView.h"
#import "Flag.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet QSYView *greenView;
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic,strong) id<RACSubscriber> subscriber;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // RACSignal:有数据产生的时候就使用RACSignal
    
    // RACSignal使用步骤: 1.创建信号 2.订阅信号 3.发送信号
    
//    [self RACSimpleUsing];
    
//    [self RACWithRACDisposable];

//    [self RACWithRACSubject];
    
//    [self RACWithRACReplaySubject];
    
//    [self RACSubjectRepalceDelegate];
    
//    [self RACWithRACTuple];
    
//    [self RACWithRACSequence];
    
//    [self RACWithModle];
    
//    [self RACRepalceKVO];
    
//    [self RACNotification_Event_TextField];
    
//    [self RACLiftSelecter];
    
//    [self racDefind];
    
//    [self racMulticastConnection];
    
//    [self racWithRACCommand];
//    [self racWithRACCommand_executionSignals];
    [self racWithRACCommand_executionSignals];
    
    NSLog(@"测试更新");
}

#pragma mark
#pragma mark --- RAC之RACCommand ---
- (void)racWithRACCommand_switchToLatest
{
    // RACCommand:处理事件
    // RACCommand:不能返回一个空信号
    // 1. 创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"事件名称 = %@",input);
        
        RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"发送事件数据"];
            
            return nil;
        }];
        
        return singal;
    }];
    
    // switchToLatest 最近的一次信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"x = %@",x);
        
    }];
    
    // 2. 执行命令
    [command execute:@"事件A"];
}

- (void)racWithRACCommand_executionSignals
{
    // RACCommand:处理事件
    // RACCommand:不能返回一个空信号
    // 1. 创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"事件名称 = %@",input);
        
        RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"发送事件数据"];
            
            return nil;
        }];
        
        return singal;
    }];
    
    [command.executionSignals subscribeNext:^(id x) {
        
        [x subscribeNext:^(id x) {
           
            NSLog(@"x = %@",x);
            
        }];
        
    }];
    
    // 2. 执行命令
    [command execute:@"事件A"];
    
}

- (void)racWithRACCommand
{
    // RACCommand:处理事件
    // RACCommand:不能返回一个空信号
    // 1. 创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"事件名称 = %@",input);
        
        RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"发送事件数据"];
            
            return nil;
        }];
        
        return singal;
    }];

    // 2. 执行命令
    RACSignal *singal = [command execute:@"事件A"];
    
    // 3. 订阅信号
    [singal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

#pragma mark
#pragma mark --- RAC之RACMulticastConnection ---
- (void)racMulticastConnection
{
    //不管订阅多少次,只会请求一次
    //RACMulticastConnection:必须要有信号
    
    /**
     *  RACMulticastConnection
     *
     *  1 创建信号
     *
     *  2 把信号转换成连接类
     *  
     *  3.订阅连接类信号
     *
     *  4.链接
     */
    RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"热门模块数据"];
        
        return nil;
    }];
    
    RACMulticastConnection *connection = [singal publish];
    
    [connection.signal subscribeNext:^(id x) {
        
        NSLog(@"数据1:%@",x);
        
    }];
    
    [connection.signal subscribeNext:^(id x) {
        
        NSLog(@"数据2:%@",x);
        
    }];
    
    [connection.signal subscribeNext:^(id x) {
        
        NSLog(@"数据2:%@",x);
        
    }];
    
    [connection connect];
}

#pragma mark
#pragma mark --- RAC之常用的宏 ---
- (void)racDefind
{
    // 1. 用来某个对象的某个属性绑定信号,只要产生信号内容,就会把内容给属性赋值
    RAC(self.label,text) = self.textF.rac_textSignal;
    
    // 2. 用来监听某个对象的属性变化
    [RACObserve(self.greenView, frame) subscribeNext:^(id x) {
        
        NSLog(@"x %@",x);
        
    }];
    
    // 3. 消除循环引用
    @weakify(self);
    
    void(^block)() = ^(){
        
       @strongify(self)
        
        NSLog(@"self = %@",self);
        
    };
    block();
    
    // 4. 包装元组
    RACTuple *tuple = RACTuplePack(@"Jadyn",@23);
    
    NSLog(@"tuple = %@",tuple);
}

#pragma mark
#pragma mark --- RAC之liftSelecter ---
- (void)RACLiftSelecter
{
    //当一个页面有多个请求,所有请求结束之后才可以记载UI,可以运用此方法
    
    // 1. 创建信号
    RACSignal *hotSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"热销模块数据"];
        
        return nil;
    }];
    
    
    RACSignal *newSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"最新模块数据"];
        
        return nil;
    }];
    
    // 2. 请求结束
    [self rac_liftSelector:@selector(updateUIWithHotData:newData:) withSignalsFromArray:@[hotSignal,newSignal]];
}

- (void)updateUIWithHotData:(NSString *)hotData newData:(NSString *)newData
{
    NSLog(@"数据 %@ , %@",hotData,newData);
}

#pragma mark
#pragma mark --- RAC监听事件,代替通知,监听文本框 ---
- (void)RACNotification_Event_TextField
{
    // 1. RAC代替通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        
        NSLog(@"x = %@",x);
        
    }];
    
    // 2. RAC监听事件
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
    
    // 3. RAC监听文本框
    [self.textF.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"x = %@",x);
        
    } ];
}

#pragma mark
#pragma mark --- RAC代替KVO ---
- (void)RACRepalceKVO
{
    // 4. 监听某个方法执行了
    [[self.greenView rac_signalForSelector:@selector(btnClick:) ]subscribeNext:^(id x) {
        
        NSLog(@"控制器知道按钮被点击了");
        
    }];
    
    // 5. RAC之KVO
    [self.greenView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent){
    
        NSLog(@"change == %@",change);
        
    }];
    
    [[self.greenView rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"x = %@",x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.greenView.frame = CGRectMake(20, 100, 200, 200);
}

#pragma mark
#pragma mark --- RACSubject代替代理 ---
- (void)RACSubjectRepalceDelegate
{
    //在定义代理处发送信号,在想接收的地方处理信号
    [self.greenView.btnSubject subscribeNext:^(id x) {
        
        NSLog(@"控制器接收数据:%@",x);
        
    }];
}

#pragma mark
#pragma mark --- RAC之集合---
- (void)RACWithModle
{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"icon.plist" ofType:nil];
    
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:filePath];
    
    /*
     * 简单用法

    NSMutableArray *modleArray = [NSMutableArray array];
    
    [dictArray.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
        
        Flag *flag = [Flag flagWithDict:x];
        
        [modleArray addObject:flag];
        
        NSLog(@"modle == %@",modleArray);
        
    }];
     */
    
    NSArray *modleArray = [[dictArray.rac_sequence map:^id(id value) {
        return [Flag flagWithDict:value];
    }] array];
    
    for (Flag *flag in modleArray) {
        
        NSLog(@"flag == %@",flag.title);
        
    };
    
//    NSLog(@"modle == %@",modleArray);
}

- (void)RACWithRACSequence
{
//    NSArray *array = @[@"Jadyn",@"ios",@23];
    
    //RAC集合
//    RACSequence *sequence = array.rac_sequence;
    
    //把集合转换成信号
//    RACSignal *signal = sequence.signal;
    
    //订阅集合信号,内部会自动遍历所有的元素发出来
//    [signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
//    [array.rac_sequence.signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    NSDictionary *dict = @{@"name":@"Jadyn",@"age":@23};
    
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        
        //RACTupleUnPack:用来解析元组
        //宏里面的参数,传需要解析出来的变量名
        // = 右边,放需要解析的元组
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        NSLog(@"key == %@,value == %@",key,value);
    }];
}

- (void)RACWithRACTuple
{
    //元组
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"Jadyn",@"ios",@23]];
    
    NSString *str = tuple[0];
    
    NSLog(@"str == %@",str);
}

#pragma mark
#pragma mark --- 初步认识RAC,RACReplaySubject ---
- (void)RACWithRACReplaySubject
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [subject subscribeNext:^(id x) {
        
        NSLog(@"收到数据:%@",x);
        
    }];
    
    //RACReplaySubject发送数据:
    // 1.先保存数据
    // 2.遍历所有订阅者,发送数据
    [subject sendNext:@{@"name":@"Jadyn",@"age":@23}];
    
    //RACReplaySubject:可以先发送信号,在订阅信号
}

#pragma mark
#pragma mark --- 初步认识RAC,RACSubject ---
- (void)RACWithRACSubject
{
    //1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    //2.订阅信号
    
    //不同信号订阅方式不一样
    //RACSubject处理订阅:仅仅是保存订阅者
    [subject subscribeNext:^(id x) {
        
        NSLog(@"收到数据:%@",x);
        
    }];
    
    //3.发送信号
    [subject sendNext:@{@"name":@"Jadyn",@"age":@23}];
}

#pragma mark
#pragma mark --- 初步认识RAC,RACDisposable ---
- (void)RACWithRACDisposable
{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //保存订阅者,发送信号后不主动取消订阅
        _subscriber = subscriber;
        
        // 3.发送信号
        [subscriber sendNext:@{@"name":@"Jadyn",@"age":@23}];
        
        return [RACDisposable disposableWithBlock:^{
            
            //只要信号取消订阅就会来这
            //清空资源
            NSLog(@"信号订阅被取消了");
            
        }];
    }];
    
    // 2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {

        NSLog(@"x == %@",x);
        
    }];
    
    //默认一个信号发送数据完毕就会取消订阅
    //只要订阅者在,就不会主动取消信号
    
    //取消订阅
    [disposable dispose];
    
}

#pragma mark
#pragma mark --- 初步认识RAC,RACSignal ---
- (void)RACSimpleUsing
{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // didSubscribe调用:只要一个信号被订阅就调用
        // didSubscribe作用:发送数据
        // 3.发送信号
        [subscriber sendNext:@{@"name":@"Jadyn",@"age":@23}];
        
        return nil;
    }];
    
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        // nextBlock调用:只要订阅者发送数据就调用
        // nextBlock作用:处理数据,展示在UI
        
        // x:信号发送的内容
        NSLog(@"x == %@",x);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
