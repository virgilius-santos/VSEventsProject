import Foundation

struct DecodeError: Error, Equatable {
    let underlyingError: Error
    
    static func ==(lhs: DecodeError, rhs: DecodeError) -> Bool {
        (lhs.underlyingError as NSError) == (rhs.underlyingError as NSError)
    }
}

extension Result where Success == APIDataResult, Failure == APIErrorResult {
    func decodeTo<T: Decodable>(_ type: T.Type) -> Result<T, any Error> {
        do {
            let apiDataResult = try self.get()
            let data = try JSONDecoder().decode(T.self, from: apiDataResult.data)
            return .success(data)
        } catch let error as APIErrorResult {
            return .failure(error)
        } catch {
            return .failure(DecodeError(underlyingError: error))
        }
    }
}
