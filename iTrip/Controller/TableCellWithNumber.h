//
//  TableCellWithNumber.h
//  iTrip
//
//  Created by 楊凱霖 on 6/16/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "XIBBasedTableCell.h"

@interface TableCellWithNumber : XIBBasedTableCell
@property (weak, nonatomic) IBOutlet UILabel *tripNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripDateLabel;

@end
