//
//  MenuModel.swift
//  SampleFood
//
//  Created by Pankaj Yadav on 09/08/22.
//

import Foundation

//
//   let collectionViewData = try? newJSONDecoder().decode(CollectionViewData.self, from: jsonData)

import Foundation

// MARK: - CollectionViewDatum
struct CollectionViewDatum: Codable {
    let name: String
    let price: Int
    let instock: Bool
}

typealias CollectionViewData = [String: [CollectionViewDatum]]
