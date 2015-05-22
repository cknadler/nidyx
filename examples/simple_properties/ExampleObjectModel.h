#import "JSONModel.h"

@protocol ExampleObjectModel
@end

@interface ExampleObjectModel : JSONModel
@property (strong, nonatomic) NSString *value;
@end
