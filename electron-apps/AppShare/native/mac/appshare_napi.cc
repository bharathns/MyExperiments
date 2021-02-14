#include <napi.h>
#include <vector>
#include <unordered_map>
#include <string>
#include <locale>
#include <codecvt>
#include <fstream>
#include <dlfcn.h>
#include <mach-o/dyld.h>

#include "AppSharePlugin.hpp"

using namespace std;

typedef AppSharePlugin* (*CreatePlugin)();
typedef void (*DestroyPlugin)(AppSharePlugin*);
AppSharePlugin* gPlugin = NULL;

void* handle =  NULL;

std::wstring s2ws(const std::string& str)
{
    using convert_typeX = std::codecvt_utf8<wchar_t>;
    std::wstring_convert<convert_typeX, wchar_t> converterX;

    return converterX.from_bytes(str);
}

std::string ws2s(const std::wstring& wstr)
{
    using convert_typeX = std::codecvt_utf8<wchar_t>;
    std::wstring_convert<convert_typeX, wchar_t> converterX;

    return converterX.to_bytes(wstr);
}

Napi::Value GetWindowList(const Napi::CallbackInfo& info) {
    // Get context
    Napi::Env env = info.Env();

    char path[1024];
    uint32_t size = sizeof(path);
    if (_NSGetExecutablePath(path, &size) == 0)
        printf("executable path is %s\n", path);
    else
        printf("buffer too small; need size %u\n", size);
    
    // check the args 
    if (info.Length() > 0) {
        Napi::TypeError::New(env, "Wrong number of arguments")
            .ThrowAsJavaScriptException();
        return env.Null();
    }

    CreatePlugin createPlugin = nullptr;

    void* handle = dlopen("/Users/bharathns/gitstreams/MyExperiments/electron-apps/AppShare/libAppShare-Plugin.dylib", RTLD_LOCAL);
    if (handle != nullptr) {
        createPlugin = (CreatePlugin)dlsym(handle, "create_object");
    }else {
        Napi::TypeError::New(env, path)
            .ThrowAsJavaScriptException();
    }
    
    gPlugin = (AppSharePlugin*)createPlugin();
    if (gPlugin == NULL) 
    { 
        Napi::TypeError::New(env, "Plugin is not initialized")
            .ThrowAsJavaScriptException();
        return env.Null();
    }

    vector<pair<unsigned long, string>> windowList = gPlugin->getWindowList();
    Napi::Array windows = Napi::Array::New(env, windowList.size());
    int i = 0;
    for (auto &&item : windowList) {
        Napi::Object obj = Napi::Object::New(env);
        // Assign values to properties
        //assert(windowItem->windowText != nullptr);
        string str = item.second;
        if (str.size() > 100) str = str.substr(0, 100);
        obj.Set("windowText", Napi::String::New(env, str));
        obj.Set("processId", Napi::Number::New(env, item.first));
        windows[i++] = obj;
    }
    return windows;
}

Napi::Value GetCaptureOfWindow(const Napi::CallbackInfo& info) {
    // Get context
    Napi::Env env = info.Env();

    // check the args 
    if (info.Length() > 1) {
        Napi::TypeError::New(env, "Wrong number of arguments")
            .ThrowAsJavaScriptException();
        return env.Null();
    }
    
    // get args
    long windowId = info[0].As<Napi::Number>().Int32Value();
   
    Napi::String base64ImageString;
    if (gPlugin == NULL)   Napi::TypeError::New(env, "hello there")
            .ThrowAsJavaScriptException();
    
    string base64Image = gPlugin->getCaptureOf(windowId);
   
    if (base64Image.size() > 0) {
        base64ImageString = Napi::String::New(env, base64Image);
    }
    else {
        Napi::TypeError::New(env, "Wrong number of arguments")
            .ThrowAsJavaScriptException();
        return env.Null();
    }
    return base64ImageString;
}

// NODE_API_MODULE Init Function
Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(Napi::String::New(env, "getWindowList"), Napi::Function::New(env, GetWindowList));
  exports.Set(Napi::String::New(env, "getCaptureOfWindow"), Napi::Function::New(env, GetCaptureOfWindow));
  return exports;
}

// export
NODE_API_MODULE(appShare, Init)
