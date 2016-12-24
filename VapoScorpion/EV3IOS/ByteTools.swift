//
//  ByteTools.swift
//  EV3BTSpike
//
//  Created by Andre on 11.05.16.
//  Copyright © 2016 Andre. All rights reserved.
//

import Foundation

class ByteTools{
    
    /**
     stolen from http://stackoverflow.com/questions/1305225/best-way-to-serialize-an-nsdata-into-a-hexadeximal-string
     */
    static func asHexString(_ data:Data)->String{
        
        if data.count > 0 {
            let  hexChars = Array("0123456789abcdef".utf8) as [UInt8];
            let buf = UnsafeBufferPointer<UInt8>(start: (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), count: data.count);
            var output = [UInt8](repeating: 0, count: data.count*2 + 1);
            var ix:Int = 0;
            for b in buf {
                let hi  = Int((b & 0xf0) >> 4);
                let low = Int(b & 0x0f);
                output[ix] = hexChars[ hi];
                ix += 1
                output[ix] = hexChars[low];
                ix += 1                
            }
            let result = String(cString: UnsafePointer(output));
            return result;
        }
        return "";
    }
    
    /**
     Takes a uint32 and converts it to a byte array
     */
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
    
    /**
     Returns the first byte of a int16 value
     */
    static func firstByteOfInt16(_ value: Int16) -> UInt8{
        let all = int16ToUint8Array(value)
        return all[1]
    }
    
    static func convertToUInt8(_ data: Data, position: Int) -> UInt8{
        var out: UInt8 = 0
        (data as NSData).getBytes(&out, range: NSMakeRange(position, 1))
        return out
    }
    
}

/// internal extension to write bytes to the nsmutabledata
extension NSMutableData{
    
    /// Appends UInt32 in BE format
    func appendUInt32(_ value : UInt32) {
        var val = value.bigEndian
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    /// Appends UInt32 in BE format
    func appendUInt32LE(_ value : UInt32) {
        var val = value.littleEndian
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    /// Appends UInt16 in LE format
    func appendUInt16LE(_ value: UInt16){
        var val = value.littleEndian
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    /// Apppends Int16 in BE format
    func appendInt16(_ value: Int16){
        var val = value.bigEndian
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    /// Apppends Int16 in LE format
    func appendInt16LE(_ value: Int16){
        var val = value.littleEndian
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    /// Appends UInt16 in BE format
    func appendUInt16(_ value : UInt16) {
        var val = value.bigEndian
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    func appendUInt8(_ value : UInt8) {
        var val = value
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
}
