//
//  SessionManager.swift
//  mvvm1
//
//  Created by Bharath Nadampalli on 31/07/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class SessionManager {
    static let shared = SessionManager()
    var urlSession: URLSession? = URLSession(configuration: URLSessionConfiguration.default, delegate: SessionDelegate.shared, delegateQueue: nil)
    
}


final class SessionDelegate: NSObject {
    static let shared = SessionDelegate()
    
    fileprivate var securityPolicyHandler: SecurityPolicy?
    /*var networkTaskArray = [NetworkTask] ()
    
    override init() {
        super.init()
        objc_sync_enter(self)
        
        Thread.callStackSymbols.forEach{print($0)}
        
        print("SessionDelegate init")
        print("**************************************")
        
        objc_sync_exit(self)
    }
    func securityPolicy(_ policy: SecurityPolicy?) -> Self {
        securityPolicyHandler = policy
        
        return self
    }
    
    func addTask(task : NetworkTask?) {
        if task != nil {
            self.networkTaskArray.append(task!)
        }
    }
    
    deinit {
        Log.info("SessionDelegate deinit")
    }*/
}



extension SessionDelegate: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust, let serverTrust = challenge.protectionSpace.serverTrust, let policy = self.securityPolicyHandler else {
            return completionHandler(.performDefaultHandling, nil)
        }
        
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?
        
        if policy.evaluateServerTrust(serverTrust, isValidForHost: challenge.protectionSpace.host) {
            disposition = .useCredential
            credential = URLCredential(trust: serverTrust)
        }
        else {
            disposition = .cancelAuthenticationChallenge
        }
        
        completionHandler(disposition, credential)
    }
    
}


extension SessionDelegate: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        urlSession(session, didReceive: challenge, completionHandler: completionHandler)
    }
    
}


final class SecurityPolicy {
    
    // MARK: Public Methods -
    
    func evaluateServerTrust(_ serverTrust: SecTrust, isValidForHost host: String) -> Bool {
        var serverTrustIsValid = false
        
        let pinnedPublicKeys = publicKeysInBundle()
        
        let policy = SecPolicyCreateSSL(true, host as CFString)
        SecTrustSetPolicies(serverTrust, policy)
        
        if trustIsValid(serverTrust) {
            outerLoop: for serverPublicKey in publicKeysForTrust(serverTrust) as [AnyObject] {
                for pinnedPublicKey in pinnedPublicKeys as [AnyObject] {
                    if serverPublicKey.isEqual(pinnedPublicKey) {
                        serverTrustIsValid = true
                        break outerLoop
                    }
                }
            }
        }
        
        return serverTrustIsValid
    }
    
    
    // MARK: Private Methods -
    
    fileprivate func certificatesInBundle(_ bundle: Bundle = Bundle.main) -> [SecCertificate] {
        var certificates: [SecCertificate] = []
        
        let paths = Set([".cer", ".CER", ".crt", ".CRT", ".der", ".DER"].map { fileExtension in
            bundle.paths(forResourcesOfType: fileExtension, inDirectory: nil)
            }.joined())
        
        for path in paths {
            if let
                certificateData = try? Data(contentsOf: URL(fileURLWithPath: path)),
                let certificate = SecCertificateCreateWithData(nil, certificateData as CFData)
            {
                certificates.append(certificate)
            }
        }
        
        return certificates
    }
    
    fileprivate func publicKeysInBundle(_ bundle: Bundle = Bundle.main) -> [SecKey] {
        var publicKeys: [SecKey] = []
        
        for certificate in certificatesInBundle(bundle) {
            if let publicKey = publicKeyForCertificate(certificate) {
                publicKeys.append(publicKey)
            }
        }
        
        return publicKeys
    }
    
    fileprivate func publicKeyForCertificate(_ certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?
        
        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)
        
        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }
        
        return publicKey
    }
    
    fileprivate func publicKeysForTrust(_ trust: SecTrust) -> [SecKey] {
        var publicKeys: [SecKey] = []
        
        for index in 0..<SecTrustGetCertificateCount(trust) {
            if let certificate = SecTrustGetCertificateAtIndex(trust, index), let publicKey = publicKeyForCertificate(certificate) {
                publicKeys.append(publicKey)
            }
        }
        
        return publicKeys
    }
    
    fileprivate func trustIsValid(_ trust: SecTrust) -> Bool {
        var isValid = false
        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(trust, &result)
        
        if status == errSecSuccess {
            let unspecified = SecTrustResultType.unspecified
            let proceed = SecTrustResultType.proceed
            isValid = result == unspecified || result == proceed
        }
        
        return isValid
    }
    
}
