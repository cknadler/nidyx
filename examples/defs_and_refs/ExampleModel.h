#import "JSONModel.h"
#import "ExampleValueModel.h"

@protocol ExampleModel
@end

@interface ExampleModel : JSONModel

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) ExampleValueModel *value;

@end
