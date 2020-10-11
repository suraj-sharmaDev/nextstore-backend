Admin
-----
1. Login Admin
	https://nxtshops.com/adminApi/admin
	POST : JSON
	```javascript
	{
		"username": "admin",
		"password": "hello"
	}
	```

2. Update Admin Token
	https://nxtshops.com/adminApi/admin/adminId
	PUT : JSON
	```javascript
	{
		"fcmToken": "_token_"
	}
	```
merchant
--------

1. Login Merchant
	https://nxtshops.com/merchantApi/login
	POST : JSON
	```javascript
	{
	"email": "suraj123",
	"password": "hello"
	}
	```

2. create Merchant
	https://nxtshops.com/merchantApi/merchant
	POST : JSON
	{
	"firstName": "suraj",
	"lastName": "sharma",
	"mobile": 7907508735
	}

3. update Merchant
	https://nxtshops.com/merchantApi/merchant/merchId
	PUT : JSON

4. View all merchants abiding to certain criteria or filtering
    https://nxtshops.com/adminApi/merchant/pageNo?merchId=x&merchName=b&merchEmail=c
    Page No is basically limit, each page will have max 15 shops
	#merchId is id of merchant which is integer
	#merchEmail is email of merchant
	e.g)https://nxtshops.com/adminApi/merchant/1?merchId=1&merchName=suraj&merchEmail=suraj123

5. Get list of shops belonging to specific merchant
    https://nxtshops.com/merchantApi/merchant/merchId
	#merchId is id of merchant which is integer

Shop
----

1. Get content of shop with shopId
	https://nxtshops.com/merchantApi/shop/shopId

	To get basic shopInfo
	https://nxtshops.com/merchantApi/shop/shopId/basic

2. Get products of shop with shopId, for subCategoryId
	https://nxtshops.com/merchantApi/shop/shopId/subCategoryId

3. Create Shop
	https://nxtshops.com/merchantApi/shop/merchId
	POST : FORMDATA

		type => shop
		
		json => {"shop":{"name":"arvees","onlineStatus":0},"address":{"pickupAddress":"Nearmavelikkarajunction","latitude":9.230385,"longitude":76.515898}}

		image => TYPE_FILE
		
4. Update Shop
	https://nxtshops.com/merchantApi/shop/merchId/shopId
	This api can be called in two ways
	One with file as formData or without file as raw json
	With Formdata
	-------------
	PUT : FORMDATA
		type => shop
		
		json => {"shop":{"name":"arvees","onlineStatus":0},"address":{"pickupAddress":"Nearmavelikkarajunction","latitude":9.230385,"longitude":76.515898}}

		image => TYPE_FILE

	With Raw Json
	-------------
	PUT : JSON
	```javascript
	{
	  "shop":{
	    "name": "arvees",
	    "onlineStatus": 0
	  },
	  "address":{
	    "pickupAddress": "Near mavelikkara junction",
	    "latitude": 9.230385,
	    "longitude": 76.515898
	  }
	}
	```
5. Get all shops abiding to certain criteria or filtering
	https://nxtshops.com/adminApi/shop/pageNo?shopName=a&merchantId=b&onlineStatus=0/1
	Page No is basically limit, each page will have max 15 shops
	#merchantId here is emailId which is string
	e.g)https://nxtshops.com/adminApi/shop/1?shopName=Nxt Stores&merchantId=suraj123&onlineStatus=1

shop offers
-----------
1. Get all offers belonging to shops
    https://nxtshops.com/adminApi/shopOffer/pageNo
	
	#Get all offers belonging to particular shop
    https://nxtshops.com/adminApi/shopOffer/pageNo/shopId	

2. Create a new offer for a shop
    https://nxtshops.com/adminApi/shopOffer/shopId
    POST : FORMDATA
        type : offer
        image : FILE

3. Update offer for shop
    https://nxtshops.com/adminApi/shopOffer/offerId/shopId
    POST : FORMDATA
        type : offer
        image : FILE

4. Delete offer for a shop
    https://nxtshops.com/adminApi/shopOffer/offerId
    DELETE Request


category
--------

1. Get All Category
	https://nxtshops.com/merchantApi/category

2. Get category with Id
	https://nxtshops.com/merchantApi/category/category/categoryId

3. Create Category
	https://nxtshops.com/merchantApi/category
	POST : JSON
	```javascript
	{
	  "name":"Vegetables"
	}	
	```
4. Update Category
	https://nxtshops.com/merchantApi/category/category/categoryId
	POST : JSON
	```javascript
	{
	  "name":"Vegetables!"
	}		
	```
5. Get subCategory with Id
	https://nxtshops.com/merchantApi/category/subCategory/subCategoryId

6. Create SubCategory
	https://nxtshops.com/customerApi/category/subCategory
	PUT : JSON
	```javascript
	{
	  "name":"Vegetables",
	  "categoryId" : 1
	}	
	```
7. Update SubCategory
	https://nxtshops.com/merchantApi/category/subCategory/subCategoryId
	PUT : JSON
	```javascript
	{
	  "name":"Vegetables!"
	}
	```

8. Get subCategoryChild with Id
	https://nxtshops.com/merchantApi/category/subCategory/subCategoryId

9. Create SubCategoryChild
	https://nxtshops.com/merchantApi/category/subCategoryChild
	```javascript
	POST : JSON
	{
	  "name":"Vegetables",
	  "subCategoryId" : 1
	}	
	```
