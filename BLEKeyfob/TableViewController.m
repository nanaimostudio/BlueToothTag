//
//  TableViewController.m
//  BLEKeyfob
//
//  Created by zeng on 11/5/12.
//  Copyright (c) 2012 zeng. All rights reserved.
//

#import "TableViewController.h"
#import <dispatch/dispatch.h>

@interface TableViewController ()
{
    CBCharacteristic *cha;
    dispatch_queue_t backgroundQueue;
}
@end

@implementation TableViewController
@synthesize centralManager = _centralManager;
@synthesize peripheral = _peripheral;
@synthesize blePeripherals = _blePeripherals;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView setRowHeight:100.0f];
    [self.tableView cellForRowAtIndexPath:0].textLabel.text = @"test";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%i",self.blePeripherals.count);
    return [self.blePeripherals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    if (self.blePeripherals.count == 0) {
        cell.textLabel.text = @"Scanning..";
    }
    
    UILabel *deviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    deviceNameLabel.text = [(CBPeripheral *)[self.blePeripherals objectAtIndex:indexPath.row] name];
    [cell.contentView addSubview:deviceNameLabel];
    
    UILabel *deviceUUIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
    deviceUUIDLabel.text = [self UUIDToString:[[self.blePeripherals objectAtIndex:indexPath.row] UUID]];
    [cell.contentView addSubview:deviceUUIDLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
//    if (indexPath.row == 0) {
//        NSString *serviceUUID = @"1802";
//        NSString *charUUID = @"2a06";
//        NSLog(@"first row selected");
//        for (CBService *service in self.peripheral.services) {
//            if ([service.UUID isEqual:[CBUUID UUIDWithString:serviceUUID]]) {
//                NSLog(@"find 1802");
//                for (CBCharacteristic *characteristic in service.characteristics) {
//                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:charUUID]]) {
//                        NSLog(@"find 2a06");
//                        Byte buzVal = 0x01;
//                        NSData *d = [[NSData alloc] initWithBytes:&buzVal length:1];
//                        
//                        [self.peripheral writeValue:d forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
//                    }
//                }
//            }
//        }
//        
//    }
//    if (indexPath.row == 1) {
//        NSString *serviceUUID = @"1802";
//        NSString *charUUID = @"2a06";
//        NSLog(@"first row selected");
//        for (CBService *service in self.peripheral.services) {
//            if ([service.UUID isEqual:[CBUUID UUIDWithString:serviceUUID]]) {
//                NSLog(@"find 1802");
//                for (CBCharacteristic *characteristic in service.characteristics) {
//                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:charUUID]]) {
//                        NSLog(@"find 2a06");
//                        Byte buzVal = 0x02;
//                        NSData *d = [[NSData alloc] initWithBytes:&buzVal length:1];
//                        
//                        [self.peripheral writeValue:d forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
//                    }
//                }
//            }
//        }
//    }
//    if (indexPath.row == 2) {
//        NSString *serviceUUID = @"1802";
//        NSString *charUUID = @"2a06";
//        NSLog(@"first row selected");
//        for (CBService *service in self.peripheral.services) {
//            if ([service.UUID isEqual:[CBUUID UUIDWithString:serviceUUID]]) {
//                NSLog(@"find 1802");
//                for (CBCharacteristic *characteristic in service.characteristics) {
//                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:charUUID]]) {
//                        NSLog(@"find 2a06");
//                        Byte buzVal = 0x00;
//                        NSData *d = [[NSData alloc] initWithBytes:&buzVal length:1];
//                        
//                        [self.peripheral writeValue:d forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
//                    }
//                }
//            }
//        }
//                   
//    }

    [self.centralManager connectPeripheral:[self.blePeripherals objectAtIndex:indexPath.row] options:nil];
}

#pragma mark - CBCentralManager Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    NSMutableArray *peripherals = [self mutableArrayValueForKey:@"_blePeripherals"];
    if( ![self.blePeripherals containsObject:peripheral] ){
        [peripherals addObject:peripheral];
        NSLog(@"refresh");
        [self.tableView reloadData];
    }
        

//    [self.centralManager connectPeripheral:self.peripheral options:nil];
}

-(NSString *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return @"NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    const char * cUUID = CFStringGetCStringPtr(s, 0);
    NSString *UUIDString = [NSString stringWithCString:cUUID encoding:NSUTF8StringEncoding];
    return UUIDString;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.peripheral = peripheral;
    NSLog(@"did connect with UUID:%@, name:%@",[self UUIDToString:self.peripheral.UUID],self.peripheral.name);
    [self.peripheral discoverServices:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Did connect to Peripheral" message:[NSString stringWithFormat:@"%@",self.peripheral.name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.peripheral = peripheral;
    NSLog(@"Disconnect with UUID:%@, name:%@",[self UUIDToString:self.peripheral.UUID],self.peripheral.name);
    [self popNotification];
}

#pragma mark - CBPeipheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    self.peripheral = peripheral;
    for (CBService *service in self.peripheral.services) {
       [self.peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    self.peripheral = peripheral;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
                [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    }
    if ( [service.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]] )
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            /* Read device name */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:CBUUIDDeviceNameString]])
            {
                [self.peripheral readValueForCharacteristic:aChar];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
        const char* str = [characteristic.value bytes];
        NSLog(@"updated value,%i\n",str[0]);
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDDeviceNameString]])
    {
        NSString * deviceName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Device Name = %@", deviceName);
    }
}

- (void)popNotification
{
    NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:2];
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
    if (notifyAlarm)
    {
        notifyAlarm.fireDate = alertTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.repeatInterval = 0;
        notifyAlarm.soundName = @"halloween_theme.mp3";
        notifyAlarm.alertBody = @"Did you forget your key?";
        
        [app presentLocalNotificationNow:notifyAlarm];
    }
}

@end
