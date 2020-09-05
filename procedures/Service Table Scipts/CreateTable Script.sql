/****** Object:  Table [dbo].[nxtServiceCategory]    Script Date: 9/2/2020 3:36:17 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[nxtServiceCategory](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](50) NULL,
	[Active] [int] NULL,
 CONSTRAINT [PK_nxtServiceCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[nxtServiceCategory] ADD  CONSTRAINT [DF_nxtServiceCategory_Active]  DEFAULT ((1)) FOR [Active]

------------------------------------------------
--USE [nxtStore]

/****** Object:  Table [dbo].[nxtServiceItem]    Script Date: 9/2/2020 3:36:37 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[nxtServiceItem](
	[CategoryItemId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryItemName] [varchar](50) NULL,
	[CategoryId] [int] NULL,
	[Description] [varchar](500) NULL,
	[Active] [int] NULL,
	[Type] [varchar](30) NULL,
 CONSTRAINT [PK_nxtServiceItem] PRIMARY KEY CLUSTERED 
(
	[CategoryItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[nxtServiceItem] ADD  CONSTRAINT [DF_Table_1_Active]  DEFAULT ((1)) FOR [Description]

ALTER TABLE [dbo].[nxtServiceItem] ADD  DEFAULT ((1)) FOR [Active]

---------------------------------------------------------
--USE [nxtStore]

/****** Object:  Table [dbo].[nxtPackage]    Script Date: 9/2/2020 3:48:55 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[nxtPackage](
	[PackageId] [int] IDENTITY(1,1) NOT NULL,
	[PackageName] [varchar](50) NULL,
	[CategoryItemId] [int] NULL,
	[Description] [varchar](500) NULL,
	[Active] [int] NULL,
 CONSTRAINT [PK_nxtPackage] PRIMARY KEY CLUSTERED 
(
	[PackageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

----------------------------------------

--USE [nxtStore]

/****** Object:  Table [dbo].[nxtPackageItemRate]    Script Date: 9/2/2020 3:57:09 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[nxtPackageItemRate](
	[PackageItemsId] [int] IDENTITY(1,1) NOT NULL,
	[PackageItemName] [varchar](250) NULL,
	[PackageId] [int] NULL,
	[Description] [varchar](100) NULL,
	[Active] [int] NULL,
	[Rate] [float] NULL,
	[OfferRate] [float] NULL,
 CONSTRAINT [PK_nxtPackageItems] PRIMARY KEY CLUSTERED 
(
	[PackageItemsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[nxtPackageItemRate] ADD  CONSTRAINT [DF_nxtPackageItems_Active]  DEFAULT ((1)) FOR [Active]

------------------------------------------
--USE [nxtStore]

/****** Object:  Table [dbo].[nxtRepairItems]    Script Date: 9/2/2020 4:00:11 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[nxtRepairItems](
	[RepairItemId] [int] IDENTITY(1,1) NOT NULL,
	[RepairItems] [varchar](250) NULL,
	[CategoryItemId] [int] NULL,
	[Active] [int] NULL,
 CONSTRAINT [PK_nxtReairItems] PRIMARY KEY CLUSTERED 
(
	[RepairItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[nxtRepairItems] ADD  CONSTRAINT [DF_nxtReairItems_Active]  DEFAULT ((1)) FOR [Active]

-----------------------------------
--USE [nxtStore]

/****** Object:  Table [dbo].[nxtRepairServiceCharge]    Script Date: 9/2/2020 4:05:35 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[nxtRepairServiceCharge](
	[RepairItemsAndRate_Id] [int] IDENTITY(1,1) NOT NULL,
	[RepairItemsPart] [varchar](100) NULL,
	[RepairItemId] [int] NULL,
	[Rate] [float] NULL,
	[OfferRate] [float] NULL,
	[Active] [int] NULL,
	[Min_Rate] [float] NULL,
	[Min_OfferRate] [float] NULL,
 CONSTRAINT [PK_nxtRepairITemsRate] PRIMARY KEY CLUSTERED 
(
	[RepairItemsAndRate_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[nxtRepairServiceCharge] ADD  CONSTRAINT [DF_nxtRepairITemsRate_Active]  DEFAULT ((1)) FOR [Active]

ALTER TABLE [dbo].[nxtRepairServiceCharge] ADD  DEFAULT ((0)) FOR [Min_Rate]

ALTER TABLE [dbo].[nxtRepairServiceCharge] ADD  DEFAULT ((0)) FOR [Min_OfferRate]

---------------------
--USE [nxtStore]

/****** Object:  Table [dbo].[RepairPartsRate]    Script Date: 9/2/2020 4:05:46 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[RepairPartsRate](
	[RepairPartsRate_Id] [int] IDENTITY(1,1) NOT NULL,
	[RepairItemID] [int] NULL,
	[RepairPartName] [varchar](250) NULL,
	[Min_Rate] [float] NULL,
	[Max_Rate] [float] NULL,
	[Active] [int] NULL,
 CONSTRAINT [PK_RepairPartsRate] PRIMARY KEY CLUSTERED 
(
	[RepairPartsRate_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[RepairPartsRate] ADD  CONSTRAINT [DF_RepairPartsRate_Active]  DEFAULT ((1)) FOR [Active]

------------------------
--USE [nxtStore]

/****** Object:  Table [dbo].[TwoWheelerSparePartRate]    Script Date: 9/2/2020 4:05:57 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[TwoWheelerSparePartRate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SparePartName] [varchar](250) NULL,
	[Moped_Min] [float] NULL,
	[Moped_Max] [float] NULL,
	[CC_150_180_Min] [float] NULL,
	[CC_150_180_Max] [float] NULL,
	[CC_Above_180_Min] [float] NULL,
	[CC_Above_180_Max] [float] NULL,
	[Bullet_Min] [float] NULL,
	[Bullet_Max] [float] NULL,
	[Active] [int] NULL,
 CONSTRAINT [PK_Repair_Rate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[TwoWheelerSparePartRate] ADD  CONSTRAINT [DF_Repair_Rate_Active]  DEFAULT ((1)) FOR [Active]