10. Update Category
	https://nxtshops.com/merchantApi/category/subCategoryChild/subCategoryChildId
	PUT : JSON
	```javascript
	{
	  "name":"Vegetables!"
	}	
	```

Services
--------

1. Get All Services Categorically
	https://nxtshops.com/searchApi/service

	#Get All Services Categorically and near the user
	https://nxtshops.com/searchApi/service/services/9.230385/76.515898

2. Get Service Item for the service Category
	https://nxtshops.com/searchApi/service/serviceItem/CategoryId

3. Get available repair and packages for service Item
	https://nxtshops.com/searchApi/service/serviceDetails/ServiceItemId

4. Get package rate for packages
	https://nxtshops.com/searchApi/service/packageRate/PackageId

5. Get Service charge and Repair Parts Rate for RepairItemId
	https://nxtshops.com/searchApi/service/repairParts/RepairItemId

6. Add a serviceProvider to a merchantId
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
7. Update a serviceProvider
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

8. Get all service providers abiding to certain criteria or filtering
	https://nxtshops.com/adminApi/service/pageNo?providerName=a&merchantId=b&onlineStatus=0/1
	Page No is basically limit, each page will have max 15 service providers
	#merchantId here is emailId which is string
	e.g)https://nxtshops.com/adminApi/service/1?onlineStatus=1&providerName=Motor House

Product Master
--------------
1. Create product in productMaster
    https://nxtshops.com/adminApi/product
    POST : FORMDATA
        type: product
        name : STRING
        bigImage1: FILE         ---> optional
        bigImage2: FILE         ---> optional
        bigImage3: FILE         ---> optional
        bigImage4: FILE         ---> optional
        bigImage5: FILE         ---> optional
        bigImage6: FILE         ---> optional
        image: FILE
        subCategoryChildId: INTEGER

2. Update product in productMaster
    https://nxtshops.com/adminApi/product/productMasterId

    POST : FORMDATA
        type: product         ---> optional
        name : STRING         ---> optional
        bigImage1: FILE         ---> optional
        bigImage2: FILE         ---> optional
        bigImage3: FILE         ---> optional
        bigImage4: FILE         ---> optional
        bigImage5: FILE         ---> optional
        bigImage6: FILE         ---> optional
        image: FILE         ---> optional
        subCategoryChildId: INTEGER         ---> optional

3. List all products in productMaster with keyword
	https://nxtshops.com/merchantApi/product?searchTerm=keyword&categoryId=categoryId
	where categoryId is optional
	
Product
---------

1. Create product
	https://nxtshops.com/merchantApi/product/shopId
	POST : JSON
	```javascript
	{
		"mrp" : 200			//mrp should be greater than or equal to price
		"price" : 200,
		"productMasterId" : 1
	}	
	```

2. Update product
	https://nxtshops.com/merchantApi/product/shopId/productId
	PUT : JSON
	```javascript
	{
		"price" : 200,
		"productMasterId" : 1
	}	
	```

Order
--------

1. Get Order Details
	https://nxtshops.com/orderApi/order/orderId

	#Get Order belonging to shop
	https://nxtshops.com/orderApi/order/shopId/orderStatus/pageNo/startDate?/endDate?
	where startDate and endDate are optional parameters

2. Accept order
	https://nxtshops.com/orderApi/operations/acceptOrder/orderId

3. Reject Order
	https://nxtshops.com/orderApi/operations/rejectOrder/orderId

4. Complete order
	https://nxtshops.com/orderApi/operations/completeOrder/orderId

Quote
--------
#Shops will have order and services will have quotes

1. Get Quote Details
	https://nxtshops.com/orderApi/quote/quoteId
	
	#Get quote belonging to serviceProvider
	https://nxtshops.com/orderApi/quote/serviceProviderId/quoteStatus/pageNo/startDate?/endDate?
	where startDate and endDate are optional parameters	

2. Bid the quote by service provider
	https://nxtshops.com/orderApi/operations/bidQuote/quoteId/serviceProviderId
	POST : JSON
	```javascript
	{
		"master":{
			"totalAmount": 800,
			"serviceCharge": 300,
			"discount": 300
		},
		"detail": [
			{
				"productId": 119,
				"productName": "DV Bellow",
				"mrp": 200,
				"serviceCharge": 300
			},
			{
				"productId": 120,
				"productName": "DV Assembly",
				"mrp": 300,
				"serviceCharge": 300
			}
		]
	}
	```
3. Reject Quote by service provider
	https://nxtshops.com/orderApi/operations/rejectQuote/quoteId/serviceProviderId

4. Accept Quote by service provider
	https://nxtshops.com/orderApi/operations/acceptQuote/quoteId/serviceProviderId

5. Complete Quote by service provider
	https://nxtshops.com/orderApi/operations/completeQuote/quoteId/serviceProviderId

Search Operations
------------------

1. Shops available within x km radius of coordinates
	https://nxtshops.com/searchApi/shop/9.230385/76.515898

2. Search for shops with product within x km radius
	https://nxtshops.com/searchApi/shop/9.230385/76.515898?searchKey=value

3. Search for products in shop
	https://nxtshops.com/searchApi/shop/1?searchKey=value

4. Find all shops within x km radius that has products from subCategoryChildId
	https://nxtshops.com/searchApi/shop/9.230385/76.515898/subCategoryChildId

5. Services available within x km radius of coordinates
	https://nxtshops.com/searchApi/service/services/9.230385/76.515898

Author : Suraj Sharma
--------------------------