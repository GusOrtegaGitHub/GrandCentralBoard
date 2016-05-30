//
//  GitHubWidget.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 21/05/16.
//

import GCBCore


final class GitHubWidget: WidgetControlling {

    private let widgetView = GitHubWidgetView()

    let view: UIView
    let sources: [UpdatingSource]

    init(source: GitHubSource) {
        sources = [source]

        let wrapperViewModel = WidgetTemplateViewModel(title: "GitHub".uppercaseString,
                                                       subtitle: "Pull Requests".uppercaseString,
                                                       contentView: widgetView)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsets(top: 36, left: 27, bottom: 0, right: 27))
        view = WidgetTemplateView.viewWithViewModel(wrapperViewModel, layoutSettings: layoutSettings)
    }

    func update(source: UpdatingSource) {
        if let source = source as? GitHubSource {
            updateRepositories(source)
        }
    }

    private func updateRepositories(source: GitHubSource) {
        source.read { [weak self] result in
            switch result {
            case .Success(let repos):
                let items = repos.flatMap { GitHubCellViewModel(forRepository: $0) }
                self?.widgetView.configureWithViewModel(GitHubWidgetViewModel(cellItems: items))
            case .Failure:
                break
            }
        }
    }

}