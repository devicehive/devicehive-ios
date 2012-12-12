//
//  EquipmentSelectorViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHEquipmentData;

@protocol EquipmentSelectorViewControllerDelegate;

@interface EquipmentSelectorViewController : UITableViewController

@property (nonatomic, strong) NSArray* equipment;

@property (nonatomic, strong) DHEquipmentData* selectedEquipment;

@property (nonatomic, weak) id<EquipmentSelectorViewControllerDelegate> delegate;

@end

@protocol EquipmentSelectorViewControllerDelegate <NSObject>

- (void)equipmentSelectorViewController:(EquipmentSelectorViewController *)viewController
               didSelectEquipment:(DHEquipmentData *)equipment;

- (void)equipmentSelectorViewControllerDidCancel:(EquipmentSelectorViewController *)viewController;

@end
