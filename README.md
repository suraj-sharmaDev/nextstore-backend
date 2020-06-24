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

procedures folder contains tsql, support for the api.
(The initialization of this folder files is required)

The database mandatory is sql server v. 2019

-------------------------
API LISTS
----------

merchant
--------

1. create Merchant
	127.0.0.1:3001/merchant
	POST : JSON
	{
	"firstName": "suraj",
	"lastName": "sharma",
	"mobile": 7907508735
	}

2. update Merchant
	127.0.0.1:3001/merchant/merchId
	PUT : JSON

Shop
----

# Get content of shop with shopId
	http://127.0.0.1:3001/shop/shopId

# Get products of shop with shopId, for subCategoryId
	http://127.0.0.1:3001/shop/shopId/subCategoryId

3. Create Shop
	127.0.0.1:3001/shop/merchId
	POST : JSON
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

4. Update Shop
	127.0.0.1:3001/shop/shopId
	PUT : JSON
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

category
--------

# Get All Category
	http://127.0.0.1:3001/category

# Get category with Id
	http://127.0.0.1:3001/category/category/categoryId

5. Create Category
	127.0.0.1:3001/category
	POST : JSON
	{
	  "name":"Vegetables"
	}	

6. Update Category
	127.0.0.1:3001/category/category/categoryId
	POST : JSON
	{
	  "name":"Vegetables!"
	}		

# Get subCategory with Id
	http://127.0.0.1:3001/category/subCategory/subCategoryId

7. Create SubCategory
	127.0.0.1:3000/category/subCategory
	PUT : JSON
	{
	  "name":"Vegetables",
	  "categoryId" : 1
	}	

8. Update SubCategory
	127.0.0.1:3001/category/subCategory/subCategoryId
	PUT : JSON
	{
	  "name":"Vegetables!"
	}

# Get subCategoryChild with Id
	http://127.0.0.1:3001/category/subCategory/subCategoryId

9. Create SubCategoryChild
	127.0.0.1:3001/category/subCategoryChild
	POST : JSON
	{
	  "name":"Vegetables",
	  "subCategoryId" : 1
	}	

10. Update Category
	127.0.0.1:3001/category/subCategoryChild/subCategoryChildId
	PUT : JSON
	{
	  "name":"Vegetables!"
	}	

Product
---------

11. Get product
	http://127.0.0.1:3001/product/shopId

12. Create product
	http://127.0.0.1:3001/product/shopId
	POST : JSON
	{
		"mrp" : 200			//mrp should be greater than or equal to price
		"price" : 200,
		"productMasterId" : 1
	}	

13. Update product
	http://127.0.0.1:3001/product/shopId/productId
	PUT : JSON
	{
		"price" : 200,
		"productMasterId" : 1
	}	

Order
--------

14. Get Order Details
	http://127.0.0.1:3002/order/orderId

15. Create New Order
	http://127.0.0.1:3002/order
	POST : JSON
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

16. Add orders to existent Order
	http://127.0.0.1:3002/order/orderId
	POST : JSON
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

17. Update some products in orders
	http://127.0.0.1:3002/order
	PUT : JSON
	//this will affect orderDetail Table
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

18. Delete full Order
	http://127.0.0.1:3002/order/orderId
	DELETE Method

19. Delete particular products in order with known id for each added products in orderDetail
	http://127.0.0.1:3002/order
	DELETE : JSON
	[1,2,3]

# Accept order
	http://127.0.0.1:3002/operations/acceptOrder/orderId

#Reject Order
	http://127.0.0.1:3002/operations/rejectOrder/orderId

Customer
--------
# Initialization of customer with customerId
	http://127.0.0.1:3000/login/customerId
	GET

20. Login or signup a user using mobile no.
	http://127.0.0.1:3000/login/
	POST : JSON
	{
		"mobile": 7907508735
	}

21. Update user information like name or mobile
	http://127.0.0.1:3000/login/customerId
	PUT : JSON
	{
		"name": "suraj sharma",
		"mobile": 7907508738
	}

22. Get address for customer 
	http://127.0.0.1:3000/address/customerId
	GET

23. Add new address for customer
	http://127.0.0.1:3000/address/
	POST : JSON
	{
	  "label":"home",
	  "addressName": "Anugraha",
	  "landmark": "Near Arvees",
	  "latitude": 9.230385,
	  "longitude": 76.515898,
	  "customerId" : 1
	}
24. Update customer Address
	http://127.0.0.1:3000/address/addressId
	PUT : JSON
	{
	  "addressName": "Anugraha",
	  "landmark": "Near Arvees!!!",
	  "latitude": 9.230385,
	  "longitude": 76.515898
	}


Search Operations
------------------

26. Shops available within x km radius of coordinates
	http://127.0.0.1:3003/shop/9.230385/76.515898

25. Search for shops with product within x km radius
	http://127.0.0.1:3003/shop/9.230385/76.515898?searchKey=value

26. Search for products in shop
	http://127.0.0.1:3003/shop/1?searchKey=value

Author : Suraj Sharma
--------------------------