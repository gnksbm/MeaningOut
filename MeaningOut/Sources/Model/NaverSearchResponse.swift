//
//  NaverSearchResponse.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import Foundation

struct NaverSearchResponse: Decodable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

extension NaverSearchResponse {
    struct Item: Decodable, Hashable {
        private let title: String
        private let link: String
        private let image: String
        private let lprice, hprice, mallName: String
        let productID: String
        private let productType: String
        private let brand: String
        private let maker: String
        private let category1: String
        private let category2: String
        private let category3: String
        private let category4: String
        
        enum CodingKeys: String, CodingKey {
            case title, link, image, lprice, hprice, mallName
            case productID = "productId"
            case productType, brand, maker
            case category1, category2, category3, category4
        }
    }
}

extension NaverSearchResponse.Item {
    var detailURL: URL? {
        URL(string: link.replacingOccurrences(of: "\\", with: ""))
    }
}

extension NaverSearchResponse.Item: SearchResultCVCellData {
    var imageURL: URL? {
        URL(string: image.replacingOccurrences(of: "\\", with: ""))
    }
    var isLiked: Bool { User.favoriteProductID.contains(productID) }
    var storeName: String { maker }
    var productDescription: String { title.removeHTMLTags() }
    var price: String { lprice.formattedPrice() }
}

#if DEBUG
extension NaverSearchResponse {
    static var mock: Self {
        guard let url = Bundle.main.url(
            forResource: "NaverSearchResponse",
            withExtension: "json"
        ),
              let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode(Self.self, from: data)
        else { fatalError("NaverSearchResponse.json 변환 실패") }
        return result
    }
}
#endif
