//
//  SPEvent.h
//  Spire
//
//  Created by Jorge Gonzalez on 5/29/12.
//  Copyright (c) 2012 Spire.io. All rights reserved.
//

#import "SPResource.h"

typedef enum{
    SPResourceEventMessage = 0,
    SPResourceEventJoin,
    SPResourceEventPart,
} SPResourceEventType;

@interface SPEvent : SPResource{
    SPResourceEventType _type;
}

@property(nonatomic, assign) SPResourceEventType type;

- (id)initWithResourceModel:(SPResourceModel *)model apiSchemaModel:(SPApiSchemaModel *)schema type:(SPResourceEventType)eventType;

- (id)getContent;
- (NSString *)getTimestamp;
- (NSString *)getChannelName;

@end


@interface SPMessage : SPEvent{
}
@end

@interface SPJoin : SPEvent{
}
@end

@interface SPPart : SPEvent{
}
@end
