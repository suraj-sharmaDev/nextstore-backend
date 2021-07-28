-- [dbo].appConfig definition
CREATE TABLE [dbo].appConfig (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	baseUrl nvarchar(150) NOT NULL,
	CGST int DEFAULT 0,
	GST int DEFAULT 0,
	stdShipping int DEFAULT 0,
	stateId int DEFAULT 0,
);

-- [dbo].admin definition

CREATE TABLE [dbo].adminTable (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[username] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[password] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fcmToken nvarchar(255) NULL
);

-- [dbo].category definition

CREATE TABLE [dbo].category (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__category__3213E83F1A37568D PRIMARY KEY (id)
);


-- [dbo].customer definition

CREATE TABLE [dbo].customer (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	mobile nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fcmToken nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__customer__3213E83FA6F76262 PRIMARY KEY (id)
);

-- [dbo].verification definition

CREATE TABLE [dbo].verification (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	customerId int NOT NULL FOREIGN KEY REFERENCES customer(id),
	otpCode NVARCHAR(10) NOT NULL,
	verified bit NULL,
	[timestamp] DATETIME2 default CURRENT_TIMESTAMP
);

-- [dbo].merchant definition

-- Drop table

-- DROP TABLE [dbo].merchant GO

CREATE TABLE [dbo].merchant (
	id int IDENTITY(1,1) NOT NULL,
	firstName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	lastName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	mobile nvarchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email nvarchar(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[password] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	createdAt datetimeoffset NOT NULL,
	updatedAt datetimeoffset NOT NULL,
	CONSTRAINT PK__merchant__3213E83F68F8C78B PRIMARY KEY (id)
);


-- [dbo].orderMaster definition

-- Drop table

-- DROP TABLE [dbo].orderMaster GO

CREATE TABLE [dbo].orderMaster (
	id int IDENTITY(1,1) NOT NULL,
	customerId int NULL,
	shopId int NULL,
	[status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'unpaid',
	createdAt datetimeoffset NULL,
	deliveryAddress NVARCHAR(3000) NULL,
	CONSTRAINT PK__orderMas__3213E83F7DB14EFF PRIMARY KEY (id)
);


-- [dbo].orderDetail definition

-- Drop table

-- DROP TABLE [dbo].orderDetail GO

CREATE TABLE [dbo].orderDetail (
	id int IDENTITY(1,1) NOT NULL,
	productId int NULL,
	productName nvarchar(300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	qty int NULL,
	price int NULL,
	orderMasterId int NULL,
	CONSTRAINT PK__orderDet__3213E83F4619239D PRIMARY KEY (id),
	CONSTRAINT FK__orderDeta__order__15DA3E5D FOREIGN KEY (orderMasterId) REFERENCES [dbo].orderMaster(id)
);

-- [dbo].cartMaster definition

-- Drop table

-- DROP TABLE [dbo].cartMaster GO

CREATE TABLE [dbo].cartMaster (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	customerId int NULL FOREIGN KEY REFERENCES customer(id) ON DELETE SET NULL,
	shopId int NULL FOREIGN KEY REFERENCES shop(id) ON DELETE SET NULL,
	[status] bit DEFAULT 0,
	createdAt datetimeoffset DEFAULT CURRENT_TIMESTAMP
);

-- [dbo].cart definition

-- Drop table

-- DROP TABLE [dbo].cart GO

CREATE TABLE [dbo].cartDetail (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	productId int NULL,
	name nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[image] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	price int NULL,
	qty int NULL,
	cartMasterId int FOREIGN KEY REFERENCES cartMaster(id)
);


-- [dbo].customerAddress definition

-- Drop table

-- DROP TABLE [dbo].customerAddress GO

CREATE TABLE [dbo].customerAddress (
	id int IDENTITY(1,1) NOT NULL,
	label nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	addressName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	landmark nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	latitude float NULL,
	longitude float NULL,
	reverseAddress nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	customerId int NULL,
	CONSTRAINT PK__customer__3213E83FFEE64773 PRIMARY KEY (id),
	CONSTRAINT FK__customerA__custo__0A9D95DB FOREIGN KEY (customerId) REFERENCES [dbo].customer(id) ON DELETE SET NULL
);

-- [dbo].shop definition

-- Drop table

-- DROP TABLE [dbo].shop GO

CREATE TABLE [dbo].shop (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	onlineStatus bit DEFAULT 1,
	fcmToken nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	coverage int NULL,
	merchantId int NULL,
	[image] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	rating int DEFAULT 0,
	CONSTRAINT PK__shop__3213E83FAF52DF09 PRIMARY KEY (id),
	CONSTRAINT FK__shop__merchantId__0B5CAFEA FOREIGN KEY (merchantId) REFERENCES [dbo].merchant(id) ON DELETE SET NULL
);

-- [dbo].serviceProvider definition

-- Drop table

-- DROP TABLE [dbo].serviceProvider GO

CREATE TABLE [dbo].serviceProvider (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	name nvarchar(255) NULL,
	categoryId int NULL FOREIGN KEY REFERENCES nxtServiceCategory(CategoryId) ON DELETE SET NULL,
	onlineStatus bit DEFAULT 1,
	fcmToken nvarchar(255) NULL,
	coverage int NULL,
	merchantId int NULL FOREIGN KEY REFERENCES merchant(id) ON DELETE SET NULL,
	[image] nvarchar(100) NULL,
	rating int DEFAULT 0
);

-- [dbo].favourite definition

CREATE TABLE [dbo].favourite (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	customerId int NULL FOREIGN KEY REFERENCES customer(id),
	shopId int NULL FOREIGN KEY REFERENCES shop(id),
	[timestamp] DATETIME default CURRENT_TIMESTAMP
);

-- [dbo].shopAddress definition

-- Drop table

-- DROP TABLE [dbo].shopAddress GO

CREATE TABLE [dbo].shopAddress (
	id int IDENTITY(1,1) NOT NULL,
	pickupAddress nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	latitude float NULL,
	longitude float NULL,
	shopId int NULL,
	CONSTRAINT PK__shopAddr__3213E83F70869032 PRIMARY KEY (id),
	CONSTRAINT FK__shopAddre__shopI__0E391C95 FOREIGN KEY (shopId) REFERENCES [dbo].shop(id)
);

-- [dbo].serviceProviderAddress definition

-- Drop table

-- DROP TABLE [dbo].serviceProviderAddress GO

CREATE TABLE [dbo].serviceProviderAddress (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	pickupAddress nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	latitude float NULL,
	longitude float NULL,
	serviceProviderId int NULL FOREIGN KEY REFERENCES [dbo].serviceProvider(id)
);

-- [dbo].subCategory definition

-- Drop table

-- DROP TABLE [dbo].subCategory GO

CREATE TABLE [dbo].subCategory (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	categoryId int NULL,
	CONSTRAINT PK__subCateg__3213E83F7CAB3994 PRIMARY KEY (id),
	CONSTRAINT FK__subCatego__categ__18B6AB08 FOREIGN KEY (categoryId) REFERENCES [dbo].category(id)
);


-- [dbo].subCategoryChild definition

-- Drop table

-- DROP TABLE [dbo].subCategoryChild GO

CREATE TABLE [dbo].subCategoryChild (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	subCategoryId int NULL,
	CONSTRAINT PK__subCateg__3213E83F94F8A0C7 PRIMARY KEY (id),
	CONSTRAINT FK__subCatego__subCa__1B9317B3 FOREIGN KEY (subCategoryId) REFERENCES [dbo].subCategory(id)
);


-- [dbo].productMaster definition

-- Drop table

-- DROP TABLE [dbo].productMaster GO

CREATE TABLE [dbo].productMaster (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[image] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bigImage1] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bigImage2] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bigImage3] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bigImage4] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bigImage5] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bigImage6] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,	
	subCategoryChildId int NULL,
	CONSTRAINT PK__productM__3213E83FBAAA4E7D PRIMARY KEY (id),
	CONSTRAINT FK__productMa__subCa__1E6F845E FOREIGN KEY (subCategoryChildId) REFERENCES [dbo].subCategoryChild(id)
);


