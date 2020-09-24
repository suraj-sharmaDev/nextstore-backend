# nextstore-backend
Complete backend for nextstore

<h3>This is completed backend for nextstore project</h3>
The server is modularized as customer which contains all api for customer interface,
merchant which contains all apis for shop, products, categories, subcategories, subcategorychild
and merchant himself.
There is module for server which contains api for all order related actions.
For search and seek related operations we have microservice in folder search
<h5>Customer server runs in port 3000</h5>
<h5>Merchant server runs in port 3001</h5>
<h5>Order server runs in port 3002</h5>
<h5>Search server runs in port 3003</h5>

<h3>Setup</h3>
The dependency of project is
1. express
2. mysql2
3. tedious
4. sequelize
5. firebase-admin
6. multer

The configuration for database is in sub folder config/config.jsom
There are three flavours of configuration namely development, test, production.

The configuration for firebase i.e service_acount.json should be inside config folder 
named as nextstore-firebase.json (required) || (not included)

The configuration for nginx server is in file xConf/nginx_conf.txt
	-follow the instructions

All the api request are saved in collection[Postman] in folder xConf/collections_nginx.json

procedures folder contains tsql, support for the api.
(The initialization of this folder files is required)

The database mandatory is sql server v. 2019

Local Server to nginx map
=========================

127.0.0.1:3000 : nxtshops.com/customerApi

127.0.0.1:3001 : nxtshops.com/merchantApi

127.0.0.1:3002 : nxtshops.com/orderApi

127.0.0.1:3003 : nxtshops.com/searchApi

-------------------------
API LISTS
----------

merchant
--------

1. create Merchant
	nxtshops.com/merchantApi/merchant
	POST : JSON
	{
	"firstName": "suraj",
	"lastName": "sharma",
	"mobile": 7907508735
	}

2. update Merchant
	nxtshops.com/merchantApi/merchant/merchId
	PUT : JSON

3. Login Merchant
	nxtshops.com/merchantApi/login
	POST : JSON
	{
	"email": "suraj@gmail.com",
	"password": "hello"
	}


Shop
----

1. Get content of shop with shopId
	https://nxtshops.com/merchantApi/shop/shopId

	To get basic shopInfo
	https://nxtshops.com/merchantApi/shop/shopId/basic

2. Get products of shop with shopId, for subCategoryId
	https://nxtshops.com/merchantApi/shop/shopId/subCategoryId

3. Create Shop
	nxtshops.com/merchantApi/shop/merchId
	POST : FORMDATA

		type => shop
		
		json => {"shop":{"name":"arvees","onlineStatus":0},"address":{"pickupAddress":"Nearmavelikkarajunction","latitude":9.230385,"longitude":76.515898}}

		image => TYPE_FILE

4. Update Shop
	nxtshops.com/merchantApi/shop/merchId/shopId
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

category
--------

1. Get All Category
	https://nxtshops.com/merchantApi/category

2. Get category with Id
	https://nxtshops.com/merchantApi/category/category/categoryId

3. Create Category
	nxtshops.com/merchantApi/category
	POST : JSON
	```javascript
	{
	  "name":"Vegetables"
	}	
	```
4. Update Category
	nxtshops.com/merchantApi/category/category/categoryId
	POST : JSON
	```javascript
	{
	  "name":"Vegetables!"
	}		
	```
5. Get subCategory with Id
	https://nxtshops.com/merchantApi/category/subCategory/subCategoryId

6. Create SubCategory
	nxtshops.com/customerApi/category/subCategory
	PUT : JSON
	```javascript
	{
	  "name":"Vegetables",
	  "categoryId" : 1
	}	
	```
7. Update SubCategory
	nxtshops.com/merchantApi/category/subCategory/subCategoryId
	PUT : JSON
	```javascript
	{
	  "name":"Vegetables!"
	}
	```

8. Get subCategoryChild with Id
	https://nxtshops.com/merchantApi/category/subCategory/subCategoryId

9. Create SubCategoryChild
	nxtshops.com/merchantApi/category/subCategoryChild
	```javascript
	POST : JSON
	{
	  "name":"Vegetables",
	  "subCategoryId" : 1
	}	
	```
10. Update Category
	nxtshops.com/merchantApi/category/subCategoryChild/subCategoryChildId
	PUT : JSON
	```javascript
	{
	  "name":"Vegetables!"
	}	
	```

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
	https://nxtshops.com/merchantApi/product?searchTerm=keyword

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

Cart
-------
1. Get all items in cart for customerId
   https://nxtshops.com/customerApi/cart/customerId
   GET

2. Create cart for customer with customerId
	https://nxtshops.com/customerApi/cart
	POST : JSON
	```javascript
	{
	"master":{
		"shopId": 2,
		"customerId": 1,
		"prevShopId": 1 //this is optional, needed only if to replace cartItems from other shop
	},
	"detail": [
		{
		"productId": 3,
		"name": "soup",
		"image": "something",
		"price": 100,
		"qty": 4
		},
		{
		"productId": 4,
		"name": "soup",
		"image": "something",
		"price": 100,
		"qty": 4
		}    
	]
	}
	```
