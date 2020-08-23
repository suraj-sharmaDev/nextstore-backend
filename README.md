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

127.0.0.1:3000 : 35.230.117.116/customerApi

127.0.0.1:3001 : 35.230.117.116/merchantApi

127.0.0.1:3002 : 35.230.117.116/orderApi

127.0.0.1:3003 : 35.230.117.116/searchApi

-------------------------
API LISTS
----------

merchant
--------

1. create Merchant
	35.230.117.116/merchantApi/merchant
	POST : JSON
	{
	"firstName": "suraj",
	"lastName": "sharma",
	"mobile": 7907508735
	}

2. update Merchant
	35.230.117.116/merchantApi/merchant/merchId
	PUT : JSON

Shop
----

1. Get content of shop with shopId
	http://35.230.117.116/merchantApi/shop/shopId

2. Get products of shop with shopId, for subCategoryId
	http://35.230.117.116/merchantApi/shop/shopId/subCategoryId

3. Create Shop
	35.230.117.116/merchantApi/shop/merchId
	POST : JSON
	```javascript
	{
	  "name":"Kirana",
	  "category":"wholesale",
	  "coverage": 8,
	  "address":{
	    "pickupAddress": "Near mavelikkara junction",
	    "latitude": 8.230385,
	    "longitude": 76.515898
	  }
	}
	```
4. Update Shop
	35.230.117.116/merchantApi/shop/shopId
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
category
--------

1. Get All Category
	http://35.230.117.116/merchantApi/category

2. Get category with Id
	http://35.230.117.116/merchantApi/category/category/categoryId

3. Create Category
	35.230.117.116/merchantApi/category
	POST : JSON
	```javascript
	{
	  "name":"Vegetables"
	}	
	```
4. Update Category
	35.230.117.116/merchantApi/category/category/categoryId
	POST : JSON
	```javascript
	{
	  "name":"Vegetables!"
	}		
	```
5. Get subCategory with Id
	http://35.230.117.116/merchantApi/category/subCategory/subCategoryId

6. Create SubCategory
	35.230.117.116/customerApi/category/subCategory
	PUT : JSON
	```javascript
	{
	  "name":"Vegetables",
	  "categoryId" : 1
	}	
	```
7. Update SubCategory
	35.230.117.116/merchantApi/category/subCategory/subCategoryId
	PUT : JSON
	```javascript
	{
	  "name":"Vegetables!"
	}
	```

8. Get subCategoryChild with Id
	http://35.230.117.116/merchantApi/category/subCategory/subCategoryId

9. Create SubCategoryChild
	35.230.117.116/merchantApi/category/subCategoryChild
	```javascript
	POST : JSON
	{
	  "name":"Vegetables",
	  "subCategoryId" : 1
	}	
	```
10. Update Category
	35.230.117.116/merchantApi/category/subCategoryChild/subCategoryChildId
	PUT : JSON
	```javascript
	{
	  "name":"Vegetables!"
	}	
	```

Product
---------

1. Create product
	http://35.230.117.116/merchantApi/product/shopId
	POST : JSON
	```javascript
	{
		"mrp" : 200			//mrp should be greater than or equal to price
		"price" : 200,
		"productMasterId" : 1
	}	
	```

2. Update product
	http://35.230.117.116/merchantApi/product/shopId/productId
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
   http://35.230.117.116/customerApi/cart/customerId
   GET

2. Create cart for customer with customerId
	http://35.230.117.116/customerApi/cart
	POST : JSON
	```javascript
	{
	"master":{
		"shopId": 1,
		"customerId": 1
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
   http://35.230.117.116/customerApi/cart/customerId/shopId
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
   http://35.230.117.116/customerApi/cart/customerId/shopId
   DELETE : JSON
   ```javascript
	[1, 2, 3]
   ```
   
Order
--------

1. Get Order Details
	http://35.230.117.116/orderApi/order/orderId

2. Create New Order
	http://35.230.117.116/orderApi/order
	POST : JSON
	```javascript
	{
	  "master": {
		"customerId": 1,
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
	http://35.230.117.116/orderApi/order/orderId
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
	http://35.230.117.116/orderApi/order
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
	http://35.230.117.116/orderApi/order/orderId
	DELETE Method

6. Delete particular products in order with known id for each added products in orderDetail
	http://35.230.117.116/orderApi/order
	DELETE : JSON
	```javascript
	[1,2,3]
	```
7. Accept order
	http://35.230.117.116/orderApi/operations/acceptOrder/orderId

8. Reject Order
	http://35.230.117.116/orderApi/operations/rejectOrder/orderId

Customer
--------

1. Initialization of customer with customerId
	http://35.230.117.116/customerApi/login/customerId
	GET

2. Login or signup a user using mobile no.
	http://35.230.117.116/customerApi/login/
	POST : JSON
	```javascript
	{
		"mobile": 7907508735
	}
	```
2. Verify the customer
	http://35.230.117.116/customerApi/verify/
	POST : JSON
	```javascript
	{
		"customerId" : 1,
		"otpCode" : "WeYM"
	}
	```	
3. Update user information like name or mobile
	http://35.230.117.116/customerApi/login/customerId
	PUT : JSON
	```javascript
	{
		"name": "suraj sharma",
		"mobile": 7907508738
	}
	```

4. Get address for customer 
	http://35.230.117.116/customerApi/address/customerId
	GET

5. Add new address for customer
	http://35.230.117.116/customerApi/address/
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
	http://35.230.117.116/customerApi/address/addressId
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
	http://35.230.117.116/customerApi/address/addressId
	DELETE

8. Get favourite shops for customer
	http://35.230.117.116/customerApi/favourite/customerId
	GET

9. 	Add shop as favourite
	http://35.230.117.116/customerApi/favourite/customerId/shopId
	POST

Search Operations
------------------

1. Shops available within x km radius of coordinates
	http://35.230.117.116/searchApi/shop/9.230385/76.515898

2. Search for shops with product within x km radius
	http://35.230.117.116/searchApi/shop/9.230385/76.515898?searchKey=value

3. Search for products in shop
	http://35.230.117.116/searchApi/shop/1?searchKey=value

4. Find all shops within x km radius that has products from subCategoryChildId
	http://35.230.117.116/searchApi/shop/9.230385/76.515898/subCategoryChildId

Author : Suraj Sharma
--------------------------