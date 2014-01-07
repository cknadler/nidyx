#import "JSONModel.h"
#import "ExampleValueObjModel.h"

@interface ExampleValueModel : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) ExampleValueObjModel<Optional> *obj;

@end
