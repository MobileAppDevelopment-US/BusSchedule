//
//  InfoViewController.m
//  BusSchedule
//
//  Created by Serik Klement on 13.03.17.
//  Copyright © 2017 Serik Klement. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@property (strong, nonatomic) NSArray *arrayNamesRows;

@end

@implementation InfoViewController

// дополнительный контроллер

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayNamesRows = [NSArray arrayWithObjects:@"Номер рейса", // надпись в лейбле
                           @"Маршрут",
                           @"Дата отправления",
                           @"Время отправления",
                           @"Дата прибытия",
                           @"Время прибытия",
                           @"Стоимость билета",
                           @"Зарезервировано мест", nil];
    
    self.navigationItem.title = @"Информация о рейсе"; // название контроллера
    
}

#pragma mark - Table view data source

// количество ячеек
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayNamesRows count];
}
// создаю ячейки
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    
    cell.textLabel.text = [self.arrayNamesRows objectAtIndex:indexPath.row];
    
    NSInteger integerNum = 0;
    
    switch (indexPath.row) {
            
        case 0:
            integerNum = ((NSNumber*)[self.dictionatySchedule objectForKey:@"bus_id"]).integerValue;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", integerNum];
            break;
        case 1:
            cell.detailTextLabel.text = [self.dictionatySchedule objectForKey:@"info"];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.numberOfLines = 2;
            break;
        case 2:
            cell.detailTextLabel.text = [self.dictionatySchedule objectForKey:@"from_date"];
            break;
        case 3:
            cell.detailTextLabel.text = [self.dictionatySchedule objectForKey:@"from_time"];
            break;
        case 4:
            cell.detailTextLabel.text = [self.dictionatySchedule objectForKey:@"to_date"];
            break;
        case 5:
            cell.detailTextLabel.text = [self.dictionatySchedule objectForKey:@"to_time"];
            break;
        case 6:
            integerNum = ((NSNumber*)[self.dictionatySchedule objectForKey:@"price"]).integerValue;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", integerNum];
            break;
        case 7:
            integerNum = ((NSNumber*)[self.dictionatySchedule objectForKey:@"reservation_count"]).integerValue;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", integerNum];
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
}

@end
