// AppShare-Plugin.cpp : Defines the exported functions for the DLL.
//

#include "pch.h"
#include "framework.h"
#include "AppShare-Plugin.h"
#include <windows.h>
#include <unordered_map>
#include <locale>
#include <codecvt>
#include <objidl.h>
#include <gdiplus.h>
#include <fstream>
#include <psapi.h>
#include <combaseapi.h>

#pragma comment(lib,"gdiplus.lib")
using namespace Gdiplus;

extern "C"  AppSharePlugin * create_object(void) {
    return new AppSharePlugin;
}

extern "C"  APPSHAREPLUGIN_API void destroy_object(AppSharePlugin * plugin) {
    delete plugin;
}

// This is an example of an exported variable
APPSHAREPLUGIN_API int nAppSharePlugin=0;

// This is an example of an exported function.
APPSHAREPLUGIN_API int fnAppSharePlugin(void)
{
    return 0;
}


static const std::string base64_chars =
"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
"abcdefghijklmnopqrstuvwxyz"
"0123456789+/";


static inline bool isBase64(BYTE c) {
    return (isalnum(c) || (c == '+') || (c == '/'));
}

std::string base64Encode(BYTE const* buf, unsigned int bufLen) {
    std::string ret;
    int i = 0;
    int j = 0;
    BYTE char_array_3[3];
    BYTE char_array_4[4];

    while (bufLen--) {
        char_array_3[i++] = *(buf++);
        if (i == 3) {
            char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
            char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
            char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
            char_array_4[3] = char_array_3[2] & 0x3f;

            for (i = 0; (i < 4); i++)
                ret += base64_chars[char_array_4[i]];
            i = 0;
        }
    }

    if (i)
    {
        for (j = i; j < 3; j++)
            char_array_3[j] = '\0';

        char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
        char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
        char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
        char_array_4[3] = char_array_3[2] & 0x3f;

        for (j = 0; (j < i + 1); j++)
            ret += base64_chars[char_array_4[j]];

        while ((i++ < 3))
            ret += '=';
    }

    return ret;
}

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

BITMAPINFOHEADER createBitmapHeader(int width, int height)
{
    BITMAPINFOHEADER  bi;

    // create a bitmap
    bi.biSize = sizeof(BITMAPINFOHEADER);
    bi.biWidth = width;
    bi.biHeight = -height;  //this is the line that makes it draw upside down or not
    bi.biPlanes = 1;
    bi.biBitCount = 32;
    bi.biCompression = BI_RGB;
    bi.biSizeImage = 0;
    bi.biXPelsPerMeter = 0;
    bi.biYPelsPerMeter = 0;
    bi.biClrUsed = 0;
    bi.biClrImportant = 0;

    return bi;
}

POINT getWindowResolution(const HWND window_handle)
{
    RECT rectangle;
    GetClientRect(window_handle, &rectangle);
    const POINT coordinates{ rectangle.right, rectangle.bottom };
    return coordinates;
}

HBITMAP GdiPlusScreenCapture(HWND hWnd)
{
    // get handles to a device context (DC)
    HDC hwindowDC = GetDC(hWnd);
    HDC hwindowCompatibleDC = CreateCompatibleDC(hwindowDC);
    SetStretchBltMode(hwindowCompatibleDC, COLORONCOLOR);

    // define scale, height and width
    int scale = 1;
    int screenx = GetSystemMetrics(SM_XVIRTUALSCREEN);
    int screeny = GetSystemMetrics(SM_YVIRTUALSCREEN);

    const auto window_resolution = getWindowResolution(hWnd);

    const auto width = window_resolution.x;
    const auto height = window_resolution.y;

    // create a bitmap
    HBITMAP hbwindow = CreateCompatibleBitmap(hwindowDC, width, height);
    BITMAPINFOHEADER bi = createBitmapHeader(width, height);

    // use the previously created device context with the bitmap
    SelectObject(hwindowCompatibleDC, hbwindow);

    // Starting with 32-bit Windows, GlobalAlloc and LocalAlloc are implemented as wrapper functions that call HeapAlloc using a handle to the process's default heap.
    // Therefore, GlobalAlloc and LocalAlloc have greater overhead than HeapAlloc.
    DWORD dwBmpSize = ((width * bi.biBitCount + 31) / 32) * 4 * height;
    HANDLE hDIB = GlobalAlloc(GHND, dwBmpSize);
    char* lpbitmap = (char*)GlobalLock(hDIB);

    // copy from the window device context to the bitmap device context
    StretchBlt(hwindowCompatibleDC, 0, 0, width, height, hwindowDC, screenx, screeny, width, height, SRCCOPY);   //change SRCCOPY to NOTSRCCOPY for wacky colors !
    GetDIBits(hwindowCompatibleDC, hbwindow, 0, height, lpbitmap, (BITMAPINFO*)&bi, DIB_RGB_COLORS);

    // avoid memory leak
    DeleteDC(hwindowCompatibleDC);
    ReleaseDC(hWnd, hwindowDC);

    return hbwindow;
}


