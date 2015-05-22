#import "JSONModel.h"

@protocol ExampleModel
@end

@interface ExampleModel : JSONModel
@property (strong, nonatomic) NSNumber<Optional> *int;
@end
