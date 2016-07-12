#import "JSONModel.h"

@class ExampleValueModel;
@protocol ExampleValueModel;
@protocol ExampleModel; @end

@interface ExampleModel : JSONModel
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) ExampleValueModel *value;
@end
