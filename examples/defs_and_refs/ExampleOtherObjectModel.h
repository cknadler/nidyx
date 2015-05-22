#import "JSONModel.h"

@protocol ExampleOtherObjectModel
@end

@interface ExampleOtherObjectModel : JSONModel
@property (strong, nonatomic) NSString *data;
@end
