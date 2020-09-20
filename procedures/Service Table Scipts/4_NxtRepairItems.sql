
INSERT INTO [dbo].[nxtRepairItems] ([RepairItems],[CategoryItemId]) VALUES ('Dry Clean',(SELECT  [CategoryItemId] FROM nxtServiceItem WHERE CategoryItemName ='Laundry Services'))
INSERT INTO [dbo].[nxtRepairItems] ([RepairItems],[CategoryItemId]) VALUES ('Wash Only',(SELECT  [CategoryItemId] FROM nxtServiceItem WHERE CategoryItemName ='Laundry Services'))
INSERT INTO [dbo].[nxtRepairItems] ([RepairItems],[CategoryItemId]) VALUES ('Wash & Steam n Press',(SELECT  [CategoryItemId] FROM nxtServiceItem WHERE CategoryItemName ='Laundry Services'))
INSERT INTO [dbo].[nxtRepairItems] ([RepairItems],[CategoryItemId]) VALUES ('Steam n Press',(SELECT  [CategoryItemId] FROM nxtServiceItem WHERE CategoryItemName ='Laundry Services'))

INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Pick-Up And Delivery',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Bath Mat',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),59)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Bath Robe',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),99)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Bath Towel Light',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Bath Towel Heavy',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),89)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Bed Spread/ Bed Cover Single',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),129)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Bed Spread/ Bed Cover Double',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),169)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Bedsheet Single',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),99)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Bedsheet Double',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),129)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Blanket Single',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),299)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Blanket Double',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),399)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Blazer/ Coat',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),229)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Blouse/ Ghagra Top',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),79)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Blouse/ Ghagra Top - Silk',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),99)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Blouse/ Ghagra Top - With Work',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),149)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Cap',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Curtain - Cotton (Per SFT)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),8)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Curtain - Nylon/ Poly (Per SFT)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),10)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Curtain - Silk (Per SFT)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),14)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Door Mat',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),79)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Dupatta Silk',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),99)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Dupatta With Work',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),169)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Ghagra',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),279)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Ghagra - Silk, Embroidered, With Work, etc.',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),349)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Gloves - Leather (Pair)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),129)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Gloves - Wool (Pair)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),89)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Hand Towel',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),49)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Handkerchief',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),49)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Jacket',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),189)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Jacket - Leather',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),399)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Jeans/ Denims',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),99)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Kids Blazer/ Coat/ Silk Kurta',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),99)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Kids Shirt/ T-Shirt/ Top/ Kurta',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Kids Skirt/ Frock',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Kids Trouser/Jeans/ Pant',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Kurti/ Kameez',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),89)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Kurti/ Kameez - Silk',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),119)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Long Coat/ Long Jacket',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),299)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Long Gown With Work',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),299)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Long Gown/ Maxi',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),219)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Men''s Dhoti',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),99)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Men''s Dhoti Silk',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),149)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Men''s Kurta',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),89)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Men''s Kurta Silk',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),129)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Men''s Safari Pant',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),149)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Men''s Safari Shirt',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),119)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Men''s Sherwani Set',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),599)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Men''s Waistcoat/ Bandi',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),89)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Men''s Waistcoat/ Bandi Silk',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),149)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Night Wear',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),89)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('One Piece/ Dress/ Western Dress',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),249)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Petticoat',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),79)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Pillow (Single)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),149)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Pillow Cover/ Cushion Cover (Single)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Pullover/ Sweater',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),189)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Pyjama',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Quilt Single',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),299)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Quilt Double',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),399)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Salwaar - Embroidered/ Stone Work, etc.',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),169)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Salwaar/ Pyjama/ Palazzo/ Patiala',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Salwaar/ Pyjama/ Palazzo/ Patiala - Silk',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),169)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Saree - Cotton/ Chiffon',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),199)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Saree - Silk',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),289)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Saree - Embroidered/ Stone Work, etc.',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),399)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Shawl',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),99)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Shawl - Woolen',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),149)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Shirt',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Shorts',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Silk Shirt',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),89)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Skirt',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),79)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Socks (Pair)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),89)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Sofa Cover (Per Seat)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),89)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Soft Toy (Large)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),249)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Soft Toy (Small)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),169)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Suit (2 Pc)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Dry Clean'),289)

-------------------------


INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Pick-Up and Delivery Charges',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Up To 4.5 Kgs. (Regular Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),249)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Up To 5.5 Kgs. (Regular Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),279)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Up To 6.5 Kgs. (Regular Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),309)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Up To 7.5 Kgs. (Regular Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),339)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Up To 4.5 Kgs. (Heavy Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),299)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Up To 5.5 Kgs. (Heavy Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),329)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Up To 6.5 Kgs. (Heavy Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),359)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Up To 7.5 Kgs. (Heavy Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),389)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Dettol Wash (Add On)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),30)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Fabric Conditioner (Add On)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash Only'),30)
--------------------------

INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Pick-Up and Delivery Charges',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Steam Press (Per Piece)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),9)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Wash Up To 4.5 Kgs. (Regular Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),249)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Wash Up To 5.5 Kgs. (Regular Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),279)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Wash Up To 6.5 Kgs. (Regular Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),309)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Wash Up To 7.5 Kgs. (Regular Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),339)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Steam Press: Heavy Garments (Per Piece)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),25)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Wash Up To 4.5 Kgs. (Heavy Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),299)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Wash Up To 5.5 Kgs. (Heavy Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),329)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Wash Up To 6.5 Kgs. (Heavy Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),359)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Wash Up To 7.5 Kgs. (Heavy Load)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),389)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Dettol Wash (Add On)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),30)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Fabric Conditioner (Add On)',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Wash & Steam n Press'),30)
-------------------------------
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Pick up and Delivery',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Steam n Press'),69)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Steam Press Only: Regular',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Steam n Press'),12)
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Steam Press Only: Heavy',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Steam n Press'),30)
-----------------------------------


INSERT INTO [dbo].[nxtRepairItems] ([RepairItems],[CategoryItemId]) VALUES ('Microwave Oven Service',(SELECT  [CategoryItemId] FROM nxtServiceItem WHERE CategoryItemName ='Microwave Oven'))
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Service Charge',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Microwave Oven Service'),	299)
---------
INSERT INTO [dbo].[nxtRepairItems] ([RepairItems],[CategoryItemId]) VALUES ('Electric Geyser Service',(SELECT  [CategoryItemId] FROM nxtServiceItem WHERE CategoryItemName ='Electric Geyser'))
INSERT INTO [dbo].[nxtRepairServiceCharge] ([RepairItemsPart],[RepairItemId],[OfferRate]) VALUES('Service Charge',(SELECT [RepairItemId] FROM [nxtRepairItems] WHERE [RepairItems] = 'Electric Geyser Service'),299)
