import UIKit
import CoreLocation


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let temperatures = try? newJSONDecoder().decode(Temperatures.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let temperatures = try? newJSONDecoder().decode(Temperatures.self, from: jsonData)

import Foundation

// MARK: - Temperatures
struct Temperatures: Codable {
    let results: Results
}

// MARK: - Results
struct Results: Codable {
    let apiVersion: String
    let resultsAvailable: Int
    let resultsReturned: String
    let resultsStart: Int
    let shop: [Shop]

    enum CodingKeys: String, CodingKey {
        case apiVersion = "api_version"
        case resultsAvailable = "results_available"
        case resultsReturned = "results_returned"
        case resultsStart = "results_start"
        case shop
    }
}

// MARK: - Shop
struct Shop: Codable {
    let access, address, band, barrierFree: String
    let budget: Budget
    let budgetMemo: String
    let capacity: Int
    let card, shopCatch, charter, child: String
    let close: String
    let couponUrls: CouponUrls
    let course, english, freeDrink, freeFood: String
    let genre: Genre
    let horigotatsu, id, karaoke: String
    let ktaiCoupon: Int
    let largeArea, largeServiceArea: Area
    let lat, lng: Double
    let logoImage: String
    let lunch: String
    let middleArea: Area
    let midnight, mobileAccess, name, nameKana: String
    let nonSmoking, shopOpen, otherMemo, parking: String
    let partyCapacity: PartyCapacity
    let pet: String
    let photo: Photo
    let privateRoom: String
    let serviceArea: Area
    let shopDetailMemo, show: String
    let smallArea: Area
    let stationName: Name
    let tatami, tv: String
    let urls: Urls
    let wedding, wifi: String

    enum CodingKeys: String, CodingKey {
        case access, address, band
        case barrierFree = "barrier_free"
        case budget
        case budgetMemo = "budget_memo"
        case capacity, card
        case shopCatch = "catch"
        case charter, child, close
        case couponUrls = "coupon_urls"
        case course, english
        case freeDrink = "free_drink"
        case freeFood = "free_food"
        case genre, horigotatsu, id, karaoke
        case ktaiCoupon = "ktai_coupon"
        case largeArea = "large_area"
        case largeServiceArea = "large_service_area"
        case lat, lng
        case logoImage = "logo_image"
        case lunch
        case middleArea = "middle_area"
        case midnight
        case mobileAccess = "mobile_access"
        case name
        case nameKana = "name_kana"
        case nonSmoking = "non_smoking"
        case shopOpen = "open"
        case otherMemo = "other_memo"
        case parking
        case partyCapacity = "party_capacity"
        case pet, photo
        case privateRoom = "private_room"
        case serviceArea = "service_area"
        case shopDetailMemo = "shop_detail_memo"
        case show
        case smallArea = "small_area"
        case stationName = "station_name"
        case tatami, tv, urls, wedding, wifi
    }
}

// MARK: - Budget
struct Budget: Codable {
    let average, code, name: String
}

// MARK: - CouponUrls
struct CouponUrls: Codable {
    let pc, sp: String
}

// MARK: - Genre
struct Genre: Codable {
    let genreCatch, code, name: String

    enum CodingKeys: String, CodingKey {
        case genreCatch = "catch"
        case code, name
    }
}

// MARK: - Area
struct Area: Codable {
    let code: String
    let name: Name
}

enum Name: String, Codable {
    case 東京 = "東京"
    case 東大和 = "東大和"
    case 玉川上水 = "玉川上水"
    case 関東 = "関東"
    case 青梅昭島小作青梅線沿線 = "青梅・昭島・小作・青梅線沿線"
}

enum PartyCapacity: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(PartyCapacity.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PartyCapacity"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Photo
struct Photo: Codable {
    let mobile: Mobile
    let pc: PC
}

// MARK: - Mobile
struct Mobile: Codable {
    let l, s: String
}

// MARK: - PC
struct PC: Codable {
    let l, m, s: String
}

// MARK: - Urls
struct Urls: Codable {
    let pc: String
}


class ViewController: UIViewController, CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate {

    var couponBenefit: String = ""
    @IBOutlet weak var locationInfoLabel: UITextView!
    
    @IBOutlet weak var tableView: UITableView!

    
    let locationManager = CLLocationManager()
    
    var articles:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        //APIkey
//        let API_KEY = "2df1a79aa99e96fb"
//        let url  = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=" + API_KEY + "&large_area=Z011"
//        print(url)
        
        
    }
    
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            
            if let error = error {
                print("reverseGeocodeLocation Failed: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?[0] {
                
                var locInfo = ""
                locInfo = locInfo + "Latitude: \(loc.coordinate.latitude)\n"
                locInfo = locInfo + "Longitude: \(loc.coordinate.longitude)\n\n"
                
                locInfo = locInfo + "Country: \(placemark.country ?? "")\n"
                locInfo = locInfo + "State/Province: \(placemark.administrativeArea ?? "")\n"
                locInfo = locInfo + "City: \(placemark.locality ?? "")\n"
                locInfo = locInfo + "PostalCode: \(placemark.postalCode ?? "")\n"
                locInfo = locInfo + "Name: \(placemark.name ?? "")"
                
                
                let Latitude = loc.coordinate.latitude
                let Longitude = loc.coordinate.longitude
                
                let newLatitude = String(Latitude)
                let newLongitude = String(Longitude)
                self.locationInfoLabel.text = locInfo

                    //ここからAPIになります
                
                let newurl = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=2df1a79aa99e96fb&lat=" + newLatitude + "&lng=" +  newLongitude + "&range=2&order=1&format=json"
                print(newurl)
                
                self.getData(from:newurl)
            }
                
        })
                
    }
    
    
    
    
    
    
    private func getData(from newurl:String){
        print(newurl)
        let url: URL = URL(string: newurl)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        
            print(data)
            
            
            if let  error = error {
                print("era-")
            }
            do {
//                var personalData = String(data: data!, encoding: .utf8)!
//                print(personalData)
                let person = try JSONDecoder().decode(Temperatures.self, from: data!)
                
                
               
                print(person.results)
                
            } catch {
                print("error:", error.localizedDescription)
            }
            
//            guard let json = result else{
//                return
//            }
        }
        task.resume()
    }
                
