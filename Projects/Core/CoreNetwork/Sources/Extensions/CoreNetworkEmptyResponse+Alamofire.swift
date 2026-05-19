import Alamofire
import CoreNetworkInterface

extension CoreNetworkEmptyResponse: @retroactive EmptyResponse {
    public static func emptyValue() -> CoreNetworkEmptyResponse {
        CoreNetworkEmptyResponse()
    }
}
