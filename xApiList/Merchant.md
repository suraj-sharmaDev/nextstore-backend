1. Login Merchant
   https://nxtshops.com/merchantApi/login
   POST : JSON

   ```javascript
   {
   "email": "suraj123",
   "password": "hello"
   }
   ```

2. Get list of shops and services belonging to specific merchant
   https://nxtshops.com/merchantApi/merchant/merchId
   #merchId is id of merchant which is integer

3. Upload a bill
   https://nxtshops.com/orderApi/bills
   POST: FORMDATA

   image: FILE ----> mandatory
   orderId: INTEGER
   quoteId: INTEGER

4. Retrieve Bills
   https://nxtshops.com/orderApi/bills/@merchantId/@type/@orderQuoteId
   METHOD : GET

   @merchantId : id of merchant
   @type : either for service or order
   @orderQuoteId : based on @type provide order or quote id