//
//  TVViewController.m
//  Gallery
//
//  Created by Chris Bower on 5/25/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "TVViewController.h"
#import "AFJSONRequestOperation.h"
#import "ArtView.h"
#import "UIImageView+AFNetworking.h"

@interface TVViewController ()

@end

@implementation TVViewController
@synthesize grid = _grid;
@synthesize artView = _artView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self setGrid:nil];
    [self setArtView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [_grid release];
    [_artView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.frame = CGRectMake(-60, -20, self.view.frame.size.width + (65*4), self.view.frame.size.height + (40 * 4));

    [self displayGrid];
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(displayGrid) userInfo:nil repeats:YES];
}


- (void)displayGrid {
    _oldGrid = self.grid;
    self.grid = [[UIView alloc] initWithFrame:_oldGrid.frame];
    self.grid.alpha = 0;
    [self.view sendSubviewToBack:self.grid];
    
    float padding = 5;
    float width,height;
    
    width = (self.grid.frame.size.width - (padding * 4.0f)) / 5.0f;
    height = (self.grid.frame.size.height - (padding * 2.0f)) / 3.0f;
    
    
    //    http://www.swarmx.com/clients/studio1/index.cfm?api=getARTFEATURE&gridblocks=15
    NSURL *url = [NSURL URLWithString:API(@"art/get_art")];//API(@"api=getARTFEATURE&gridblocks=15")];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        NSMutableArray *layout = [self randomizeGrid:[JSON objectForKey:@"posts"]];
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
            [_grid addSubview:iv];
            [iv release];
        }
        [self.view addSubview:self.grid];
        [UIView animateWithDuration:.5 animations:^{
            _oldGrid.alpha = 0;
            self.grid.alpha = 1;
        } completion:^(BOOL finished) {
            [self performSelectorOnMainThread:@selector(cleanupGrid) withObject:nil waitUntilDone:NO];
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}
- (void)cleanupGrid {
    [_oldGrid removeFromSuperview];
}
- (NSMutableArray *)randomizeGrid:(NSArray *)urls {
    NSMutableArray *available = [NSMutableArray arrayWithArray:urls];
    int photoCount = [available count];
    photoCount -= arc4random_uniform(12);
    
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
    if (num2x2 == 2) {
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
        photoCount -= 2;
    } else if (num2x2 == 1) {
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
        if ([placements count] > 0) {
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
            if (matrix[r][c] == 0) {
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
- (void)showFullTv:(NSDictionary *)art {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _artView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *img = [NSURL URLWithString:[art objectForKey:@"large"]];
    [_artView setImageWithURL:img placeholderImage:nil];
    [UIView animateWithDuration:.5 animations:^{
        _artView.alpha = 1; 
        self.grid.alpha = 0;
    }];
    [self.view bringSubviewToFront:_artView];
}
- (void)hideFullTv {
    [UIView animateWithDuration:.5 animations:^{
        _artView.alpha = 0; 
        self.grid.alpha = 1;
    } completion:^(BOOL finished) {
        
        //[self displayGrid];
        _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(displayGrid) userInfo:nil repeats:YES];
    }];    
}
@end
