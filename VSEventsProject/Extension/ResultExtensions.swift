import Foundation

extension Swift.Result where Success == Data, Failure == Error {
    func decodeTo<T: Decodable>(_ type: T.Type) -> Swift.Result<T, Failure> {
        flatMap { data in
            Swift.Result {
                try T.decoder(json: data)
            }
        }
    }
}
