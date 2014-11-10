//
//  PEG_PickerViewController.m
//  PEG
//
//  Created by HorsMedia1 on 21/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_PickerViewController.h"
#import "PEG_FMobilitePegase.h"

@interface PEG_PickerViewController ()
- (IBAction)BtnChoisirUIButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerUIPickerView;

@end

@implementation PEG_PickerViewController

// pm141110 TODO: rename that (this is not an initializer !)
- (void)initWithListValue:(NSArray*)listAllValue andListValueSelected:(NSArray*)listValueSelected andNbColonnesToSee:(NSInteger)nbColonnes
{
    self.nbColonnesToSee = nbColonnes;
    self.listIndexSelectedRow = [[NSMutableArray alloc]init];
    self.listAllValues = listAllValue;
    self.listValueSelected = listValueSelected;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listValueSelected)
    {
        for (int nb=0; nb<self.nbColonnesToSee; nb++) {
            
            SPIROrderedDictionary* v_dict = (SPIROrderedDictionary*)[self.listAllValues objectAtIndex:nb];
            NSInteger count = [v_dict count];
            for (int i = 0; i < count; i++)
            {
                NSString *rowKey = [v_dict keyAtIndex:i];
                if ([rowKey isEqualToString:[self.listValueSelected objectAtIndex:nb]])
                {
                    [self.listIndexSelectedRow addObject:[NSNumber numberWithInt:i]];
                    [self.pickerUIPickerView selectRow:i inComponent:nb animated:NO];
                    break;
                }
            }
        }
    }
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)aPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    SPIROrderedDictionary* v_dict = (SPIROrderedDictionary*)[self.listAllValues objectAtIndex:component];
	return [v_dict objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.listIndexSelectedRow replaceObjectAtIndex:component withObject:[NSNumber numberWithInt:row]];
}



#pragma mark ) UIPickerViewDatasource

//TODO TSE PASSER CELA EN PARAMETRE DU COMPOSANT
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if([self.listLargueurColonne objectAtIndex:component] != nil)
    {
    return [[self.listLargueurColonne objectAtIndex:component] floatValue];
    }
    else{
        return 150;
    }
    /*if (component == 0)
        return 170;
    if (component == 1)
        return 70;
    if (component == 2)
        return 60;
    return 150;*/
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//return 1;
    return self.nbColonnesToSee;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger v_retour=0;
    if([self.listAllValues count] > 0){
    SPIROrderedDictionary* v_dict = (SPIROrderedDictionary*)[self.listAllValues objectAtIndex:component];
        v_retour=[v_dict count];
    }
    return v_retour;
}



- (IBAction)BtnChoisirUIButton:(id)sender {
    
    if ((self.delegate != nil) &&
        [(NSObject *)self.delegate respondsToSelector:@selector(formPicker:didChoose:)] &&
        ([self.listAllValues count] > 0))
	{
        if (self.listIndexSelectedRow != nil)
        {
            NSMutableArray* v_listValue = [NSMutableArray array];
            for (int nb=0; nb<self.nbColonnesToSee; nb++) {
                
                NSNumber* v_index = (NSNumber*)[self.listIndexSelectedRow objectAtIndex:nb];
                SPIROrderedDictionary* v_dict = (SPIROrderedDictionary*)[self.listAllValues objectAtIndex:nb];
                [v_listValue addObject: [v_dict objectAtIndex:[v_index integerValue]]];
                
            }
            [self.delegate formPicker:self didChoose:v_listValue];
        }
        else{
            [self.delegate formPicker:self didChoose:nil];
            
        }
	}
}

- (IBAction)BtnAnnulerClicked:(id)sender {
    if ((self.delegate != nil) &&
        [(NSObject *)self.delegate respondsToSelector:@selector(formPicker:didChoose:)] )
	{
        [self.delegate formPicker:self didChoose:nil];
    }
}


@end
