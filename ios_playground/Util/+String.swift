//
//  +String.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/23.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import CoreLocation


extension CLRegionState {
    public var description: String {
        get {
            switch self {
            case .inside:
                return "inside"
            case .outside:
                return "outside"
            case .unknown:
                return "unknown"
            }
        }
    }
}
