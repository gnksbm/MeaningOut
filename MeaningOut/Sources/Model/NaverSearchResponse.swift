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
        let title: String
        let link: String
        let image: String
        let lprice, hprice, mallName, productID: String
        let productType: String
        let brand: String
        let maker: String
        let category1: String
        let category2: String
        let category3: String
        let category4: String
        
        enum CodingKeys: String, CodingKey {
            case title, link, image, lprice, hprice, mallName
            case productID = "productId"
            case productType, brand, maker
            case category1, category2, category3, category4
        }
    }
}

extension NaverSearchResponse.Item: SearchResultCVCellData {
    var imageURL: URL? {
        URL(string: image.replacingOccurrences(of: "\\", with: ""))
    }
    var isLiked: Bool {
        @UserDefaultsWrapper(key: .likedList, defaultValue: [String]())
        var likedList
        return likedList.contains(productID)
    }
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
