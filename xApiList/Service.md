### Service Provider

1. Add a serviceProvider to a merchantId
   https://nxtshops.com/merchantApi/service
   POST : JSON
   ```javascript
   {
   	"detail": {
   		"name": "Motor House",
   		"categoryId": 1,
   		"coverage": 10,
   		"merchantId": 1
   	},
   	"address": {
   		"pickupAddress": "Near mavelikkara junction",
   		"latitude": 9.230385,
   		"longitude": 76.515898
   	}
   }
   ```
2. Update a serviceProvider
   https://nxtshops.com/merchantApi/service/serviceProviderId
   PUT : JSON

   ```javascript
   {
   	"detail": {
   		"name": "Motor House",
   		"categoryId": 1,
   		"coverage": 10,
   		"merchantId": 1
   	},
   	"address": {
   		"pickupAddress": "Near mavelikkara junction",
   		"latitude": 9.230385,
   		"longitude": 76.515898
   	}
   }
   ```

3. Get all service providers abiding to certain criteria or filtering
   https://nxtshops.com/adminApi/service/pageNo?providerName=a&merchantId=b&onlineStatus=0/1
   Page No is basically limit, each page will have max 15 service providers
   #merchantId here is emailId which is string
   e.g)https://nxtshops.com/adminApi/service/1?onlineStatus=1&providerName=Motor House

### Service Category POST, PUT, DELETE

1. Add service Category
   https://nxtshops.com/adminApi/serviceCategory
   Method : POST

   ```javascript
   {
      "CategoryName": "new service category",
      "Active": 1/0,
      "InitialPaymentAmount": INTEGER,
      "MinBookDay": INTEGER
   }
   ```

2. Update service Item
   https://nxtshops.com/adminApi/serviceCategory/serviceCategoryId
   Method : PUT

   ```javascript
   {
      "CategoryName": "updated service category",
      "Active": 1/0,
      "InitialPaymentAmount": INTEGER,
      "MinBookDay": INTEGER
   }
   ```

## Service Item, packages, repairs

1. Get All Services Categorically
   https://nxtshops.com/searchApi/service

   #Get All Services Categorically and near the user
   https://nxtshops.com/searchApi/service/services/9.230385/76.515898

2. Add service Item
   https://nxtshops.com/adminApi/service
   Method : POST

   ```javascript
   {
      "CategoryItemName": "new service",
      "CategoryId": 1,
      "Description": "some value",
      "Active": 1/0
   }
   ```

3. Update service Item
   https://nxtshops.com/adminApi/service/serviceItemId
   Method : PUT

   ```javascript
   {
      "CategoryItemName": "new service",
      "CategoryId": 1,
      "Description": "some value",
      "Active": 1/0
   }
   ```

4. Add service Package
   https://nxtshops.com/adminApi/servicePackage
   Method : POST

   ```javascript
   {
      "PackageName": "new package",
      "CategoryItemId": 1,
      "Description": "some value",
      "Active": 1/0
   }
   ```

5. Update service Package
   https://nxtshops.com/adminApi/servicePackage/packageId
   Method : PUT

   ```javascript
   {
      "PackageName": "new package renamed",
      "CategoryItemId": 1,
      "Description": "some value",
      "Active": 1/0
   }
   ```

6. Add service PackageItem
   https://nxtshops.com/adminApi/servicePackage/packageItem
   Method : POST

   ```javascript
   {
      "PackageItemName": "new packageItem",
      "PackageId": 1,
      "Description": "some value",
      "Active": 1/0,
      "Rate": 100,
      "OfferRate": 90
   }
   ```

7. Update service PackageItem
   https://nxtshops.com/adminApi/servicePackage/packageItem/packageId
   Method : PUT

   ```javascript
   {
      "PackageItemName": "new packageItem renamed",
      "PackageId": 1,
      "Description": "some value",
      "Active": 1/0,
      "Rate": 120,
      "OfferRate": 80
   }
   ```

8. Add service Repair
   https://nxtshops.com/adminApi/serviceRepair
   Method : POST

   ```javascript
   {
      "RepairItems": "new repair Item",
      "CategoryItemId": 1,
      "Active": 1/0
   }
   ```

9. Update service Repair
   https://nxtshops.com/adminApi/serviceRepair/RepairItemId
   Method : PUT

   ```javascript
   {
      "RepairItems": "new repair Item renamed",
      "CategoryItemId": 1,
      "Active": 1/0
   }
   ```

10. Add service Repair Parts
    https://nxtshops.com/adminApi/serviceRepair/repairPart
    Method : POST

    ```javascript
    {
       "RepairItemsPart": "new repair Item Part",
       "RepairItemId": 1,
       "Rate": 1000,
       "OfferRate": 800,
       "Active": 1/0,
       "Min_Rate": 900,
       "Min_OfferRate": 700
    }
    ```

11. Update service Repair Parts
    https://nxtshops.com/adminApi/serviceRepair/repairPart/RepairItemsAndRate_Id
    Method : PUT

    ```javascript
    {
       "RepairItemsPart": "new repair Item Part",
       "RepairItemId": 1,
       "Rate": 1000,
       "OfferRate": 800,
       "Active": 1/0,
       "Min_Rate": 900,
       "Min_OfferRate": 700
    }
    ```

12. Get Service Item for the service Category
    https://nxtshops.com/searchApi/service/serviceItem/CategoryId?isActive=0

13. Get available repair and packages for service Item
    https://nxtshops.com/searchApi/service/serviceDetails/ServiceItemId?isActive=0

14. Get package rate for packages
    https://nxtshops.com/searchApi/service/packageRate/PackageId?isActive=0

15. Get Service charge and Repair Parts Rate for RepairItemId
    https://nxtshops.com/searchApi/service/repairParts/RepairItemId?isActive=0
