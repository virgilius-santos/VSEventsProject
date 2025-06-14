import Foundation

protocol DetailAPIProtocol {
    func fetchEvent(_ event: Event, completion: @escaping (Swift.Result<Event, Error>) -> Void)
    func checkIn(user: User, completion: @escaping (Result<CheckIn, Error>) -> Void)
}

final class ShowDetailsService: DetailAPIProtocol {
    let api: APIProtocol
    
    init(api: APIProtocol = API()) {
        self.api = api
    }
    
    func getEventStringURL(path: String) -> String {
        "https://vsevents.free.beeceptor.com/api/events/\(path)"
    }
    
    func fetchEvent(_ event: Event, completion: @escaping (Result<Event, any Error>) -> Void) {
        let endpoint = Endpoint(
            method: .get,
            url: getEventStringURL(path: event.id)
        )
        api.fetch(endpoint: endpoint) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                completion(mapResult(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func mapResult(_ data: Data) -> Result<Event, any Error> {
        do {
            let decodedObject = try Event.decoder(json: data)
            return .success(decodedObject)
        } catch {
            return .failure(error)
        }
    }
    
    let postCheckIngStringURL = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin"
    
    func checkIn(user: User, completion: @escaping (Result<CheckIn, any Error>) -> Void) {
        let data: Data?
        do {
            data = try user.toData()
        } catch {
            completion(.failure(error))
            return
        }
        
        let endpoint = Endpoint(
            method: .post,
            url: postCheckIngStringURL,
            parameters: data
        )
        api.fetch(endpoint: endpoint) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                completion(mapResult(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func mapResult(_ data: Data) -> Result<CheckIn, any Error> {
        do {
            let decodedObject = try CheckIn.decoder(json: data)
            return .success(decodedObject)
        } catch {
            return .failure(error)
        }
    }
}
