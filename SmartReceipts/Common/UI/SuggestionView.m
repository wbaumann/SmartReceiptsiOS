//
//  SuggestionView.m
//  SuggestionView
//
//  Created by Victor on 12/2/16.
//  Copyright © 2016 sadf. All rights reserved.
//

#import "SuggestionView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation SuggestionView {
    NSMutableOrderedSet *_suggestions;
    NSMutableArray *_suggestionButtons;
}

- (instancetype)init {
    self = [self initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 36.0f)];
    
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame inputViewStyle:UIInputViewStyleKeyboard];
    
    if (self) {
        _suggestions = [[NSMutableOrderedSet alloc] initWithCapacity:3];
        self.maxSuggestionCount = 3;
        _suggestionButtons = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor colorWithRed:0.73 green:0.76 blue:0.79 alpha:1.00];
    }
    
    return self;
}

#pragma mark - Modifying Suggestions

- (void)addSuggestion:(NSString *)suggestion {
    if (suggestion) {
        [_suggestions addObject:suggestion];
    }
    
    while (_suggestions.count > self.maxSuggestionCount) {
        [_suggestions removeObjectAtIndex:self.maxSuggestionCount];
    }
}

- (void)removeSuggestion:(NSString *)suggestion {
    [_suggestions removeObject:suggestion];
}

- (void)setSuggestions:(NSObject *)suggestions {
    if ([suggestions respondsToSelector:@selector(countByEnumeratingWithState:objects:count:)]) {
        [_suggestions removeAllObjects];
        
        for (NSString *suggestion in (NSArray *)suggestions) {
            if (_suggestions.count < self.maxSuggestionCount) {
                [_suggestions addObject:suggestion];
            } else {
                break;
            }
        }
    }
}

- (NSArray *)suggestions {
    NSMutableArray *suggestionsArray = [[NSMutableArray alloc] initWithCapacity:_suggestions.count];
    for (NSString *suggestion in _suggestions) {
        [suggestionsArray addObject:suggestion];
    }
    
    return suggestionsArray;
}

#pragma mark - Visual Layout of Suggestions

- (void)layoutSubviews {
    [self layoutSuggestions];
}

- (void)layoutSuggestions {
    for (UIView *subview in _suggestionButtons) {
        [subview removeFromSuperview];
    }
    
    [_suggestionButtons removeAllObjects];
    
    for (int i = 0; i < (int)_suggestions.count; i++) {
        NSString *suggestion = _suggestions[i];
        UIButton *suggestionButton = [[UIButton alloc] initWithFrame:CGRectMake(i * self.bounds.size.width/_suggestions.count, 0.0f, self.bounds.size.width/_suggestions.count, self.bounds.size.height)];
        [suggestionButton setTitle:suggestion forState:UIControlStateNormal];
        suggestionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        suggestionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [suggestionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [suggestionButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:suggestionButton];
        
        if (i > 0) {
            UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.5f, self.bounds.size.height)];
            whiteLine.backgroundColor = [UIColor whiteColor];
            [suggestionButton addSubview:whiteLine];
        }
        
        [_suggestionButtons addObject:suggestionButton];
    }
}

#pragma mark - Selecting a Suggestion

- (void)buttonTouched:(UIButton *)button {
    NSTimeInterval animationDuration = 0.09f;
    [UIView animateWithDuration:animationDuration animations:^{
        [button setBackgroundColor:[UIColor whiteColor]];
        
        if ([self.delegate respondsToSelector:@selector(suggestionSelected:)]) {
            [self performSelector:@selector(suggestionSelected:) withObject:button.currentTitle afterDelay:animationDuration * 0.9f];
        }
        
        [button performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:animationDuration];
    }];
}

- (void)suggestionSelected:(NSString *)suggestion {
    if ([self.delegate respondsToSelector:@selector(suggestionSelected:)]) {
        [self.delegate suggestionSelected:suggestion];
    }
}

@end
