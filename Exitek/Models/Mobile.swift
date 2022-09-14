//
//  Mobile.swift
//  Exitek
//
//  Created by Анатолий Миронов on 13.09.2022.
//

import Foundation

struct Mobile: Hashable {
    let imei: String
    let model: String
}

extension Mobile {
    static func getSomeMobiles() -> [Mobile] {
        var mobiles: [Mobile] = []
        mobiles.append(contentsOf: [
            Mobile(
                imei: "123",
                model: "iPhone11"
            ),
            Mobile(
                imei: "1234",
                model: "iPhone12"
            ),
            Mobile(
                imei: "12345",
                model: "iPhone13"
            )
        ])
        return mobiles
    }
}
