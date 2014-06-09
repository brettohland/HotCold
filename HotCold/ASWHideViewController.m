//
//  ASWHideViewController.m
//  HotCold
//
//  Created by brett ohland on 2014-04-13.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

#import "ASWHideViewController.h"
#import "ASWDefaults.h"

@import CoreLocation;
@import CoreBluetooth;

CBPeripheralManager *perhipheralManager = nil;
CLBeaconRegion *region = nil;

NSDictionary *beaconPerhipheralData;
NSNumber *power = nil;

@interface ASWHideViewController () <CBPeripheralManagerDelegate>

@property NSUUID *uuid;
@property NSNumber *major;
@property NSNumber *minor;

@end

@implementation ASWHideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uuid = [ASWDefaults sharedDefaults].defaultProximityUUID;
    self.major = [NSNumber numberWithShort:0];
    self.minor = [NSNumber numberWithShort:0];
    power = [ASWDefaults sharedDefaults].defaultPower;
    
    region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid
                                                     major:[self.major shortValue]
                                                     minor:[self.minor shortValue]
                                                identifier:BeaconIdentifier];
    beaconPerhipheralData = [region peripheralDataWithMeasuredPower:power];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!perhipheralManager) {
        perhipheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                                   options:nil];
    } else {
        perhipheralManager.delegate = self;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [perhipheralManager stopAdvertising];
    perhipheralManager.delegate = nil;
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"TRANSMITTING");
        [perhipheralManager startAdvertising:beaconPerhipheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff){
        NSLog(@"Transmission Ceased");
        [perhipheralManager stopAdvertising];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
