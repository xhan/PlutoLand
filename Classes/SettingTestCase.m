//
//  SettingTestCase.m
//  PlutoLand
//
//  Created by xhan on 10-10-11.
//  Copyright 2010 ixhan.com. All rights reserved.
//

#import "SettingTestCase.h"


@implementation SettingTestCase

@dynamic name, age, score, male;

SettingTestCase* _gInstance;
+ (SettingTestCase*)singleton{
	if (!_gInstance) {
		_gInstance = [[[self class] alloc] init];
	}
	return _gInstance;
}

- (void)loadDefaults{
	self.name = @"xhan";
	self.age = 23;
	self.score = 87.5;
	self.male = YES;
}

+ (void)setupRoutes{
	[self setupProperty:@"name" withType:PLSettingTypeObject];
	[self setupProperty:@"age" withType:PLSettingTypeInt];
	[self setupProperty:@"score" withType:PLSettingTypeFloat];
	[self setupProperty:@"male" withType:PLSettingTypeBool];
}

@end
