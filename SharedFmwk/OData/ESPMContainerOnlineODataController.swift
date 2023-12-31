//
// wizapp
//
// Created by SAP BTP SDK Assistant for iOS v9.1.3 application on 16/06/23
//

import ESPMContainerFmwk
import SAPCommon
import SAPFoundation
import SAPOData

public class ESPMContainerOnlineODataController: ODataControlling {
    private let logger = Logger.shared(named: "ESPMContainerOnlineODataController")
    public var dataService: ESPMContainer!

    public init() {}

    // MARK: - Public methods

    // Read more about consumption of OData services in mobile applications: https://help.sap.com/viewer/fc1a59c210d848babfb3f758a6f55cb1/Latest/en-US/22e9533533c646d8831e87357519cf4e.html
    public func configureOData(sapURLSession: SAPURLSession, serviceRoot: URL) throws {
        let odataProvider = OnlineODataProvider(serviceName: "ESPMContainer", serviceRoot: serviceRoot, sapURLSession: sapURLSession)
        // Disables version validation of the backend OData service
        #warning("Version validation should only be disabled in demo and test applications")
        odataProvider.serviceOptions.checkVersion = false
        dataService = ESPMContainer(provider: odataProvider)
        // To update entity force to use X-HTTP-Method header
        odataProvider.networkOptions.tunneledMethods.append("MERGE")
    }
}
