# shipping
This is a sample of analysing shipping data 
Part 1
From the data, write the SQL query to:
1. Show list of transactions occurring in February 2018 with SHIPPED status.
2. Show list of transactions occurring from midnight to 9 AM
3. Show a list of only the last transactions from each vendor
4. Showalistofonlythesecondlasttransactionsfromeachvendor
5. Count the transactions from each vendor with the status CANCELLED per day
6. Showalistofcustomerswhomademorethan1SHIPPEDpurchases
7. Showthetotaltransactions(volume)andcategoryofeachvendorsbyfollowingthesecriteria:
a. Superb:Morethan2SHIPPEDand0CANCELLEDtransactions
b. Good:Morethan2SHIPPEDand1ormoreCANCELLEDtransactions
c. Normal: other than Superb and Good criteria
Order the vendors by the best category (Super, Good, Normal), then by the biggest transaction volume
8. Groupthetransactionsbyhouroftransaction_date
9. Groupthetransactionsbydayandstatusesastheexamplebelow
10. Calculate the average, minimum and maximum of days interval of each transaction (how many days from one transaction to the next)

PART 2
In reference to both tables, write an SQL query to:
1. Show the sum of the total value of the products shipped along with the Distributor
Commissions (2% of the total product value if total quantity is 100 or less, 4% of the total product value if total quantity sold is more than 100)
2. Showtotalquantityof“Indomie(allvariant)”shippedwithinFebruary2018
3. Foreachproduct,showtheIDofthelasttransactionwhichcontainedthatparticularproduct
