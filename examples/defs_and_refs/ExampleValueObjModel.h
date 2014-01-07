#import "JSONModel.h"
#import "ExampleObjModel.h"

@interface ExampleValueObjModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) ExampleObjModel<Optional> *data;

@end
