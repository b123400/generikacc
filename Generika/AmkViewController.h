//
//  AmkViewController.h
//  Generika
//
//  Copyright (c) 2012-2017 ywesee GmbH. All rights reserved.
//

#import "Receipt.h"

@interface AmkViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, strong, readonly) Receipt *receipt;

- (void)loadReceipt:(Receipt *)receipt;

@end