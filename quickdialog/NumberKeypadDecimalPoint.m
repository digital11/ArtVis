//
//  DecimalPointButton.m
//  iDeal
//
//  Created by David Casserly on 13/03/2010.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "NumberKeypadDecimalPoint.h"

static UIImage *backgroundImageDepressed;

@implementation DecimalPointButton

+ (void) initialize {
	backgroundImageDepressed = [[UIImage imageNamed:@"decimalKeyDownBackground.png"] retain];
}

- (id) init {
	if(self = [super initWithFrame:CGRectMake(0, 480, 105, 53)]) { //Initially hidden	
		//[super adjustsImageWhenDisabled:NO];
		self.titleLabel.font = [UIFont systemFontOfSize:35];
		[self setTitleColor:[UIColor colorWithRed:77.0f/255.0f green:84.0f/255.0f blue:98.0f/255.0f alpha:1.0] forState:UIControlStateNormal];	
		[self setBackgroundImage:backgroundImageDepressed forState:UIControlStateHighlighted];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //
        NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        [numberFormatter setLocale:[NSLocale currentLocale]];
		[self setTitle:[numberFormatter decimalSeparator] forState:UIControlStateNormal];
	}
	return self;
}
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	//Bring in the button at same speed as keyboard
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2]; //we lose 0.1 seconds when we display it with timer
	self.frame = CGRectMake(0, 427, 105, 53);
	[UIView commitAnimations];
}

+ (DecimalPointButton *) decimalPointButton {
	DecimalPointButton *button = [[DecimalPointButton alloc] init];
	return [button autorelease];
}

@end

@implementation NumberKeypadDecimalPoint

static NumberKeypadDecimalPoint *keypad;

@synthesize decimalPointButton;
@synthesize showDecimalPointTimer;
@synthesize currentTextField;

#pragma mark - Initialization methods

- (void) dealloc {
	[decimalPointButton release];
	[showDecimalPointTimer release];
	[super dealloc];
}

#pragma mark - Private methods

- (void) addButtonToKeyboard:(DecimalPointButton *)button {	
	//Add a button to the top, above all windows
	NSArray *allWindows = [[UIApplication sharedApplication] windows];
	int topWindow = [allWindows count] - 1;
	UIWindow *keyboardWindow = [allWindows objectAtIndex:topWindow];
	[keyboardWindow addSubview:button];	
}
- (void) addTheDecimalPointToKeyboard {	
	[keypad addButtonToKeyboard:keypad.decimalPointButton];
}
- (void) decimalPointPressed {
	//Check to see if there is a . already
	NSString *currentText = currentTextField.text;
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setLocale:[NSLocale currentLocale]];
	if ([currentText rangeOfString:[numberFormatter decimalSeparator] options:NSBackwardsSearch].length == 0) {
		currentTextField.text = [currentTextField.text stringByAppendingString:[numberFormatter decimalSeparator]];
	}else {
		//alreay has a decimal point
	}
}

+ (NumberKeypadDecimalPoint *) keypadForTextField:(UITextField *)textField {
	if (!keypad) {
		keypad = [[NumberKeypadDecimalPoint alloc] init];
		keypad.decimalPointButton = [DecimalPointButton decimalPointButton];
		[keypad.decimalPointButton addTarget:keypad action:@selector(decimalPointPressed) forControlEvents:UIControlEventTouchUpInside];
	}
	keypad.currentTextField = textField;
	keypad.showDecimalPointTimer = [NSTimer timerWithTimeInterval:0.1 target:keypad selector:@selector(addTheDecimalPointToKeyboard) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:keypad.showDecimalPointTimer forMode:NSDefaultRunLoopMode];
	return keypad;
}

- (void) removeButtonFromKeyboard {
	[self.showDecimalPointTimer invalidate]; //stop any timers still wanting to show the button
	[self.decimalPointButton removeFromSuperview];
}


@end

