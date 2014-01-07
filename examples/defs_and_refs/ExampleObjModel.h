#import "JSONModel.h"

@interface ExampleObjModel : JSONModel

@property (strong, nonatomic) NSNumber *size;
@property (strong, nonatomic) NSString<Optional> *content;

@end
