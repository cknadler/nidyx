#import "JSONModel.h"
#import "ExampleValueObjModel.h"

@protocol ExampleObjModel
@end

@protocol ExampleOtherObjectModel
@end

@interface ExampleValueModel : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) ExampleValueObjModel<Optional> *obj;
@property (strong, nonatomic) NSArray<ExampleObjModel, ExampleOtherObjectModel, Optional> *arr;

@end
