//
//  PLBaseInputViewController.m
//  EmbeddedControl
//
//  Created by Yaroslav Vorontsov on 22.11.11.
//  Copyright (c) 2011 DataArt. All rights reserved.
//

#import "EMBaseInputViewController.h"

@interface EMBaseInputViewController()
- (void) addInputAccessoryViewToViewAndSubviews:(UIView*)view;
- (void) checkViewIsVisible:(UIView*)view keyboardFrame:(CGRect)keyboardFrame;
@end

@implementation EMBaseInputViewController
@synthesize scrollView = _scrollView;
@synthesize activeView = _activeView;
@synthesize activeTextField = _activeTextField;
@synthesize persistentStorageManager;
@synthesize restClient;
//@synthesize keyboardAccessoryView = _keyboardAccessoryView;

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    _keyboardShown = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:self.view.window];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
//    self.keyboardAccessoryView = [PLKeyboardAccessoryView view];
//    _keyboardAccessoryView.accessoryViewDelegate = self;
    [self addInputAccessoryViewToViewAndSubviews:self.view];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isViewVisible = YES;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _isViewVisible = NO;
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Actions

- (void) backgroundTapped:(UITapGestureRecognizer*)recognizer
{
    if (!CGRectContainsPoint(_activeView.bounds, [recognizer locationInView:_activeView]))
    {
        if(recognizer.state == UIGestureRecognizerStateRecognized)
            [_activeView resignFirstResponder];
    }
}

#pragma mark - Notification handling methods

- (void) keyboardWillShow:(NSNotification *)notification
{
    if (_isViewVisible)
    {
        _keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGFloat y = self.view.frame.size.height - _keyboardFrame.size.height;
        _keyboardFrame = CGRectMake(0.0f, y, _keyboardFrame.size.width, _keyboardFrame.size.height);
        [self checkViewIsVisible:_activeView keyboardFrame:_keyboardFrame];
        _keyboardShown = YES;
    }
}

- (void) keyboardDidShow:(NSNotification *)notification
{
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    if (_isViewVisible)
    {
        NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView beginAnimations:@"KeyboardHidingAnimation" context:NULL];
        [UIView setAnimationDuration:animationDuration];
        _scrollView.contentInset = UIEdgeInsetsZero;
        _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
        [UIView commitAnimations];
        _keyboardShown = NO;
    }
}

- (void) keyboardDidHide:(NSNotification *)notification
{
}

#pragma mark - Accessory view addition logic

- (void) addInputAccessoryViewToViewAndSubviews:(UIView *)view
{
//    for (UIView *subview in view.subviews)
//    {
//        [self addInputAccessoryViewToViewAndSubviews:subview];
//        if ([subview respondsToSelector:@selector(setInputAccessoryView:)])
//            [subview performSelector:@selector(setInputAccessoryView:) withObject:_keyboardAccessoryView];
//    }
}

#pragma mark - View shifting logic

- (void) checkViewIsVisible:(UIView *)view keyboardFrame:(CGRect)keyboardFrame
{
    if (UIEdgeInsetsEqualToEdgeInsets(_scrollView.contentInset, UIEdgeInsetsZero))
    {
        UIEdgeInsets contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height, 0.0);
        _scrollView.contentInset = contentInset;
        _scrollView.scrollIndicatorInsets = contentInset;
    }
    CGRect viewFrame = [self.view convertRect:view.frame fromView:view.superview];
    CGPoint leftBottomCorner = CGPointMake(viewFrame.origin.x, viewFrame.origin.y + viewFrame.size.height);
    if ([view isKindOfClass:[UITextView class]])
        leftBottomCorner.y = viewFrame.origin.y + 2*((UITextView*)view).font.lineHeight;
    CGPoint scrollPoint = _scrollView.contentOffset;
	float y = leftBottomCorner.y - keyboardFrame.origin.y + _scrollView.contentOffset.y;
	if (leftBottomCorner.y > keyboardFrame.origin.y)
        scrollPoint = CGPointMake(0.0, y);
    else if(viewFrame.origin.y <= 0)
		scrollPoint = CGPointMake(0.0, y > 0 ? y : 0);
    [UIView animateWithDuration:0.4f animations:^{
        _scrollView.contentOffset = scrollPoint;
    }];
}

#pragma mark - Abstract methods

- (NSUInteger) maxLengthForTextField:(UITextField*)textField
{
    return NSUIntegerMax;
}

- (UIView*) lastInputView
{
    ALog(@"Override this method in subclasses");
    return nil;
}

#pragma mark - UITextField delegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    _activeTextField = textField;
    _activeView = textField;
    if (_keyboardShown)
        [self checkViewIsVisible:_activeTextField keyboardFrame:_keyboardFrame];
//    _keyboardAccessoryView.backEnabled = textField.tag > 1;
//    _keyboardAccessoryView.nextEnabled = textField.tag < (self.lastInputView?self.lastInputView.tag:NSIntegerMax);
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger maxLength = [self maxLengthForTextField:textField];
    if ((textField.text.length && range.length == 1) || [string isEqualToString:@"\n"]) 
        return YES;
    if (textField.text.length>=maxLength)
        return NO;
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return [self switchToNextInputView:textField goForward:YES shouldStop:textField == self.lastInputView];
}

#pragma mark - View switching logic

- (BOOL) switchToNextInputView:(UIView *)currentView goForward:(BOOL)goForward shouldStop:(BOOL)shouldStop
{
    BOOL shouldReturn = NO;
    if (shouldStop)
        shouldReturn = [currentView resignFirstResponder];
    else
    {
        UIView *nextView = [_scrollView viewWithTag:currentView.tag+(goForward?1:-1)];
        shouldReturn = [nextView becomeFirstResponder];
    }
    return shouldReturn;
}

#pragma mark - UITextView delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _activeView = textView;
    if (_keyboardShown)
        [self checkViewIsVisible:textView keyboardFrame:_keyboardFrame];
//    _keyboardAccessoryView.backEnabled = textView.tag > 1;
//    _keyboardAccessoryView.nextEnabled = textView.tag < self.lastInputView.tag;
    return YES;
}

/*
 Text view autosctolling support. Idea taken from here:
 https://discussions.apple.com/thread/1794454?start=0&tstart=0
 */
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    CGRect textViewFrame = textView.frame;
    _initialTextViewHeight = textViewFrame.size.height;
    textViewFrame.size.height = _keyboardFrame.origin.y + textView.font.lineHeight*1.2;
    [UIView animateWithDuration:0.5
                     animations:^{
                         textView.frame = textViewFrame;
                     }
                     completion:^(BOOL finished) {
                         if (finished)
                             [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 0)];
                     }];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    CGRect textViewFrame = textView.frame;
    textViewFrame.size.height = _initialTextViewHeight;
    [UIView animateWithDuration:0.5
                     animations:^{
                         textView.frame = textViewFrame;
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [textView scrollRangeToVisible:NSMakeRange(0, 0)];
                     }];
}

#pragma mark - Keyboard accessory view delegate

- (void) nextClicked
{
    [self switchToNextInputView:_activeView goForward:YES shouldStop:NO];
}

- (void) backClicked
{
    [self switchToNextInputView:_activeView goForward:NO shouldStop:NO];
}

- (void) doneClicked
{
    [_activeView resignFirstResponder];
}

@end
