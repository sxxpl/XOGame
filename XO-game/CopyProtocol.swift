//
//  CopyProtocol.swift
//  XO-game
//
//  Created by Артем Тихонов on 22.08.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation
protocol Copying {
    init(_ prototype: Self)
}

extension Copying {
    func copy() -> Self {
        return type(of: self).init(self) }
}
