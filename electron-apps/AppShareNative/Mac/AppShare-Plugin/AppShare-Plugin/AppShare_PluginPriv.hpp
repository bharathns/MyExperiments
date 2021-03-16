//
//  AppShare_PluginPriv.hpp
//  AppShare-Plugin
//
//  Created by Bharath nadampalli on 2/3/21.
//

/* The classes below are not exported */
#pragma GCC visibility push(hidden)

class AppShare_PluginPriv
{
    public:
    void HelloWorldPriv(const char *);
    void HelloWorldPriv();
};

#pragma GCC visibility pop
