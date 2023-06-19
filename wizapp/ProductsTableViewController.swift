//
//  ProductsTableViewController.swift
//  TutorialApp
//
//  Created by Muessig, Kevin on 05.01.22.
//  Copyright © 2022 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import SAPFoundation
import SAPOData
import SAPFioriFlows
import SAPCommon
import ESPMContainerFmwk
import SharedFmwk

class ProductsTableViewController: UITableViewController, SAPFioriLoadingIndicator {
    var loadingIndicator: FUILoadingIndicatorView?
    
    /// First retrieve the destinations your app can talk to from the AppParameters.
    let destinations = FileConfigurationProvider("AppParameters").provideConfiguration().configuration["Destinations"] as! NSDictionary

      /// Create a computed property that uses the OnboardingSessionManager to retrieve the onboarding session and uses the destinations dictionary to pull the correct destination. Of course you only have one destination here. Handle the errors in case the OData controller is nil. You are using the AlertHelper to display an AlertDialogue to the user in case of an error. The AlertHelper is a utils class provided through the Assistant.
    var dataService: ESPMContainer? {
            guard let odataController = OnboardingSessionManager
                    .shared
                    .onboardingSession?
                    .odataControllers[ODataContainerType.eSPMContainer.description] as? ESPMContainerOnlineODataController else {
                AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
                return nil
            }
            return odataController.dataService
        }
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let logger = Logger.shared(named: "ProductsTableViewController")

    private var imageCache = [String: UIImage]()
    private var productImageURLs = [String]()
    private var products = [Product]()
    
    private var searchController: FUISearchController?
    private var searchedProducts = [Product]()


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
           tableView.estimatedRowHeight = 120
           tableView.rowHeight = UITableView.automaticDimension
        
        loadData()
        setupSearchBar()
    }
    
    private func loadData() {

        Task {
            do {
                showFioriLoadingIndicator()

                async let pProducts = fetchProducts()
                var (aProducts) = try await (pProducts)
                
                self.products.append(contentsOf: aProducts )
                self.productImageURLs = self.products.map { $0.pictureUrl ?? "" }

                self.tableView.reloadData()
                self.hideFioriLoadingIndicator()

            } catch {
                self.hideFioriLoadingIndicator()
                self.tableView.reloadData()
                //ACA VA ALGUN ERROR
                AlertHelper.displayAlert(with: NSLocalizedString("Failed to load data!", comment: ""), error: error, viewController: self)
            }
        }
        
    }
    
    private func fetchProducts() async throws -> [ESPMContainerFmwk.Product] {
        // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
        let query = DataQuery().selectAll().top(20)
        do {
            return try await dataService!.fetchProducts(matching: query)
        }
    }

    
    private func loadImageFrom(_ url: URL, completionHandler: @escaping (_ image: UIImage) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let sapURLSession = appDelegate.sessionManager.onboardingSession?.sapURLSession {
            sapURLSession.dataTask(with: url, completionHandler: { data, _, error in

                if let error = error {
                    self.logger.error("Failed to load image!", error: error)
                    return
                }

                if let image = UIImage(data: data!) {
                    // safe image in image cache
                    self.imageCache[url.absoluteString] = image
                    DispatchQueue.main.async { completionHandler(image) }
                }
            }).resume()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return isSearching() ? searchedProducts.count : products.count
          }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let product = isSearching() ? searchedProducts[indexPath.row] : products[indexPath.row]
            let productCell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier) as! FUIObjectTableViewCell
            productCell.accessoryType = .detailDisclosureButton
            productCell.headlineText = product.name ?? "-"
            productCell.subheadlineText = product.categoryName ?? "-"
            productCell.footnoteText = product.stockDetails?.quantity?.intValue() != 0 ? NSLocalizedString("In Stock", comment: "") : NSLocalizedString("Out", comment: "")
            // set a placeholder image
            productCell.detailImageView.image = FUIIconLibrary.system.imageLibrary

            // This URL is found in Mobile Services
            let baseURL = "https://f8f7c4d8trial-dev-com-sap-wizapp.cfapps.us10-001.hana.ondemand.com/SampleServices/ESPM.svc/v2"
            let url = URL(string: baseURL.appending(productImageURLs[indexPath.row]))

            guard let unwrapped = url else {
                logger.info("URL for product image is nil. Returning cell without image.")
                return productCell
            }
            // check if the image is already in the cache
            if let img = imageCache[unwrapped.absoluteString] {
                productCell.detailImageView.image = img
            } else {
                // The image is not cached yet, so download it.
                loadImageFrom(unwrapped) { image in
                    productCell.detailImageView.image = image
                }
            }
            // Only visible on regular
            productCell.descriptionText = product.longDescription ?? ""

            return productCell
        }

    private func setupSearchBar() {
        // Search Controller setup
        searchController = FUISearchController(searchResultsController: nil)

        // Handle the search result directly in the ProductsTableViewController
        searchController!.searchResultsUpdater = self
        searchController!.hidesNavigationBarDuringPresentation = false
        searchController!.searchBar.placeholderText = NSLocalizedString("Search for products...", comment: "")
        searchController!.searchBar.isBarcodeScannerEnabled = false

        // Set the search bar to the table header view like you did with the KPI Header.
        self.tableView.tableHeaderView = searchController!.searchBar
    }
    
    // Verify if the search text is empty or not
    private func searchTextIsEmpty() -> Bool {
       return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    // Verify if the user is currently searching or not
    private func isSearching() -> Bool {
        return searchController?.isActive ?? false && !searchTextIsEmpty()
    }
    
    // actual search logic for finding the correct products for the term the user is searching for
    private func searchProducts(_ searchText: String) {
        searchedProducts = products.filter({( product : Product) -> Bool in
            // Make sure the string is completely lower-cased or upper-cased. Either way makes it easier for you to
            // compare strings.
            return product.name?.lowercased().contains(searchText.lowercased()) ?? false
        })

        // Don't forget to trigger a reload.
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating extension

extension ProductsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {

            // Simply call the search logic method and pass the searched for text here!
            // You could check if the search text's length is at least 3 characters
            // to not trigger the search for each and every single character.
            // if searchText.count >= 3 { searchProducts(searchText) }

            searchProducts(searchText)
            return
        }
    }
}
