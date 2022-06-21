import UIKit
import CoreLocation


struct Qiita : Codable{
    let results : Result
}
struct Result : Codable{
    let apiversion : String
    let resultsavailable: Int
    let resultsreturned : String
    let resultsstart: Int
    let shop: [Shop]
    
    
    enum CodingKeys: String, CodingKey {
        case apiversion = "api_version"
        case resultsavailable = "results_available"
        case resultsreturned = "results_returned"
        case resultsstart = "results_start"
    }
}

struct Shop: Codable {
    let name : String

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
        let task = URLSession.shared.dataTask(with: URL(string: newurl)!, completionHandler: {data, response, error in
        
            
            
            guard let jsonData = data else {
                return
            }
            do {
                let person = try JSONDecoder().decode(Qiita.self, from: jsonData)
                
                
               
                print(person)
                
            } catch {
                print("error:", error.localizedDescription)
            }
            
//            guard let json = result else{
//                return
//            }
        })
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