-- [dbo].product1 definition

-- Drop table

-- DROP TABLE [dbo].product1 GO

CREATE TABLE [dbo].product1 (
	id int IDENTITY(1,1) NOT NULL,
	mrp float NULL,
	price float NULL,
	shopId int NULL,
	productMasterId int NULL,
	stock int DEFAULT 1,
	CONSTRAINT PK__product__3213E83F16B61479 PRIMARY KEY (id),
	CONSTRAINT FK__product__product__22401542 FOREIGN KEY (productMasterId) REFERENCES [dbo].productMaster(id),
	CONSTRAINT FK__product__shopId__214BF109 FOREIGN KEY (shopId) REFERENCES [dbo].shop(id)
);

-- [dbo].recommendedProducts definition
CREATE TABLE [dbo].recommendedProducts (
	id int IDENTITY(1,1) NOT NULL,
	shopId int NOT NULL FOREIGN KEY REFERENCES shop(id),
	productId int NOT NULL,
	[count] int DEFAULT 1
);

-- [dbo].offers definition

CREATE TABLE [dbo].offers (
	id int IDENTITY(1,1) NOT NULL,
	offer_name varchar(15) NOT NULL,
	offer_image varchar(40) NOT NULL,
	offer_type varchar(20) NOT NULL,
	createdAt datetime default CURRENT_TIMESTAMP
);

