//
// wizapp
//
// Created by SAP BTP SDK Assistant for iOS v9.1.3 application on 16/06/23
//

import ESPMContainerFmwk
import Foundation
import SAPCommon
import SAPFiori
import SAPFoundation
import SAPOData

import PhotosUI

class ProductDetailViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    var dataService: ESPMContainer!
    private var validity = [String: Bool]()
    var allowsEditableCells = false

    private var _entity: ESPMContainerFmwk.Product?
    var entity: ESPMContainerFmwk.Product {
        get {
            if _entity == nil {
                _entity = createEntityWithDefaultValues()
            }
            return _entity!
        }
        set {
            _entity = newValue
        }
    }

    var entityMedia: Data?

    private let logger = Logger.shared(named: "ProductMasterViewControllerLogger")
    var loadingIndicator: FUILoadingIndicatorView?
    var entityUpdater: ESPMContainerEntityUpdaterDelegate?
    var tableUpdater: ESPMContainerEntitySetUpdaterDelegate?
    var entityMediaUpdater: ESPMContainerEntityMediaUpdaterDelegate?
    var tableMediaUpdater: ESPMContainerEntitySetMediaUpdaterDelegate?
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    var preventNavigationLoop = false
    var entitySetName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        tableView.register(FUIDatePickerFormCell.self, forCellReuseIdentifier: FUIDatePickerFormCell.reuseIdentifier)
        tableView.register(FUIAttachmentsFormCell.self, forCellReuseIdentifier: FUIAttachmentsFormCell.reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "updateEntity" {
            // Show the Detail view with the current entity, where the properties scan be edited and updated
            logger.info("Showing a view to update the selected entity.")
            let dest = segue.destination as! UINavigationController
            let detailViewController = dest.viewControllers[0] as! ProductDetailViewController
            detailViewController.title = NSLocalizedString("keyUpdateEntityTitle", value: "Update Entity", comment: "XTIT: Title of update selected entity screen.")
            detailViewController.dataService = dataService
            detailViewController.entity = entity
            detailViewController.entityMedia = entityMedia
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: detailViewController, action: #selector(detailViewController.updateEntity))
            detailViewController.navigationItem.rightBarButtonItem = doneButton
            let cancelButton = UIBarButtonItem(title: NSLocalizedString("keyCancelButtonToGoPreviousScreen", value: "Cancel", comment: "XBUT: Title of Cancel button."), style: .plain, target: detailViewController, action: #selector(detailViewController.cancel))
            detailViewController.navigationItem.leftBarButtonItem = cancelButton
            detailViewController.allowsEditableCells = true
            detailViewController.entityUpdater = self
            detailViewController.tableUpdater = tableUpdater
            detailViewController.entityMediaUpdater = self
            detailViewController.tableMediaUpdater = tableMediaUpdater
            detailViewController.entitySetName = entitySetName
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellForCategory(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.category)
        case 1:
            return cellForCategoryName(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.categoryName)
        case 2:
            return cellForCurrencyCode(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.currencyCode)
        case 3:
            return cellForDimensionDepth(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.dimensionDepth)
        case 4:
            return cellForDimensionHeight(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.dimensionHeight)
        case 5:
            return cellForDimensionUnit(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.dimensionUnit)
        case 6:
            return cellForDimensionWidth(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.dimensionWidth)
        case 7:
            return cellForLongDescription(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.longDescription)
        case 8:
            return cellForName(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.name)
        case 9:
            return cellForPictureUrl(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.pictureUrl)
        case 10:
            return cellForPrice(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.price)
        case 11:
            return cellForProductID(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.productID)
        case 12:
            return cellForQuantityUnit(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.quantityUnit)
        case 13:
            return cellForShortDescription(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.shortDescription)
        case 14:
            return cellForSupplierID(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.supplierID)
        case 15:
            return cellForUpdatedTimestamp(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.updatedTimestamp)
        case 16:
            return cellForWeight(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.weight)
        case 17:
            return cellForWeightUnit(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: Product.weightUnit)
        case 18:
            let cell = CellCreationHelper.cellForDefault(tableView: tableView, indexPath: indexPath, editingIsAllowed: false)
            cell.keyName = "StockDetails"
            if entity.isNew {
                cell.title.textColor = UIColor.preferredFioriColor(forStyle: .primaryLabel)
            }
            cell.value = " "
            cell.accessoryType = .disclosureIndicator
            return cell

        case 19:
            let cell = CellCreationHelper.cellForDefault(tableView: tableView, indexPath: indexPath, editingIsAllowed: false)
            cell.keyName = "SupplierDetails"
            if entity.isNew {
                cell.title.textColor = UIColor.preferredFioriColor(forStyle: .primaryLabel)
            }
            cell.value = " "
            cell.accessoryType = .disclosureIndicator
            return cell

        case 20:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIAttachmentsFormCell.reuseIdentifier, for: indexPath) as! FUIAttachmentsFormCell
            cell.attachmentsController.delegate = self
            cell.attachmentsController.dataSource = self

            cell.attachmentsController.maxItems = 2
            cell.attachmentsController.customAttachmentsTitleFormat = "Media"
            cell.isEditable = allowsEditableCells
            cell.attachmentsController.isEditable = allowsEditableCells
            cell.attachmentsController.reloadData()

            let addPhotoAction = FUIAddPhotoLibraryItemsAttachmentAction()
            addPhotoAction.delegate = self
            cell.attachmentsController.addAttachmentAction(addPhotoAction)

            let takePhotoAction = FUITakePhotoAttachmentAction()
            takePhotoAction.delegate = self
            cell.attachmentsController.addAttachmentAction(takePhotoAction)

            let filePickerAction = FUIDocumentPickerAttachmentAction()
            filePickerAction.delegate = self
            cell.attachmentsController.addAttachmentAction(filePickerAction)

            return cell

        default:
            return UITableViewCell()
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 21
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        if preventNavigationLoop {
            AlertHelper.displayAlert(with: NSLocalizedString("keyAlertNavigationLoop", value: "No further navigation is possible.", comment: "XTIT: Title of alert message about preventing navigation loop."), error: nil, viewController: self)
            return
        }
        switch indexPath.row {
        case 18:
            if !entity.isNew {
                showFioriLoadingIndicator()
                let destinationStoryBoard = UIStoryboard(name: "Stock", bundle: nil)
                let destinationDetailVC = destinationStoryBoard.instantiateViewController(withIdentifier: "StockDetailViewController") as! StockDetailViewController
                Task.init {
                    do {
                        try await self.dataService.loadProperty(Product.stockDetails, into: self.entity)
                        self.hideFioriLoadingIndicator()
                    } catch {
                        AlertHelper.displayAlert(with: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), error: error, viewController: self)
                        return
                    }
                }

                if let stockDetails = entity.stockDetails {
                    destinationDetailVC.entity = stockDetails
                }
                destinationDetailVC.navigationItem.leftItemsSupplementBackButton = true
                destinationDetailVC.navigationItem.title = "StockDetails"
                destinationDetailVC.allowsEditableCells = false
                destinationDetailVC.preventNavigationLoop = true
                navigationController?.pushViewController(destinationDetailVC, animated: true)
            }
        case 19:
            if !entity.isNew {
                showFioriLoadingIndicator()
                let destinationStoryBoard = UIStoryboard(name: "Supplier", bundle: nil)
                let destinationDetailVC = destinationStoryBoard.instantiateViewController(withIdentifier: "SupplierDetailViewController") as! SupplierDetailViewController
                Task.init {
                    do {
                        try await self.dataService.loadProperty(Product.supplierDetails, into: self.entity)
                        self.hideFioriLoadingIndicator()
                    } catch {
                        AlertHelper.displayAlert(with: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), error: error, viewController: self)
                        return
                    }
                }

                if let supplierDetails = entity.supplierDetails {
                    destinationDetailVC.entity = supplierDetails
                }
                destinationDetailVC.navigationItem.leftItemsSupplementBackButton = true
                destinationDetailVC.navigationItem.title = "SupplierDetails"
                destinationDetailVC.allowsEditableCells = false
                destinationDetailVC.preventNavigationLoop = true
                navigationController?.pushViewController(destinationDetailVC, animated: true)
            }
        default:
            return
        }
    }

    // MARK: - OData property specific cell creators

    private func cellForCategory(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.category {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.category = nil
                    isNewValueValid = true
                } else {
                    if Product.category.isOptional || newValue != "" {
                        currentEntity.category = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForCategoryName(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.categoryName {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.categoryName = nil
                    isNewValueValid = true
                } else {
                    if Product.categoryName.isOptional || newValue != "" {
                        currentEntity.categoryName = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForCurrencyCode(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.currencyCode {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.currencyCode = nil
                    isNewValueValid = true
                } else {
                    if Product.currencyCode.isOptional || newValue != "" {
                        currentEntity.currencyCode = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForDimensionDepth(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.dimensionDepth {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.dimensionDepth = nil
                    isNewValueValid = true
                } else {
                    if let validValue = BigDecimal.parse(newValue) {
                        currentEntity.dimensionDepth = validValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForDimensionHeight(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.dimensionHeight {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.dimensionHeight = nil
                    isNewValueValid = true
                } else {
                    if let validValue = BigDecimal.parse(newValue) {
                        currentEntity.dimensionHeight = validValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForDimensionUnit(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.dimensionUnit {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.dimensionUnit = nil
                    isNewValueValid = true
                } else {
                    if Product.dimensionUnit.isOptional || newValue != "" {
                        currentEntity.dimensionUnit = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForDimensionWidth(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.dimensionWidth {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.dimensionWidth = nil
                    isNewValueValid = true
                } else {
                    if let validValue = BigDecimal.parse(newValue) {
                        currentEntity.dimensionWidth = validValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForLongDescription(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.longDescription {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.longDescription = nil
                    isNewValueValid = true
                } else {
                    if Product.longDescription.isOptional || newValue != "" {
                        currentEntity.longDescription = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForName(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.name {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.name = nil
                    isNewValueValid = true
                } else {
                    if Product.name.isOptional || newValue != "" {
                        currentEntity.name = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForPictureUrl(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.pictureUrl {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.pictureUrl = nil
                    isNewValueValid = true
                } else {
                    if Product.pictureUrl.isOptional || newValue != "" {
                        currentEntity.pictureUrl = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForPrice(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.price {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.price = nil
                    isNewValueValid = true
                } else {
                    if let validValue = BigDecimal.parse(newValue) {
                        currentEntity.price = validValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForProductID(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.productID {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.productID = nil
                    isNewValueValid = true
                } else {
                    if Product.productID.isOptional || newValue != "" {
                        currentEntity.productID = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForQuantityUnit(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.quantityUnit {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.quantityUnit = nil
                    isNewValueValid = true
                } else {
                    if Product.quantityUnit.isOptional || newValue != "" {
                        currentEntity.quantityUnit = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForShortDescription(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.shortDescription {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.shortDescription = nil
                    isNewValueValid = true
                } else {
                    if Product.shortDescription.isOptional || newValue != "" {
                        currentEntity.shortDescription = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForSupplierID(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.supplierID {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.supplierID = nil
                    isNewValueValid = true
                } else {
                    if Product.supplierID.isOptional || newValue != "" {
                        currentEntity.supplierID = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForUpdatedTimestamp(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.updatedTimestamp {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.updatedTimestamp = nil
                    isNewValueValid = true
                } else {
                    if let validValue = LocalDateTime.parse(newValue) { // This is just a simple solution to handle UTC only
                        currentEntity.updatedTimestamp = validValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForWeight(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.weight {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.weight = nil
                    isNewValueValid = true
                } else {
                    if let validValue = BigDecimal.parse(newValue) {
                        currentEntity.weight = validValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForWeightUnit(tableView: UITableView, indexPath: IndexPath, currentEntity: ESPMContainerFmwk.Product, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.weightUnit {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.weightUnit = nil
                    isNewValueValid = true
                } else {
                    if Product.weightUnit.isOptional || newValue != "" {
                        currentEntity.weightUnit = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    // MARK: - OData functionalities

    private func getMediaContent() -> ByteStream? {
        guard let entityMedia = entityMedia else {
            return nil
        }
        let content = ByteStream.fromBinary(data: entityMedia)
        content.mediaType = "image/jpeg" // customize the media type logic as necessary
        return content
    }

    @objc func createEntity() {
        showFioriLoadingIndicator()
        view.endEditing(true)
        logger.info("Creating entity in backend.")
        Task.init {
            do {
                guard let content = getMediaContent() else {
                    self.logger.error("Create entry failed. Error: Unable to get content for Media Entity")
                    AlertHelper.displayAlert(with: NSLocalizedString("keyErrorMediaEntityCreationTitle", value: "Create entry failed. Error: Unable to get content for Media Entity", comment: "XTIT: Title of alert message about media entity creation error."), error: nil, viewController: self)
                    return
                }
                try await dataService.createEntity(entity)
                try await dataService.createMedia(entity: entity, content: content)
                self.hideFioriLoadingIndicator()
            } catch {
                self.logger.error("Create entry failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorEntityCreationTitle", value: "Create entry failed", comment: "XTIT: Title of alert message about entity creation error."), error: error, viewController: self)
                return
            }

            self.logger.info("Create entry finished successfully.")
            await MainActor.run {
                self.dismiss(animated: true) {
                    FUIToastMessage.show(message: NSLocalizedString("keyEntityCreationBody", value: "Created", comment: "XMSG: Title of alert message about successful entity creation."))
                    self.tableUpdater?.entitySetHasChanged()
                }
            }
        }
    }

    func createEntityWithDefaultValues() -> ESPMContainerFmwk.Product {
        let newEntity = ESPMContainerFmwk.Product()

        // Key properties without default value should be invalid by default for Create scenario
        if newEntity.productID == nil || newEntity.productID!.isEmpty {
            validity["ProductId"] = false
        }

        barButtonShouldBeEnabled()
        return newEntity
    }

    @objc func updateEntity(_: AnyObject) {
        showFioriLoadingIndicator()
        view.endEditing(true)
        logger.info("Updating entity in backend.")
        Task.init {
            do {
                guard let content = getMediaContent() else {
                    self.logger.error("Update entry failed. Error: Unable to get content for Media Entity")
                    AlertHelper.displayAlert(with: NSLocalizedString("keyErrorMediaEntityUpdateTitle", value: "Update entry failed. Error: Unable to get content for Media Entity", comment: "XTIT: Title of alert message about media entity update error."), error: nil, viewController: self)
                    return
                }
                try await dataService.updateEntity(entity)
                try await dataService.uploadMedia(entity: entity, content: content)
                self.hideFioriLoadingIndicator()
            } catch {
                self.logger.error("Update entry failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorEntityUpdateTitle", value: "Update entry failed", comment: "XTIT: Title of alert message about entity update failure."), error: error, viewController: self)
                return
            }

            self.logger.info("Update entry finished successfully.")
            await MainActor.run {
                self.dismiss(animated: true) {
                    FUIToastMessage.show(message: NSLocalizedString("keyUpdateEntityFinishedTitle", value: "Updated", comment: "XTIT: Title of alert message about successful entity update."))
                    self.entityUpdater?.entityHasChanged(self.entity)
                    self.entityMediaUpdater?.entityMediaHasChanged(self.entityMedia)
                    self.tableMediaUpdater?.entitySetMediaHasChanged(for: self.entity, to: self.entityMedia)
                }
            }
        }
    }

    // MARK: - other logic, helper

    @objc func cancel() {
        showFioriLoadingIndicator()
        view.endEditing(true)
        Task.init {
            do {
                try await dataService.loadEntity(entity)
            } catch {
                self.logger.warn("Load entity failed on cancel. Shown cached data may not be reflective of the backend.")
            }
            self.hideFioriLoadingIndicator()
            await MainActor.run {
                self.dismiss(animated: true)
            }
        }
    }

    // Check if all text fields are valid
    private func barButtonShouldBeEnabled() {
        let anyFieldInvalid = validity.values.first { field in
            field == false
        }
        navigationItem.rightBarButtonItem?.isEnabled = anyFieldInvalid == nil
    }
}

extension ProductDetailViewController: ESPMContainerEntityUpdaterDelegate {
    func entityHasChanged(_ entityValue: EntityValue?) {
        if let entity = entityValue {
            let currentEntity = entity as! ESPMContainerFmwk.Product
            self.entity = currentEntity
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

extension ProductDetailViewController: ESPMContainerEntityMediaUpdaterDelegate {
    func entityMediaHasChanged(_ changedMedia: Data?) {
        if let media = changedMedia {
            entityMedia = media
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

extension ProductDetailViewController: FUIAttachmentsViewControllerDelegate {
    func attachmentsViewController(_: FUIAttachmentsViewController, didPressDeleteAtIndex _: Int) {
        entityMedia = nil
        tableView.reloadData()
    }

    func attachmentsViewController(_: SAPFiori.FUIAttachmentsViewController, couldNotPresentAttachmentAtIndex _: Int) {
        logger.error("can't present attachment at index")
    }
}

extension ProductDetailViewController: FUIAttachmentsViewControllerDataSource {
    func numberOfAttachments(in _: SAPFiori.FUIAttachmentsViewController) -> Int {
        return 1
    }

    func attachmentsViewController(_: FUIAttachmentsViewController, iconForAttachmentAtIndex _: Int) -> (image: UIImage, contentMode: UIViewContentMode)? {
        if let entityMedia = entityMedia, let entityImage = UIImage(data: entityMedia) {
            return (entityImage, .scaleAspectFill)
        } else {
            return nil
        }
    }
}

extension ProductDetailViewController: FUIAddPhotoLibraryItemsAttachmentActionDelegate {
    func addPhotoLibraryItemAttachmentAction(_: SAPFiori.FUIAddPhotoLibraryItemsAttachmentAction, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            loadItem(itemProvider: result.itemProvider)
        }
    }

    func loadItem(itemProvider: NSItemProvider) {
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            showFioriLoadingIndicator()
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                // Loading HDR files on simulators will result in error. This is a known problem. https://developer.apple.com/forums/thread/665265
                if let error = error {
                    self.logger.warn("Failed to load image: \(error)")
                    return
                }
                if let image = image as? UIImage, let media = image.jpegData(compressionQuality: 1.0) {
                    self.logger.info("Image loaded successfully")
                    self.entityMedia = media
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.hideFioriLoadingIndicator()
                    }
                }
            }
        }
    }
}

extension ProductDetailViewController: FUITakePhotoAttachmentActionDelegate {
    func takePhotoAttachmentAction(_: SAPFiori.FUITakePhotoAttachmentAction, didTakePhoto asset: PHAsset, at _: URL) {
        let imageManager = PHImageManager.default()
        showFioriLoadingIndicator()
        imageManager.requestImageDataAndOrientation(for: asset, options: nil) { data, _, _, _ in
            guard let data = data else {
                self.logger.warn("Failed to get photo.")
                return
            }
            self.entityMedia = data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.reloadData()
                self.hideFioriLoadingIndicator()
            }
        }
    }
}

extension ProductDetailViewController: FUIDocumentPickerAttachmentActionDelegate {
    var documentPicker: UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [UTType.data]
        return UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
    }

    func documentPickerAttachmentAction(_: SAPFiori.FUIDocumentPickerAttachmentAction, didPickFileAt url: URL) {
        showFioriLoadingIndicator()
        if let data = try? Data(contentsOf: url) {
            entityMedia = data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.reloadData()
                self.hideFioriLoadingIndicator()
            }
        } else {
            logger.error("cant get data of the selected file")
        }
    }
}
