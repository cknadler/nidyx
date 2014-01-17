#import "JSONModel.h"

@protocol ExampleModel
@end

@interface ExampleModel : JSONModel

@property (strong, nonatomic) NSArray<Optional> *array;
@property (strong, nonatomic) NSNumber<Optional> *similarStuff;
@property (strong, nonatomic) id *notReallySimilarStuff;
@property (assign, nonatomic) NSInteger positive;
@property (strong, nonatomic) id<Optional> *nothing;
@property (strong, nonatomic) NSNumber<Optional> *notRequired;

@end
