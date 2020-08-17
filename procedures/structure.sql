-- nextstore.dbo.appConfig definition
CREATE TABLE nextstore.dbo.appConfig (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	baseUrl nvarchar(150) NOT NULL,
	CGST int DEFAULT 0,
	GST int DEFAULT 0,
	stdShipping int DEFAULT 0,
	stateId int DEFAULT 0
);

-- nextstore.dbo.category definition

CREATE TABLE nextstore.dbo.category (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__category__3213E83F1A37568D PRIMARY KEY (id)
);


-- nextstore.dbo.customer definition

CREATE TABLE nextstore.dbo.customer (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	mobile nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fcmToken nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__customer__3213E83FA6F76262 PRIMARY KEY (id)
);

-- nextstore.dbo.verification definition

CREATE TABLE nextstore.dbo.verification (
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	customerId int NOT NULL FOREIGN KEY REFERENCES customer(id),
	otpCode NVARCHAR(10) NOT NULL,
	verified bit NULL,
	[timestamp] DATETIME2 default CURRENT_TIMESTAMP
);

-- nextstore.dbo.merchant definition

-- Drop table

-- DROP TABLE nextstore.dbo.merchant GO

CREATE TABLE nextstore.dbo.merchant (
	id int IDENTITY(1,1) NOT NULL,
	firstName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	lastName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	mobile nvarchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	createdAt datetimeoffset NOT NULL,
	updatedAt datetimeoffset NOT NULL,
	CONSTRAINT PK__merchant__3213E83F68F8C78B PRIMARY KEY (id)
);


-- nextstore.dbo.orderMaster definition

-- Drop table

-- DROP TABLE nextstore.dbo.orderMaster GO

CREATE TABLE nextstore.dbo.orderMaster (
	id int IDENTITY(1,1) NOT NULL,
	customerId int NULL,
	shopId int NULL,
	status nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	createdAt datetimeoffset NULL,
	CONSTRAINT PK__orderMas__3213E83F7DB14EFF PRIMARY KEY (id)
);


-- nextstore.dbo.cart definition

-- Drop table

-- DROP TABLE nextstore.dbo.cart GO

CREATE TABLE nextstore.dbo.cart (
	id int IDENTITY(1,1) NOT NULL,
	productId int NULL,
	name nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[image] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	price int NULL,
	qty int NULL,
	customerId int NULL,
	CONSTRAINT PK__cart__3213E83FB0A13225 PRIMARY KEY (id),
	CONSTRAINT FK__cart__customerId__0D7A0286 FOREIGN KEY (customerId) REFERENCES nextstore.dbo.customer(id) ON DELETE SET NULL
);


-- nextstore.dbo.customerAddress definition

-- Drop table

-- DROP TABLE nextstore.dbo.customerAddress GO

CREATE TABLE nextstore.dbo.customerAddress (
	id int IDENTITY(1,1) NOT NULL,
	label nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	addressName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	landmark nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	latitude float NULL,
	longitude float NULL,
	reverseAddress nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	customerId int NULL,
	CONSTRAINT PK__customer__3213E83FFEE64773 PRIMARY KEY (id),
	CONSTRAINT FK__customerA__custo__0A9D95DB FOREIGN KEY (customerId) REFERENCES nextstore.dbo.customer(id) ON DELETE SET NULL
);


-- nextstore.dbo.orderDetail definition

-- Drop table

-- DROP TABLE nextstore.dbo.orderDetail GO

CREATE TABLE nextstore.dbo.orderDetail (
	id int IDENTITY(1,1) NOT NULL,
	productId int NULL,
	productName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	qty int NULL,
	price int NULL,
	orderMasterId int NULL,
	CONSTRAINT PK__orderDet__3213E83F4619239D PRIMARY KEY (id),
	CONSTRAINT FK__orderDeta__order__15DA3E5D FOREIGN KEY (orderMasterId) REFERENCES nextstore.dbo.orderMaster(id)
);


-- nextstore.dbo.shop definition

-- Drop table

-- DROP TABLE nextstore.dbo.shop GO

