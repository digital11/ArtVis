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

@implementation QuickDialogController (Loading)

- (UIView *)createLoadingView {
    
    UIView *loading = [[[UIView alloc] init] autorelease];
    loading.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    loading.frame = CGRectMake(0, 0, self.selectedTableView.frame.size.width, self.selectedTableView.frame.size.height);
    loading.tag = 1123002;
    UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    [activity startAnimating];
    [activity sizeToFit];
    activity.center = CGPointMake(loading.center.x, loading.frame.size.height/3);
    [loading addSubview:activity];

    [self.selectedTableView.superview addSubview:loading];
    [self.selectedTableView.superview bringSubviewToFront:loading];
    return loading;
}


- (void)loading:(BOOL)visible {
   UIView *loadingView = [self.selectedTableView.superview viewWithTag:1123002];
    if (loadingView==nil){
        loadingView = [self createLoadingView];
    }

    self.selectedTableView.userInteractionEnabled = !visible;

    if (visible)
        loadingView.hidden = NO;

    loadingView.alpha = visible ? 0 : 1;
    [UIView animateWithDuration:0.3
                     animations:^{
                          loadingView.alpha = visible ? 1 : 0;
                     }
                     completion: ^(BOOL  finished) {
                         if (!visible)
                              loadingView.hidden = YES;
                     }];
}
@end