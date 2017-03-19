//
//  ViewHeader.m
//  BusSchedule
//
//  Created by Serik Klement on 14.03.17.
//  Copyright © 2017 Serik Klement. All rights reserved.
//

#import "ViewHeader.h"

@interface ViewHeader ()

@property (assign, nonatomic) CGFloat space;
@property (assign, nonatomic) CGFloat widthSityLabel;
@property (assign, nonatomic) CGFloat widthOtherLabel;

@property (strong, nonatomic) UILabel *sityLabel;
@property (strong, nonatomic) UILabel *dateFromLabel;
@property (strong, nonatomic) UILabel *timeFromLabel;
@property (strong, nonatomic) UILabel *dateToLabel;
@property (strong, nonatomic) UILabel *timeToLabel;

@end

@implementation ViewHeader

// класс для создания хедера таблицы

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:215.0/255 green:211.0/255 blue:213.0/255 alpha:0.5];
        
        self.sityLabel = [self createLabel];
        self.sityLabel.text = @"Маршрут";
        self.dateFromLabel = [self createLabel];
        self.dateFromLabel.text = @"Дата\nотправ";
        self.timeFromLabel = [self createLabel];
        self.timeFromLabel.text = @"Время\nотправ";
        self.dateToLabel = [self createLabel];
        self.dateToLabel.text = @"Дата\nприб";
        self.timeToLabel = [self createLabel];
        self.timeToLabel.text = @"Время\nприб";
        
    }
    
    return self;
    
}

- (UILabel*) createLabel {
    
    UILabel *label = [UILabel new];
    //label.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.3, self.frame.size.height);
    label.backgroundColor = [UIColor colorWithRed:215.0/255 green:211.0/255 blue:213.0/255 alpha:1];
    label.adjustsFontSizeToFitWidth = YES; // уменьшаем текст по размеру лейбла
    label.numberOfLines = 2; // две строки в лейбле
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    return label;
    
}

- (void) setWidthLabels {
    
    self.space = 3.f;
    self.widthSityLabel = [[UIScreen mainScreen] bounds].size.width * 0.3;
    self.widthOtherLabel = (([[UIScreen mainScreen] bounds].size.width - self.widthSityLabel) - self.space * 4) / 4;
    
}

// метод выравнивания
- (void) layoutSubviews {
    
    [super layoutSubviews]; // вызываю у родителя метод выравнивания
    
    [self setWidthLabels];
    
    self.sityLabel.frame = CGRectMake(0, 0, self.widthSityLabel, self.frame.size.height);
    self.dateFromLabel.frame = CGRectMake(self.sityLabel.frame.size.width + self.space, 0, self.widthOtherLabel, self.frame.size.height);
    self.timeFromLabel.frame = CGRectMake(self.dateFromLabel.frame.size.width + self.dateFromLabel.frame.origin.x + self.space, 0, self.widthOtherLabel, self.frame.size.height);
    self.dateToLabel.frame = CGRectMake(self.timeFromLabel.frame.size.width + self.timeFromLabel.frame.origin.x + self.space, 0, self.widthOtherLabel, self.frame.size.height);
    self.timeToLabel.frame = CGRectMake(self.dateToLabel.frame.size.width + self.dateToLabel.frame.origin.x + self.space, 0, self.widthOtherLabel, self.frame.size.height);
    
}

@end
