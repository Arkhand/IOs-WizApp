//
// wizapp
//
// Created by SAP BTP SDK Assistant for iOS v9.1.3 application on 16/06/23
//

import SAPFiori
import SAPFioriFlows
import SAPFoundation
import SAPOData

import ESPMContainerFmwk
import SharedFmwk

protocol ESPMContainerEntityUpdaterDelegate {
    func entityHasChanged(_ entity: EntityValue?)
}

protocol ESPMContainerEntityMediaUpdaterDelegate {
    func entityMediaHasChanged(_ changedMedia: Data?)
}

protocol ESPMContainerEntitySetUpdaterDelegate {
    func entitySetHasChanged()
}

protocol ESPMContainerEntitySetMediaUpdaterDelegate {
    func entitySetMediaHasChanged(for entity: EntityValue?, to media: Data?)
}

class ESPMContainerCollectionsViewController: FUIFormTableViewController {
    private var collections = ESPMContainerCollectionType.allCases

    // Variable to store the selected index path
    private var selectedIndex: IndexPath?

    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")

    var isPresentedInSplitView: Bool {
        return !(self.splitViewController?.isCollapsed ?? true)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 320, height: 480)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeSelection()
    }

    override func viewWillTransition(to _: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            let isNotInSplitView = !self.isPresentedInSplitView
            self.tableView.visibleCells.forEach { cell in
                // To refresh the disclosure indicator of each cell
                cell.accessoryType = isNotInSplitView ? .disclosureIndicator : .none
            }
            self.makeSelection()
        })
    }

    // MARK: - UITableViewDelegate

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return collections.count
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell
        cell.headlineLabel.text = collections[indexPath.row].description
        cell.accessoryType = !isPresentedInSplitView ? .disclosureIndicator : .none
        cell.isMomentarySelection = false
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        collectionSelected(at: indexPath)
    }

    // CollectionType selection helper
    private func collectionSelected(at indexPath: IndexPath) {
        // Load the EntityType specific ViewController from the specific storyboard"
        var masterViewController: UIViewController!
        guard let odataController = OnboardingSessionManager.shared.onboardingSession?.odataControllers[ODataContainerType.eSPMContainer.description] as? ESPMContainerOnlineODataController, let dataService = odataController.dataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        selectedIndex = indexPath

        switch collections[indexPath.row] {
        case .customers:
            let customerStoryBoard = UIStoryboard(name: "Customer", bundle: nil)
            let customerMasterViewController = customerStoryBoard.instantiateViewController(withIdentifier: "CustomerMaster") as! CustomerMasterViewController
            customerMasterViewController.dataService = dataService
            customerMasterViewController.entitySetName = "Customers"
            func fetchCustomers() async throws -> [ESPMContainerFmwk.Customer] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchCustomers(matching: query)
                }
            }
            customerMasterViewController.loadEntitiesBlock = fetchCustomers
            customerMasterViewController.navigationItem.title = "Customer"
            masterViewController = customerMasterViewController
        case .productCategories:
            let productCategoryStoryBoard = UIStoryboard(name: "ProductCategory", bundle: nil)
            let productCategoryMasterViewController = productCategoryStoryBoard.instantiateViewController(withIdentifier: "ProductCategoryMaster") as! ProductCategoryMasterViewController
            productCategoryMasterViewController.dataService = dataService
            productCategoryMasterViewController.entitySetName = "ProductCategories"
            func fetchProductCategories() async throws -> [ESPMContainerFmwk.ProductCategory] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchProductCategories(matching: query)
                }
            }
            productCategoryMasterViewController.loadEntitiesBlock = fetchProductCategories
            productCategoryMasterViewController.navigationItem.title = "ProductCategory"
            masterViewController = productCategoryMasterViewController
        case .stock:
            let stockStoryBoard = UIStoryboard(name: "Stock", bundle: nil)
            let stockMasterViewController = stockStoryBoard.instantiateViewController(withIdentifier: "StockMaster") as! StockMasterViewController
            stockMasterViewController.dataService = dataService
            stockMasterViewController.entitySetName = "Stock"
            func fetchStock() async throws -> [ESPMContainerFmwk.Stock] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchStock(matching: query)
                }
            }
            stockMasterViewController.loadEntitiesBlock = fetchStock
            stockMasterViewController.navigationItem.title = "Stock"
            masterViewController = stockMasterViewController
        case .purchaseOrderItems:
            let purchaseOrderItemStoryBoard = UIStoryboard(name: "PurchaseOrderItem", bundle: nil)
            let purchaseOrderItemMasterViewController = purchaseOrderItemStoryBoard.instantiateViewController(withIdentifier: "PurchaseOrderItemMaster") as! PurchaseOrderItemMasterViewController
            purchaseOrderItemMasterViewController.dataService = dataService
            purchaseOrderItemMasterViewController.entitySetName = "PurchaseOrderItems"
            func fetchPurchaseOrderItems() async throws -> [ESPMContainerFmwk.PurchaseOrderItem] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchPurchaseOrderItems(matching: query)
                }
            }
            purchaseOrderItemMasterViewController.loadEntitiesBlock = fetchPurchaseOrderItems
            purchaseOrderItemMasterViewController.navigationItem.title = "PurchaseOrderItem"
            masterViewController = purchaseOrderItemMasterViewController
        case .purchaseOrderHeaders:
            let purchaseOrderHeaderStoryBoard = UIStoryboard(name: "PurchaseOrderHeader", bundle: nil)
            let purchaseOrderHeaderMasterViewController = purchaseOrderHeaderStoryBoard.instantiateViewController(withIdentifier: "PurchaseOrderHeaderMaster") as! PurchaseOrderHeaderMasterViewController
            purchaseOrderHeaderMasterViewController.dataService = dataService
            purchaseOrderHeaderMasterViewController.entitySetName = "PurchaseOrderHeaders"
            func fetchPurchaseOrderHeaders() async throws -> [ESPMContainerFmwk.PurchaseOrderHeader] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchPurchaseOrderHeaders(matching: query)
                }
            }
            purchaseOrderHeaderMasterViewController.loadEntitiesBlock = fetchPurchaseOrderHeaders
            purchaseOrderHeaderMasterViewController.navigationItem.title = "PurchaseOrderHeader"
            masterViewController = purchaseOrderHeaderMasterViewController
        case .salesOrderHeaders:
            let salesOrderHeaderStoryBoard = UIStoryboard(name: "SalesOrderHeader", bundle: nil)
            let salesOrderHeaderMasterViewController = salesOrderHeaderStoryBoard.instantiateViewController(withIdentifier: "SalesOrderHeaderMaster") as! SalesOrderHeaderMasterViewController
            salesOrderHeaderMasterViewController.dataService = dataService
            salesOrderHeaderMasterViewController.entitySetName = "SalesOrderHeaders"
            func fetchSalesOrderHeaders() async throws -> [ESPMContainerFmwk.SalesOrderHeader] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchSalesOrderHeaders(matching: query)
                }
            }
            salesOrderHeaderMasterViewController.loadEntitiesBlock = fetchSalesOrderHeaders
            salesOrderHeaderMasterViewController.navigationItem.title = "SalesOrderHeader"
            masterViewController = salesOrderHeaderMasterViewController
        case .products:
            let productStoryBoard = UIStoryboard(name: "Product", bundle: nil)
            let productMasterViewController = productStoryBoard.instantiateViewController(withIdentifier: "ProductMaster") as! ProductMasterViewController
            productMasterViewController.dataService = dataService
            productMasterViewController.entitySetName = "Products"
            func fetchProducts() async throws -> [ESPMContainerFmwk.Product] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchProducts(matching: query)
                }
            }
            productMasterViewController.loadEntitiesBlock = fetchProducts
            productMasterViewController.navigationItem.title = "Product"
            masterViewController = productMasterViewController
        case .salesOrderItems:
            let salesOrderItemStoryBoard = UIStoryboard(name: "SalesOrderItem", bundle: nil)
            let salesOrderItemMasterViewController = salesOrderItemStoryBoard.instantiateViewController(withIdentifier: "SalesOrderItemMaster") as! SalesOrderItemMasterViewController
            salesOrderItemMasterViewController.dataService = dataService
            salesOrderItemMasterViewController.entitySetName = "SalesOrderItems"
            func fetchSalesOrderItems() async throws -> [ESPMContainerFmwk.SalesOrderItem] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchSalesOrderItems(matching: query)
                }
            }
            salesOrderItemMasterViewController.loadEntitiesBlock = fetchSalesOrderItems
            salesOrderItemMasterViewController.navigationItem.title = "SalesOrderItem"
            masterViewController = salesOrderItemMasterViewController
        case .productTexts:
            let productTextStoryBoard = UIStoryboard(name: "ProductText", bundle: nil)
            let productTextMasterViewController = productTextStoryBoard.instantiateViewController(withIdentifier: "ProductTextMaster") as! ProductTextMasterViewController
            productTextMasterViewController.dataService = dataService
            productTextMasterViewController.entitySetName = "ProductTexts"
            func fetchProductTexts() async throws -> [ESPMContainerFmwk.ProductText] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchProductTexts(matching: query)
                }
            }
            productTextMasterViewController.loadEntitiesBlock = fetchProductTexts
            productTextMasterViewController.navigationItem.title = "ProductText"
            masterViewController = productTextMasterViewController
        case .suppliers:
            let supplierStoryBoard = UIStoryboard(name: "Supplier", bundle: nil)
            let supplierMasterViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "SupplierMaster") as! SupplierMasterViewController
            supplierMasterViewController.dataService = dataService
            supplierMasterViewController.entitySetName = "Suppliers"
            func fetchSuppliers() async throws -> [ESPMContainerFmwk.Supplier] {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    return try await dataService.fetchSuppliers(matching: query)
                }
            }
            supplierMasterViewController.loadEntitiesBlock = fetchSuppliers
            supplierMasterViewController.navigationItem.title = "Supplier"
            masterViewController = supplierMasterViewController
        @unknown default:
            masterViewController = UIViewController()
        }

        // Load the NavigationController and present with the EntityType specific ViewController
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let rightNavigationController = mainStoryBoard.instantiateViewController(withIdentifier: "RightNavigationController") as! UINavigationController
        rightNavigationController.viewControllers = [masterViewController]
        splitViewController?.showDetailViewController(rightNavigationController, sender: nil)
    }

    // MARK: - Handle highlighting of selected cell

    private func makeSelection() {
        if let selectedIndex = selectedIndex {
            tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            tableView.scrollToRow(at: selectedIndex, at: .none, animated: true)
        } else {
            selectDefault()
        }
    }

    private func selectDefault() {
        // Automatically select first element if we have two panels (iPhone plus and iPad only)
        guard let odataController = OnboardingSessionManager.shared.onboardingSession?.odataControllers[ODataContainerType.eSPMContainer.description] as? ESPMContainerOnlineODataController else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }

        if splitViewController!.isCollapsed || odataController.dataService == nil {
            return
        }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        collectionSelected(at: indexPath)
    }

    static func entitySet(withName entitySetName: String?) -> EntitySet? {
        switch entitySetName {
        case "Customers": return ESPMContainerMetadata.EntitySets.customers
        case "ProductCategories": return ESPMContainerMetadata.EntitySets.productCategories
        case "Stock": return ESPMContainerMetadata.EntitySets.stock
        case "PurchaseOrderItems": return ESPMContainerMetadata.EntitySets.purchaseOrderItems
        case "PurchaseOrderHeaders": return ESPMContainerMetadata.EntitySets.purchaseOrderHeaders
        case "SalesOrderHeaders": return ESPMContainerMetadata.EntitySets.salesOrderHeaders
        case "Products": return ESPMContainerMetadata.EntitySets.products
        case "SalesOrderItems": return ESPMContainerMetadata.EntitySets.salesOrderItems
        case "ProductTexts": return ESPMContainerMetadata.EntitySets.productTexts
        case "Suppliers": return ESPMContainerMetadata.EntitySets.suppliers
        default: return nil
        }
    }
}
