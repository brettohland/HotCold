//
//  ASWDefaults.m
//  HotCold
//
//  Created by brett ohland on 2014-04-15.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

#import "ASWDefaults.h"

NSString *BeaconIdentifier = @"com.example.ampersand-softworks.HotCold";

@implementation ASWDefaults

-(id) init {
    
    self = [super init];
    if (self){
        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"D9EED498-BFDB-43C0-8B55-D06BB74C430B"]];
        _defaultPower = @-59;
    }
    
    return self;
}

+(ASWDefaults*) sharedDefaults {
    
    static id sharedDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDefaults = [[self alloc] init];
    });
    
    return sharedDefaults;
}

- (NSUUID *) defaultProximityUUID {
    return _supportedProximityUUIDs[0];
}

@end
