// The following ifdef block is the standard way of creating macros which make exporting
// from a DLL simpler. All files within this DLL are compiled with the APPSHAREPLUGIN_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see
// APPSHAREPLUGIN_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef APPSHAREPLUGIN_EXPORTS
#define APPSHAREPLUGIN_API __declspec(dllexport)
#else
#define APPSHAREPLUGIN_API __declspec(dllimport)
#endif
#include <string>
#include <vector>
#include <utility>
#include <WTypes.h>
using namespace std;
struct APPSHAREPLUGIN_API GuiWindow {
	HWND hWnd;
	BSTR windowText;
	DWORD processId;
};

// This class is exported from the dll
class APPSHAREPLUGIN_API AppSharePlugin {
private:
	vector<GuiWindow*> windowList;
	string base64Image;
public:
	AppSharePlugin(void);
	// TODO: add your methods here.
	virtual vector<GuiWindow*>& getWindowList(void);
	virtual string& getCaptureOfWindow(DWORD processId);

};

extern APPSHAREPLUGIN_API int nAppSharePlugin;

//extern "C"  APPSHAREPLUGIN_API vector<pair<DWORD, string>>& getWindowList(void);

extern "C"  APPSHAREPLUGIN_API AppSharePlugin * create_object(void);

extern "C"  APPSHAREPLUGIN_API void destroy_object(AppSharePlugin * plugin);
