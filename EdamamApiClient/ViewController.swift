//
//  ViewController.swift
//  EdamamApiClient
//
//  Created by Fumiya Tanaka on 2021/03/08.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    // APIのURL
    let nutritionBaseUrl: URL = URL(string: "https://api.edamam.com/search?app_id=\(appId)&app_key=\(appKey)")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startRequest() {
        fetchNutrition()
    }

    func fetchNutrition() {
        
        var components: URLComponents = URLComponents(url: nutritionBaseUrl, resolvingAgainstBaseURL: false)!
        let queryItem = URLQueryItem(name: "q", value: "ラーメン")
        components.queryItems?.append(queryItem)
        let url = components.url!
        
        var request = URLRequest(url: url)
        request.method = .get
        request.headers = HTTPHeaders([
            .contentType("application/json")
        ])
        
        AF.request(request).response { (response) in
            if let error = response.error {
                print(error)
                return
            }
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(NutritionResponse.self, from: data)
                    print(response)
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct NutritionResponse: Decodable {
    
    let hits: [HitItem]
    
    struct HitItem: Decodable {
        let recipe: HitRecipe
    }
    
    struct HitRecipe: Decodable {
        let url: String
        let label: String
        let image: String
        let source: String
        let dietLabels: [String]
        let healthLabels: [String]
        let cautions: [String]
        
        let totalNutrients: Nutrients
    }
    
    struct Nutrients: Decodable {
        let ENERC_KCAL: Nutrient?
        let FAT: Nutrient?
        let FASAT: Nutrient?
        let FATRN: Nutrient?
        let FAMS: Nutrient?
        let FAPU: Nutrient?
        let CHOCDF: Nutrient?
        let FIBGT: Nutrient?
        let SUGAR: Nutrient?
        let PROCNT: Nutrient?
        let CHOLE: Nutrient?
        let NA: Nutrient?
        let CA: Nutrient?
        let MG: Nutrient?
        let K: Nutrient?
        let FE: Nutrient?
        let ZN: Nutrient?
        let P: Nutrient?
        let VITA_RAE: Nutrient?
        let VIC: Nutrient?
        let THIA: Nutrient?
        let RIBF: Nutrient?
        let NIA: Nutrient?
        let VITB6A: Nutrient?
        let FOLDFE: Nutrient?
    }
    
    struct Nutrient: Decodable {
        let label: String
        let quantity: Float
        let unit: String
    }
}

