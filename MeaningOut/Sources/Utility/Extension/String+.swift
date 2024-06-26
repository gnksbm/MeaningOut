//
//  String+.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import Foundation

extension String {
    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "MeaningOut"
    
    func formattedPrice() -> String {
        Int(self)?
            .formatted(
                .currency(code: "KRW")
                .locale(Locale(identifier: "ko_KR"))
                .presentation(.fullName)
            )
            .replacingOccurrences(of: " 대한민국 ", with: "") ?? self
    }
    
    func removeHTMLTags() -> String {
        do {
            let attributedString = try NSAttributedString(
                data: Data(utf8),
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            return attributedString.string
        } catch {
            Logger.error(ConvertError.htmlTagRemovalFailed(error: error))
            return self
        }
    }
    
    enum ConvertError: LocalizedError {
        case htmlTagRemovalFailed(error: Error)
        
        var errorDescription: String? {
            switch self {
            case .htmlTagRemovalFailed(let error):
                "HTML Tag 제거 실패: \(error)"
            }
        }
    }
}
