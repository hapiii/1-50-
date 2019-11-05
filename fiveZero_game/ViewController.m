//
//  ViewController.m
//  fiveZero_game
//
//  Created by hapii on 2019/11/5.
//  Copyright © 2019 hapii. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray <NSString *> * firstData;
@property (nonatomic, strong) NSMutableArray <NSString *> * secondData;
@property (nonatomic, assign) int rowNum;
@property (nonatomic, assign) int currectIndex;
@property (nonatomic, assign) float currectTime;
@property (nonatomic, strong)  NSTextField *alertLab;
@property (nonatomic, strong)  NSTextField *timeLab;
@property (nonatomic, strong) NSButton *retryBtn;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
    [self configBasicUI];
}

- (void)configBasicUI{
    
    _alertLab = [[NSTextField alloc]init];
    _alertLab.editable = NO;
    _alertLab.bordered = NO;
    _alertLab.backgroundColor = [NSColor whiteColor];
    _alertLab.textColor = [NSColor redColor];
    _alertLab.alignment = NSTextAlignmentCenter;
    _alertLab.maximumNumberOfLines = 2; //最多显示行数
    _alertLab.frame = NSMakeRect(self.view.frame.size.width/2-100,self.view.frame.size.height/2, 200, 50);
    _alertLab.hidden = YES;
    [self.view addSubview:_alertLab];
    
    _timeLab = [[NSTextField alloc]init];
    _timeLab.editable = NO;
    _timeLab.bordered = NO;
    _timeLab.backgroundColor = [NSColor clearColor];
    _timeLab.textColor = [NSColor redColor];
    _timeLab.alignment = NSTextAlignmentRight;
    _timeLab.frame = NSMakeRect(self.view.frame.size.width-100,20, 90,20);
    [self.view addSubview:_timeLab];
    
    _retryBtn = [[NSButton alloc] initWithFrame:CGRectMake(100, 100, self.view.frame.size.width-200, self.view.frame.size.height-200)];
    _retryBtn.font = [NSFont systemFontOfSize:40.0f];
    [_retryBtn setSound:[NSSound soundNamed:@"Pop"]];
    [_retryBtn setTarget:self];
    [_retryBtn setAction:@selector(reloadData)];
    [self.view addSubview:_retryBtn];
    _retryBtn.hidden = YES;


    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        self->_currectTime = self->_currectTime+0.1;
        dispatch_async(dispatch_get_main_queue(), ^{
             self->_timeLab.stringValue = [NSString stringWithFormat:@"%.1f秒",self->_currectTime];
        });
       
    });
    dispatch_resume(timer);
    _timer = timer;
}

- (void)showAlert:(NSString *)str{
    
    _alertLab.hidden = NO;
    _alertLab.stringValue = str;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_alertLab.hidden = YES;
    });
}
- (void)reloadData{
    
    _rowNum = 5;
    _currectIndex = 1;
    _currectTime = 0.0;
    for (int i = 1; i<=_rowNum*_rowNum; i++) {
        [self.firstData addObject:[NSString stringWithFormat:@"%i",i]];
    }
    for (int i = _rowNum*_rowNum+1; i<=_rowNum*_rowNum*2; i++) {
        [self.secondData addObject:[NSString stringWithFormat:@"%i",i]];
    }
    _retryBtn.hidden = YES;
    [self configUI];
    
}

- (void)configUI{
    
    CGFloat rowWidth = self.view.frame.size.width/(_rowNum+2);
    for (int i = 0; i<_rowNum; i++) {
        
        for (int j = 0; j<_rowNum; j++) {
            NSButton *btn = [[NSButton alloc] initWithFrame:CGRectMake(rowWidth*(i+1), rowWidth*(j+1), rowWidth, rowWidth)];
            btn.title = [self getRandomFromData:self.firstData];
            [btn setSound:[NSSound soundNamed:@"Pop"]];
            btn.font = [NSFont systemFontOfSize:30.0f];
            btn.tag = btn.title.intValue;
            [self.view addSubview:btn];
            [btn setAlignment:NSTextAlignmentCenter];
            [btn setTarget:self];
            [btn setAction:@selector(handelClick:)];
        }
    }
}

- (void)handelClick:(NSButton *)btn{
    
    
    if (![btn.title isEqualToString:[NSString stringWithFormat:@"%i",_currectIndex]]) {
        [self showAlert:@"请按顺序点击"];
        return;
    }
    _currectIndex ++;
    ///完成游戏
    if (_currectIndex == _rowNum*_rowNum*2+1) {
        dispatch_suspend(_timer);
        _retryBtn.title = [NSString stringWithFormat:@"用时%.1f秒,\n再玩一次",_currectTime];
        _retryBtn.hidden = NO;
    }
    
    if (btn.title.intValue>_rowNum*_rowNum) {
        btn.hidden = YES;
        [btn removeFromSuperview];
        return;
    }
    
    btn.title = [self getRandomFromData:self.secondData];
}

- (NSString *)getRandomFromData:(NSMutableArray <NSString *>*)datas{
    NSInteger i = random()%datas.count;
    NSString *str = datas[i].mutableCopy;
    [datas removeObject:str];
    return str;
}

- (NSMutableArray<NSString *> *)firstData{
    if (_firstData == nil) {
        _firstData = [[NSMutableArray alloc] init];
    }
    return _firstData;
}

- (NSMutableArray<NSString *> *)secondData{
    if (_secondData == nil) {
        _secondData = [[NSMutableArray alloc] init];
    }
    return _secondData;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    
}

@end
