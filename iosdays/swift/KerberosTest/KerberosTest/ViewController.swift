//
//  ViewController.swift
//  KerberosTest
//
//  Created by Bharath Nadampalli on 23/07/17.
//  Copyright © 2017 com.ot. All rights reserved.
//

import UIKit
import Foundation

let URLString = "http://web.leap.dctmlabs.com:8080/d2fs-rest/repositories/leapexpress"

class ViewController: UIViewController, URLSessionDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate  {

    @IBOutlet weak var numberOfTimes: UITextField!
    @IBOutlet weak var responseTextView: UITextView!
    
    private let url : URL = URL(string: URLString)!
    private var session: URLSession? = nil
    private var downloadTask: URLSessionDownloadTask!
    var tasks : [URLSessionDataTask]? = [URLSessionDataTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let config = URLSessionConfiguration.default
        //let config =  NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("DownloadIdentifier")
       
        session = URLSession(configuration:config, delegate: self, delegateQueue: nil)
        responseTextView.layer.cornerRadius = 5
        responseTextView.layer.borderColor = UIColor.purple.cgColor
        responseTextView.layer.borderWidth = 1
        //downloadTask = session?.downloadTask(with: downloadURL as URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedGet(_ sender: Any) {
        self.tasks?.removeAll()
        if !(numberOfTimes.text?.isEmpty)!, let text = numberOfTimes.text, let noOfCalls = Int(text) {
            for  i in stride(from: 0, to: noOfCalls-1, by: 1) {
                self.fireReSTCall()
            }
            
        }else  {
            self.fireReSTCall()
        }
        
    }
    
    func fireReSTCall () {
        var request = URLRequest.init(url: self.url)
        
        request.timeoutInterval = 180.0 // TimeoutInterval in Second
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = session?.dataTask(with: request, completionHandler: {[weak self]
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        
                        //Implement your logic
                        print(json)
                        
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
            }
            
        })
        tasks?.append(task!)
        task?.resume()
    }

    func someFunction() {
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }
    
    func dLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
        print("[\((filename as NSString).lastPathComponent):\(line)] \(function) - \(message)")
    }
    
    /*
     * URLSessionDelegate : NSObjectProtocol
     */
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?)
    {
        dLog(message:"")
    }
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void)
    {
        dLog(message:"")
        completionHandler(.performDefaultHandling, nil)
    }
    
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession)
    {
        dLog(message:"")
    }
    
    /*
     * URLSessionTaskDelegate : URLSessionDelegate
     */
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void)
    {
        dLog(message:"\(request.description)")
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void)
    {
        dLog(message:"didReceive challenge:")
        completionHandler(.performDefaultHandling, nil)
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void)
    {
        dLog(message:"")
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        dLog(message:"")
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics)
    {
        dLog(message:"")
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        dLog(message:"")
    }
    
    /*
     * URLSessionDataDelegate : URLSessionTaskDelegate
     */
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void)
    {
        dLog(message:"")
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask)
    {
        dLog(message:"")
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask)
    {
        dLog(message:"")
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        if let str = String(data: data, encoding: .utf8) {
            dLog(message:"\(str)")
            print("received data: \(str)")
        }
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void)
    {
        dLog(message:"")
    }
    
    /*
     * URLSessionDownloadDelegate : URLSessionTaskDelegate
     */
    
    /* Sent when a download task that has completed a download.  The delegate should
     * copy or move the file at the given location to a new location as it will be
     * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
     * still be called.
     */
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        dLog(message:"")
    }
    
    
    /* Sent periodically to notify the delegate of download progress. */
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        dLog(message:"")
    }
    
    
    /* Sent when a download has been resumed. If a download failed with an
     * error, the -userInfo dictionary of the error will contain an
     * NSURLSessionDownloadTaskResumeData key, whose value is the resume
     * data.
     */
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64)
    {
        dLog(message:"")
    }
    
    
    /*
     * URLSessionStreamDelegate : URLSessionTaskDelegate
     */
    
    
    /* Indiciates that the read side of a connection has been closed.  Any
     * outstanding reads complete, but future reads will immediately fail.
     * This may be sent even when no reads are in progress. However, when
     * this delegate message is received, there may still be bytes
     * available.  You only know that no more bytes are available when you
     * are able to read until EOF. */
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask)
    {
        dLog(message:"")
    }
    
    
    /* Indiciates that the write side of a connection has been closed.
     * Any outstanding writes complete, but future writes will immediately
     * fail.
     */
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask)
    {
        dLog(message:"")
    }
    
    
    /* A notification that the system has determined that a better route
     * to the host has been detected (eg, a wi-fi interface becoming
     * available.)  This is a hint to the delegate that it may be
     * desirable to create a new task for subsequent work.  Note that
     * there is no guarantee that the future task will be able to connect
     * to the host, so callers should should be prepared for failure of
     * reads and writes over any new interface. */
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask)
    {
        dLog(message:"")
    }
    
    
    /* The given task has been completed, and unopened NSInputStream and
     * NSOutputStream objects are created from the underlying network
     * connection.  This will only be invoked after all enqueued IO has
     * completed (including any necessary handshakes.)  The streamTask
     * will not receive any further delegate messages.
     */
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream)
    {
        dLog(message:"")
    }

    
    /*func URLSession(session: URLSession, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("challenged")
        completionHandler(.performDefaultHandling, nil)
    }
    
    func URLSession(session: URLSession, task: URLSessionTask, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("Challenged")
        completionHandler(.performDefaultHandling, nil)
    }
    
    func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
        print("ERROR: \(error)")
    }
    
    func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        print("response: \(response)")
        if (response as! HTTPURLResponse).statusCode == 401 {
            completionHandler(.allow)
        } else {
            completionHandler(.becomeDownload)
        }
    }
    
    func URLSession(session: URLSession, dataTask: URLSessionDataTask, didBecomeDownloadTask downloadTask: URLSessionDownloadTask) {
        print("became download task")
    }
    
    func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: NSData) {
        print("received data: \(data)")
    }
    
    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("finished downloading: \(location)")
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        do {
            try FileManager.default.moveItem(at: location as URL, to: NSURL.fileURL(withPath: (paths[0] ) + "/output.file"))
        } catch _ {
        }
    }
    
    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("progress: \(bytesWritten) of \(totalBytesExpectedToWrite)")
    }
    
    


    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }*/
    
    
    
}

