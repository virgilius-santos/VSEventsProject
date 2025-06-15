typealias CommonDependencies = AnyObject
& HasApi

typealias SceneDependencies = AnyObject
& HasShowDetailsFactoryProtocol
& HasShowEventsFactoryProtocol

typealias Dependencies = AnyObject
& CommonDependencies
& SceneDependencies

final class DependenciesContainer: Dependencies {
    lazy var api: any APIProtocol = API()
    
    lazy var showDetailsFactory: ShowDetailsFactoryProtocol = ShowDetailsConfigurator(dependencies: self)
    lazy var showEventsFactory: ShowEventsFactoryProtocol = ShowEventsConfigurator(dependencies: self)
}