bool saveToMemory
(HBITMAP* hbitmap, std::vector<BYTE>& data, std::string dataFormat = "png")
{
    Gdiplus::Bitmap bmp(*hbitmap, nullptr);
    // write to IStream
    IStream* istream = nullptr;
    CreateStreamOnHGlobal(NULL, TRUE, &istream);

    // define encoding
    CLSID clsid;
    if (dataFormat.compare("bmp") == 0) { CLSIDFromString(L"{557cf400-1a04-11d3-9a73-0000f81ef32e}", &clsid); }
    else if (dataFormat.compare("jpg") == 0) { CLSIDFromString(L"{557cf401-1a04-11d3-9a73-0000f81ef32e}", &clsid); }
    else if (dataFormat.compare("gif") == 0) { CLSIDFromString(L"{557cf402-1a04-11d3-9a73-0000f81ef32e}", &clsid); }
    else if (dataFormat.compare("tif") == 0) { CLSIDFromString(L"{557cf405-1a04-11d3-9a73-0000f81ef32e}", &clsid); }
    else if (dataFormat.compare("png") == 0) { CLSIDFromString(L"{557cf406-1a04-11d3-9a73-0000f81ef32e}", &clsid); }

    Gdiplus::Status status = bmp.Save(istream, &clsid, NULL);
    if (status != Gdiplus::Status::Ok)
        return false;

    // get memory handle associated with istream
    HGLOBAL hg = NULL;
    GetHGlobalFromStream(istream, &hg);

    // copy IStream to buffer
    int bufsize = GlobalSize(hg);
    data.resize(bufsize);

    // lock & unlock memory
    LPVOID pimage = GlobalLock(hg);
    memcpy(&data[0], pimage, bufsize);
    GlobalUnlock(hg);
    istream->Release();
    return true;
}



BOOL isMainWindow(HWND handle)
{
    return GetWindow(handle, GW_OWNER) == (HWND)0 && IsWindowVisible(handle);
}

BOOL CALLBACK enumWindowProc(HWND hwnd, LPARAM lParam) {
    
    const DWORD TITLE_SIZE = 1024;
    WCHAR windowTitle[TITLE_SIZE];
    GuiWindow& window = *(GuiWindow*)lParam;
    unsigned long processId = 0;
    GetWindowThreadProcessId(hwnd, &processId);
    if (window.processId != processId || !isMainWindow(hwnd))
        return TRUE;

    GetWindowTextW(hwnd, windowTitle, TITLE_SIZE);
    wstring title(&windowTitle[0]);
    window.windowText = NULL;
    if (!title.empty()) {
        window.windowText = SysAllocStringLen(title.data(), title.size());
    }
    window.hWnd = hwnd;

    return FALSE;
}

GuiWindow* findMainWindow(DWORD processId) {
    GuiWindow* window = new GuiWindow;
    window->processId = processId;
    window->hWnd = NULL;
    EnumWindows(enumWindowProc, (LPARAM)window);
    return window;
}


// This is the constructor of a class that has been exported.
AppSharePlugin::AppSharePlugin()
{
    return;
}

vector<GuiWindow*>& AppSharePlugin::getWindowList(void) {
    DWORD aProcesses[1024], cbNeeded, cProcesses;
    unsigned int i;

    if (!EnumProcesses(aProcesses, sizeof(aProcesses), &cbNeeded))
    {
        return  windowList;
    }
    // Calculate how many process identifiers were returned.

    cProcesses = cbNeeded / sizeof(DWORD);
    for (i = 0; i < cProcesses; i++)
    {
        if (aProcesses[i] != 0)
        {
            GuiWindow* window = findMainWindow(aProcesses[i]);

            if (window->processId != 0 && window->hWnd != NULL) {
                //auto w = make_pair(window.processId, window.windowText);
                windowList.push_back(window);
            }
        }
    }
    return windowList;
}

string& AppSharePlugin::getCaptureOfWindow(DWORD processId) {
   
    // get args
    GuiWindow* window = NULL;    
    base64Image = "";
    for (auto windowItem : windowList) {
        if (windowItem->processId == processId) {
            window = windowItem;
            break;
        }
    }

    if (window == NULL) return base64Image;

    GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR gdiplusToken;
    GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);


    HWND hWnd = window->hWnd;// g_hwnds[windowIndex];
    HBITMAP hBmp = GdiPlusScreenCapture(hWnd);

    // save as png to memory
    std::vector<BYTE> data;
    std::string dataFormat = "bmp";
    if (saveToMemory(&hBmp, data, dataFormat) && data.size() > 0)
    {
        base64Image = base64Encode(&data[0], data.size());
        std::ofstream fout("Screenshot-m1." + dataFormat, std::ios::binary);
        fout.write((char*)data.data(), data.size());
    }

    GdiplusShutdown(gdiplusToken);
    return base64Image;
}