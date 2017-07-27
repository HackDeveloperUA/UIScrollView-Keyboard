//
//  ViewController.m
//  UIScrollView-Keyboard
//
//  Created by Uber on 27/07/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 1. Регистрируем тап, для скрытия клавиатуры
    // 1. Register tap to hide the keyboard
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self.view addGestureRecognizer:tapGesture];
}


- (void) viewWillAppear:(BOOL)animated
{
    // 2. Подписываемся на нотификации
    // 2. Subscribe to notifications
    
    [super viewWillAppear:animated];
    [self addObservers];
}

- (void) viewWillDisappear:(BOOL)animated
{
    // 3. Отписываемся от нотификаций
    // 3. Unsubscribe from notifications
    
    [super viewWillDisappear:animated];
    [self removeObservers];
}

#pragma mark - Keybords methods

- (void) addObservers
{
    // Нотификация которая появляется при открытии клавиатуры
    // Notification that appears when you open the keyboard
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification*  note) {
        [self keyboardWillShow:note];
    }];
    
    // Нотификация которая появляется при закрытии клавиатуры
    // Notification that appears when you close the keyboard
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification*  note) {
        [self keyboardWillHide:note];
    }];
}


- (void) keyboardWillShow:(NSNotification*) notification
{
    // Получаем словарь - Get Dictionary
    
    NSDictionary* userInfo = notification.userInfo;
    
    if (userInfo)
    {
        // Вытаскиваем frame который описывает кооридинаты клавиатуры
        // Pull out frame which describes the coordinates of the keyboard
        CGRect frame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        // Создаем отступ по высоте клавиатуры
        // Create an inset at the height of the keyboard
        
        UIEdgeInsets contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frame), 0);
        
        // Применяем отступ - Apply the inset
        self.scrollView.contentInset = contentInset;
    }
}

- (void) keyboardWillHide:(NSNotification*) notification
{
    // Отменяем отступ - Cancel inset
    self.scrollView.contentInset = UIEdgeInsetsZero;
}


- (void) removeObservers
{
    // Отписываемся от нотификаций - Unsubscribe from notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  Action

- (void) didTapView:(UITapGestureRecognizer*) gesture {
    [self.view endEditing:YES];
}



@end