//                let task = URLSession.shared.dataTask(with: newurl!, completionHandler: {data, response, error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        print("通信が失敗しました")
//                        return
//                    }
//
//                    if let data = data{
//                        do {
//                            // パターン1
//                            // 結果：通信結果のJSONをStringで得る。  -> { "id": 1, "name": "GOOD" }
//                            var personalData = String(data: data, encoding: .utf8)!
//                            print("ここからはUTF8")
//                        //print(personalData)
//                            print(data)
//                            // パターン2:JSON形式を構造体(Struct）に変換して使用する
//                            // パターン3:Dictionary(辞書)型に変換して使用する
//
//                            //let object = try JSONSerialization.jsonObject(with: personalData) as! [String:Any]
//                            let object = try JSONDecoder().decode([Qiita].self, from: data)
//                            print(object)
//                            print("テスト")
//                            print("object:",object)  // 辞書型に変換したJSONから値name(String)を取り出す。
//                        } catch let error {
//                            print("エラーが入りました",error)
//                        }
//
//
//                    }

        //                        print("statusCode:\(response.statusCode)")


        //                    let personalData: Data =  newurl.data(using: String.Encoding.utf8)!
        //                    print(personalData)
        //
        //                    do {
        //                        // パースする
        //                        let items = try JSONSerialization.jsonObject(with: personalData) as! Dictionary<String, Any>
        //                        print(items["id"] as! Int) // メンバid Intにキャスト
        //                        print(items["name"] as! String) // メンバname Stringにキャスト
        //                    } catch {
        //                        print(error)
        //                    }
//                })
//                task.resume()
 //実行する
            
                
            
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを作る
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "couponCell")
        //テキストにクーポン特典を設定
        cell.textLabel?.text = self.couponBenefit
        //サブテキストにクーポンの有効期限を設定

        return cell
    }
        
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
   
//    url += "&latitude=" + String(loc.latitude)
//    url += "&longitude=" + String(loc.longitude)

}
