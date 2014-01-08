#import "JSONModel.h"

@interface ExampleObjModel : JSONModel

@property (nonatomic) double size;
@property (strong, nonatomic) NSString<Optional> *content;

@end
