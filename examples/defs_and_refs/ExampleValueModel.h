#import "JSONModel.h"
#import "ExampleValueObjModel.h"
#import "ExampleObjModel.h"
#import "ExampleOtherObjectModel.h"

@protocol ExampleValueModel
@end

@interface ExampleValueModel : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) ExampleValueObjModel<Optional> *obj;
@property (strong, nonatomic) NSArray<ExampleObjModel, ExampleOtherObjectModel, Optional> *arr;

@end
