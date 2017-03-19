//
//  ScheduleViewController.m
//  BusSchedule
//
//  Created by Serik Klement on 13.03.17.
//  Copyright © 2017 Serik Klement. All rights reserved.
//

#import "ScheduleViewController.h"
#import "InfoViewController.h"
#import "CellFive.h"
#import "ViewHeader.h"
#import <AFNetworking.h>

@interface ScheduleViewController ()

@property (strong, nonatomic) NSArray *arrayDictionaries; // массив дикшинарей
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) UIRefreshControl *refresh;

@end

@implementation ScheduleViewController

// основной контроллер

// при первом входе приложение получает данные и сохраняет в локальную базу, при последующих входах данные отображаются из базы, данные в базе обновляются по свайпу вниз на списке.
// при выполнение сетевых операций интерфейс блокируется и пользователь видит диалог ожидания. Если сервер отдаст пустой список то пользователь увидит надпись “Список маршрутов пуст” по середине экрана. Если сетевая операция не пройдет, то пользователь увидит сообщение с описанием проблемы и кнопку “Повторить” посреди экрана.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    self.arrayDictionaries = [userDef  objectForKey:@"arrayDictionaries"]; // получаю сохраненные данные в массив
    
    if (self.arrayDictionaries.count == 0) { // если в массиве нет данных
        
        [self loadData]; // вызываю загрузку с сервера
        
    } else { // если в массиве данные есть
        
        [self datafromLocalDatabase];
    }
    self.navigationItem.title = @"Расписание автобусов"; // название контроллера
    
    self.refresh = [[UIRefreshControl alloc] init]; // создаю рефреш - скролинг вниз
    
    [self.refresh addTarget:self
                     action:@selector(actionRefresh:)
           forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = self.refresh;
    
}

- (void) datafromLocalDatabase {
    
    [self.tableView reloadData];
    
    [self showAllertWithMessage:@"Вы используете данные из локальной базы. Пожалуйста обновите данные!"
                       andTitle:@"ВНИМАНИЕ!"];
    
}

- (void)loadData { // загрузка с сервера
    
    [self addLockView];
    
    self.manager = [AFHTTPSessionManager manager];
    
    [self.manager GET:@"http://smartbus.gmoby.org/web/index.php/api/trips?from_date=20150101&to_date=20180301"
           parameters:nil
             progress:nil
              success:^(NSURLSessionTask *task, NSDictionary*responseObject) {
                  
                  self.arrayDictionaries = [responseObject objectForKey:@"data"]; // записываем в массив данные по ключу
                  
                  [[self.view viewWithTag:1] removeFromSuperview]; // удаляем прозрачную вьюху
                  
                  [self showAllertWithMessage:@"Список маршрутов обновлен"
                                     andTitle:@""];
                  
                  [self.refresh endRefreshing]; // заканчиваем рефреш
                  
                  [self.tableView reloadData]; // перезагружаю таблицу
                  
                  [self saveUserDefault]; // сохраняю настройки
                  
              } failure:^(NSURLSessionTask *operation, NSError *error) {
                  
                  [self.refresh endRefreshing]; // заканчиваем рефреш
                  
                  [self showAllertWithMessage:@"Список маршрутов пуст"
                                     andTitle:@"ВНИМАНИЕ!"];
                  
                  NSLog(@"Error: %@", error);
                  
              }];
    
}

- (void) addLockView {
    
    UIView *view = [[UIView alloc] init];
    view.frame = self.view.frame;
    view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
    view.tag = 1;
    [self.view addSubview:view];
    
}

#pragma mark - Actions

//нажатие на ячейку
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoViewController *controller = [[InfoViewController alloc] init];  // корневой контроллер для UINavigationController *controlyes
    
    [self.navigationController pushViewController:controller animated:YES]; // pushViewController  - добавляю в онавн
    
    controller.dictionatySchedule = [self.arrayDictionaries objectAtIndex:indexPath.row];
    
}

//рефреш можно делать только когда он закончился ( повторно нельзя во время загрузки)
- (void) actionRefresh:(UIRefreshControl *) sender { // передаю сюда рефреш
    
    [self loadData];
}

#pragma mark - UITableViewDataSource

// создаю количество ячеек
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayDictionaries count];
    
}

// создаю ячейки
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    CellFive *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[CellFive alloc] initWithStyle:UITableViewCellStyleValue1
                               reuseIdentifier:identifier];
        
    }
    // получаю дикшинари из массива
    NSDictionary *dic = [self.arrayDictionaries objectAtIndex:indexPath.row];
    
    //достаю из дикшинари по ключу
    NSString *stringSities = [dic objectForKey:@"info"];
    NSArray *arraySities = [stringSities componentsSeparatedByString:@" "]; // режу строку через пробел
    
    NSString *stringFirst = arraySities.firstObject; // первый объект массива
    NSString *stringLast = arraySities.lastObject; // последний объект массива
    
    if ([stringFirst containsString:@"-"]) {
        
        stringFirst = [stringFirst componentsSeparatedByString:@"-"].firstObject; // вырезаю "-" в первом городе
        
    }
    
    if ([stringLast containsString:@"-"]) {
        
        stringLast = [stringLast componentsSeparatedByString:@"-"].lastObject; // вырезаю - во втором городе
        
    }
    
    NSString *stringSity = [NSString stringWithFormat:@"%@-%@", stringFirst, stringLast];
    
    NSString *stringFromDate = [dic objectForKey:@"from_date"];
    NSString *stringFromTime = [dic objectForKey:@"from_time"];
    NSString *stringToDate = [dic objectForKey:@"to_date"];
    NSString *stringToTime = [dic objectForKey:@"to_time"];
    
    cell.sityLabel.text = stringSity;
    cell.dateFromLabel.text = stringFromDate;
    cell.timeFromLabel.text = stringFromTime;
    cell.dateToLabel.text = stringToDate;
    cell.timeToLabel.text = stringToTime;
    
    return cell;
    
}

// указываю высоту хедера - метод 1
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}
// метод 2 создаю хедер таблицы
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 40);
    
    ViewHeader *viewHeader = [[ViewHeader alloc] initWithFrame:rect];
    
    return viewHeader;
}

- (void)showAllertWithMessage:(NSString*)message andTitle:(NSString*)title {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil]; // кнопка на алерте
    [alert addAction:ok]; //добавляю кнопку
    
    [self.navigationController presentViewController:alert
                                            animated:YES
                                          completion:nil];
}

// сохранение настроек
- (void) saveUserDefault {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:self.arrayDictionaries forKey:@"arrayDictionaries"];
    
    [userDefault synchronize]; // момент сохранения
    
}

@end
