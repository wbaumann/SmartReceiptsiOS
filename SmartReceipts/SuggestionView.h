//
//  SuggestionView.h
//  SuggestionView
//
//  Created by Victor on 12/2/16.
//  Copyright © 2016 sadf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SuggestionViewDelegate <NSObject>

@required
- (void)suggestionSelected:(NSString *)suggestion;

@end

@interface SuggestionView : UIInputView

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  The list of suggestions being displayed.
 *  The array contains 0-3 strings.
 *
 *  @return Array of NSString's representing the current suggested strings
 */
- (NSArray *)suggestions;

/**
 *  Add a suggestion to display in the view.
 *  If there are already maxSuggestionCount suggestions, the added suggestion will push one of them out.
 *  If there are already maxSuggestionCount suggestions and the input is 'nil' then the last suggestion will be removed.
 *
 *  @param suggestion String to suggest to the user
 */
- (void)addSuggestion:(NSString *)suggestion;

/**
 *  Removes the suggestion from the list of displayed suggestions.
 *  If the string is not in the set then there is no change made.
 *
 *  @param suggestion NSString to remove from the suggested strings
 */
- (void)removeSuggestion:(NSString *)suggestion;

/**
 *  Takes in either NSArray or NSSet and replaces 'suggestions' with the input.
 *  Only the first three arguments are recognized.
 *  Objects should be strings. Undefined behavior otherwise.
 *
 *  @param suggestions NSArray or NSSet with 0-3 NSStrings
 */
- (void)setSuggestions:(NSObject *)suggestions;

@property (weak) id <SuggestionViewDelegate> delegate;

/**
 *  The maximum number of suggestions allowed. Default is 3.
 */
@property (nonatomic) NSUInteger maxSuggestionCount;

@end
