//
//  OverviewTableViewController.swift
//  TutorialApp
//
//  Created by Muessig, Kevin on 04.01.22.
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

class OverviewTableViewController: UITableViewController, SAPFioriLoadingIndicator {
    var loadingIndicator: FUILoadingIndicatorView?
    
    private var products = [Product]()
    private var customers = [Customer]()
    private let logger = Logger.shared(named: "OverviewTableViewController")
    private var imageCache = [String: UIImage]()
    private var productImageURLs = [String]()
    private let productSegueIdentifier = "showProductsList"
    private let customerSegueIdentifier = "showCustomersList"
    
    var kpiHeader: FUIKPIHeader!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the navigation item's title to "Overview".
        navigationItem.title = NSLocalizedString("Overview", comment: "")

        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        tableView.register(FUICollectionViewTableViewCell.self, forCellReuseIdentifier: FUICollectionViewTableViewCell.reuseIdentifier)
        tableView.register(FUITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)

        // To make sure the FUICollectionViewTableViewCell gets displayed correctly you set the estimated row height to 180 and the row height to automatic dimension which will allow the table view to resize the cell.
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        setupKPIHeader()
        loadData()
    }
    
    // MARK: - KPI Header

    private func setupKPIHeader() {

        kpiHeader = FUIKPIHeader()

        // Create a new FUIKPIView displaying the customer satisfaction.
        let customerSatisfactionKPI = FUIKPIView()

        // Add a FUIKPIUnitItem for the unit and a FUIKPIMetricItem for the value itself. The value is mocked here as it is not existing in the OData service.
        customerSatisfactionKPI.items = [FUIKPIUnitItem(string: "%"), FUIKPIMetricItem(string: "82")]
        customerSatisfactionKPI.captionlabel.text = NSLocalizedString("Customer Satisfaction", comment: "")
        customerSatisfactionKPI.isEnabled = false

        // Create a new FUIKPIView displaying the sales order count.
        let salesOrdersKPI = FUIKPIView()

        // Retrieve a list of the salesOrders overall.
        let salesOrders = customers.flatMap { $0.salesOrders }
        salesOrdersKPI.items = [FUIKPIMetricItem(string: "\(salesOrders.count)")]
        salesOrdersKPI.captionlabel.text = NSLocalizedString("Sales Orders", comment: "")
        salesOrdersKPI.isEnabled = false

        // Add the items to the header
        kpiHeader.items = [customerSatisfactionKPI, salesOrdersKPI]

        // Set the KPI Header as new table header view.
        tableView.tableHeaderView = kpiHeader
    }
    
    private func loadData() {
        showFioriLoadingIndicator()
        
        Task {
            do {
                showFioriLoadingIndicator()

                async let pProducts = fetchProducts()
                async let pCustomers = fetchCustomers()
                var (aProducts, aCustomers) = try await (pProducts, pCustomers)
                
                aCustomers = aCustomers.sorted(by: { $0.salesOrders.count > $1.salesOrders.count })
                self.customers.append(contentsOf: aCustomers )
                self.products.append(contentsOf: aProducts )
                self.productImageURLs = products.map { $0.pictureUrl ?? "" }

                                      
                self.hideFioriLoadingIndicator()
                self.setupKPIHeader()
                self.tableView.reloadData()

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
    
    private func fetchCustomers() async throws -> [ESPMContainerFmwk.Customer] {
        let query = DataQuery().expand(Customer.salesOrders)
        do {
            return try await dataService!.fetchCustomers(matching: query)
        }
    }
    
    /**
    Retrieve an instance of the AppDelegate to get access to the SAPURLSession.
    Safe unwrap the SAPURLSession with the help of a guard-statement.
    Start a data task to download the image using the passed in URL. If the download task is completed check for errors. and safe the loaded image in the image cache.
    Dispatch back to the main thread and pass the loaded image.
    */
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
          return 4
      }

      /**
        Here you tell the Table View how many rows you want to display for each section.
        You can use the *Switch* statement to do so.

        - Case 1:   return 3 if the count of available products is equal or higher then 3
        - Case 3:   return 1 if the count of available customers is equal or higher then 1. That is because you only display the FUICollectionViewTableViewCell here.
        - Default:  return 0 because those are the dividers which are not going to display any rows.

      */
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          switch section {
          case 1: if products.count >= 3 { return 3 }
          case 3: if customers.count >= 1 { return 1 }
          default:
              return 0
          }
          return 0
      }

    /**
    Dequeue the registered FUITableViewHeaderFooterView and force cast it to the respective class.
    Again use a Switch-statement to distinguish between the different sections.

    - Case 1:   You want to see just the title for the Product section header
    - Case 3:   You want to see title and an attribute for the Customer section header.
    - Default:  Return the divider view.

    */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView

       switch section {
       case 1:
           headerFooterView.style = .title
           headerFooterView.titleLabel.text = NSLocalizedString("Products", comment: "")
           return headerFooterView
       case 3:
           headerFooterView.style = .attribute
           headerFooterView.titleLabel.text = NSLocalizedString("Customers", comment: "")
           headerFooterView.attributeLabel.text = NSLocalizedString("See All(\(customers.count))", comment: "")
           headerFooterView.didSelectHandler = {
               // TODO: Implement later
           }
           return headerFooterView
       default:
           let divider = UIView()
           divider.backgroundColor = .preferredFioriColor(forStyle: .separatorOpaque)
           return divider
       }
    }

    /**
    For the Footer you display a FUITableViewHeaderFooterView set to style attribute like the customer section header.
    If it is not the product section then show an empty UIView.
    */
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
            headerFooterView.didSelectHandler = {
                // perform the segue with the defined identifier if the user taps on the See All footer view.
                self.performSegue(withIdentifier: self.productSegueIdentifier, sender: self)
            }
            headerFooterView.style = .attribute
            headerFooterView.titleLabel.text = NSLocalizedString("See All", comment: "")
            headerFooterView.attributeLabel.text = "\(products.count)"
            return headerFooterView
        } else {
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }

      /**
      At the moment return a UITableViewCell.
      */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      switch indexPath.section {
      case 1:
              // Get the needed product using the IndexPath and deque the FUIObjectTableViewCell.
              let product = products[indexPath.row]
              let productCell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier) as! FUIObjectTableViewCell

              // Set the data to the dequeued cell.
              productCell.headlineText = product.name ?? "-"
              productCell.subheadlineText = product.categoryName ?? "-"

              // Show In Stock or Out of Stock depending on the available quantity of the product.
              productCell.footnoteText = product.stockDetails?.quantity?.intValue() != 0 ? NSLocalizedString("In Stock" , comment: "") : NSLocalizedString("Out of Stock", comment: "")
              // set a placeholder image
              productCell.detailImageView.image = FUIIconLibrary.system.imageLibrary

              // This URL is found in Mobile Services API tab and is needed to fetch the product images.
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

              productCell.accessoryType = .detailDisclosureButton

              return productCell
      case 3:
          let customerCollectionViewCell = tableView.dequeueReusableCell(withIdentifier: FUICollectionViewTableViewCell.reuseIdentifier) as! FUICollectionViewTableViewCell

          // The FUICollectionViewTableViewCell's collection view has a delegate and datasource as well. Your OverviewTableViewController will also provide those for the collection view.
          customerCollectionViewCell.collectionView.delegate = self
          customerCollectionViewCell.collectionView.dataSource = self

          // Use the horizontal scroll layout to display the customers horizontally with scroll enabled in the FUICollectionViewTableViewCell. Define the layouts parameters.
          let collectionViewLayout = FUICollectionViewLayout.horizontalScroll
          collectionViewLayout.minimumInteritemSpacing = CGFloat(16)
          collectionViewLayout.itemSize = CGSize(width: 120, height: 140)
          // Be aware of recommended margins in compact (left 16) and regular (left 48) mode
          customerCollectionViewCell.collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 0)

          // Set the layout on the collection view and register the FUIItemCollectionViewCell
          customerCollectionViewCell.collectionView.collectionViewLayout = collectionViewLayout
          customerCollectionViewCell.collectionView.register(FUIItemCollectionViewCell.self, forCellWithReuseIdentifier: FUIItemCollectionViewCell.reuseIdentifier)


          return customerCollectionViewCell
      default:
          return UITableViewCell()
      }
    }

      // MARK: - Navigation

    /**
    In a storyboard-based application, you will often want to do a little preparation before navigation.
    Using a Switch-statement let's you distinct between the different segues. Right now there is only the showProductsList but you will add a showCustomersList later on.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case productSegueIdentifier:
            let productsTableVC = segue.destination as! ProductsTableViewController
            productsTableVC.navigationItem.title = NSLocalizedString("All Products (\(products.count))", comment: "")
        default:
            return
        }
    }
}

extension OverviewTableViewController: UICollectionViewDelegate {
    //TODO: Implement navigation
}

extension OverviewTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return customers.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customer = customers[indexPath.row]

        let customerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: FUIItemCollectionViewCell.reuseIdentifier, for: indexPath) as! FUIItemCollectionViewCell

        let customerName = "\(customer.firstName ?? "") \(customer.lastName ?? "")"
        customerCollectionViewCell.title.text = customerName

        customerCollectionViewCell.detailImageView.image = UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        customerCollectionViewCell.detailImageView.isCircular = true

        // Use a Date Formatter to format the date to the medium style
        if let customerDOB = customer.dateOfBirth {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            customerCollectionViewCell.subtitle.text = "\(dateFormatter.string(from: customerDOB.utc() ?? Date()))"
        }

        return customerCollectionViewCell
    }
}
