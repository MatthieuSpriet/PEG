//
//  PEG_PickerViewController.h
//  PEG
//
//  Created by HorsMedia1 on 21/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPIROrderedDictionary.h"

@protocol PEGPickerDelegate;

@interface PEG_PickerViewController : PEG_BaseUIViewController
<
UIPickerViewDataSource,
UIPickerViewDelegate
>
@property (nonatomic, weak) id<PEGPickerDelegate> delegate;

@property (nonatomic, strong) NSArray*           listLargueurColonne;
@property (nonatomic, strong) NSArray*           listValueSelected;
@property (nonatomic, strong) NSArray*                  listAllValues;
@property (nonatomic, strong) NSMutableArray*           listIndexSelectedRow;
@property (nonatomic, assign) NSInteger                 nbColonnesToSee;


-(void)initWithListValue:(NSArray*)listAllValue andListValueSelected:(NSArray*) listValueSelected andNbColonnesToSee:(NSInteger) nbColonnes;

@end


@protocol PEGPickerDelegate <NSObject>

@optional

- (void)formPicker:(PEG_PickerViewController *)_formPicker didChoose:(NSMutableArray *)values;

@end
