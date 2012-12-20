//
//  EquipmentSelectorViewController.h
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/14/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EquipmentSelectorViewControllerDelegate;
@protocol DHEquipmentProtocol;

@interface EquipmentSelectorViewController : UITableViewController

@property (nonatomic, strong) NSArray* equipment;

@property (nonatomic, strong) id<DHEquipmentProtocol> selectedEquipment;

@property (nonatomic, weak) id<EquipmentSelectorViewControllerDelegate> delegate;

@end

@protocol EquipmentSelectorViewControllerDelegate <NSObject>

- (void)equipmentSelectorViewController:(EquipmentSelectorViewController *)viewController
                     didSelectEquipment:(id<DHEquipmentProtocol>)equipment;

- (void)equipmentSelectorViewControllerDidCancel:(EquipmentSelectorViewController *)viewController;

@end
