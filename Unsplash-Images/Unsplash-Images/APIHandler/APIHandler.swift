//
//  APIHandler.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 30/10/23.
//

import Foundation
import Alamofire
class APIHandler{
    static let shared = APIHandler()
    private init() { }
    func sendRequest(_ page: Int,_ vc: ImagesViewController,_ refreshing: Bool = false)
    {
        let url = "https://api.unsplash.com/photos?page=\(page)&client_id=\(client_id)"
        let header: HTTPHeaders = [
            "Connection": "keep-alive"
        ]
        AF.request(url,method: .get,encoding: URLEncoding.default,headers: header).response{
            response in
            switch response.result{
            case .success(let data):
                if  response.response!.statusCode == 401{
                    AlertManager.shared.showAlert(from: vc, withTitle: "Unauthenticated", message: "Give valid client id")
                }
                else if response.response!.statusCode == 200{
                    do{
                        let jsonData = try JSONDecoder().decode([Result].self, from: data!)
                        DispatchQueue.main.async {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            
                            let sortedArray = jsonData.sorted { (first, second) in
                                if let firstDate = dateFormatter.date(from: first.created_at ?? "2000-01-01T00:00:00Z"),
                                   let secondDate = dateFormatter.date(from: second.created_at ?? "2000-01-01T00:00:00Z") {
                                    return firstDate > secondDate
                                } else {
                                    print("Something wrong at date")
                                    return false
                                }
                            }
                            vc.results.append(contentsOf: sortedArray)
                            vc.filteredData.append(contentsOf: sortedArray)
                            vc.spinner.stopAnimating()
                            vc.tableview.reloadData()
                            
                            if refreshing{
                                print("Ended refresh")
                                vc.refreshControl.endRefreshing()
                            }
                        }
                    }
                    catch{
                        print(error.localizedDescription)
                        vc.spinner.stopAnimating()
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    func filterAPI(_ page:Int,_ vc: ImagesViewController,_ topic:String)
    {
        
        let url = "https://api.unsplash.com/topics/\(topic)/photos?page=\(page)&client_id=\(client_id)"
        let header: HTTPHeaders = [
            "Connection": "keep-alive"
        ]
        
        AF.request(url,method: .get,encoding: URLEncoding.default,headers: header).response{
            response in
            switch response.result{
            case .success(let data):
                if response.response!.statusCode == 200{
                    do{
                        let jsonData = try JSONDecoder().decode([Result].self, from: data!)
                        DispatchQueue.main.async {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            
                            let sortedArray = jsonData.sorted { (first, second) in
                                if let firstDate = dateFormatter.date(from: first.created_at ?? "2000-01-01T00:00:00Z"),
                                   let secondDate = dateFormatter.date(from: second.created_at ?? "2000-01-01T00:00:00Z") {
                                    return firstDate > secondDate
                                } else {
                                    print("Something wrong at date")
                                    return false // Handle invalid dates here
                                }
                            }
                            vc.results.append(contentsOf: sortedArray)
                            vc.filteredData.append(contentsOf: sortedArray)
                            vc.spinner.stopAnimating()
                            vc.tableview.reloadData()
                            
                        }
                    }
                    catch{
                        print(error.localizedDescription)
                        vc.spinner.stopAnimating()
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
                
                vc.spinner.stopAnimating()
            }
        }
    }
}
