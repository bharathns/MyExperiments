//
//  main.cpp
//  AppShareClientCmdLine
//
//  Created by Bharath nadampalli on 2/3/21.
//

#include <iostream>
#include <string>
#include <dlfcn.h>
#include <mach-o/dyld.h>
#include "../../AppShare-Plugin/AppShare-Plugin/AppSharePlugin.hpp"
typedef AppSharePlugin* (*CreatePlugin)();
typedef void (*DestroyPlugin)(AppSharePlugin*);
using namespace std;

int main(void) {
    char path[1024];
    uint32_t size = sizeof(path);
    if (_NSGetExecutablePath(path, &size) == 0)
        printf("executable path is %s\n", path);
    else
        printf("buffer too small; need size %u\n", size);
    void* handle = dlopen("libAppShare-Plugin.dylib", RTLD_LOCAL);
    if (handle) {
        CreatePlugin createPlugin = (CreatePlugin)dlsym(handle, "create_object");
        DestroyPlugin destroyPlugin = (DestroyPlugin)dlsym(handle, "destroy_object");
        
        AppSharePlugin* myClass = (AppSharePlugin*)createPlugin();
    
        vector<pair<unsigned long, string>> vect = myClass->getWindowList();
        for (auto &&item : vect) {
            cout<<item.first<<" : "<<item.second<<endl;
        }
        string base64String = myClass->getCaptureOf(69);
        cout<<base64String.size()<<endl;
        //myClass->HelloWorld("how are you");
        destroyPlugin( myClass );
    }
    else {
        printf("[%s] Unable to open libAppShare-Plugin.dylib: %s\n", __FILE__, dlerror());
    }
    dlclose(handle);
}
