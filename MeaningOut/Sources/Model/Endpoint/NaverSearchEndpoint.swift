//
//  NaverSearchEndpoint.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import Foundation

struct NaverSearchEndpoint: EndpointRepresentable {
    let query: String
    var sort: Sort
    /// 검색 시작 위치(기본값: 1, 최댓값: 1000)
    var display: Int
    var page: Int
    
    var httpMethod: HTTPMethod { .get }
    var scheme: Scheme { .https }
    var host: String { "openapi.naver.com" }
    var path: String { "/v1/search/shop.json" }
    var header: [String : String]? {
        [
            "X-Naver-Client-Id": APIKey.naverID,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
    }
    var queries: [String : String]? {
        [
            "query": query,
            "display": "\(display)",
            "start": "\(start)",
            "sort": sort.toQuery
        ]
    }
    /// 한 번에 표시할 검색 결과 개수(기본값: 10, 최댓값: 100)
    private var start: Int {
        (page - 1) * display + 1
    }
    
    init(
        query: String,
        sort: Sort = .sim,
        display: Int = 30,
        page: Int = 1
    ) {
        self.query = query
        self.sort = sort
        self.display = display
        self.page = page
    }
    
    func isFinalPage(total: Int) -> Bool {
        guard 1...100 ~= display,
              1...1000 ~= start else { return true }
        return page * display >= total
    }
}

extension NaverSearchEndpoint {
    func toURL() -> URL? {
        guard 1...100 ~= display,
              1...1000 ~= start else { return nil }
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.port = port
        components.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return components.url
    }
}

extension NaverSearchEndpoint {
    enum Sort: Int, CaseIterable, SortOption {
        /// 정확도순으로 내림차순 정렬(기본값)
        case sim
        /// 날짜순으로 내림차순 정렬
        case date
        /// 가격순으로 내림차순 정렬
        case dsc
        /// 가격순으로 오름차순 정렬
        case asc
        
        var title: String {
            switch self {
            case .sim:
                "정확도순"
            case .date:
                "날짜순"
            case .dsc:
                "가격높은순"
            case .asc:
                "가격낮은순"
            }
        }
        
        var toQuery: String {
            String(describing: self)
        }
    }
}

#if DEBUG
import SwiftUI

import Alamofire
import SnapKit

struct NaverSearchEndpointPreview: PreviewProvider {
    static var previews: some View {
        UIViewController().build { builder in
            builder.action { vc in
                let label = UILabel()
                label.numberOfLines = 0
                vc.view.addSubview(label)
                label.snp.makeConstraints { make in
                    make.edges.equalTo(vc.view.safeAreaLayoutGuide)
                }
                let endpoint = NaverSearchEndpoint(
                    query: "아이폰",
                    sort: .sim,
                    display: 1,
                    page: 1
                )
                AF.request(endpoint)
                    .responseString { response in
                        guard let statusCode = response.response?.statusCode,
                              200..<300 ~= statusCode
                        else {
                            label.text =
                            "잘못된 URL: \(endpoint.toURL()?.absoluteString ?? "URL nil")"
                            return
                        }
                        label.text = response.value ?? "값 없음"
                    }
            }
        }.swiftUIView
    }
}
#endif
