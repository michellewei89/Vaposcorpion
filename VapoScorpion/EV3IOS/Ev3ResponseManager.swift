//
//  Ev3ResponseManager.swift
//  EV3BTSpike
//
//  Created by Andre on 26.04.16.
//  Copyright © 2016 Andre. All rights reserved.
//

import Foundation

class Ev3ResponseManager {
    fileprivate static var nextSequence: UInt16 = 0x0001
    fileprivate static var responses = [UInt16 : Ev3Response]()
    
    fileprivate static func getSequenceNumber() -> UInt16  {
        if nextSequence == UInt16.max{
            nextSequence = nextSequence &+ 1 //unsigned overflow
        }
        nextSequence += 1
        return nextSequence;
    }
    
    static func createResponse() -> Ev3Response {
        let sequence = getSequenceNumber();
        let r = Ev3Response(sequence: sequence);
        responses.updateValue(r, forKey: sequence)
        return r;
    }
    
    static func handleResponse(_ report: [UInt8]){
        if report.count < 3 {
            return
        }
        
        //let sequence: UInt16 = (ushort) (report[0] | (report[1] << 8));
        
        //TODO seems not that the seqence number is stored le
        let sequence: UInt16 = UInt16(report[1]) << 8 | UInt16(report[0])
        
        if sequence < 1 {
            return
        }
        
        print("received reply for sequence number \(sequence)")
        
        let replyType: UInt8 = report[2]
        let rt = responses[sequence]
        
        if rt == nil {
            print("no item for sequence number \(sequence)")
            return
        }
        
        let r = rt!       
        
        
        if let rt = ReplyType(rawValue: replyType){
            r.replyType = rt
        }
        
        
        if(r.replyType != nil && ( r.replyType == .directReply || r.replyType == .directReplyError)) {
            let tmp = Data(bytes: UnsafePointer<UInt8>(report), count: report.count)
            // Michelle convert to swift 3
           // r.data = tmp.subdata(in: NSRange(location: 3, length: report.count - 3))
            r.data = tmp.subdata(in: 3 ..< report.count)
            
        }
        else if (r.replyType != nil && (r.replyType == .systemReply || r.replyType == .systemReplyError )){
            if let oc = SystemOpcode(rawValue: report[3]){
                r.systemCommand = oc
            }
            
            if let rs = SystemReplyStatus(rawValue: report[4]){
                r.systemReplyStatus = rs
            }
            
            let tmp = Data(bytes: UnsafePointer<UInt8>(report), count: report.count)
            // Michelle convert to swift 3
            // r.data = tmp.subdata(in: NSRange(location: 5, length: report.count - 5))
            r.data = tmp.subdata(in: 5 ..< report.count)
    
        }
        
        // informes the callback that a response for the command was received
        r.responseReceivedCallback?()        
    }
}


