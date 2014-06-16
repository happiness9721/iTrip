//
//  TripTableViewCell.m
//  iTrip
//
//  Created by 楊凱霖 on 6/16/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "XIBBasedTableCell.h"

@implementation XIBBasedTableCell

+ (XIBBasedTableCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    XIBBasedTableCell *xibBasedTableViewCell = nil;
    NSObject* nibItem = nil;
    
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[XIBBasedTableCell class]]) {
            xibBasedTableViewCell = (XIBBasedTableCell *)nibItem;
            break; // we have a winner
        }
    }
    return xibBasedTableViewCell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
