//
//  Trip.m
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "Trip.h"

@implementation Trip
 
-(void) printTrip
{
    NSString* string = [NSString stringWithFormat:@"Trip: tid=%d, name=%@, detail=%@, date=%@, budget=%d, location=%@, latitude=%g, longitude=%g", self.tid, self.name, self.detail, self.date, self.budget, self.location, self.latitude, self.longitude];
    NSLog(@"%@", string);
}
@end
