//
//  tempfile.swift
//  VapoScorpion
//
//  Created by Wen Wei on 21/12/2016.
//  Copyright © 2016 Michelle Wei. All rights reserved.
//

import Foundation

static func uint32ToUint8Array(_ value: UInt32) -> [UInt8]{
    //michelle
    /* orginal
     var bigEndian = value.bigEndian
     let bytePtr = withUnsafePointer(to: &bigEndian) {
     UnsafeBufferPointer<UInt8>(start: UnsafePointer($0), count: MemoryLayout.size(ofValue: bigEndian))
     }
     */
    var bigEndian = value.bigEndian
    let count = MemoryLayout<UInt32>.size
    let bytePtr = withUnsafePointer(to: &bigEndian) {
        $0.withMemoryRebound(to: UInt8.self, capacity: count) {
            UnsafeBufferPointer(start: $0, count: count)
        }
    }
    return Array(bytePtr)
}

/**
 Takes a int16 and converts it to a byte array
 */
static func int16ToUint8Array(_ value: Int16) -> [UInt8]{
    // michelle
    /*
     var bigEndian = value.bigEndian
     let bytePtr = withUnsafePointer(to: &bigEndian) {
     UnsafeBufferPointer<UInt8>(start: UnsafePointer($0), count: MemoryLayout.size(ofValue: bigEndian))
     }
     */
    var bigEndian = value.bigEndian
    let count = MemoryLayout<UInt16>.size
    let bytePtr = withUnsafePointer(to: &bigEndian) {
        $0.withMemoryRebound(to: UInt8.self, capacity: count) {
            UnsafeBufferPointer(start: $0, count: count)
        }
    }
    return Array(bytePtr)
}

//michelle
//let data = Data(bytes: UnsafePointer<UInt8>((c.response!.data! as NSData).bytes), count: c.response!.data!.count)
let ptr = (c.response!.data! as NSData).bytes.assumingMemoryBound(to: UInt8.self)
let data = Data(bytes: ptr, count: c.response!.data!.count)
//
receivedRaw(data)


if(r.replyType != nil && ( r.replyType == .directReply || r.replyType == .directReplyError)) {
    let tmp = Data(bytes: UnsafePointer<UInt8>(report), count: report.count)
    // Michelle convert to swift 3
    // r.data = tmp.subdata(in: NSRange(location: 3, length: report.count - 3))
    r.data = tmp.subdata(in: 3 ..< report.count)


    let tmp = Data(bytes: UnsafePointer<UInt8>(report), count: report.count)
    // Michelle convert to swift 3
    // r.data = tmp.subdata(in: NSRange(location: 5, length: report.count - 5))
    r.data = tmp.subdata(in: 5 ..< report.count)





