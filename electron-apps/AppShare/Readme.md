# AppShare Sample

AppShare Sample is an experiment for cross platform for appshare using nodejs and native C++ and respective apis (win32 and corefoundation/cocoa) for windows and mac.

## Installation

```bash
npm install
npm run rebuild
npm run start
```
## Demo
### Windows
(Window on the right is the AppShare window, where you can select the window you want to share)
![Alt text](AppShare-Orig-Win-Demo.gif?raw=true "Windows Demo")

### Mac OS X
(Window on the right is the AppShare window, where you can select the window you want to share)
![Alt text](AppShare-Orig-Mac-Demo.gif?raw=true "Mac Demo")


## Current Issues/Improvements
1. Cross platform c++ code can be cleaned up for make it truly reusable.
2. Build and packing.
3. The screen rendering needs improvement
4. mac is using hardcoded path instead of relying on the dlopen search path.
5. 

## Pending Items (to complete the POC)
1. Sharing the images to a conference server
2. Multiparty conference to share the screen (like zoom)
## License
[MIT](https://choosealicense.com/licenses/mit/)