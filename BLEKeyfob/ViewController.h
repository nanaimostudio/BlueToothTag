//
//  ViewController.h
//  BLEKeyfob
//
//  Created by zeng on 10/29/12.
//  Copyright (c) 2012 zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitorLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiValueLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *rssiValueProgressBar;
@property (weak, nonatomic) IBOutlet UISwitch *leftSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (weak, nonatomic) IBOutlet UISlider *sliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiValueTextLabel;

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) AVAudioPlayer *player;

@property (assign, nonatomic) BOOL IsSoundAlert;
@property (assign, nonatomic) float progressBarValue;

- (IBAction)scanAndConnectToKeyfobPress:(id)sender;
- (IBAction)rangeOfAlarmChange:(id)sender;
- (IBAction)soundAlarmPress:(id)sender;

@end
