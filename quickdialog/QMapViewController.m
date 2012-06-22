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

#import <MapKit/MKAnnotation.h>
#import "QMapViewController.h"
#import "QMapAnnotation.h"

@interface QMapViewController ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) MKMapView * mapView;
@property (nonatomic, retain) NSString *mapTitle;

@end

@implementation QMapViewController

@synthesize coordinate;
@synthesize mapView;
@synthesize mapTitle;

- (QMapViewController *)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)inCoordinate {
    self = [self initWithCoordinate:inCoordinate];
    self.mapTitle = title;
    return self;
}

- (QMapViewController *)initWithCoordinate:(CLLocationCoordinate2D)inCoordinate {

    self = [super init];
    if (self != nil){
        self.coordinate = inCoordinate;
        self.mapView = [[[MKMapView alloc] init] autorelease];
        self.mapView.delegate = self;

        self.view = self.mapView;
    }
    return self;
}

-(void)dealloc {
    self.mapView = nil;
    self.mapTitle = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    self.mapView.region = MKCoordinateRegionMake(self.coordinate, MKCoordinateSpanMake(0.05, 0.05));
    self.mapView.zoomEnabled = YES;
    [self.mapView regionThatFits:self.mapView.region];

    QMapAnnotation *current = [[[QMapAnnotation alloc] initWithCoordinate:self.coordinate title:self.mapTitle] autorelease];
    [self.mapView addAnnotation:current];

    self.title = self.mapTitle;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"reuse"] autorelease];
    pin.animatesDrop = YES;
    pin.canShowCallout = NO;
    pin.pinColor = MKPinAnnotationColorGreen;
    return pin;
}

@end