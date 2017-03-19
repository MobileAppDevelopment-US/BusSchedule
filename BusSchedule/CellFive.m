//
//  CellFive.m
//  BusSchedule
//
//  Created by Serik Klement on 14.03.17.
//  Copyright © 2017 Serik Klement. All rights reserved.
//

#import "CellFive.h"

@interface CellFive () //расширяю класс для проперти

@property (assign, nonatomic) CGFloat space;
@property (assign, nonatomic) CGFloat widthSityLabel;
@property (assign, nonatomic) CGFloat widthOtherLabel;

@end

@implementation CellFive

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.sityLabel = [self createLabel];
        self.sityLabel.textAlignment = NSTextAlignmentCenter;
        self.dateFromLabel = [self createLabel];
        self.dateFromLabel.textAlignment = NSTextAlignmentCenter;
        self.timeFromLabel = [self createLabel];
        self.timeFromLabel.textAlignment = NSTextAlignmentCenter;
        self.dateToLabel = [self createLabel];
        self.dateToLabel.textAlignment = NSTextAlignmentCenter;
        self.timeToLabel = [self createLabel];
        self.timeToLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return self;
    
}

- (UILabel*) createLabel {
    
    UILabel *label = [UILabel new];
   //label.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.3, self.frame.size.height);
    label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2f];
    label.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:label];
    
    return label;
    
}

- (void) setWidthLabels {
    
    self.space = 3.f;
    self.widthSityLabel = [[UIScreen mainScreen] bounds].size.width * 0.3;
    self.widthOtherLabel = (([[UIScreen mainScreen] bounds].size.width - self.widthSityLabel) - self.space * 4) / 4;
    
}

//метод выравнивания
- (void) layoutSubviews {
    
    [super layoutSubviews]; //вызываю у родителя метод выравнивания
    
    [self setWidthLabels];
    
    self.sityLabel.frame = CGRectMake(0, 0, self.widthSityLabel, self.frame.size.height);
    self.dateFromLabel.frame = CGRectMake(self.sityLabel.frame.size.width + self.space, 0, self.widthOtherLabel, self.frame.size.height);
    self.timeFromLabel.frame = CGRectMake(self.dateFromLabel.frame.size.width + self.dateFromLabel.frame.origin.x + self.space, 0, self.widthOtherLabel, self.frame.size.height);
    self.dateToLabel.frame = CGRectMake(self.timeFromLabel.frame.size.width + self.timeFromLabel.frame.origin.x + self.space, 0, self.widthOtherLabel, self.frame.size.height);
    self.timeToLabel.frame = CGRectMake(self.dateToLabel.frame.size.width + self.dateToLabel.frame.origin.x + self.space, 0, self.widthOtherLabel, self.frame.size.height);
    
}

@end
