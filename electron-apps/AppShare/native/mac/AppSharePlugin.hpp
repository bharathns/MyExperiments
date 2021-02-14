//
//  AppShare_Plugin.hpp
//  AppShare-Plugin
 //
//  Created by Bharath nadampalli on 2/3/21.
//

#ifndef AppShare_Plugin_
#define AppShare_Plugin_
#include <string>
#include <vector>
#include <set>
using namespace std;

/* The classes below are exported */
#pragma GCC visibility push(default)
struct AppSharePluginImpl;
class AppSharePlugin
{
    private: 
        AppSharePluginImpl* appSharePlugin;
        std::string getWindowText(void *window, long windowId);
        std::string getBase64ImageString(long windowId);
    public:
        AppSharePlugin();
        ~AppSharePlugin();
        virtual vector<pair<unsigned long, std::string>> getWindowList();
        virtual std::string getCaptureOf(long windowId);
};

#pragma GCC visibility pop
#endif
