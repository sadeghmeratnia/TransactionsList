//
//  NetworkAgent.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import RxSwift
import UIKit

class EWNetworkAgent {
    private let baseURL: URL?
    private var decoder: JSONDecoder!
    private var encoder: JSONEncoder!
    private var session: URLSession!

    init(baseUrl: URL?) {
        self.baseURL = baseUrl
        self.setupURLSessionConfiguration()
        self.setupDecoder()
        self.setupEncoder()
    }

    func setupURLSessionConfiguration() {
        let config = URLSessionConfiguration.default
        config.httpShouldSetCookies = false
        config.httpCookieAcceptPolicy = .never
        config.networkServiceType = .responsiveData
        config.timeoutIntervalForRequest = 30
        config.shouldUseExtendedBackgroundIdleMode = true
        self.session = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
    }

    func setupDecoder() {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base64
        decoder.dateDecodingStrategy = .millisecondsSince1970
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "Infinity",
            negativeInfinity: "-Infinity",
            nan: "NaN"
        )

        self.decoder = decoder
    }

    func setupEncoder() {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(Int64(date.timeIntervalSinceNow * 1000))
        }

        self.encoder = encoder
    }

    func request<R: APIRouter>(
        _ router: R,
        shouldUseDynamicKey _: Bool = true,
        useCache _: Bool = false,
        checkSum _: String? = nil
    ) -> Observable<R.ResponseType?> {
        let decodableType = type(of: router)

        do {
            guard let url = URL(string: decodableType.path, relativeTo: baseURL) else {
                throw NetworkError.parsing
            }

            var request = URLRequest(url: url)
            request.httpMethod = decodableType.method.rawValue

            switch decodableType.requestType {
            case .jsonBody:
                if let data = router.requestBody?.toJSON() {
                    request.httpBody = data
                }
            case .urlQuery:
                if let parameters = router.queryParams {
                    parameters.forEach { value in
                        guard var URLString = request.url?.absoluteString else { return }
                        URLString.append("/\(value)")
                        request.url = URL(string: URLString)
                    }
                }
            case .httpHeader:
                request.httpBody = nil
            default:
                fatalError()
            }

            request.addValue("text/plain", forHTTPHeaderField: "accept")
            request.addValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")

            return self.run(request)

        } catch {
            return Observable<R.ResponseType?>.create { observer in
                observer.onError(error)
                return Disposables.create()
            }.observe(on: MainScheduler.instance)
        }
    }

    func run<C: Codable>(_ request: URLRequest) -> Observable<C?> {
        return Observable<C?>
            .create { observer in
                let task = self.session.dataTask(with: request) { data, response, error in
                    do {
                        if let error = error { throw error }

                        guard
                            response as? HTTPURLResponse != nil,
                            let data = data
                        else { throw NetworkError.server }

                        let model = try self.decoder.decode(C.self, from: data)

                        observer.onNext(model)

                    } catch {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }

                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            }
            .observe(on: MainScheduler.instance)
    }

    private func validate(response _: HTTPURLResponse, data: Data?) throws -> Data {
        guard let data = data else { throw NetworkError.server }
        return data
    }
}
