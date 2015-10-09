public class LogisticsController {

    // Collections of data to display
    List<ServiceContract> serviceContracts;
    
    // Program Sort Objects
    public String progSortColumn = 'Service_Level__c';
    public String progSortDirection = 'ASC';
    public String progSortColumn2 = 'Account.Name';
    public String progSortDirection2 = 'ASC';
    public Util_Sorter progSorter {get; set;}
    
    // Program Filter Objects
    public boolean sl1 = false;
    public boolean sl2 = false;
    public boolean sl3 = false;
    public boolean sl4 = false;
    public boolean sl5 = true;
    public SL_Filter progServiceLevelFilter {get; set;}
    
    // Instances of Utilities
    public LogisticsController(){
        progSorter = new Util_Sorter(progSortColumn, progSortDirection, progSortColumn2, progSortDirection2);
        progServiceLevelFilter = new SL_Filter(sl1, sl2, sl3, sl4, sl5);
    }
    
    // Begin collecting data
    public List<ServiceContract> getServiceContracts(){
        if(serviceContracts == null) {
            try{
                String SOQLQuery = 'SELECT Id, Name, Account.Name, Account.Id, Account.Account_Manager__r.Id, Account.Account_Manager__r.Name, Account.Industry, Operations_Lead__r.Name, Operations_Lead__r.Id, Ops_Link__c, Program_Coordinator__r.Name, Program_Coordinator__r.Id, Sales_Link__c, Service_Level__c, Vendor_Management_System__c, Managed_Service_Provider__c, Welcome_Site__c, ActivationDate, StartDate, EndDate, CRG_Link__c, (SELECT PricebookEntry.Product2.Name, Subtotal, TotalPrice, Quantity FROM ContractLineItems) FROM ServiceContract WHERE Service_Level__c NOT IN ('
                    + progServiceLevelFilter.getFiltValue()
                    + ') ORDER BY '
                    + progSorter.getColumn()
                    + ' '
                    + progSorter.getSortDirection()
                    + ', '
                    + progSorter.getColumn2()
                    + ' '
                    + progSorter.getSortDirection2();
                system.debug(LoggingLevel.Error,SOQLQuery);
                return database.query(SOQLQuery);
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
        return serviceContracts;
    }
    
    // Run Utilities
    public PageReference sort() {
        return null;
    }
    
    public PageReference filter() {
        return null;
    }
}