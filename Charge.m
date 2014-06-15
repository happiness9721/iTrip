//
//  Charge.m
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "Charge.h"

@implementation Charge

-(void) printCharge
{
    NSString* string = [NSString stringWithFormat:@"Charge: tid=%d, name=%@, pay=%d, time=%@", self.tid, self.name, self.pay, self.time];
    NSLog(@"%@", string);
}

@end
