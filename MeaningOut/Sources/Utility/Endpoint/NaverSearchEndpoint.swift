//
//  NaverSearchEndpoint.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import Foundation

struct NaverSearchEndpoint: EndpointRepresentable {
    let query: String
    var filter: Filter
    var display: Int
    var page: UInt
    
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
            "sort": filter.toQuery
        ]
    }
    
    private var start: Int {
        return (Int(page) - 1) * display + 1
    }
    
    init(
        query: String,
        filter: Filter = .sim,
        display: Int = 15,
        page: UInt = 1
    ) {
        self.query = query
        self.filter = filter
        self.display = display
        self.page = page
    }
}

extension NaverSearchEndpoint {
    enum Filter: Int, CaseIterable, FiltarableOption {
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
                AF.request(
                    NaverSearchEndpoint(
                        query: "아이폰",
                        filter: .sim,
                        display: 10,
                        page: 1
                    )
                )
                .responseString { response in
                    label.text = response.value ?? "실패"
                }
            }
        }.swiftUIView
    }
}
#endif