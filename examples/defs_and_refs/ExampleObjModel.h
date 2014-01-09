#import "JSONModel.h"

@interface ExampleObjModel : JSONModel

@property (assign, nonatomic) double size;
@property (strong, nonatomic) NSString<Optional> *content;

@end
