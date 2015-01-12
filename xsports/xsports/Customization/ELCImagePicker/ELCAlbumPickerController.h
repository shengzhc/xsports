//
//  AlbumPickerController.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAssetsCollectionViewController.h"

@interface ELCAlbumPickerController : UITableViewController
@property (strong, nonatomic) ELCAssetsCollectionViewController *assetsCollectionViewController;
@property (assign, nonatomic) NSUInteger mode;
@end

