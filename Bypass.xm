#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <substrate.h>
#import <unistd.h>
#import <stdlib.h>
#import <mach-o/dyld.h>
#import <string.h>

// Блокируем exit
static void (*orig_exit)(int);
static void my_exit(int status) {
    NSLog(@"[Bypass] Blocked exit");
}

// Блокируем _exit
static void (*orig__exit)(int);
static void my__exit(int status) {
    NSLog(@"[Bypass] Blocked _exit");
}

// Скрываем наш dylib
static const char* (*orig_dyld_get_image_name)(uint32_t);
static const char* my_dyld_get_image_name(uint32_t idx) {
    const char* name = orig_dyld_get_image_name(idx);
    if (name && (strstr(name, "Bypass") || strstr(name, "Cheat") || strstr(name, "H5GG") || strstr(name, "substrate"))) {
        return "/usr/lib/libSystem.B.dylib";
    }
    return name;
}

// Инициализация при загрузке
__attribute__((constructor)) static void init_bypass() {
    MSHookFunction((void *)exit, (void *)my_exit, (void **)&orig_exit);
    MSHookFunction((void *)_exit, (void *)my__exit, (void **)&orig__exit);
    MSHookFunction((void *)_dyld_get_image_name, (void *)my_dyld_get_image_name, (void **)&orig_dyld_get_image_name);
}
