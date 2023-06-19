//
// wizapp
//
// Created by SAP BTP SDK Assistant for iOS v9.1.3 application on 16/06/23
//

import Foundation

public enum ESPMContainerCollectionType: CaseIterable {
    case customers
    case productCategories
    case stock
    case purchaseOrderItems
    case purchaseOrderHeaders
    case salesOrderHeaders
    case products
    case salesOrderItems
    case productTexts
    case suppliers

    public init?(rawValue: String) {
        guard let type = ESPMContainerCollectionType.allCases.first(where: { rawValue == $0.description }) else {
            return nil
        }
        self = type
    }

    public var description: String {
        switch self {
        case .customers: return "Customers"
        case .productCategories: return "ProductCategories"
        case .stock: return "Stock"
        case .purchaseOrderItems: return "PurchaseOrderItems"
        case .purchaseOrderHeaders: return "PurchaseOrderHeaders"
        case .salesOrderHeaders: return "SalesOrderHeaders"
        case .products: return "Products"
        case .salesOrderItems: return "SalesOrderItems"
        case .productTexts: return "ProductTexts"
        case .suppliers: return "Suppliers"
        }
    }
}
