//
//  NetworkManager.swift
//  Smartrac-Grohe
//
//  Created by Happy on 15/06/22.
//

import Foundation
import UIKit
import Alamofire

class NetworkingManager {
    static let instance = NetworkingManager()
    // Good to use private keyword to prevent other objects from creating their own instances
    private init() {}
    
    func postDetailsToServerMethod(_ urlstring:String, parameters:[String: AnyObject],completion:@escaping (_ responseDict:[String: AnyObject]) -> (),failure:@escaping(String) -> ()) {
//            print(urlstring)
//            print(parameters)
        guard let serviceUrl = URL(string: urlstring) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    completion(json as? [String : AnyObject] ?? [:])
                } catch {
                    print(error)
                    failure(error.localizedDescription)
                }
                }
            }
        }.resume()
            
        }
    
    func postDetailsDecodableToServerMethod(_ urlstring:String, parameters:[String: AnyObject],completion:@escaping (_ responseDict:AttandanceSummaryModel) -> (),failure:@escaping(String) -> ()) {
            print(urlstring)
            print(parameters)
           guard let serviceUrl = URL(string: urlstring) else { return }
           var request = URLRequest(url: serviceUrl)
           request.httpMethod = "POST"
           request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
           guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
               return
           }
           request.httpBody = httpBody
           let session = URLSession.shared
           session.dataTask(with: request) { (data, response, error) in
               if let response = response {
                   print(response)
               }
               if let data = data {
                   do {
                      do{
                           let jsonDecoder = JSONDecoder()
                           let mainData = try jsonDecoder.decode(AttandanceSummaryModel.self, from: data)
                           completion(mainData)
                       }catch let jsonErr {
                           print("Error decoding Json Questons", jsonErr)
                           failure(jsonErr.localizedDescription)
                       }
                       
                   } catch {
                       print(error)
                       failure(error.localizedDescription)
                   }
               }
           }.resume()
            
        }
    
    func postDecodeJSON(path:String,Parameters:[String:String],success:@escaping(Any)->(),failure:@escaping(Any)->()) {
        
        Alamofire.request(path,method:.post,parameters:Parameters).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if response.response?.statusCode == 200  {
                    if let dataDic = response.data {
                        success(dataDic)
                    }
                }else {
                    failure("Unable to get data")
                }
            case .failure(let error):
                if response.response?.statusCode != nil {
                    failure(error.localizedDescription)
                }else {
                    failure(error.localizedDescription)
                }
            }
            
        }
    }
    
    func getDecodeJSON(path:String,Parameters:[String:AnyObject],success:@escaping(Any)->(),failure:@escaping(Any)->()) {
       // let profile = DataSaveManager.sharedInstance.getTheUserProfileFromDB().profile//
        let headers = [
            //"Accept":"application/json",
           "Authorization":"Bearer "
        ]
        Alamofire.request(path,method:.get,parameters:Parameters,headers:headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if response.response?.statusCode == 200  {
                    if let dataDic = response.data {
                        success(dataDic)
                    }
                }else {
                    failure("Unable to get data")
                }
            case .failure(let error):
                if response.response?.statusCode != nil {
                    failure(error.localizedDescription)
                }else {
                    failure(error.localizedDescription)
                }
            }
            
        }
    }
    func generateBoundaryString() -> String{
        return "(UUID().uuidString)"
    }
    func sendDetailsToServerMethod(parametersDict:[String:Any],imageDataDic:[String:Data],baseUrl:String, success:@escaping([String: AnyObject])->(),failure:@escaping(String)->())
    {
        let boundary = generateBoundaryString()
        let headers = [
        "Accept":"application/json",
        "Content-Type":"multipart/form-data"]
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (theKey, theValue) in parametersDict {
                multipartFormData.append((theValue as! String).data(using: String.Encoding.utf8)!, withName: theKey )
            }
            
            
        },
                         usingThreshold: UInt64.init(),to:baseUrl,
                         method:.post,headers:headers)
        { (result) in
            switch result {
            case .success(let upload,_, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.request ?? "")  // original URL request
                    print(response.response ?? "") // URL response
                    print(response.data ?? "")     // server data
                    print(response.result)
                    print(response.result.value ?? "")
                    if response.result.value == nil {
                        failure(("Something went wrong please try again later"))
                    }else{
                       if let result = response.result.value {
                            if let loginDetails = result as? [String: AnyObject] {
                            success(loginDetails)
                           
                            }
                        }
                        
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                failure("Something went wrong please try again later")
            }
        }
    }
    
    func downloadPdf(pdfReport: String, completionHandler:@escaping(String, Bool)->()) {
        let boundary = generateBoundaryString()
        let downloadUrl: String = pdfReport
        let destinationPath: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
            let fileURL = documentsURL.appendingPathComponent("\(boundary).pdf")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        print(downloadUrl)
        Alamofire.download(downloadUrl, to: destinationPath)
            .downloadProgress { progress in

            }
            .responseData { response in
                print("response: \(response)")
                switch response.result{
                case .success:
                    if response.destinationURL != nil, let filePath = response.destinationURL?.absoluteString {
                        completionHandler(filePath, true)
                    }
                    break
                case .failure:
                    completionHandler("", false)
                    break
                }

        }
    }
    
    
}

