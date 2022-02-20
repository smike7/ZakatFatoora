
/*
 
MIT License

Copyright (c) 2022 Faisal H Almuhaidly

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files, to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

 
Credit/Author: https://twitter.com/AlmuhaidlyF
*/

import UIKit
import CoreImage.CIFilterBuiltins



@available(iOS 13.0, *)
public class ZakatFatoora {
    
    
    ///Enum containing error cases and their description.
    public enum InvoiceError: String, Error {
        case invalidVatID           = "The VAT registration number of the seller must contain 15 numbers."
        case noQRCode               = "Could not generate QR Code."
        case invalidValuesLength    = "Values length is too large. "
        case noEncodedString        = "Could not encode string to Base-64."
    }
    
    
    
    public static let shared               = ZakatFatoora()
    
    // The array containing all the Tag's Length's Value's
    private var tlvs: [UInt8]       = []
    
    // QR Code Image generation
    private let context             = CIContext()
    private let filter              = CIFilter.qrCodeGenerator()
    
    private init() { }
    
    ///Generates QR Code and the encoded string based on the giving input
    /// - Parameters:
    ///    - seller: The seller's name - اسم البائع
    ///    - vatRegistrationNumber:The VAT registration number of the seller (must be 15 characters) -  رقم تعريف ضريبة القيمة المضافة للبائع
    ///    - timeStamp: Time stamp of the invoice (date and time) - وقت وتاريخ الفاتورة
    ///    - invoiceTotalWithVAT: invoice total (with VAT) - المجموع الكلي للفاتورة مع الضريبة
    ///    - vatTotal: VAT total - قيمة الضريبة
    ///    - Returns: result tuple in case of success which contains the image and the encoded string or error in case of failure.
    public func generateQRCodeWithInfo(seller: String, vatRegistrationNumber: String, timeStamp: String, invoiceTotalWithVAT: String, vatTotal: String, completion: (Result<(image: UIImage, encodedString: String), InvoiceError>) -> () ) {
        
        
        
        guard vatRegistrationNumber.count == 15 else {completion(.failure(.invalidVatID)); return}
        
        guard seller.utf8.count < 256, vatRegistrationNumber.utf8.count < 256, timeStamp.utf8.count < 256, invoiceTotalWithVAT.utf8.count < 256, vatTotal.utf8.count < 256 else {completion(.failure(.invalidValuesLength)); return}
        
        
        
        
        let tlvs1                   = [UInt8("1")!, UInt8(seller.utf8.count)] + valueInUInt8(seller)
        
        let tlvs2                   = [UInt8("2")!, UInt8(vatRegistrationNumber.utf8.count)] + valueInUInt8(vatRegistrationNumber)
        
        let tlvs3                   = [UInt8("3")!, UInt8(timeStamp.utf8.count)] + valueInUInt8(timeStamp)
        
        let tlvs4                   = [UInt8("4")!, UInt8(invoiceTotalWithVAT.utf8.count)] + valueInUInt8(invoiceTotalWithVAT)
        
        let tlvs5                   = [UInt8("5")!, UInt8(vatTotal.utf8.count)] + valueInUInt8(vatTotal)
        
        tlvs                        = tlvs1 + tlvs2 + tlvs3 + tlvs4 + tlvs5
        
        
        
        guard let image             = qrCodeImage(tlvs: tlvs) else {completion(.failure(.noQRCode)); return}
        
        guard let encodedString     = base64EncodedString(tlvs) else {completion(.failure(.noEncodedString)); return}
        
        completion(.success((image, encodedString)))
        
    }
    
    private func valueInUInt8(_ value: String) -> [UInt8] {
        return [UInt8](value.utf8)
    }
    private func base64EncodedString(_ tlvs: [UInt8]) -> String? {
        guard !tlvs.isEmpty else {return nil}
        return Data(tlvs).base64EncodedString()
    }
    
    private func qrCodeImage(tlvs: [UInt8]) -> UIImage? {
        guard !tlvs.isEmpty else {return nil}
        if let encodedString = base64EncodedString(tlvs) {
            return getQrCodeImage(encodedString)
        } else {
            return nil
        }
    }
    private func getQrCodeImage(_ string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
        
        
    }
    
}
