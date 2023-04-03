//
//  SGCommonMethods.swift
//  Smartrac-Grohe
//
//  Created by Happy on 15/06/22.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0
import ARSLineProgress

class SGCommonMethods: NSObject {
class var SharedInstance: SGCommonMethods {
    struct Singleton {
        static let sharedInstance = SGCommonMethods()
    }
    return  Singleton.sharedInstance
}
    //MARK:- Show Loader Method
    func showLoader()  {
        ARSLineProgress.show()
    }
    
    static func restoreDefaults() {
        //ARSLineProgressConfiguration.backgroundViewColor = RGColors.ButtonsColor?.cgColor ?? UIColor.orange.cgColor
    }
    
    //MARK:- Hide Loader Method
    func hideLoader() {
        ARSLineProgress.hide()
    }
    
    //MARK:- ActionSheetPicker Method
    func showPicker(title:String,rows:[[Any]], initialSelection:
        [Int],completionPicking:@escaping (_ value:[String])->Void,controller :UIViewController) {
        
       ActionSheetMultipleStringPicker.show(withTitle: title, rows: rows, initialSelection: initialSelection, doneBlock: {
            picker, indexes, values in
            if let key = values! as? [String] {
                completionPicking(key)
                
            }
            print(values!)
            print("values = \(values)")
            print("indexes = \(indexes)")
            print("picker = \(picker)")
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: controller.view)
        
       }
    
    func converArrayToJsonstring(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func dateFormatTime(date : Date,format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func getCurrentTextDateMethod(currentDate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatedStartDate = dateFormatter.date(from: currentDate)
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: formatedStartDate ?? Date())
    }
    
    func convertDateFormateMethod(date:String) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd/MM/yyyy"
          let formatedStartDate = dateFormatter.date(from: date)
          dateFormatter.dateFormat = "yyyy-MM-dd"
          return dateFormatter.string(from: formatedStartDate ?? Date())// Jan 2, 2001
      }
      
      func convertDateMethod(date:String) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy/MM/dd"
          let formatedStartDate = dateFormatter.date(from: date)
          dateFormatter.dateFormat = "dd/MM/yyyy"
          return dateFormatter.string(from: formatedStartDate ?? Date())// Jan 2, 2001
      }
    
    func getTimeAndDateFromCurrentDate(dateString : String?) -> String {
         if  dateString != "" {
              let formatter = DateFormatter()
              formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            //"yyyy-MM-dd'T'HH:mm:ss"
               let fromDate = formatter.date(from: dateString ?? "")!
              formatter.dateFormat = "MMM d, yyyy"
              //formatter.dateStyle = .medium
              return formatter.string(from: fromDate as Date)
              
          }else {
              
              return "NA"
          }
          
      }
    
    //MARK:- Generate Boundary String Method
    func generateBoundaryString() -> String{
        return "\(UUID().uuidString)"
    }

    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }

}

extension Dictionary {

    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }

    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}

extension Date {

    static func getDateTimeMethod(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}

extension Date {

  func isEqualTo(_ date: Date) -> Bool {
    return self == date
  }
  
  func isGreaterThan(_ date: Date) -> Bool {
     return self > date
  }
  
  func isSmallerThan(_ date: Date) -> Bool {
     return self < date
  }
}

extension UIView {
    func addColors(colors: [UIColor], withPercentage percentages: [Double]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        var colorsArray: [CGColor] = []
        var locationsArray: [NSNumber] = []
        var total = 0.0
        locationsArray.append(0.0)
        for (index, color) in colors.enumerated() {
            // append same color twice
            colorsArray.append(color.cgColor)
            colorsArray.append(color.cgColor)
            // Calculating locations w.r.t Percentage of each
            if index+1 < percentages.count{
                total += percentages[index]
                let location: NSNumber = NSNumber(value: total/100)
                locationsArray.append(location)
                locationsArray.append(location)
            }
        }
        locationsArray.append(1.0)
        gradientLayer.colors = colorsArray
        gradientLayer.locations = locationsArray
        self.backgroundColor = .clear
        self.layer.addSublayer(gradientLayer)
    }
}

//extension UITextField {
//    func placeholderColor(color: UIColor) {
//        let attributeString = [
//            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
//            NSAttributedString.Key.font: self.font!
//        ] as [NSAttributedString.Key : Any]
//        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
//    }
//}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
