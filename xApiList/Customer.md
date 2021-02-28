## API LISTS

## Shop

1. Get content of shop with shopId
   http://nxtshops.com/merchantApi/shop/shopId

2. Get products of shop with shopId, for subCategoryId
   http://nxtshops.com/merchantApi/shop/shopId/subCategoryId

## Services

1. Get All Services Categorically
   https://nxtshops.com/searchApi/service

   #Get All Services Categorically and near the user
   https://nxtshops.com/searchApi/service/services/lat/lng/categoryId?
   where categoryId is optional parameter
   e.g) https://nxtshops.com/searchApi/service/services/9.230385/76.515898

2. Get Service Item for the service Category
   https://nxtshops.com/searchApi/service/serviceItem/CategoryId

3. Get available repair and packages for service Item
   https://nxtshops.com/searchApi/service/serviceDetails/ServiceItemId

4. Get package rate for packages
   https://nxtshops.com/searchApi/service/packageRate/PackageId

5. Get Service charge and Repair Parts Rate for RepairItemId
   https://nxtshops.com/searchApi/service/repairParts/RepairItemId

## category

1. Get All Category
   http://nxtshops.com/merchantApi/category

2. Get category with Id
   http://nxtshops.com/merchantApi/category/category/categoryId

   ```

   ```

3. Get subCategory with Id
   http://nxtshops.com/merchantApi/category/subCategory/subCategoryId

4. Get subCategoryChild with Id
   http://nxtshops.com/merchantApi/category/subCategory/subCategoryId

## Cart

1. Get all items in cart for customerId
   http://nxtshops.com/customerApi/cart/customerId
   GET

2. Create cart for customer with customerId
   http://nxtshops.com/customerApi/cart/customerId
   POST : JSON
   ```javascript
   [
     {
       productId: 3,
       name: "soup",
       image: "something",
       price: 100,
       qty: 4,
     },
   ];
   ```
3. Update some of item in cart table using cartId
   http://nxtshops.com/customerApi/cart/cartId
   PUT : JSON

   ```javascript
   {
   "qty": 10
   }
   ```

4. Delete some or all items in cartTable using cartId
   http://nxtshops.com/customerApi/cart
   DELETE : JSON
   ```javascript
   [1, 2, 3];
   ```

## Order

1. Get Order Details
   http://nxtshops.com/orderApi/order/orderId

   #Get Order belonging to Customer
   https://nxtshops.com/customerApi/order/customerId/pageNo/startDate?/endDate?
   where startDate and endDate are optional parameters

2. Create New Order
   http://nxtshops.com/orderApi/order
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
   http://nxtshops.com/orderApi/order/orderId
   POST : JSON
   ```javascript
   [
     {
       productId: 3,
       productName: "soup & veg",
       price: 200,
       qty: 2,
     },
     {
       productId: 4,
       productName: "soup & veg",
       price: 200,
       qty: 2,
     },
   ];
   ```
4. Update some products in orders
   http://nxtshops.com/orderApi/order
   PUT : JSON
   //this will affect orderDetail Table
   ```javascript
   [
     {
       id: 1,
       qty: 2,
     },
     {
       id: 2,
       qty: 1,
     },
   ];
   ```
5. Delete full Order
   http://nxtshops.com/orderApi/order/orderId
   DELETE Method

6. Delete particular products in order with known id for each added products in orderDetail
   http://nxtshops.com/orderApi/order
   DELETE : JSON
   ```javascript
   [1, 2, 3];
   ```

## Payment

   <!-- After create order API and the payment has been done -->

1. Finalize Payment
   http://nxtshops.com/paymentApi/payment

   METHOD : POST

   ```javascript
    {
        "orderType" : 'order' / 'service',
        "orderQuoteId": Id of order or quote
        "totalAmount" : ??,
        "paymentMethod" : ??
        "razorpay_payment_id" : ??
        "razorpay_order_id" : ??
        "razorpay_signature" : ??
    }
   ```

## Quote

#Shops will have order and services will have quotes

1.  Get Quote Details
    https://nxtshops.com/orderApi/quote/quoteId

    #Get Quote belonging to Customer
    https://nxtshops.com/customerApi/quote/customerId/pageNo/startDate?/endDate?
    where startDate and endDate are optional parameters

