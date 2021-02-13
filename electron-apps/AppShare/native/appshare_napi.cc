#include <napi.h>
#include <windows.h>
#include <vector>
#include <unordered_map>
#include <string>
#include <locale>
#include <codecvt>
#include <gdiplus.h>
#include <fstream>
#include <psapi.h>
#include "AppShare-Plugin.h"

#pragma comment(lib,"gdiplus.lib")
using namespace std;
using namespace Gdiplus;

typedef AppSharePlugin* (*CreatePlugin)();
typedef void (*DestroyPlugin)(AppSharePlugin*);
AppSharePlugin* gPlugin = NULL;
HINSTANCE hinstLib;

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

    // check the args 
    if (info.Length() > 0) {
        Napi::TypeError::New(env, "Wrong number of arguments")
            .ThrowAsJavaScriptException();
        return env.Null();
    }

    CreatePlugin create;
    DestroyPlugin destroy;

    BOOL fFreeResult, fRunTimeLinkSuccess = FALSE;

    // Get a handle to the DLL module.

    hinstLib = LoadLibrary("AppSharePlugin.dll");

    // If the handle is valid, try to get the function address.
    if (hinstLib != NULL)
    {
        create = (CreatePlugin)GetProcAddress(hinstLib, "create_object");
        destroy = (DestroyPlugin)GetProcAddress(hinstLib, "destroy_object");

        // If the function address is valid, call the function., 

        if (NULL != create)
        {
            fRunTimeLinkSuccess = TRUE;
            if (gPlugin == NULL)
                gPlugin = (create)();
        }
    }
    else {
        Napi::TypeError::New(env, "LoadLibrary Failed!!")
            .ThrowAsJavaScriptException();
        return env.Null();
    }

    if (gPlugin == NULL) 
    { 
        Napi::TypeError::New(env, "Plugin is not initialized")
            .ThrowAsJavaScriptException();
        return env.Null();
    }

    
    vector<GuiWindow*>& windowList = gPlugin->getWindowList();
    Napi::Array windows = Napi::Array::New(env, windowList.size());
    int i = 0;
    for (auto windowItem : windowList) {
        Napi::Object obj = Napi::Object::New(env);
        // Assign values to properties
        //assert(windowItem->windowText != nullptr);
        std::wstring ws(windowItem->windowText, SysStringLen(windowItem->windowText));
        string str = ws2s(ws);
        obj.Set("windowText", Napi::String::New(env, str));
        obj.Set("processId", Napi::Number::New(env, windowItem->processId));
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
    DWORD processId = info[0].As<Napi::Number>().Int32Value();
    Napi::String base64ImageString;
    string& base64Image = gPlugin->getCaptureOfWindow(processId);
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