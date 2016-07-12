#import "JSONModel.h"

@class ExampleValueObjModel;
@class ExampleObjModel;
@class ExampleOtherObjectModel;
@protocol ExampleValueObjModel;
@protocol ExampleObjModel;
@protocol ExampleOtherObjectModel;
@protocol ExampleValueModel; @end

@interface ExampleValueModel : JSONModel
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) ExampleValueObjModel<Optional> *obj;
@property (strong, nonatomic) NSArray<ExampleObjModel, ExampleOtherObjectModel, Optional> *arr;
@end
