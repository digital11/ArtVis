//
//  PagingGridViewController.m
//  Gallery
//
//  Created by Chris Bower on 6/18/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "PagingGridViewController.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "ArtView.h"
#import "DetailDialogViewController.h"
#import "AppDelegate.h"

@interface PagingGridViewController ()

@end

@implementation PagingGridViewController
@synthesize scroller = _scroller;
- (id)initWithFrame:(CGRect)frame andQuery:(NSDictionary *)query {
    self = [super init];
    if (self) {
        self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.opaque = NO;
        self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scroller.backgroundColor = [UIColor clearColor];
        self.scroller.opaque = NO;
        self.scroller.pagingEnabled = YES;
        self.scroller.clipsToBounds = NO;
        self.scroller.delegate = self;
        [self.view addSubview:self.scroller];

        _inited = NO;

        _url = [NSMutableString stringWithString:API(@"art/get_art/?exclude=tags,categories")];
        for (NSString *key in [query allKeys]) {
            [_url appendFormat:@"&%@=%@",key,[query objectForKey:key]];
        }
        [_url retain];
        _page = 1;
        _pages = [[NSMutableArray array] retain];
        [self fetch:_page];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scroller = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)dealloc {
    [_pages release];
    [_url release];
    [_scroller release];
    [super dealloc];
}
- (void)gridTap:(UITapGestureRecognizer *)tap {

    
    NSDictionary *art = [(ArtView*)tap.view art];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    DetailDialogViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"detailDialog"];
    vc.art = art;
    [vc willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0];
    [vc didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
    [self.view addSubview:vc.view];
    
    [vc retain];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
   
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageHeight = scrollView.frame.size.height;
    float fractionalPage = scrollView.contentOffset.y / pageHeight;
    NSInteger page = lround(fractionalPage)+1;
    if (previousPage != page) {
        _page = page;
        if (_page+1 <= _numPages && _page+1 > [_pages count]) {
            [self fetch:_page+1];
        }
        previousPage = page;
    }
}
- (void)fill:(UIView *)gridPage withLayout:(NSArray *)layout {
    
    float padding = 5;
    float width,height;
    
    width = (self.scroller.frame.size.width - (padding * 4.0f)) / 5.0f;
    height = (self.scroller.frame.size.height - (padding * 2.0f)) / 3.0f;
    
    for (NSDictionary *dict in layout) {
        CGRect rect = [[dict objectForKey:@"rect"] CGRectValue];
        CGRect frame = CGRectMake(rect.origin.x * width + rect.origin.x * padding, rect.origin.y * height + rect.origin.y * padding, rect.size.width * width + ((rect.size.width - 1.0f) * padding), rect.size.height * height + ((rect.size.height - 1.0f) * padding));
        NSDictionary *art = [dict objectForKey:@"art"];
        NSURL *img = [NSURL URLWithString:[art objectForKey:@"small"]];
        ArtView *iv = [[ArtView alloc] initWithFrame:frame];
        
        iv.art = art;
        iv.backgroundColor = [UIColor blackColor];
        iv.alpha = 0;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        [iv setImageWithURL:img placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
            [UIView animateWithDuration:1 animations:^{
                iv.alpha = 1; 
            }];
        }
                    failure:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gridTap:)];
        [iv addGestureRecognizer:tap];
        iv.userInteractionEnabled = YES;
        [tap release];
        [gridPage addSubview:iv];
        [iv release];
    }
}
- (void)fetch:(int)page {
     
    float padding = 5;
    float width,height;
    
    width = (self.scroller.frame.size.width - (padding * 4.0f)) / 5.0f;
    height = (self.scroller.frame.size.height - (padding * 2.0f)) / 3.0f;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&page=%d",_url,page]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!_inited) {
            _inited = YES;
            _numPages = [[JSON objectForKey:@"pages"] intValue];
            _scroller.contentSize = CGSizeMake(_scroller.frame.size.width, _scroller.frame.size.height * _numPages);
            if (_numPages > 1) {
                [self fetch:2];
            }
        }
        UIView *gridPage = [[UIView alloc] initWithFrame:CGRectMake(0, _scroller.frame.size.height * (page - 1), _scroller.frame.size.width, _scroller.frame.size.height)];
        gridPage.backgroundColor = [UIColor clearColor];
        gridPage.opaque = NO;
        
        NSMutableArray *layout = [self randomizeGrid:[JSON objectForKey:@"posts"]];
        [_pages addObject:layout];
        [self fill:gridPage withLayout:layout];
        [_scroller addSubview:gridPage];
        [gridPage release];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
}
- (NSMutableArray *)randomizeGrid:(NSArray *)urls {
    NSMutableArray *available = [NSMutableArray arrayWithArray:urls];
    int photoCount = [available count];
    //photoCount -= arc4random_uniform(12);
    
    NSMutableArray *finished = [NSMutableArray arrayWithCapacity:photoCount];
    int** matrix = (int**)malloc(3 * sizeof(int*));
    
    
    //int (*matrix)[3] = malloc(3 * sizeof(int));
    for (int j=0; j<3; j++) {
        matrix[j] = malloc(5 * sizeof(int));
        for (int k=0; k<5; k++) {
            matrix[j][k] = 0;
        }
    }
    int slots = 15;    
    int possible2x2 = slots - photoCount;
    
    if (possible2x2 >= 8)
        possible2x2 = 2;
    else if (possible2x2 >= 4)
        possible2x2 = 1;
    else
        possible2x2 = 0;
    
    int num2x2 = arc4random_uniform(possible2x2+1);
    slots = slots - (num2x2 * 4);
    
    slots = slots - (photoCount - num2x2);
    int num1x2 = 0;
    while (slots > 0) {
        num1x2++;
        slots--;
    }
    
    // Start placing 4x4's
    if (num2x2 == 2 && [available count] > 0) {
        // 1 has to start on column 0 or 1, the other on column 2 or 3, depending on value of first
        int c = arc4random_uniform(2);
        int r = arc4random_uniform(2); // Has to start on row 0 or row 1
        NSDictionary *art = [available objectAtIndex:arc4random_uniform([available count] - 1)];
        [available removeObject:art];
        [finished addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          art, @"art", 
          [NSValue valueWithCGRect:CGRectMake(c, r, 2, 2)], @"rect",
          nil]];
        
        
        matrix[r][c] = matrix[r][c+1] = matrix[r+1][c] = matrix[r+1][c+1] = 4;
        
        photoCount -= 1;
        if ([available count] > 0) {
            if (c == 1)
                c = 3;
            else
                c = arc4random_uniform(2) + 2;
            r = arc4random_uniform(2); // Has to start on row 0 or row 1
            art = [available objectAtIndex:arc4random_uniform([available count])];
            [available removeObject:art];
            [finished addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              art, @"art", 
              [NSValue valueWithCGRect:CGRectMake(c, r, 2, 2)], @"rect",
              nil]];
            
            matrix[r][c] = matrix[r][c+1] = matrix[r+1][c] = matrix[r+1][c+1] = 4;
            photoCount -= 1;
        }
    } else if (num2x2 == 1 && [available count] > 0) {
        // Can be placed on columns 0 - 3 and rows 0 - 1
        int c = arc4random_uniform(4);
        int r = arc4random_uniform(2);
        NSDictionary *art = [available objectAtIndex:arc4random_uniform([available count])];
        [available removeObject:art];
        [finished addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          art, @"art", 
          [NSValue valueWithCGRect:CGRectMake(c, r, 2, 2)], @"rect",
          nil]];
        
        matrix[r][c] = matrix[r][c+1] = matrix[r+1][c] = matrix[r+1][c+1] = 4;
        photoCount--;
    }
    
    while (num1x2 > 0) {
        
        // Find possible placements from remaining positions
        NSMutableArray *placements = [NSMutableArray array];
        for (int j=0;j<3;j++) {
            for (int k=0;k<5;k++) {
                if (matrix[j][k] == 0 && k < 4 && matrix[j][k+1] == 0) {
                    // Possible horizontal
                    [placements addObject:[NSValue valueWithCGRect:CGRectMake(k, j, 2, 1)]];
                }
                if (matrix[j][k] == 0 && j < 2 && matrix[j+1][k] == 0) {
                    // Possible vertical
                    [placements addObject:[NSValue valueWithCGRect:CGRectMake(k, j, 1, 2)]];
                }
            }
        }
        if ([placements count] > 0 && [available count] > 0) {
            // Randomly choose a placement to use
            CGRect rect = [(NSValue *)[placements objectAtIndex:arc4random_uniform([placements count])] CGRectValue];
            NSDictionary *art = [available objectAtIndex:arc4random_uniform([available count])];
            [available removeObject:art];
            [finished addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              art, @"art", 
              [NSValue valueWithCGRect:rect], @"rect",
              nil]];
            
            matrix[(int)rect.origin.y][(int)rect.origin.x] = matrix[(int)rect.origin.y + (int)rect.size.height - 1][(int)rect.origin.x + (int)rect.size.width - 1] = 2;
            
        } else {
            // This is bad...             
        }
        
        
        num1x2--;
    }
    
    for (int r=0;r<3;r++) {
        for (int c=0;c<5;c++) {
            if (matrix[r][c] == 0 && [available count] > 0) {
                NSDictionary *art = [available objectAtIndex:arc4random_uniform([available count])];
                [available removeObject:art];
                [finished addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  art, @"art", 
                  [NSValue valueWithCGRect:CGRectMake(c, r, 1, 1)], @"rect",
                  nil]];
                matrix[r][c] = 1;
            }
        }
    }
    
    NSMutableString *str = [NSMutableString string];
    
    
    for (int j=0; j<3; j++) {
        [str appendString:@"\n"];
        for (int k=0; k<5; k++) {
            [str appendFormat:@"%d ",matrix[j][k]];
        }
        free(matrix[j]);        
    }
    free(matrix);
    NSLog(@"%@",str);
    
    return finished;
}
@end
