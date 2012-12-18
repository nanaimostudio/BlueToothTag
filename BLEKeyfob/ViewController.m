//
//  ViewController.m
//  BLEKeyfob
//
//  Created by zeng on 10/29/12.
//  Copyright (c) 2012 zeng. All rights reserved.
//

#import "ViewController.h"
#import "TIBLECBKeyfobDefines.h"

@interface ViewController ()
{
}

@end

@implementation ViewController

@synthesize activitorLabel = _activitorLabel;
@synthesize scanButtonLabel = _scanButtonLabel;
@synthesize rssiValueLabel = _rssiValueLabel;
@synthesize rssiValueProgressBar = _rssiValueProgressBar;
@synthesize leftSwitch = _leftSwitch;
@synthesize rightSwitch = _rightSwitch;
@synthesize centralManager = _centralManager;
@synthesize peripheral = _peripheral;
@synthesize player = _player;
@synthesize sliderLabel = _sliderLabel;
@synthesize IsSoundAlert = _IsSoundAlert;
@synthesize progressBarValue = _progressBarValue;

#pragma mark - default methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sliderLabel.value = self.progressBarValue;
    [self setupMusic];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(readRSSIValue) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)scanAndConnectToKeyfobPress:(id)sender
{
    NSLog(@"Scan Button press\n");
   
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (IBAction)rangeOfAlarmChange:(id)sender {
}

- (IBAction)soundAlarmPress:(id)sender {
   
}

#pragma mark - helper methods
- (void)setupMusic
{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    NSURL *url = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"halloween_theme" ofType:@"mp3"]];
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.player prepareToPlay];
}

- (void)popupNotification
{
    NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:3];
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
    if (notifyAlarm)
    {
        notifyAlarm.fireDate = alertTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.repeatInterval = 0;
//        notifyAlarm.soundName = @"halloween_theme.mp3";
        notifyAlarm.alertBody = @"Did you forget your key?";
        
        [app presentLocalNotificationNow:notifyAlarm];
    }
}

-(NSString *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return @"NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    const char * cUUID = CFStringGetCStringPtr(s, 0);
    NSString *UUIDString = [NSString stringWithCString:cUUID encoding:NSUTF8StringEncoding];
    return UUIDString;
}

#pragma mark - CBCentralManagerDelegate methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"state power on\n");
        
        [self.activitorLabel startAnimating];
         [self.scanButtonLabel setTitle:@"Scanning.." forState:UIControlStateNormal];
        
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    else
    {
        NSLog(@"Bluetooth LE device not ready.");
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral\n");
    for (NSString *key in advertisementData.allKeys) {
        NSLog(@"Key named:%@, value:%@\n",key,[advertisementData objectForKey:key]);
    }
    if ([self.peripheral.name rangeOfString:@"Keyfob"].location != NSNotFound) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        NSLog(@"Found a peripheral named:%@ with UUID:%@",self.peripheral.name,[self UUIDToString:self.peripheral.UUID]);

        [self.centralManager connectPeripheral:self.peripheral options:nil];
        [self.scanButtonLabel setTitle:@"connecting to keyfob" forState:UIControlStateNormal];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.peripheral = peripheral;
    NSLog(@"Didconnect Found a peripheral named:%@",self.peripheral.name);

    [self.activitorLabel stopAnimating];
    [self.scanButtonLabel setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    [self.centralManager stopScan];
    NSLog(@"stopScan\n");
    
    [self.peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect Peripheral");
    [self popupNotification];
}

#pragma mark - CBPeripheralDelegate methods
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.peripheral = peripheral;
    int rssiValue = abs([self.peripheral.RSSI intValue]);
    self.rssiValueTextLabel.text = [NSString stringWithFormat:@"%i",rssiValue];
    
    self.rssiValueProgressBar.progress = (rssiValue-40)/60.0;
    self.progressBarValue = self. rssiValueProgressBar.progress;
    
    if (self.rssiValueProgressBar.progress > self.sliderLabel.value) {
        [self.player play];
    }
    else{
        [self.player stop];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    self.peripheral = peripheral;
    for (CBService *service in self.peripheral.services) {
        NSLog(@"Did discover Services with UUID:%@",service.UUID);
    }
    NSLog(@"Did discover Services with UUID:%@",self.peripheral.services);
}

@end
