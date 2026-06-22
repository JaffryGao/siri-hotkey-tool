#import <Foundation/Foundation.h>
#import <dlfcn.h>

static id Call0(id obj, NSString *selName) {
    SEL sel = NSSelectorFromString(selName);
    if (![obj respondsToSelector:sel]) {
        NSLog(@"missing selector %@ on %@", selName, obj);
        return nil;
    }
    IMP imp = [obj methodForSelector:sel];
    id (*func)(id, SEL) = (void *)imp;
    return func(obj, sel);
}

static void CallSet(id obj, NSDictionary *dict, BOOL saeEnabled) {
    SEL sel = NSSelectorFromString(@"setKeyboardShortcutDictionary:saeEnabled:");
    if (![obj respondsToSelector:sel]) {
        NSLog(@"missing setter on %@", obj);
        exit(2);
    }
    IMP imp = [obj methodForSelector:sel];
    void (*func)(id, SEL, NSDictionary *, BOOL) = (void *)imp;
    func(obj, sel, dict, saeEnabled);
}

static NSDictionary *StandardShortcut(unsigned short charCode, unsigned short keyCode, NSUInteger modifiers) {
    return @{
        @"enabled": @YES,
        @"value": @{
            @"parameters": @[ @(charCode), @(keyCode), @(modifiers) ],
            @"type": @"standard",
        },
    };
}

static NSDictionary *SAEShortcut(unsigned short charCode, unsigned short keyCode, NSUInteger modifiers) {
    return @{
        @"enabled": @YES,
        @"value": @{
            @"parameters": @[ @(charCode), @(keyCode), @(modifiers) ],
            @"type": @"SAE1.0",
        },
    };
}

static void PrintUsage(const char *name) {
    fprintf(stderr,
        "usage: %s status|off|either|left|right|hold-command-space|hold-option-space|function-space|cmd-space|cmd-shift-space|cmd-option-space|ctrl-option-space|cmd-return|cmd-option-return|custom <charCode> <keyCode> <modifiers>|custom-sae <charCode> <keyCode> <modifiers>\\n",
        name);
}

static void PrintShortcut(NSString *label, NSDictionary *shortcut) {
    printf("%s: %s\n", [label UTF8String], [[shortcut description] UTF8String]);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            PrintUsage(argv[0]);
            return 64;
        }

        dlopen("/System/Library/PrivateFrameworks/SiriFoundation.framework/SiriFoundation", RTLD_NOW | RTLD_GLOBAL);

        Class cls = NSClassFromString(@"SRFUserDefaultsController");
        id controller = nil;
        SEL sharedSel = NSSelectorFromString(@"sharedUserDefaultsController");
        if ([cls respondsToSelector:sharedSel]) {
            IMP imp = [cls methodForSelector:sharedSel];
            id (*func)(id, SEL) = (void *)imp;
            controller = func(cls, sharedSel);
        }
        if (!controller) {
            controller = [[cls alloc] init];
        }

        NSString *mode = [NSString stringWithUTF8String:argv[1]];
        NSDictionary *old = Call0(controller, @"keyboardShortcutDictionary");
        NSDictionary *next = nil;

        if ([mode isEqualToString:@"status"] || [mode isEqualToString:@"read"]) {
            PrintShortcut(@"current", old);
            return 0;
        }

        NSDictionary<NSString *, NSString *> *selectorByMode = @{
            @"off": @"userHotkeyDisabledSAE",
            @"either": @"userHotKeyEitherCommandTwice",
            @"left": @"userHotKeyLeftCommandTwice",
            @"right": @"userHotKeyRightCommandTwice",
            @"hold-command-space": @"userHotKeyHoldCommandSpace",
            @"hold-option-space": @"userHotKeyHoldOptionSpace",
            @"function-space": @"userHotKeyFunctionSpace",
        };

        NSString *selector = selectorByMode[mode];
        BOOL useSAESetter = YES;
        if (selector) {
            next = Call0(controller, selector);
        } else if ([mode isEqualToString:@"cmd-space"]) {
            next = SAEShortcut(32, 49, 1048576);
        } else if ([mode isEqualToString:@"cmd-shift-space"]) {
            next = SAEShortcut(32, 49, 1048576 | 131072);
        } else if ([mode isEqualToString:@"cmd-option-space"]) {
            next = SAEShortcut(32, 49, 1048576 | 524288);
        } else if ([mode isEqualToString:@"ctrl-option-space"]) {
            next = SAEShortcut(32, 49, 262144 | 524288);
        } else if ([mode isEqualToString:@"cmd-return"]) {
            next = SAEShortcut(13, 36, 1048576);
        } else if ([mode isEqualToString:@"cmd-option-return"]) {
            next = SAEShortcut(13, 36, 1048576 | 524288);
        } else if ([mode isEqualToString:@"custom"]) {
            if (argc != 5) {
                PrintUsage(argv[0]);
                return 64;
            }
            unsigned short charCode = (unsigned short)strtoul(argv[2], NULL, 0);
            unsigned short keyCode = (unsigned short)strtoul(argv[3], NULL, 0);
            NSUInteger modifiers = (NSUInteger)strtoull(argv[4], NULL, 0);
            next = StandardShortcut(charCode, keyCode, modifiers);
            useSAESetter = NO;
        } else if ([mode isEqualToString:@"custom-sae"]) {
            if (argc != 5) {
                PrintUsage(argv[0]);
                return 64;
            }
            unsigned short charCode = (unsigned short)strtoul(argv[2], NULL, 0);
            unsigned short keyCode = (unsigned short)strtoul(argv[3], NULL, 0);
            NSUInteger modifiers = (NSUInteger)strtoull(argv[4], NULL, 0);
            next = SAEShortcut(charCode, keyCode, modifiers);
        } else {
            fprintf(stderr, "unknown mode: %s\n", argv[1]);
            PrintUsage(argv[0]);
            return 64;
        }
        if (!next) {
            fprintf(stderr, "failed to build shortcut dictionary for mode: %s\n", argv[1]);
            return 1;
        }

        PrintShortcut(@"old", old);
        PrintShortcut(@"new", next);
        CallSet(controller, next, useSAESetter);
        PrintShortcut(@"saved", Call0(controller, @"keyboardShortcutDictionary"));
    }
    return 0;
}