2.  Post a quote by user
    https://nxtshops.com/orderApi/quote
    POST : JSON

    ## Package

        {
        		"master": {
        		"customerId": 1,
        		"deliveryAddress": {
        			"id":1,
        			"savedAs":"home",
        			"coordinate": {
        				"latitude":9.230385,
        				"longitude":76.515898
        				},
        				"houseDetail":"Anugraha",
        				"landmark":"Near Arvees"
        			},
        		"type": "package",
        		"categoryId": 1
        		},
        		"detail":[
        		{
        			"productName" : "Name of the package",
        			"json":	{
        					"PackageItemsId":1,
        					"PackageItemName":"Below 180 CC 1",
        					"PackageId":1,
        					"Active":1,
        					"Rate":950,
        					"OfferRate":600,
        					"vehicleInformation":"Model 1",
        					"deliveryTime":"12:00 PM - 3:00 PM",
        					"deliveryDate":"2021-01-15T14:08:03.585Z"
        				}
        			}
        		]
        }

    ## Repair Parts

        {
        		"master": {
        		"customerId": 1,
        		"deliveryAddress": {
        			"id":1,
        			"savedAs":"home",
        			"coordinate": {
        				"latitude":9.230385,
        				"longitude":76.515898
        				},
        				"houseDetail":"Anugraha",
        				"landmark":"Near Arvees"
        			},
        		"type": "repair",
        		"categoryId": 1
        		},
        		"detail":[
        			{
        				"productName" : "Two Wheeler",
        				"json":	{
        					"symptoms":["Oil Leaking","Low mileage","Too much engine noise"],
        					"vehicleInformation":"Model x",
        					"deliveryTime":"12:00 PM - 3:00 PM",
        					"deliveryDate":"2021-01-15T14:08:37.704Z"
        				}
        			}
        		]
        }

    ## Breakdown

        {
        		"master": {
        		"customerId": 1,
        		"deliveryAddress": {
        			"id":1,
        			"savedAs":"home",
        			"coordinate": {
        				"latitude":9.230385,
        				"longitude":76.515898
        				},
        				"houseDetail":"Anugraha",
        				"landmark":"Near Arvees"
        			},
        		"type": "repair",
        		"categoryId": 1
        		},
        		"detail":[
        			{
        				"productName" : "Breakdown Assistance",
        				"json":	{
        					"PackageItemName":"Breakdown Assistance",
        					"Description":"Some issue with car",
        					"destination":{
        						"latitude":9.177656677129272,
        						"longitude":76.55770098790526,
        						"houseDetail":"Kayamkulam - Pathanapuram Road",
        						"landmark":"Thazhavamukku Bus Stop"
        					}
        				}
        			}
        		]
        }

3.  Accept Service Provider biddings by customer
    https://nxtshops.com/orderApi/operations/acceptBid/quoteBiddingId/serviceProviderId

## Customer

1.  Initialization of customer with customerId
    https://nxtshops.com/customerApi/login/customerId
    GET

2.  Login or signup a user using mobile no.
    https://nxtshops.com/customerApi/login/
    POST : JSON
    ```javascript
    {
    	"mobile": 7907508735
    }
    ```
3.  Verify the customer
    https://nxtshops.com/customerApi/verify/
    POST : JSON
    ```javascript
    {
    	"customerId" : 1,
    	"otpCode" : "WeYM"
    }
    ```
4.  Update user information like name or mobile
    https://nxtshops.com/customerApi/login/customerId
    PUT : JSON

    ```javascript
    {
    	"name": "suraj sharma",
    	"mobile": 7907508738
    }
    ```

5.  Get address for customer
    https://nxtshops.com/customerApi/address/customerId
    GET

6.  Add new address for customer
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
7.  Update customer Address
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

8.  Delete customer Address
    https://nxtshops.com/customerApi/address/addressId
    DELETE

9.  Get favourite shops for customer
    https://nxtshops.com/customerApi/favourite/customerId
    GET

10.     Add shop as favourite

    https://nxtshops.com/customerApi/favourite/customerId/shopId
    POST

11.     Delete shop from favourite
    https://nxtshops.com/customerApi/favourite/customerId/shopId
    DELETE

## Search Operations

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

## Author : Suraj Sharma
