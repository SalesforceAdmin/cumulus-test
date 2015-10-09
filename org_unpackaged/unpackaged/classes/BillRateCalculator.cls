/**********************************************************
* Description      : Bill Rate Calculator Web Service to calculate Hourly and Annual Bill Rate 
* @author          : Kiran Kurella
* @date            : June 19, 2015
* Copyright 2015 MBO Partners. All rights reserved.
**********************************************************/

@RestResource(urlMapping='/BillRate/v1/*')
global without sharing class BillRateCalculator {
    
    @HttpPost
    global static void doPost() {
        
        BillRateResponse brRes = new BillRateResponse();
        if (RestContext.request != null) {
            brRes = calculateBillRate(RestContext.request.requestBody.toString());
            
            RestResponse response = RestContext.response;
            response.addHeader('Content-type', 'application/json');
            response.statusCode = 200;
            
            response.responseBody = blob.valueOf(brRes.serialize());
            
            // delete Bill Rate Result record, if it is not associated with a Lead or Contact record
            system.debug(' ### billRateResult_To_Delete ' + billRateResult_To_Delete);
            if (billRateResult_To_Delete != null) delete billRateResult_To_Delete;
        }
    }
    
    private static BillRateResult__c billRateResult_To_Delete;
    public static BillRateResponse calculateBillRate(String jsonString) {
        
        BillRateResponse brRes = new BillRateResponse();
        try {

            system.debug(' ### jsonString - Bill Rate Calculator request: ' + jsonString);

            BillRateRequest brReq = new BillRateRequest();
            if (String.isNotBlank(jsonString)) brReq = (BillRateRequest) system.JSON.deserialize(jsonString, BillRateRequest.class);
            system.debug(' ### bill rate request ' + brReq);

            SObject sobj;
            system.debug(' ### email ' + brReq.user.email);
            if (String.isNotBlank(brReq.user.email)) {
                // find matching Contact or Lead
                sobj = findMatchingContactOrLead(brReq.user.email);

                // no mathcing Lead or Contact found - create a new Lead
                if (sobj == null) {
                    if (String.isBlank(brReq.user.lastName)) brReq.user.lastName = '[Not Provided]';

                    sobj = new Lead (FirstName=brReq.user.firstName, LastName=brReq.user.lastName, Email=brReq.user.email, State=brReq.user.State, Bill_Rate_Submitted__c=TRUE);
                    insert sobj;

                    system.debug(' ### created a new Lead ' + sobj);
                }
            }

            // get the National average, if the State parameter is blank or the State Tax Rate is not available
            if (String.isBlank(brReq.user.state) || !mapStateTaxRates.containsKey(brReq.user.state)) brReq.user.state = 'All';

            // get State tax rate
            decimal taxRate = mapStateTaxRates.get(brReq.user.state).Tax_Rate__c;
            system.debug(' ### state ' + brReq.user.state + ' taxRate ' + taxRate);

            BillRateResult__c br;
            list<BillRateResult__c> existingBRs = new list<BillRateResult__c>{};

                if (sobj != null) {
                    // get existing Bill Rate Result record
                    existingBRs = [SELECT 	Prospective_Associate__c, State__c, State_Tax_Rate__c, State_Tax_Amount__c, Fed_Tax_Amount__c,
                                   Annual_Income__c, Annual_Hours__c, Annual_Expenses__c, Annual_Bill_Rate__c, Target_Bill_Rate__c, Gross_Margin__c,
                                   Profit_Margin__c
                                   FROM 	BillRateResult__c
                                   WHERE 	Prospective_Associate__c = :sobj.Id OR Associate__c = :sobj.Id];
                }

            system.debug(' ### existingBRs ' + existingBRs.size() + ' => ' + existingBRs);
            if (existingBRs.isEmpty()) {

                // create a new Bill Rate Result
                boolean isLead = sobj != null && sobj.Id.getSobjectType() == Schema.Lead.sObjectType;
                br = new BillRateResult__c(Associate__c=(isLead || sobj==null ? null : sobj.Id), Prospective_Associate__c=(isLead ? sobj.Id : null),
                                           State__c=brReq.user.state, State_Tax_Rate__c=taxRate, Annual_Income__c=brReq.targetWages,
                                           Annual_Hours__c=brReq.getTotalHours(), Annual_Expenses__c=brReq.getTotalExpenses(), Profit_Margin__c=(100*brReq.profitMargin));
            } else {
                br = existingBRs[0];

                // update existing Bill Rate Result
                br.State__c = brReq.user.state;
                br.State_Tax_Rate__c = taxRate;
                br.Annual_Income__c = brReq.targetWages;
                br.Annual_Hours__c = brReq.getTotalHours();
                br.Annual_Expenses__c = brReq.getTotalExpenses();
                br.Profit_Margin__c = (100*brReq.profitMargin);
            }
            
            upsert br;
            
            // query the record from DB to retrieve the formula field values
            br = [SELECT Prospective_Associate__c, State__c, State_Tax_Rate__c, State_Tax_Amount__c, Fed_Tax_Amount__c,
                  Annual_Income__c, Annual_Hours__c, Annual_Expenses__c, Annual_Bill_Rate__c, Target_Bill_Rate__c, Gross_Margin__c,
                  Profit_Annual_Billings__c, Profit_Annual_Income__c, Profit_Fed_Tax_Amount__c, Profit_Hourly_Rate__c, Profit_State_Tax_Amount__c, Profit_Margin__c
                  FROM 	BillRateResult__c
                  WHERE 	Id = :br.Id];
            
            system.debug(' ### bill rate result ' + br);
            
            // Hourly Bill Rate ([Income + State Tax + Expense] / Hour)	- ((0.11*( Annual_Expenses__c + Annual_Income__c ))+Annual_Expenses__c + Annual_Income__c)/ Annual_Hours__c
            brRes.request = jsonString;
            brRes.profitMargin = brReq.profitMargin;
            
            brRes.assignBillRateResult(br);
            
            // delete Bill Rate Result record, if it is not associated with a Lead or Contact record (i.e., if the email address is missing)
            if (sobj == null) billRateResult_To_Delete = br;
            
            brRes.isSuccess = true;
            //} else {
            //brRes.errorMessage = errMsg;
            //}
        } catch (exception ex) {
            system.debug(' ### exception in BillRateCalculator ' + ex);
            brRes.errorMessage = ex.getMessage();
        }
        
        system.debug(' ### bill rate response ' + brRes);
        return brRes;
    }
    
    public static map<String, State_Tax_Rate__c> mapStateTaxRates {
        get {
            if (mapStateTaxRates == null) {
                mapStateTaxRates = State_Tax_Rate__c.getAll();
                system.debug(' ### mapStateTaxRates ' + mapStateTaxRates.size() + ' => ' + mapStateTaxRates);
            }
            
            return mapStateTaxRates;
        }
        private set;
    }
    
    private static SObject findMatchingContactOrLead(String email) {
        
        SObject sobj;
        
        system.debug(' ### email in findMatchingContactOrLead ' + email);
        if (String.isNotBlank(email)) {
            list<Lead> leads = new list<Lead>();
            list<Contact> contacts = new list<Contact>();
            
            // Order the list by CreatedDate
            list<list<SObject>> searchList = [FIND :email
                                              IN EMAIL FIELDS
                                              RETURNING Lead(Id WHERE IsConverted = false Order By CreatedDate desc), Contact(Id Order By CreatedDate desc)];
            
            contacts = ((list<Contact>) searchList[1]);
            system.debug(' ### existing contacts ' + contacts.size() + ' => ' + contacts);
            
            leads = ((list<Lead>) searchList[0]);
            System.debug(' ### existing leads ' + leads.size() + ' => ' + leads);
            
            // return the first matching Contact or Lead; set the field tracking that the Lead/Contact submitted the API.
            if (!contacts.isEmpty()) {
                contacts[0].Bill_Rate_Submitted__c = TRUE;
                Update contacts[0];
                sobj = contacts[0];
                system.debug(' ### found an existing Contact ' + sobj);
            } else if (!leads.isEmpty()) {
                leads[0].Bill_Rate_Submitted__c = TRUE;
                Update leads[0];
                sobj = leads[0];
                system.debug(' ### found an existing Lead ' + sobj);
            }
        }
        
        return sobj;
    }
    
    /*****************************************************************************************************************************************
     * Bill Rate request and response classes
     *****************************************************************************************************************************************/
    
    public class BillRateRequest {
        public User user;
        public decimal targetWages = 0;
        public decimal profitMargin = 0;
        public decimal workHours = 0;
        public list<BillRateDetail> nonBillableTime;
        public list<BillRateDetail> expenses;
        
        public BillRateRequest() {
            user = new User();
        }
        
        public decimal getTotalExpenses() {
            decimal totalExpenses = 0;
            
            // Expense Formula: (expense[0].amount * expense[0].periods) + (expense[1].amount * expense[1].periods) + …
            if (expenses != null && !expenses.isEmpty()) {
                for (BillRateDetail brd : expenses) {
                    if (brd.amount != null && brd.periods != null) totalExpenses += (brd.amount * brd.periods);
                }
            }
            system.debug(' ### totalExpenses ' + totalExpenses);
            
            return totalExpenses;
        }
        
        public decimal getTotalHours() {
            decimal totalHours = 0;
            
            // The formula for total hours would be: workHours – ( (nonBillableHours[0].amount * nonBillableHours[0].periods) + (nonBillableHours[1].amount * nonBillableHours[1].periods) + …)
            if (nonBillableTime != null && !nonBillableTime.isEmpty()) {
                for (BillRateDetail brd : nonBillableTime) {
                    if (brd.amount != null && brd.periods != null) totalHours += (brd.amount * brd.periods);
                }
            }
            system.debug(' ### nonBillableTime ' + totalHours);
            
            totalHours = (workHours * 52) - totalHours;
            system.debug(' ### workHours ' + workHours + ' totalHours ' + totalHours);
            
            return totalHours;
        }
    }
    
    public class User {
        public String userId;
        public String firstName;
        public String lastName;
        public String email;
        public String state;
    }
    
    public class BillRateDetail {
        public String purpose;
        public decimal amount = 0;
        public decimal periods = 0;
    }
    
    public class ItemizedBreakdown {
        public decimal Total_Gross_Wages = 0;
        public decimal Expenses = 0;
        public decimal Taxes = 0;
        public decimal Billings_Needed_to_Reach_Gross_Wages = 0;
        public decimal Target_Profit_Margin = 0;
        public decimal Billings_Needed_to_Reach_Profit_Margin = 0;
        public decimal Annual_Billable_Hours = 0;
        public decimal Hourly_Bill_Rate_to_Reach_Profit_Margin = 0;
    }
    
    public class BillingRate {
        //public decimal hourlyRate = 0;
        //public decimal yearlyBilling = 0;
        
        public decimal hourlyRate {get; set {if (value==null) value=0; hourlyRate=value;}}
        public decimal yearlyBilling {get; set {if (value==null) value=0; yearlyBilling=value;}}
        
        public BillingRate() {
            hourlyRate = 0;
            yearlyBilling = 0;
        }
    }
    
    public class BillRateResponse {
        public boolean isSuccess = false;
        public String errorMessage = '';
        
        public String request;
        public decimal profitMargin = 0;
        public BillingRate targetRate;
        public BillingRate profitRate;
        public ItemizedBreakdown itemizedBreakdown;
        
        public BillRateResponse() {
            targetRate = new BillingRate();
            profitRate = new BillingRate();
            itemizedBreakdown = new ItemizedBreakdown();
        }
        
        /*
         * public void calculateProfitRates() {
         * profitRate.hourlyRate = targetRate.hourlyRate==null || profitMargin==null ? targetRate.hourlyRate : (targetRate.hourlyRate * (1 + profitMargin));
         * profitRate.yearlyBilling = targetRate.yearlyBilling==null || profitMargin==null ? targetRate.yearlyBilling : (targetRate.yearlyBilling * (1 + profitMargin));
         * }
         */
        
        public void assignBillRateResult(BillRateResult__c br) {
            if (br != null) {
                // assign target rates
                targetRate.hourlyRate = br.Target_Bill_Rate__c==null ? 0 : br.Target_Bill_Rate__c;
                targetRate.yearlyBilling = br.Annual_Bill_Rate__c == null ? 0: br.Annual_Bill_Rate__c;	// Annual Bill Rate = Annual_Income__c + Annual_Expenses__c + Fed_Tax_Amount__c + State_Tax_Amount__c
                
                
                
                
                // calculate profit rate from target Rate
                //profitRate.hourlyRate = targetRate.hourlyRate==null || brReq.profitMargin==null ? targetRate.hourlyRate : (targetRate.hourlyRate * (1 + brReq.profitMargin));
                //profitRate.yearlyBilling = targetRate.yearlyBilling==null || brReq.profitMargin==null ? targetRate.yearlyBilling : (targetRate.yearlyBilling * (1 + brReq.profitMargin));
                //calculateProfitRates();
                
                // assign itemized break down details
                itemizedBreakdown.Total_Gross_Wages = br.Annual_Income__c==null ? 0 : br.Annual_Income__c;
                itemizedBreakdown.Expenses = br.Annual_Expenses__c==null ? 0 : br.Annual_Expenses__c;
                itemizedBreakdown.Taxes = br.State_Tax_Amount__c + br.Fed_Tax_Amount__c;
                itemizedBreakdown.Billings_Needed_to_Reach_Gross_Wages = br.Annual_Bill_Rate__c==null ? 0 : br.Annual_Bill_Rate__c;
                itemizedBreakdown.Target_Profit_Margin = (br.Profit_Margin__c / 100); //itemizedBreakdown.Target_Profit_Margin = profitMargin;
                
                /*
                 * itemizedBreakdown.Billings_Needed_to_Reach_Profit_Margin = profitRate.yearlyBillings + br.Annual_Expenses__c + profitRate.State_Tax_Amount + profitRate.Fed_Tax_Amount;
                 * profitRate.yearlyBillings = profitRate.hourlyRate * br.Annual_Hours__c;
                 * profitRate.State_Tax_Amount = profitRate.yearlyBillings * br.State_Tax_Rate__c;
                 * profitRate.Fed_Tax_Amount = profitRate.yearlyBillings * br.Fed_Tax_Rate__c;
                 */
                
                /*
                 * decimal yearlyBillings = br.Annual_Income__c==null ? 0 : br.Annual_Income__c * (1 + profitMargin);
                 * decimal pmStateTaxAmount = yearlyBillings * br.State_Tax_Rate__c;
                 * decimal pmFedTaxAmount = yearlyBillings * (String.isBlank(system.Label.Federal_Tax_Rate) ? 0 : decimal.valueOf(system.Label.Federal_Tax_Rate));
                 * decimal profitAnnual = yearlyBillings + br.Annual_Expenses__c + pmStateTaxAmount + pmFedTaxAmount;
                 * decimal profitHourly = profitAnnual==null || br.Annual_Hours__c==null ? br.Target_Bill_Rate__c : profitAnnual / br.Annual_Hours__c;
                 */
                
                itemizedBreakdown.Billings_Needed_to_Reach_Profit_Margin = br.Profit_Annual_Billings__c; //itemizedBreakdown.Billings_Needed_to_Reach_Profit_Margin = profitAnnual;
                profitRate.yearlyBilling = br.Profit_Annual_Billings__c; //profitRate.yearlyBilling = profitAnnual;
                
                itemizedBreakdown.Annual_Billable_Hours = br.Annual_Hours__c;
                itemizedBreakdown.Hourly_Bill_Rate_to_Reach_Profit_Margin = br.Profit_Hourly_Rate__c; //itemizedBreakdown.Hourly_Bill_Rate_to_Reach_Profit_Margin = profitHourly;
                profitRate.hourlyRate = br.Profit_Hourly_Rate__c; //profitRate.hourlyRate = profitHourly;
            }
        }
        
        public String serialize() {
            String jsonString = JSON.serialize(this);
            
            // format the response
            jsonString = jsonString.replace('Total_Gross_Wages', 'Total Gross Wages');
            jsonString = jsonString.replace('Billings_Needed_to_Reach_Gross_Wages', 'Billings Needed to Reach Gross Wages');
            jsonString = jsonString.replace('Target_Profit_Margin', 'Target Profit Margin');
            jsonString = jsonString.replace('Billings_Needed_to_Reach_Profit_Margin', 'Billings Needed to Reach Profit Margin');
            jsonString = jsonString.replace('Annual_Billable_Hours', 'Annual Billable Hours');
            jsonString = jsonString.replace('Hourly_Bill_Rate_to_Reach_Profit_Margin', 'Hourly Bill Rate to Reach Profit Margin');
            
            return jsonString;
        }
    }
}