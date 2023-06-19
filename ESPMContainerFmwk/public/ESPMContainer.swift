// # Proxy Compiler 23.1.2

import Foundation
import SAPOData

open class ESPMContainer: OnlineDataServiceAsync {
    private static let customers__lock = ObjectBase()

    private static var customers_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "Customers")

    private static let productCategories__lock = ObjectBase()

    private static var productCategories_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "ProductCategories")

    private static let productTexts__lock = ObjectBase()

    private static var productTexts_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "ProductTexts")

    private static let products__lock = ObjectBase()

    private static var products_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "Products")

    private static let purchaseOrderHeaders__lock = ObjectBase()

    private static var purchaseOrderHeaders_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "PurchaseOrderHeaders")

    private static let purchaseOrderItems__lock = ObjectBase()

    private static var purchaseOrderItems_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "PurchaseOrderItems")

    private static let salesOrderHeaders__lock = ObjectBase()

    private static var salesOrderHeaders_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "SalesOrderHeaders")

    private static let salesOrderItems__lock = ObjectBase()

    private static var salesOrderItems_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "SalesOrderItems")

    private static let stock__lock = ObjectBase()

    private static var stock_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "Stock")

    private static let suppliers__lock = ObjectBase()

    private static var suppliers_: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "Suppliers")

    override public init(provider: OnlineODataProvider) {
        super.init(provider: provider)
        provider.metadata = ESPMContainerMetadata.document
        ProxyInternal.setCsdlFetcher(provider: provider, fetcher: nil)
        ProxyInternal.setCsdlOptions(provider: provider, options: ESPMContainerMetadataParser.options)
        ProxyInternal.setMergeAction(provider: provider, action: { ESPMContainerMetadataChanges.merge(metadata: provider.metadata) })
    }

    @inline(__always)
    open class var customers: EntitySet {
        get {
            objc_sync_enter(customers__lock)
            defer { objc_sync_exit(customers__lock) }
            do {
                return ESPMContainer.customers_
            }
        }
        set(value) {
            objc_sync_enter(customers__lock)
            defer { objc_sync_exit(customers__lock) }
            do {
                ESPMContainer.customers_ = value
            }
        }
    }

    private func fetchCustomer(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Customer {
        return try CastRequired<Customer>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.customers), headers: headers, options: options).requiredEntity())
    }

    open func fetchCustomer(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Customer {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Customer, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchCustomer(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchCustomerWithKey(customerID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Customer {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchCustomer(matching: var_query.withKey(Customer.key(customerID: customerID)), headers: headers, options: options)
    }

    open func fetchCustomerWithKey(customerID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Customer {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Customer, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchCustomerWithKey(customerID: customerID, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchCustomers(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [Customer] {
        let var_query = DataQuery.newIfNull(query: query)
        return try Customer.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.customers), headers: headers, options: options).entityList())
    }

    open func fetchCustomers(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [Customer] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[Customer], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchCustomers(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchProduct(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Product {
        return try CastRequired<Product>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.products), headers: headers, options: options).requiredEntity())
    }

    open func fetchProduct(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Product {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Product, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchProduct(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchProductCategories(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [ProductCategory] {
        let var_query = DataQuery.newIfNull(query: query)
        return try ProductCategory.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.productCategories), headers: headers, options: options).entityList())
    }

    open func fetchProductCategories(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [ProductCategory] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[ProductCategory], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchProductCategories(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchProductCategory(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> ProductCategory {
        return try CastRequired<ProductCategory>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.productCategories), headers: headers, options: options).requiredEntity())
    }

    open func fetchProductCategory(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> ProductCategory {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<ProductCategory, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchProductCategory(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchProductCategoryWithKey(category: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> ProductCategory {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchProductCategory(matching: var_query.withKey(ProductCategory.key(category: category)), headers: headers, options: options)
    }

    open func fetchProductCategoryWithKey(category: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> ProductCategory {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<ProductCategory, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchProductCategoryWithKey(category: category, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchProductText(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> ProductText {
        return try CastRequired<ProductText>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.productTexts), headers: headers, options: options).requiredEntity())
    }

    open func fetchProductText(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> ProductText {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<ProductText, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchProductText(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchProductTextWithKey(keyID: Int64?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> ProductText {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchProductText(matching: var_query.withKey(ProductText.key(id: keyID)), headers: headers, options: options)
    }

    open func fetchProductTextWithKey(keyID: Int64?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> ProductText {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<ProductText, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchProductTextWithKey(keyID: keyID, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchProductTexts(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [ProductText] {
        let var_query = DataQuery.newIfNull(query: query)
        return try ProductText.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.productTexts), headers: headers, options: options).entityList())
    }

    open func fetchProductTexts(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [ProductText] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[ProductText], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchProductTexts(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchProductWithKey(productID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Product {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchProduct(matching: var_query.withKey(Product.key(productID: productID)), headers: headers, options: options)
    }

    open func fetchProductWithKey(productID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Product {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Product, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchProductWithKey(productID: productID, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchProducts(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [Product] {
        let var_query = DataQuery.newIfNull(query: query)
        return try Product.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.products), headers: headers, options: options).entityList())
    }

    open func fetchProducts(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [Product] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[Product], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchProducts(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchPurchaseOrderHeader(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> PurchaseOrderHeader {
        return try CastRequired<PurchaseOrderHeader>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.purchaseOrderHeaders), headers: headers, options: options).requiredEntity())
    }

    open func fetchPurchaseOrderHeader(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> PurchaseOrderHeader {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<PurchaseOrderHeader, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchPurchaseOrderHeader(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchPurchaseOrderHeaderWithKey(purchaseOrderID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> PurchaseOrderHeader {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchPurchaseOrderHeader(matching: var_query.withKey(PurchaseOrderHeader.key(purchaseOrderID: purchaseOrderID)), headers: headers, options: options)
    }

    open func fetchPurchaseOrderHeaderWithKey(purchaseOrderID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> PurchaseOrderHeader {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<PurchaseOrderHeader, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchPurchaseOrderHeaderWithKey(purchaseOrderID: purchaseOrderID, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchPurchaseOrderHeaders(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [PurchaseOrderHeader] {
        let var_query = DataQuery.newIfNull(query: query)
        return try PurchaseOrderHeader.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.purchaseOrderHeaders), headers: headers, options: options).entityList())
    }

    open func fetchPurchaseOrderHeaders(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [PurchaseOrderHeader] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[PurchaseOrderHeader], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchPurchaseOrderHeaders(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchPurchaseOrderItem(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> PurchaseOrderItem {
        return try CastRequired<PurchaseOrderItem>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.purchaseOrderItems), headers: headers, options: options).requiredEntity())
    }

    open func fetchPurchaseOrderItem(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> PurchaseOrderItem {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<PurchaseOrderItem, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchPurchaseOrderItem(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchPurchaseOrderItemWithKey(itemNumber: Int?, purchaseOrderID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> PurchaseOrderItem {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchPurchaseOrderItem(matching: var_query.withKey(PurchaseOrderItem.key(itemNumber: itemNumber, purchaseOrderID: purchaseOrderID)), headers: headers, options: options)
    }

    open func fetchPurchaseOrderItemWithKey(itemNumber: Int?, purchaseOrderID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> PurchaseOrderItem {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<PurchaseOrderItem, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchPurchaseOrderItemWithKey(itemNumber: itemNumber, purchaseOrderID: purchaseOrderID, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchPurchaseOrderItems(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [PurchaseOrderItem] {
        let var_query = DataQuery.newIfNull(query: query)
        return try PurchaseOrderItem.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.purchaseOrderItems), headers: headers, options: options).entityList())
    }

    open func fetchPurchaseOrderItems(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [PurchaseOrderItem] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[PurchaseOrderItem], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchPurchaseOrderItems(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchSalesOrderHeader(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> SalesOrderHeader {
        return try CastRequired<SalesOrderHeader>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderHeaders), headers: headers, options: options).requiredEntity())
    }

    open func fetchSalesOrderHeader(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> SalesOrderHeader {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<SalesOrderHeader, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchSalesOrderHeader(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchSalesOrderHeaderWithKey(salesOrderID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> SalesOrderHeader {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchSalesOrderHeader(matching: var_query.withKey(SalesOrderHeader.key(salesOrderID: salesOrderID)), headers: headers, options: options)
    }

    open func fetchSalesOrderHeaderWithKey(salesOrderID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> SalesOrderHeader {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<SalesOrderHeader, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchSalesOrderHeaderWithKey(salesOrderID: salesOrderID, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchSalesOrderHeaders(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [SalesOrderHeader] {
        let var_query = DataQuery.newIfNull(query: query)
        return try SalesOrderHeader.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderHeaders), headers: headers, options: options).entityList())
    }

    open func fetchSalesOrderHeaders(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [SalesOrderHeader] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[SalesOrderHeader], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchSalesOrderHeaders(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchSalesOrderItem(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> SalesOrderItem {
        return try CastRequired<SalesOrderItem>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderItems), headers: headers, options: options).requiredEntity())
    }

    open func fetchSalesOrderItem(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> SalesOrderItem {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<SalesOrderItem, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchSalesOrderItem(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchSalesOrderItemWithKey(itemNumber: Int?, salesOrderID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> SalesOrderItem {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchSalesOrderItem(matching: var_query.withKey(SalesOrderItem.key(itemNumber: itemNumber, salesOrderID: salesOrderID)), headers: headers, options: options)
    }

    open func fetchSalesOrderItemWithKey(itemNumber: Int?, salesOrderID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> SalesOrderItem {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<SalesOrderItem, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchSalesOrderItemWithKey(itemNumber: itemNumber, salesOrderID: salesOrderID, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchSalesOrderItems(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [SalesOrderItem] {
        let var_query = DataQuery.newIfNull(query: query)
        return try SalesOrderItem.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderItems), headers: headers, options: options).entityList())
    }

    open func fetchSalesOrderItems(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [SalesOrderItem] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[SalesOrderItem], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchSalesOrderItems(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchStock(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [Stock] {
        let var_query = DataQuery.newIfNull(query: query)
        return try Stock.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.stock), headers: headers, options: options).entityList())
    }

    open func fetchStock(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [Stock] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[Stock], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchStock(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchStock1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Stock {
        return try CastRequired<Stock>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.stock), headers: headers, options: options).requiredEntity())
    }

    open func fetchStock1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Stock {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Stock, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchStock1(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchStock1WithKey(productID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Stock {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchStock1(matching: var_query.withKey(Stock.key(productID: productID)), headers: headers, options: options)
    }

    open func fetchStock1WithKey(productID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Stock {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Stock, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchStock1WithKey(productID: productID, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchSupplier(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Supplier {
        return try CastRequired<Supplier>.from(ProxyInternal.executeQuery(service: self, query: query.fromDefault(ESPMContainerMetadata.EntitySets.suppliers), headers: headers, options: options).requiredEntity())
    }

    open func fetchSupplier(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Supplier {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Supplier, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchSupplier(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchSupplierWithKey(supplierID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Supplier {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchSupplier(matching: var_query.withKey(Supplier.key(supplierID: supplierID)), headers: headers, options: options)
    }

    open func fetchSupplierWithKey(supplierID: String?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Supplier {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Supplier, Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchSupplierWithKey(supplierID: supplierID, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchSuppliers(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [Supplier] {
        let var_query = DataQuery.newIfNull(query: query)
        return try Supplier.array(from: ProxyInternal.executeQuery(service: self, query: var_query.fromDefault(ESPMContainerMetadata.EntitySets.suppliers), headers: headers, options: options).entityList())
    }

    open func fetchSuppliers(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> [Supplier] {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<[Supplier], Error>) in
            asyncFunction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.fetchSuppliers(matching: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func generateSamplePurchaseOrders(query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Bool {
        let var_query = DataQuery.newIfNull(query: query)
        return try BooleanValue.unwrap(ProxyInternal.executeQuery(service: self, query: var_query.invoke(ESPMContainerMetadata.ActionImports.generateSamplePurchaseOrders, ParameterList.empty), headers: headers, options: options).checkedResult())
    }

    open func generateSamplePurchaseOrders(query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Bool {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Bool, Error>) in
            asyncAction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.generateSamplePurchaseOrders(query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func generateSampleSalesOrders(query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Bool {
        let var_query = DataQuery.newIfNull(query: query)
        return try BooleanValue.unwrap(ProxyInternal.executeQuery(service: self, query: var_query.invoke(ESPMContainerMetadata.ActionImports.generateSampleSalesOrders, ParameterList.empty), headers: headers, options: options).checkedResult())
    }

    open func generateSampleSalesOrders(query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Bool {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Bool, Error>) in
            asyncAction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.generateSampleSalesOrders(query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    override open var metadataLock: MetadataLock {
        return ESPMContainerMetadata.lock
    }

    @inline(__always)
    open class var productCategories: EntitySet {
        get {
            objc_sync_enter(productCategories__lock)
            defer { objc_sync_exit(productCategories__lock) }
            do {
                return ESPMContainer.productCategories_
            }
        }
        set(value) {
            objc_sync_enter(productCategories__lock)
            defer { objc_sync_exit(productCategories__lock) }
            do {
                ESPMContainer.productCategories_ = value
            }
        }
    }

    @inline(__always)
    open class var productTexts: EntitySet {
        get {
            objc_sync_enter(productTexts__lock)
            defer { objc_sync_exit(productTexts__lock) }
            do {
                return ESPMContainer.productTexts_
            }
        }
        set(value) {
            objc_sync_enter(productTexts__lock)
            defer { objc_sync_exit(productTexts__lock) }
            do {
                ESPMContainer.productTexts_ = value
            }
        }
    }

    @inline(__always)
    open class var products: EntitySet {
        get {
            objc_sync_enter(products__lock)
            defer { objc_sync_exit(products__lock) }
            do {
                return ESPMContainer.products_
            }
        }
        set(value) {
            objc_sync_enter(products__lock)
            defer { objc_sync_exit(products__lock) }
            do {
                ESPMContainer.products_ = value
            }
        }
    }

    @inline(__always)
    open class var purchaseOrderHeaders: EntitySet {
        get {
            objc_sync_enter(purchaseOrderHeaders__lock)
            defer { objc_sync_exit(purchaseOrderHeaders__lock) }
            do {
                return ESPMContainer.purchaseOrderHeaders_
            }
        }
        set(value) {
            objc_sync_enter(purchaseOrderHeaders__lock)
            defer { objc_sync_exit(purchaseOrderHeaders__lock) }
            do {
                ESPMContainer.purchaseOrderHeaders_ = value
            }
        }
    }

    @inline(__always)
    open class var purchaseOrderItems: EntitySet {
        get {
            objc_sync_enter(purchaseOrderItems__lock)
            defer { objc_sync_exit(purchaseOrderItems__lock) }
            do {
                return ESPMContainer.purchaseOrderItems_
            }
        }
        set(value) {
            objc_sync_enter(purchaseOrderItems__lock)
            defer { objc_sync_exit(purchaseOrderItems__lock) }
            do {
                ESPMContainer.purchaseOrderItems_ = value
            }
        }
    }

    private func refreshMetadata() throws {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        do {
            try ProxyInternal.refreshMetadata(service: self, fetcher: nil, options: ESPMContainerMetadataParser.options, mergeAction: { ESPMContainerMetadataChanges.merge(metadata: self.metadata) })
        }
    }

    override open func refreshMetadata() async throws {
        try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Void, Error>) in
            asyncFunction {
                do {
                    try self.refreshMetadata()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func resetSampleData(query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Bool {
        let var_query = DataQuery.newIfNull(query: query)
        return try BooleanValue.unwrap(ProxyInternal.executeQuery(service: self, query: var_query.invoke(ESPMContainerMetadata.ActionImports.resetSampleData, ParameterList.empty), headers: headers, options: options).checkedResult())
    }

    open func resetSampleData(query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Bool {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Bool, Error>) in
            asyncAction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.resetSampleData(query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    @inline(__always)
    open class var salesOrderHeaders: EntitySet {
        get {
            objc_sync_enter(salesOrderHeaders__lock)
            defer { objc_sync_exit(salesOrderHeaders__lock) }
            do {
                return ESPMContainer.salesOrderHeaders_
            }
        }
        set(value) {
            objc_sync_enter(salesOrderHeaders__lock)
            defer { objc_sync_exit(salesOrderHeaders__lock) }
            do {
                ESPMContainer.salesOrderHeaders_ = value
            }
        }
    }

    @inline(__always)
    open class var salesOrderItems: EntitySet {
        get {
            objc_sync_enter(salesOrderItems__lock)
            defer { objc_sync_exit(salesOrderItems__lock) }
            do {
                return ESPMContainer.salesOrderItems_
            }
        }
        set(value) {
            objc_sync_enter(salesOrderItems__lock)
            defer { objc_sync_exit(salesOrderItems__lock) }
            do {
                ESPMContainer.salesOrderItems_ = value
            }
        }
    }

    @inline(__always)
    open class var stock: EntitySet {
        get {
            objc_sync_enter(stock__lock)
            defer { objc_sync_exit(stock__lock) }
            do {
                return ESPMContainer.stock_
            }
        }
        set(value) {
            objc_sync_enter(stock__lock)
            defer { objc_sync_exit(stock__lock) }
            do {
                ESPMContainer.stock_ = value
            }
        }
    }

    @inline(__always)
    open class var suppliers: EntitySet {
        get {
            objc_sync_enter(suppliers__lock)
            defer { objc_sync_exit(suppliers__lock) }
            do {
                return ESPMContainer.suppliers_
            }
        }
        set(value) {
            objc_sync_enter(suppliers__lock)
            defer { objc_sync_exit(suppliers__lock) }
            do {
                ESPMContainer.suppliers_ = value
            }
        }
    }

    private func updateSalesOrderStatus(id: String, newStatus: String, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Bool {
        let var_query = DataQuery.newIfNull(query: query)
        return try BooleanValue.unwrap(ProxyInternal.executeQuery(service: self, query: var_query.invoke(ESPMContainerMetadata.ActionImports.updateSalesOrderStatus, ParameterList(capacity: 2 as Int).with(name: "id", value: StringValue.of(id)).with(name: "newStatus", value: StringValue.of(newStatus))), headers: headers, options: options).checkedResult())
    }

    open func updateSalesOrderStatus(id: String, newStatus: String, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) async throws -> Bool {
        return try await withUnsafeThrowingContinuation {
            (continuation: UnsafeContinuation<Bool, Error>) in
            asyncAction {
                do {
                    try self.checkIfCancelled(options?.cancelToken)
                    let result = try self.updateSalesOrderStatus(id: id, newStatus: newStatus, query: query, headers: headers, options: options)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
