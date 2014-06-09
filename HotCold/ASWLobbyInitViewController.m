//
//  ASWLobbyInitViewController.m
//  HotCold
//
//  Created by brett ohland on 2014-05-24.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

#import "ASWLobbyInitViewController.h"
@import MultipeerConnectivity;

static NSString * const HotColdServiceType = @"hotcold-service";

@interface ASWLobbyInitViewController () <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate>

@property IBOutlet UILabel *myDeviceName;
@property IBOutlet UILabel *theirDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *theirButtonCounter;
@property (weak, nonatomic) IBOutlet UIButton *incrementCounterButton;

@property MCSession *session;
@property MCNearbyServiceAdvertiser *advertiser;
@property MCNearbyServiceBrowser *browser;
@property MCPeerID *localPeerID;
@property NSMutableArray *connectedPeers;

@end


@implementation ASWLobbyInitViewController {
    NSNumber *buttonCounter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    self.myDeviceName.text = @"";
    self.theirDeviceName.text = @"";
    self.theirButtonCounter.text = @"0 times";
    self.incrementCounterButton.enabled = NO;
    buttonCounter = [[NSNumber alloc] initWithInt:0];
    self.connectedPeers = [[NSMutableArray alloc] init];
    
    // Browser for others
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerID
                                                    serviceType:HotColdServiceType];
    self.browser.delegate = self;
    
    // Advertise to others
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID
                                                        discoveryInfo:nil
                                                          serviceType:HotColdServiceType];
    self.advertiser.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.myDeviceName.text = self.localPeerID.displayName;
    
    // Start both advertising and browsing at the same time.
    // Either will stop both the adversiting and browsing
    [self.browser startBrowsingForPeers];
    [self.advertiser startAdvertisingPeer];
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID
      withContext:(NSData *)context
invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    // Creates a session anytime someone connects using the service.
    NSLog(@"Received Invitation from %@", peerID.displayName);
    
    if (!self.session) {
        self.session = [[MCSession alloc] initWithPeer:self.localPeerID
                                      securityIdentity:nil
                                  encryptionPreference:MCEncryptionNone];
        self.session.delegate = self;
        invitationHandler(YES, self.session);
        
        [self.advertiser stopAdvertisingPeer];
        [self.browser stopBrowsingForPeers];
    }
    
}

#pragma mark - MCNearbyServiceBrowserDelegate

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSLog(@"FOUND PEER %@", peerID.displayName);
    
    if (!self.session){
        self.session = [[MCSession alloc] initWithPeer:self.localPeerID
                                      securityIdentity:nil
                                  encryptionPreference:MCEncryptionNone];
        self.session.delegate = self;
        
        [browser invitePeer:peerID toSession:self.session withContext:nil timeout:5];
        
        [self.advertiser stopAdvertisingPeer];
        [self.browser stopBrowsingForPeers];
    }
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"LOST PEER %@", peerID);
    
    // Kill the session
    self.session = nil;

    // Start looking again.
    [self.advertiser startAdvertisingPeer];
    [self.browser startBrowsingForPeers];
}

#pragma mark - MCSessionDelegate

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Message received: %@", message);
    dispatch_async(dispatch_get_main_queue(),^ {
        self.theirButtonCounter.text = message;
    });
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream
      withName:(NSString *)streamName
      fromPeer:(MCPeerID *)peerID {
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName
      fromPeer:(MCPeerID *)peerID
  withProgress:(NSProgress *)progress {
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName
      fromPeer:(MCPeerID *)peerID
         atURL:(NSURL *)localURL
     withError:(NSError *)error {
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSArray *stateStringRepresentation = @[@"MCSessionStateNotConnected", @"MCSessionStateConnecting", @"MCSessionStateConnected" ];

    NSLog(@"SESSION STATE CHANGE: %@", stateStringRepresentation[state] );
    
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected to %@", peerID.displayName);

        [self.connectedPeers addObject:peerID];

        dispatch_async(dispatch_get_main_queue(),^ {
            self.theirDeviceName.text = peerID.displayName;
            self.incrementCounterButton.enabled = YES;
        });
        
        [self.view setNeedsDisplay];
    }
}

- (IBAction)incrementCounterAndSend:(UIButton *)sender {
    buttonCounter = @([buttonCounter intValue] + 1);
    NSString *message = [NSString stringWithFormat:@"%d times", [buttonCounter integerValue]];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    if (![self.session sendData:data
                        toPeers:self.connectedPeers
                       withMode:MCSessionSendDataReliable
                          error:&error]) {
        NSLog(@"[Error] %@", error);
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // HYGENE!
    [self.advertiser stopAdvertisingPeer];
    [self.browser stopBrowsingForPeers];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
