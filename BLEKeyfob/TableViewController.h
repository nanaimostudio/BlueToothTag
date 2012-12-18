//
//  TableViewController.h
//  BLEKeyfob
//
//  Created by zeng on 11/5/12.
//  Copyright (c) 2012 zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface TableViewController : UITableViewController<CBCentralManagerDelegate, CBPeripheralDelegate>

@property(strong, nonatomic) CBCentralManager *centralManager;
@property(strong, nonatomic) CBPeripheral *peripheral;
@property(strong, nonatomic) NSMutableArray *blePeripherals;

@end
