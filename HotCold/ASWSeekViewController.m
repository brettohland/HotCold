//
//  ASWSeekViewController.m
//  HotCold
//
//  Created by brett ohland on 2014-04-13.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

#import "ASWSeekViewController.h"
#import "ASWDefaults.h"
@import CoreLocation;

@interface ASWSeekViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *howClose;

@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;

@end

@implementation ASWSeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beacons = [[NSMutableDictionary alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    for (NSUUID *uuid in [ASWDefaults sharedDefaults].supportedProximityUUIDs) {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        self.rangedRegions[region] = [NSArray array];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (CLBeaconRegion *region in self.rangedRegions) {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    for (CLBeaconRegion *region in self.rangedRegions) {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {

    if ([beacons count] > 0) {
        // Let's assume we're getting one beacon for now.
        CLBeacon *beacon = beacons[0];
        self.howClose.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
    } else {
      self.howClose.text = @"No Beacons found";
    }
    
}

@end
