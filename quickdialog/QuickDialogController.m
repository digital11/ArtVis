//                                
// Copyright 2011 ESCOZ Inc  - http://escoz.com
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "QuickDialogControllerSubClass.h"

@interface QuickDialogController ()

- (void)_setupQuickDialogController;

@end

@implementation QuickDialogController

@synthesize root;
@synthesize willDisappearCallback = _willDisappearCallback;
@synthesize tableView;
@synthesize selectedTableView;
@synthesize tableRect;
@synthesize contenSize;
@synthesize keyboardVisible;
@synthesize tableOffset;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.root = nil;
        [self _setupQuickDialogController];
    }
    return self;
}

- (id)initWithRoot:(QRootElement *)rootElement {
    self = [super init];
    if (self) {
        self.root = rootElement;
        [self _setupQuickDialogController];
    }
    return self;
}

- (void)dealloc {
    self.root = nil;
    self.tableView = nil;
    [super dealloc];
}

- (void)setRoot:(QRootElement *)inRoot {
    if (root!= nil)
        [root release];
    root = [inRoot retain];
    ((QuickDialogTableView *)self.tableView).root = inRoot;
    self.title = self.root.title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    QuickDialogTableView *quickformTableView = [[[QuickDialogTableView alloc] initWithController:self] autorelease];
    self.tableView = quickformTableView;
    self.tableView.frame = self.view.bounds;
    self.tableRect = self.tableView.frame;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.selectedTableView = self.tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:) name: UIKeyboardDidHideNotification object:nil];
    
    [((QuickDialogTableView *)self.selectedTableView) viewWillAppear];
    [super viewWillAppear:animated];
    if (self.root!=nil)
        self.title = self.root.title;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [super viewWillDisappear:animated];
    if (_willDisappearCallback!=nil){
        _willDisappearCallback();
    }
}

- (void)popToPreviousRootElement {
    if (self.navigationController!=nil){
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)displayViewController:(UIViewController *)newController {
    if (self.navigationController != nil ){
        [self.navigationController pushViewController:newController animated:YES];
    } else {
        [self presentModalViewController:newController animated:YES];
    }
}

- (void)displayViewControllerForRoot:(QRootElement *)inRoot {

    Class controllerClass = nil;
    if (inRoot.controllerName!=NULL){
        controllerClass = NSClassFromString(inRoot.controllerName);
    } else {
        controllerClass = [self class];
    }
    QuickDialogController * newController =  [[((QuickDialogController *)[controllerClass alloc]) initWithRoot:inRoot] autorelease];
    [self displayViewController:newController];
}

+ (QuickDialogController *)controllerForRoot:(QRootElement *)inRoot {
    Class controllerClass = nil;
    if (inRoot.controllerName!=NULL){
        controllerClass = NSClassFromString(inRoot.controllerName);
    } else {
        controllerClass = [self class];
    }
    return [[((QuickDialogController *)[controllerClass alloc]) initWithRoot:inRoot] autorelease];
}

+ (UINavigationController*)controllerWithNavigationForRoot:(QRootElement *)inRoot {
    return [[[UINavigationController alloc] initWithRootViewController:[QuickDialogController controllerForRoot:inRoot]] autorelease];
}

#pragma mark - Private methods

- (void)_setupQuickDialogController {
    self.keyboardVisible = NO;
    self.tableOffset = 0.f;
}

#pragma mark - Protected methods

- (void)keyboardWillShow:(NSNotification *)nsNotification {
    if (!self.keyboardVisible)
        self.contenSize = self.selectedTableView.contentSize;
    NSDictionary *userInfo = nsNotification.userInfo;
    CGRect keyboardRect;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    QuickDialogTableView *quickformTableView = (QuickDialogTableView *)self.selectedTableView;
    float selectedCellTop = (quickformTableView.frame.origin.y + quickformTableView.selectedCell.frame.origin.y);
    float selectedCellBottom = (selectedCellTop + quickformTableView.selectedCell.frame.size.height);
    float keyboardTop = [self.view convertPoint:CGPointMake(keyboardRect.origin.x,keyboardRect.origin.y) fromView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]].y;
    self.tableOffset = selectedCellBottom - keyboardTop;
    //
    if (selectedCellBottom > keyboardTop) {
        [self.selectedTableView setContentOffset:CGPointMake(0.f, self.tableOffset) animated:YES];
    }
    else if ((self.selectedTableView.contentOffset.y - selectedCellTop) < 0.f) {
        [self.selectedTableView setContentOffset:CGPointMake(0.f, 0.f) animated:YES];
    }
}
- (void)keyboardDidShow:(NSNotification *)nsNotification {
    NSDictionary *userInfo = nsNotification.userInfo;
    CGRect keyboardRect;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    self.selectedTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.f, 0.f, keyboardRect.size.height, 0.f);
    self.selectedTableView.contentSize = CGSizeMake(self.selectedTableView.contentSize.width, self.selectedTableView.contentSize.height + keyboardRect.size.height);
    self.keyboardVisible = YES;
}
- (void)keyboardWillHide:(NSNotification *)nsNotification {
    self.selectedTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.selectedTableView.contentSize = self.contenSize;
}
- (void)keyboardDidHide:(NSNotification *)nsNotification {
    self.keyboardVisible = NO;
}


@end