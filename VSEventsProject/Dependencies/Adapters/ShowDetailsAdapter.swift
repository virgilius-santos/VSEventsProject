import UIKit

final class ShowDetailsAdapter: ShowDetailsFactoryProtocol {
    typealias Dependencies = HasApi
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func make(eventItem: Event) -> UIViewController {
        ShowDetailsConfigurator(dependencies: dependencies).make(eventItem: eventItem)
    }
}