-- [dbo].shopOffers definition

CREATE TABLE [dbo].shopOffers (
	id int IDENTITY(1,1) NOT NULL,
	shopId int NOT NULL FOREIGN KEY REFERENCES shop(id),
	offer_image varchar(100) NOT NULL,
	createdAt datetime default CURRENT_TIMESTAMP
);

-- [dbo].coupons definition

CREATE TABLE [dbo].coupons (
  id int IDENTITY(1,1) PRIMARY KEY,
  coupon_code varchar(12) NULL,
  max_use_count int NOT NULL,
  discount_percentage int NOT NULL,
  min_order_amount int,
  max_discount_amount int
);

-- [dbo].notifications definition

CREATE TABLE [dbo].notifications (
  id int IDENTITY(1,1) PRIMARY KEY,
  sender_category varchar(15) NOT NULL,
  receiver_category varchar(15) NOT NULL,
  sender_id int NOT NULL,
  receiver_id int NOT NULL,
  notification_type varchar(50) NOT NULL,
  notification_data TEXT DEFAULT NULL,
  received_status bit null,  
  createdAt datetimeoffset NULL
);

-- [dbo].quoteMaster definition

-- Drop table

-- DROP TABLE [dbo].quoteMaster GO

CREATE TABLE [dbo].quoteMaster (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	customerId int NULL,
	[status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'unpaid', --can be pending, accepted, rejected or completed
	[type] NVARCHAR(30) NULL,	--can be repair or package
	categoryId INT NULL,
	[image] NVARCHAR(100) NULL, --if type is image then file url, used for storing bill image,	
	deliveryAddress NVARCHAR(250) NULL,
	createdAt datetimeoffset NULL
);


-- [dbo].quoteDetail definition

-- Drop table

-- DROP TABLE [dbo].quoteDetail GO

-- This table is filled by user
CREATE TABLE [dbo].quoteDetail (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	productId int NULL,
	productName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[json] NVARCHAR(1000) NULL, --this can be json data or text
	remark NVARCHAR(500) NULL, -- this is user given comments
	[image] NVARCHAR(100) NULL, --if type is image then file url, used for storing user request	
	quoteMasterId int NULL FOREIGN KEY REFERENCES [dbo].quoteMaster(id)
);

-- [dbo].quotedServiceProviders definition

-- Drop table

-- DROP TABLE [dbo].quotedServiceProviders GO

CREATE TABLE [dbo].quotedServiceProviders (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	serviceProviderId int NULL FOREIGN KEY REFERENCES serviceProvider(id),
	quoteMasterId int NULL FOREIGN KEY REFERENCES [dbo].quoteMaster(id),
	[status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'pending', --can be pending, rejected or accepted
	createdAt datetimeoffset NULL
);

--- when merchant accpets above then he call bid
-- customer can accept the bids
CREATE TABLE [dbo].quotationBiddings (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	serviceProviderId int NULL FOREIGN KEY REFERENCES serviceProvider(id),
	quoteMasterId int NULL FOREIGN KEY REFERENCES [dbo].quoteMaster(id),
	[status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'pending',  -- can be pending, rejected or accepted
	[json] NVARCHAR(1000) NULL,
	createdAt datetimeoffset NULL
);

---Merchant can store their bill image in the server
-- this is just optional table in case
CREATE TABLE [dbo].nxtBillDetails (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	merchantId int DEFAULT NULL,	
	orderId int DEFAULT NULL,	
	quoteId int DEFAULT NULL,
	[image] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	createdAt datetimeoffset NULL
);

---------Payment Tables -------------

---------Order Payment Table---------
CREATE TABLE [dbo].payments (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	orderId int DEFAULT NULL,	
	quoteId int DEFAULT NULL,
	totalAmount int NOT NULL,
	paymentMethod varchar(100) DEFAULT 'COD',
	razorpay_payment_id NVARCHAR(100),
	razorpay_order_id NVARCHAR(100),
	razorpay_signature NVARCHAR(255),
	remarks NVARCHAR(255) DEFAULT NULL,
	createdAt datetimeoffset NULL	
);


----------Wallets--------------
CREATE TABLE [dbo].wallet (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	customerId int FOREIGN KEY REFERENCES customer(id),
	walletAmount int NOT NULL,
	createdAt datetimeoffset NULL		
);