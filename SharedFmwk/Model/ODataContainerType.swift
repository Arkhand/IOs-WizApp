//
// wizapp
//
// Created by SAP BTP SDK Assistant for iOS v9.1.3 application on 16/06/23
//

import Foundation

public enum ODataContainerType: CaseIterable {
    case eSPMContainer
    case none

    public init?(rawValue: String) {
        guard let type = ODataContainerType.allCases.first(where: { rawValue == $0.description }) else {
            return nil
        }
        self = type
    }

    public var description: String {
        switch self {
        case .eSPMContainer: return "ESPMContainer"
        case .none: return ""
        }
    }
}
