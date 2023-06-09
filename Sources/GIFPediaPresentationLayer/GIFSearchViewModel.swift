//
//  GIFSearchViewModel.swift
//
//
//  Created by USER on 2023/06/10.
//

import Foundation
import GIFPediaService
import Combine

public final class GIFSearchViewModel: ObservableObject {

    // MARK: - Dependencies

    private let searchService: GIFPediaSearchService
    private let pinService: GIFFlagService

    // MARK: - Properties

    private var isLoading = false
    @Published public var queryText = ""
    @Published public private(set) var scrollTo: GIF? = nil
    @Published public private(set) var gifs: [GIF] = []

    // MARK: - Initializers

    public init(searchService: GIFPediaSearchService, pinService: GIFFlagService) {
        self.searchService = searchService
        self.pinService = pinService
        bind()
    }

    // MARK: - Private Methods

    private func bind() {
        Publishers.CombineLatest(searchService.gifsPublisher, pinService.flagged)
            .map { searchedEntities, pinnedEntities in
                searchedEntities.map { entity in
                    entity.model(isPinned: pinnedEntities.contains(entity))
                }
            }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$gifs)
    }

    // MARK: - Public Methods

    public func onAppear() {
        pinService.reload()
    }

    public func didTapSearchButton() {
        Task {
            isLoading = true
            await searchService.search(keyword: queryText)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.scrollTo = self?.gifs.first
            }
            isLoading = false
        }
    }

    public func didScroll(to gif: GIF) {
        guard !isLoading,
              !queryText.isEmpty,
              let index = gifs.lastIndex(of: gif),
              (gifs.count - 1 - index) < 30 else { return }
        Task {
            isLoading = true
            await searchService.requestNext()
            isLoading = false
        }
    }

    public func didDoubleTap(for gif: GIF) {
        if gif.isPinned {
            pinService.unflag(gif: gif.entity)
        } else {
            pinService.flag(gif: gif.entity)
        }
    }
}
