//
//  PinnedGIFViewModel.swift
//  
//
//  Created by USER on 2023/06/10.
//

import Foundation
import GIFPediaService
import Combine

public final class PinnedGIFViewModel: ObservableObject {

    // MARK: - Dependencies

    private let pinService: GIFFlagService

    // MARK: - Properties

    @Published public private(set) var gifs: [GIF] = []

    // MARK: - Initializers

    public init(pinService: GIFFlagService) {
        self.pinService = pinService
        bind()
    }

    // MARK: - Private Methods

    private func bind() {
        pinService.flagged
            .map { entities in
                entities.map { entity in
                    entity.model(isPinned: true)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$gifs)
    }

    // MARK: - Public Methods

    public func onAppear() {
        pinService.reload()
    }

    public func didDoubleTap(for gif: GIF) {
        if gif.isPinned {
            pinService.unflag(gif: gif.entity)
        } else {
            pinService.flag(gif: gif.entity)
        }
    }
}
