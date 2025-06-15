typealias Dependencies = HasShowDetailsFactoryProtocol
& HasApi

final class DependenciesContainer: Dependencies {
    lazy var api: any APIProtocol = API()
    lazy var showDetailsFactory: ShowDetailsFactoryProtocol = ShowDetailsAdapter(dependencies: self)
}
