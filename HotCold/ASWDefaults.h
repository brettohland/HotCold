//
//  ASWDefaults.h
//  HotCold
//
//  Created by brett ohland on 2014-04-15.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

extern NSString *BeaconIdentifier;

@interface ASWDefaults : NSObject

+(ASWDefaults *) sharedDefaults;

@property (nonatomic, copy, readonly) NSArray *supportedProximityUUIDs;
@property (nonatomic, copy, readonly) NSUUID *defaultProximityUUID;
@property (nonatomic, copy, readonly) NSNumber *defaultPower;

@end
