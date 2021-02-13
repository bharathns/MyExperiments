// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.

const appShare = require('bindings')('appShare.node')

var txt =  "<option value=\"-1\">Choose a window</option>";
var windowCount = 0;
var windowArray;
var select = document.getElementById("selectWindow"); 
function getWindow(value) {
  	var opt = document.createElement("option"); // Create the new element


        opt.value = value.processId.toString();; // set the value
        opt.text = value.windowtext.trim().replace(/[\u{0080}-\u{FFFF}]/gu,""); // set the text

        select.appendChild(opt); // add it to the select
        windowCount =  windowCount + 1;
  	//txt = txt +  "<option value=\"" + value[processId] + "\">" + value[windowText]+ "</option>";
}

function getWindowList() {
  var windowArray = appShare.getWindowList()
  windowCount =  0
  for (var i=0; i<windowArray.length; i++) {
        var opt = document.createElement("option"); // Create the new element
        var windowProp =  [];
        for (let value of Object.values(windowArray[i])) {
           var str = value
           windowProp.push(str.toString())
        }
        if (windowProp[0].trim().length > 0) {
        	opt.value = windowProp[1]//windowArray[i].processId.toString();; // set the value
        	opt.text = windowProp[0]//windowArray[i].windowtext.valueOf();//.trim().replace(/[\u{0080}-\u{FFFF}]/gu,""); // set the text

        	select.appendChild(opt); // add it to the select
        }
  }
}

function populateWindows() {
	if (select != null) {
		getWindowList();
	}
}

function getCaptureOfWindow(value) {
        var windowIndex = parseInt(value, 10);
        var base64Buff = appShare.getCaptureOfWindow(windowIndex);
	return base64Buff;
}