3. Update some of item in cart table using cartId
   https://nxtshops.com/customerApi/cart/customerId/shopId
   PUT : JSON
   ```javascript
	[
	{
		"productId" : 1,
		"qty" : 1
	},
	{
		"productId" : 2,
		"qty" : 2
	}  
	]
   ```

4. Delete some or all items in cartTable using productId
   https://nxtshops.com/customerApi/cart/customerId/shopId
   DELETE : JSON
   ```javascript
	[1, 2, 3]
   ```
   
Order
--------

1. Get Order Details
	https://nxtshops.com/orderApi/order/orderId

	#Get Order belonging to shop
	https://nxtshops.com/orderApi/order/shopId/orderStatus/pageNo/startDate?/endDate?
	where startDate and endDate are optional parameters

2. Create New Order
	https://nxtshops.com/orderApi/order
	POST : JSON
	```javascript
	{
	  "master": {
		"customerId": 1,
		"deliveryAddress": "{\"latitude\": 9.0, \"longitude\": 72.0}",
		"shopId": 1
	  },
	  "detail":[
	    {
			"productId": 1,
			"productName" : "soup",
			"price": 200,
		    "qty": 2
	    },
	    {
			"productId": 2,
			"productName" : "noodles",
			"price": 200,
		    "qty": 2
	    }    
	   ]
	}
	```
3. Add orders to existent Order
	https://nxtshops.com/orderApi/order/orderId
	POST : JSON
	```javascript
	[
	  {
		"productId": 3,
		"productName" : "soup & veg",
		"price": 200,
		"qty": 2
	  },
	  {
		"productId": 4,
		"productName" : "soup & veg",
		"price": 200,
		"qty": 2
	  }	  
	]
	```
4. Update some products in orders
	https://nxtshops.com/orderApi/order
	PUT : JSON
	//this will affect orderDetail Table
	```javascript
	[
	  {
	    "id" : 1,
	    "qty" : 2
	  },
	  {
	    "id" : 2,
	    "qty" : 1
	  }
	]
	```
5. Delete full Order
	https://nxtshops.com/orderApi/order/orderId
	DELETE Method

6. Delete particular products in order with known id for each added products in orderDetail
	https://nxtshops.com/orderApi/order
	DELETE : JSON
	```javascript
	[1,2,3]
	```
7. Accept order
	https://nxtshops.com/orderApi/operations/acceptOrder/orderId

8. Reject Order
	https://nxtshops.com/orderApi/operations/rejectOrder/orderId

Quote
--------
#Shops will have order and services will have quotes

1. Get Quote Details
	https://nxtshops.com/orderApi/quote/quoteId

2. Post a quote by user
	https://nxtshops.com/orderApi/quote
	POST : JSON
	```javascript
	{
	"master": {
		"customerId": 1,
		"deliveryAddress": "{\"latitude\": 9.230385, \"longitude\": 76.515898}",
		"type": "repair",
		"categoryId": 1
	},
	"detail":[
		{
			"productId": 119,
			"productName" : "DV Bellow"
		},
		{
			"productId": 120,
			"productName" : "DV Assembly"
		}    
	]
	}	
	```
3. Bid the quote by service provider
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
4. Reject Quote by service provider
	https://nxtshops.com/orderApi/operations/rejectQuote/quoteId/serviceProviderId

5. Accept Service Provider biddings by customer
	https://nxtshops.com/orderApi/operations/acceptQuote/quoteBiddingId/serviceProviderId

Customer
--------

1. Initialization of customer with customerId
	https://nxtshops.com/customerApi/login/customerId
	GET

2. Login or signup a user using mobile no.
	https://nxtshops.com/customerApi/login/
	POST : JSON
	```javascript
	{
		"mobile": 7907508735
	}
	```
2. Verify the customer
	https://nxtshops.com/customerApi/verify/
	POST : JSON
	```javascript
	{
		"customerId" : 1,
		"otpCode" : "WeYM"
	}
	```	
3. Update user information like name or mobile
	https://nxtshops.com/customerApi/login/customerId
	PUT : JSON
	```javascript
	{
		"name": "suraj sharma",
		"mobile": 7907508738
	}
	```

4. Get address for customer 
	https://nxtshops.com/customerApi/address/customerId
	GET

5. Add new address for customer
	https://nxtshops.com/customerApi/address/
	POST : JSON
	```javascript
	{
	  "label":"home",
	  "addressName": "Anugraha",
	  "landmark": "Near Arvees",
	  "latitude": 9.230385,
	  "longitude": 76.515898,
	  "customerId" : 1
	}
	```
6. Update customer Address
	https://nxtshops.com/customerApi/address/addressId
	PUT : JSON
	```javascript
	{
	  "addressName": "Anugraha",
	  "landmark": "Near Arvees!!!",
	  "latitude": 9.230385,
	  "longitude": 76.515898
	}
	```

7. Delete customer Address
	https://nxtshops.com/customerApi/address/addressId
	DELETE

8. Get favourite shops for customer
	https://nxtshops.com/customerApi/favourite/customerId
	GET

9. 	Add shop as favourite
	https://nxtshops.com/customerApi/favourite/customerId/shopId
	POST

9. 	Delete shop from favourite
	https://nxtshops.com/customerApi/favourite/customerId/shopId
	DELETE

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