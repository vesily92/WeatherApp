//
//  Bundle + Decodable.swift
//  WeatherApp
//
//  Created by Василий Пронин on 18.04.2023.
//

import Foundation

extension Bundle {
    func decode<x: Decodable>(_ type: x.Type, from filename: String) -> x {
        guard let json = url(forResource: filename, withExtension: nil) else {
            fatalError("Failed to locate \(filename) in bundle.")
        }
        do {
            let jsonData = try Data(contentsOf: json)
            let decoder = JSONDecoder()
            let result = try decoder.decode(x.self, from: jsonData)
            return result
        } catch {
            print("Failed to load and decode JSON with error: \(error)")
        }
        
        fatalError("Failed to decode from bundle.")
    }
}
