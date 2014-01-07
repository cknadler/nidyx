#import "JSONModel.h"

@interface ExampleModel : JSONModel

@property (strong, nonatomic) NSArray<Optional> *array;
@property (strong, nonatomic) NSNumber<Optional> *similar_stuff;
@property (strong, nonatomic) id *not_really_similar_stuff;
@property (assign, nonatomic) NSUInteger positive;
@property (strong, nonatomic) id<Optional> *nothing;
@property (strong, nonatomic) NSNumber<Optional> *not_required;

@end
