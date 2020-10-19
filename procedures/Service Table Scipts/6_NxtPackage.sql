-------------------------------------------------------

-- SELECT * FROM nxtServiceItem WHERE CategoryItemName = 'Two Wheeler'

INSERT INTO nxtPackage ([PackageName],[CategoryItemId]) 
VALUES
('General check-up',1),
('Minor electrical check-up',1),
('Minor engine tune-up',1);

-----------------------

-------------------------------------------------------

-- SELECT * FROM nxtServiceItem WHERE CategoryItemName = 'Pest Control'

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Pest Control',15,'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Pest Control',19,'')

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Rodent Control',15,'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Rodent Control',19,'')

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bed Bug',15,'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bed Bug',19,'')

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bed Bug & Pest Control',15,'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bed Bug & Pest Control',19,'')
-----------------------

-- SELECT * FROM nxtServiceItem WHERE CategoryItemName = 'House Cleaning'

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('House Cleaning',16,'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('House Cleaning',20,'')

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Empty House Cleaning',16,'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Empty House Cleaning',20,'')

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Kitchen Cleaning',16,'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Kitchen Cleaning',20,'')

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bathroom Cleaning',16,'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bathroom Cleaning',20,'')
-----------------

-- SELECT * FROM nxtServiceItem WHERE CategoryItemName = 'Beauty Services' -- 26

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Facial',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Beauty Services'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Pedicure',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Beauty Services'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Hair Care',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Beauty Services'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bleach',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Beauty Services'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Low-Ccontact Threading',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Beauty Services'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Waxing',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Beauty Services'),'')
-- Pest Ctrl
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Pest Control',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Home Maintenance'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Rodent Control',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Home Maintenance'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bed Bug',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Home Maintenance'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bed Bug & Pest Control',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Home Maintenance'),'')

INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Pest Control',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Cleaning Service'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Rodent Control',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Cleaning Service'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bed Bug',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Cleaning Service'),'')
INSERT INTO nxtPackage ([PackageName],[CategoryItemId],[Description]) VALUES('Bed Bug & Pest Control',(SELECT CategoryItemId FROM nxtServiceItem WHERE CategoryItemName = 'Cleaning Service'),'')