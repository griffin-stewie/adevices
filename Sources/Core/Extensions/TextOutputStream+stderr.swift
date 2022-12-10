import Darwin
    
public struct StandardError: TextOutputStream {
    public mutating func write(_ string: String) {
        for byte in string.utf8 { putc(numericCast(byte), stderr) }
    }
}