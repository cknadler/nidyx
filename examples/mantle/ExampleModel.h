#import "Mantle/Mantle.h"

@interface ExampleModel : MTLModel <MTLJSONSerializing> 

@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSNumber *similarStuff;
@property (strong, nonatomic) id *notReallySimilarStuff;
@property (assign, nonatomic) NSInteger positive;
@property (strong, nonatomic) id *nothing;
@property (strong, nonatomic) NSNumber *notRequired;

@end
