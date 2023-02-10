//
//  ChekInternet.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 10.02.2023.
//

import Foundation

import SystemConfiguration

//public class TestInternetConnection {
//    
//    class func connectedToNetwork() -> Bool {
//        
//        var zeroAddress = sockaddr_in()
//        
//        zeroAddress.sin_len = UInt8(zeroAddress)
//        
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
//            
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//            
//        }) else {
//            
//            return false
//            
//        }
//        
//        var flags : SCNetworkReachabilityFlags = []
//        
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
//            
//            return false
//            
//        }
//        
//        let isReachable = flags.contains(.reachable)
//        
//        let needsConnection = flags.contains(.connectionRequired)
//        
//        return (isReachable && !needsConnection)
//        
//    }
//    
//}
