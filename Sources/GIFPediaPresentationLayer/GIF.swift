//
//  GIF.swift
//  
//
//  Created by USER on 2023/06/10.
//

import Foundation
import GIFPediaService

public struct GIF: Hashable, Equatable {
    public let id: String
    public let title: String
    public let thumbnailUrl: URL
    public let originalUrl: URL
    public let isPinned: Bool

    internal var entity: GIFEntity {
        GIFEntity(id: id, title: title, thumbnailUrl: thumbnailUrl, originalUrl: originalUrl)
    }
}

extension GIFEntity {
    internal func model(isPinned: Bool) -> GIF {
        GIF(id: id, title: title, thumbnailUrl: thumbnailUrl, originalUrl: originalUrl, isPinned: isPinned)
    }
}