CREATE TABLE nextstore.dbo.shop (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	category nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	onlineStatus bit NULL,
	fcmToken nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	coverage int NULL,
	merchantId int NULL,
	[image] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__shop__3213E83FAF52DF09 PRIMARY KEY (id),
	CONSTRAINT FK__shop__merchantId__0B5CAFEA FOREIGN KEY (merchantId) REFERENCES nextstore.dbo.merchant(id) ON DELETE SET NULL
);


-- nextstore.dbo.shopAddress definition

-- Drop table

-- DROP TABLE nextstore.dbo.shopAddress GO

CREATE TABLE nextstore.dbo.shopAddress (
	id int IDENTITY(1,1) NOT NULL,
	pickupAddress nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	latitude float NULL,
	longitude float NULL,
	shopId int NULL,
	CONSTRAINT PK__shopAddr__3213E83F70869032 PRIMARY KEY (id),
	CONSTRAINT FK__shopAddre__shopI__0E391C95 FOREIGN KEY (shopId) REFERENCES nextstore.dbo.shop(id)
);


-- nextstore.dbo.subCategory definition

-- Drop table

-- DROP TABLE nextstore.dbo.subCategory GO

CREATE TABLE nextstore.dbo.subCategory (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	categoryId int NULL,
	CONSTRAINT PK__subCateg__3213E83F7CAB3994 PRIMARY KEY (id),
	CONSTRAINT FK__subCatego__categ__18B6AB08 FOREIGN KEY (categoryId) REFERENCES nextstore.dbo.category(id)
);


-- nextstore.dbo.subCategoryChild definition

-- Drop table

-- DROP TABLE nextstore.dbo.subCategoryChild GO

CREATE TABLE nextstore.dbo.subCategoryChild (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	subCategoryId int NULL,
	CONSTRAINT PK__subCateg__3213E83F94F8A0C7 PRIMARY KEY (id),
	CONSTRAINT FK__subCatego__subCa__1B9317B3 FOREIGN KEY (subCategoryId) REFERENCES nextstore.dbo.subCategory(id)
);


-- nextstore.dbo.productMaster definition

-- Drop table

-- DROP TABLE nextstore.dbo.productMaster GO

CREATE TABLE nextstore.dbo.productMaster (
	id int IDENTITY(1,1) NOT NULL,
	name nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[image] nvarchar(180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	subCategoryChildId int NULL,
	CONSTRAINT PK__productM__3213E83FBAAA4E7D PRIMARY KEY (id),
	CONSTRAINT FK__productMa__subCa__1E6F845E FOREIGN KEY (subCategoryChildId) REFERENCES nextstore.dbo.subCategoryChild(id)
);


-- nextstore.dbo.product1 definition

-- Drop table

-- DROP TABLE nextstore.dbo.product1 GO

CREATE TABLE nextstore.dbo.product1 (
	id int IDENTITY(1,1) NOT NULL,
	mrp int NULL,
	price int NULL,
	shopId int NULL,
	productMasterId int NULL,
	CONSTRAINT PK__product__3213E83F16B61479 PRIMARY KEY (id),
	CONSTRAINT FK__product__product__22401542 FOREIGN KEY (productMasterId) REFERENCES nextstore.dbo.productMaster(id),
	CONSTRAINT FK__product__shopId__214BF109 FOREIGN KEY (shopId) REFERENCES nextstore.dbo.shop(id)
);

-- nextstore.dbo.offers definition

CREATE TABLE nextstore.dbo.offers (
	id int IDENTITY(1,1) NOT NULL,
	offer_name varchar(15) NOT NULL,
	offer_image varchar(40) NOT NULL,
	offer_type varchar(20) NOT NULL,
	createdAt datetime default CURRENT_TIMESTAMP
);


-- nextstore.dbo.coupons definition

CREATE TABLE nextstore.dbo.coupons (
  id int IDENTITY(1,1) PRIMARY KEY,
  coupon_code varchar(12) NULL,
  max_use_count int NOT NULL,
  discount_percentage int NOT NULL,
  min_order_amount int,
  max_discount_amount int
);

-- nextstore.dbo.notifications definition

CREATE TABLE nextstore.dbo.notifications (
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