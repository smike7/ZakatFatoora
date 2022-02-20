# ZakatFatoora

![header](/images/header-zakat.png)

author: [@AlmuhaidlyF](https://twitter.com/AlmuhaidlyF)

A simple way to implement e-invoicing (FATOORA) for iOS. 

Zakat, Tax and Customs Authority Guide: [Guide](https://zatca.gov.sa/ar/E-Invoicing/SystemsDevelopers/Documents/QRCodeCreation.pdf)

## Installation 

To install this package, import `https://github.com/smike7/ZakatFatoora` in SPM. 

## usage example 

Generates QR Code and the encoded string based on the giving input


seller: The seller's name / اسم البائع 

vatRegistrationNumber: The VAT registration number of the seller (must be 15 characters) / رقم تعريف ضريبة القيمة المضافة 

timeStamp: Time stamp of the invoice (date and time) / وقت وتاريخ الفاتورة

invoiceTotalWithVAT: invoice total (with VAT) / المجموع الكلي للفاتورة مع الضريبة

vatTotal: VAT total / ضريبة القيمة المضافة


```swift 

import ZakatFatoora



ZakatFatoora.shared.generateQRCodeWithInfo(
    
    seller: "فيصل المهيدلي",
    vatRegistrationNumber: "123456789012345",
    timeStamp: "\(Date())",
    invoiceTotalWithVAT: "120",
    vatTotal: "\((15 * 120) / 100)"
    
) { result in
    
    switch result {
        
    case .failure(let error):
        
        print(error.rawValue)
        
    case .success(let results):
        
        self.yourImageView              = results.image
        self.yourTextView               = results.encodedString
    
    }
    
}


```

## Testing 


To test that the generated QR code complies with the regulations download this [app](https://apps.apple.com/sa/app/e-invoice-qr-reader-ksa/id1580793042). 



## Credits 

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


Swift, the Swift logo, Xcode, Instruments, Cocoa Touch, Touch ID, AirDrop, iBeacon, iPhone, iPad, Safari, App Store, watchOS, tvOS, Mac and macOS are trademarks of Apple Inc., registered in the U.S. and other countries.
