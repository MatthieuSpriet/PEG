//
//  PEG_ListeTourneesViewController.h
//  PEG
//
//  Created by HorsMedia1 on 17/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEG_DatePickerViewController.h"

typedef enum {
        DateDebutSelected = 0,
        DateFinSelected = 1,
        None = 2
} PEGDateSelected;

@interface PEG_ListeTourneesViewController : PEG_BaseUIViewController
<
UITableViewDelegate,
PEGDatePickerDelegate
>

@property (nonatomic,assign) PEGDateSelected dateSelected;
//liste de PEG_BeanTournee
@property (nonatomic,strong) NSArray* ListTourneeDate;
@property (nonatomic,strong) NSDate* dateDebut;
@property (nonatomic,strong) NSDate* dateFin;

@end
