//
//  EMBaseInputViewController.h
//  EmbeddedControl
//
//  Created by Yaroslav Vorontsov on 22.11.11.
//  Copyright (c) 2011 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMContextPasser.h"

@interface EMBaseInputViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, EMContextPasser>
{
    BOOL _isViewVisible;
    __weak UIScrollView *_scrollView;
    __weak UITextField *_activeTextField;
    __weak UIView *_activeView;
    //PLKeyboardAccessoryView *_keyboardAccessoryView;
    BOOL _keyboardShown;
    CGRect _keyboardFrame;
    CGFloat _initialTextViewHeight;
}
@property (nonatomic, weak) UIView *activeView;
@property (nonatomic, weak) UITextField *activeTextField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
//@property (nonatomic, retain) PLKeyboardAccessoryView *keyboardAccessoryView;
@property (nonatomic, readonly) UIView *lastInputView;
- (void) keyboardWillShow:(NSNotification*)notification;
- (void) keyboardDidShow:(NSNotification*)notification;
- (void) keyboardWillHide:(NSNotification*)notification;
- (void) keyboardDidHide:(NSNotification*)notification;
- (NSUInteger) maxLengthForTextField:(UITextField*)textField;
- (void) backgroundTapped:(UITapGestureRecognizer*)recognizer;
- (BOOL) switchToNextInputView:(UIView*)currentView goForward:(BOOL)goForward shouldStop:(BOOL)shouldStop;
@end
