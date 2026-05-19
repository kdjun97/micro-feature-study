import Alamofire
import CoreNetworkInterface
import Foundation

extension CoreNetworkClient {
    func call<Response: Decodable>(_ endpoint: CoreNetworkEndpoint) async throws -> Response {
        let response = await session
            .request(
                CoreNetworkRequest(
                    baseURL: baseURL,
                    endpoint: endpoint,
                    defaultHeaders: defaultHeaders
                ),
                interceptor: endpoint.requiresAuthorization ? requestInterceptor : nil
            )
            .validate(statusCode: 200..<300)
            .serializingDecodable(
                Response.self,
                decoder: decoder,
                emptyResponseCodes: [200]
            )
            .response

        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error.asCoreNetworkError()
        }
    }
}
