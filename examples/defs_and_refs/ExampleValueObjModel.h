#import "JSONModel.h"

@class ExampleObjModel;
@protocol ExampleObjModel;
@protocol ExampleValueObjModel; @end

@interface ExampleValueObjModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *tag;
@property (strong, nonatomic) ExampleObjModel<Optional> *data;
@end
