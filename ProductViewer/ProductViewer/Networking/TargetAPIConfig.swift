//
//  TargetAPIConfig.swift
//  Target Clone
//
//  Created by Gourav Kumar on 26/07/25.
//

import Foundation

//https://api.target.com/mobile_case_study_deals/v1
//https://api.target.com/mobile_case_study_deals/v1/deals
enum TargetAPIConfig {
    static let host = "api.target.com"
    static let scheme = "https"
    
    enum Path {
        static let basePath = "/mobile_case_study_deals/v1/deals"
    }
}
