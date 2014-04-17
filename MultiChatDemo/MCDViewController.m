//
//  MCDViewController.m
//  MultiChatDemo
//
//  Created by Tony DiPasquale on 4/16/14.
//  Copyright (c) 2014 Tony DiPasquale. All rights reserved.
//

#import "MCDViewController.h"
#import "MCDTextCell.h"

@interface MCDViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic) NSMutableArray *messages;

@end

@implementation MCDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.messages = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCDTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCDTextCell" forIndexPath:indexPath];

    cell.textView.text = self.messages[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.messages[indexPath.row];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};

    CGRect frame = [text boundingRectWithSize:CGSizeMake(tableView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return frame.size.height + 20;
}

#pragma mark - Action Methods

- (IBAction)send:(id)sender
{
    if ([self.textField.text isEqualToString:@""]) {
        return;
    }

    // send text
    [self.messages addObject:[self.textField.text copy]];
    [self.tableView reloadData];
    self.textField.text = @"";
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self send:nil];
    return NO;
}

#pragma mark - Keyboard Presentation Methods

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize size = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect frame = self.controlView.frame;
    frame.origin.y = frame.origin.y - size.height;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.controlView.frame = frame;
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGSize size = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect frame = self.controlView.frame;
    frame.origin.y = frame.origin.y + size.height;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.controlView.frame = frame;
    } completion:nil];
}

@end
