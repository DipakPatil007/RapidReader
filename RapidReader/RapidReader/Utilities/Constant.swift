//
//  Constant.swift
//  RapidReader
//
//  Created by Dipak on 17/09/25.
//

import Foundation

final class Constant {
    static var data = Constant()

    let apiURLString = "https://newsapi.org/v2/top-headlines?country=us&apiKey="
    let apiKey = KeychainHelper.standard.read(service: "com.rapidreader.api", account: "mainKey")
}
