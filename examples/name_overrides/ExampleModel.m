#import "ExampleModel.h"

@implementation ExampleModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"integer": @"int"
    }];
}

@end
