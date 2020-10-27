INSERT INTO adminTable (username, password) VALUES
(
    'admin', HASHBYTES('MD5', 'hello')
);
INSERT INTO category (name) VALUES
('Babycare'),
('Organic'),
('Groceries'),
('Beverages'),
('Snacks'),
('Personal Care'),
('Households'),
('Kitchen'),
('Electronics Mobiles'),
('Eggs, Meat & Fish');

SET IDENTITY_INSERT subCategory ON;

INSERT INTO subCategory (id, categoryId, name) VALUES
(1, '1', 'Baby Bath & Hygiene'),
(2, '1', 'Mothers & Maternity'),
(3, '1', 'Baby Accessories'),
(4, '1', 'Diapers & Wipes'),
(5, '1', 'Baby Food & Formula'),
(6, '2', 'Egg'),
(7, '2', 'Fish'),
(8, '2', 'Vegetables'),
(9, '2', 'Fruits'),
(10, '3', 'Milk'),
(11, '3', 'Dals & Pulses'),
(12, '3', 'Salt, Sugar & Jaggery'),
(13, '3', 'Rice & Rice Products'),
(14, '3', 'Atta, Flours & Sooji'),
(15, '3', 'Edible Oils & Ghee'),
(16, '3', 'Dry Fruits'),
(17, '3', 'Organic Staples'),
(18, '3', 'Masalas & Spices'),
(19, '4', 'Tea'),
(20, '4', 'Coffee'),
(21, '4', 'Water'),
(22, '4', 'Health Drink, Supplement'),
(23, '4', 'Fruit Juices & Drinks'),
(24, '4', 'Energy & Soft Drinks'),
(25, '5', 'Noodle, Pasta, Vermicelli'),
(26, '5', 'Breakfast Cereals'),
(27, '5', 'Biscuits & Cookies'),
(28, '5', 'Spreads, Sauces, Ketchup'),
(29, '5', 'Snacks & Namkeen'),
(30, '5', 'Frozen Veggies & Snacks'),
(31, '5', 'Chocolates & Candies'),
(32, '5', 'Ready To Cook & Eat'),
(33, '5', 'Pickles & Chutney'),
(34, '5', 'Indian Mithai'),
(35, '6', 'Health & Medicine'),
(36, '6', 'Oral Care'),
(37, '6', 'Feminine Hygiene'),
(38, '6', 'Bath & Hand Wash'),
(39, '6', 'Men''s Grooming'),
(40, '6', 'Makeup'),
(41, '6', 'Hair Care'),
(42, '6', 'Fragrances & Deos'),
(43, '6', 'Skin Care'),
(44, '7', 'Detergents & Dishwash'),
(45, '7', 'All Purpose Cleaners'),
(46, '7', 'Party & Festive Needs'),
(47, '7', 'Fresheners & Repellents'),
(48, '7', 'Stationery'),
(49, '7', 'Disposables, Garbage Bag'),
(50, '7', 'Mops, Brushes & Scrubs'),
(51, '7', 'Bins & Bathroom Ware'),
(52, '7', 'Pooja Needs'),
(53, '7', 'Pets'),
(54, '7', 'Car & Shoe Care'),
(55, '8', 'Steel Utensils'),
(56, '8', 'Cookware & Non Stick'),
(57, '8', 'Bakeware'),
(58, '8', 'Storage & Accessories'),
(59, '8', 'Kitchen Accessories'),
(60, '8', 'Flask & Casserole'),
(61, '8', 'Crockery & Cutlery'),
(62, '9', 'Smart Phones'),
(63, '9', 'Tablets'),
(64, '9', 'Phones'),
(65, '9', 'Wearable Gadgets'),
(66, '9', 'Computers'),
(67, '9', 'Entertainment'),
(68, '9', 'Appliances'),
(69, '10', 'Pork & Other Meats'),
(70, '10', 'Poultry'),
(71, '10', 'Eggs'),
(72, '10', 'Fish & Seafood'),
(73, '10', 'Mutton & Lamb'),
(74, '3', 'Canned Food');

SET IDENTITY_INSERT subCategory OFF;

SET IDENTITY_INSERT subCategoryChild ON;

INSERT INTO subCategoryChild (id, subCategoryId, name) VALUES
(1, '1', 'Baby Laundry'),
(2, '1', 'Baby Bath'),
(3, '1', 'Baby Creams & Lotions'),
(4, '1', 'Baby Oil & Shampoo'),
(5, '1', 'Baby Powder'),
(6, '2', 'Maternity Health Supplements'),
(7, '2', 'Maternity Personal Care'),
(8, '3', 'Combs, Brushes, Clippers'),
(9, '3', 'Baby Gift Sets'),
(10, '3', 'Baby Dishes & Utensils'),
(11, '4', 'Baby Wipes'),
(12, '4', 'Diapers'),
(13, '4', 'Nappies & Rash Cream'),
(14, '5', 'Infant Formula'),
(15, '5', 'Organic Baby Food'),
(16, '5', 'Baby Food'),
(17, '6', 'Egg'),
(18, '7', 'Fish'),
(19, '8', 'Vegetables'),
(20, '9', 'Fruits'),
(21, '10', 'Milk Powder'),
(22, '10', 'Milk'),
(23, '11', 'Toor, Channa & Moong Dal'),
(24, '11', 'Cereals & Millets'),
(25, '11', 'Urad & Other Dals'),
(26, '12', 'Salts'),
(27, '12', 'Sugar & Jaggery'),
(28, '12', 'Sugarfree Sweeteners'),
(29, '13', 'Boiled & Steam Rice'),
(30, '13', 'Raw Rice'),
(31, '13', 'Basmati Rice'),
(32, '13', 'Poha, Sabudana & Murmura'),
(33, '14', 'Atta Whole Wheat'),
(34, '14', 'Sooji, Maida & Besan'),
(35, '14', 'Rice & Other Flours'),
(36, '15', 'Gingelly Oil'),
(37, '15', 'Ghee & Vanaspati'),
(38, '15', 'Blended Cooking Oils'),
(39, '15', 'Sunflower, Rice Bran Oil'),
(40, '15', 'Soya & Mustard Oils'),
(41, '15', 'Other Edible Oils'),
(42, '15', 'Olive & Canola Oils'),
(43, '16', 'Almonds'),
(44, '16', 'Cashews'),
(45, '16', 'Raisins'),
(46, '16', 'Other Dry Fruits'),
(47, '16', 'Mukhwas'),
(48, '17', 'Organic Sugar, Jaggery'),
(49, '17', 'Organic Dry Fruits'),
(50, '17', 'Organic Flours'),
(51, '17', 'Organic Dals & Pulses'),
(52, '17', 'Organic Rice, Other Rice'),
(53, '17', 'Organic Masalas & Spices'),
(54, '17', 'Organic Edible Oil, Ghee'),
(55, '18', 'Powdered Spices'),
(56, '18', 'Whole Spices'),
(57, '18', 'Cooking Pastes'),
(58, '18', 'Blended Masalas'),
(59, '18', 'Herbs & Seasoning'),
(60, '19', 'Leaf & Dust Tea'),
(61, '19', 'Green Tea'),
(62, '19', 'Tea Bags'),
(63, '20', 'Instant Coffee'),
(64, '20', 'Ground Coffee'),
(65, '21', 'Packaged Water'),
(66, '21', 'Spring Water'),
(67, '22', 'Kids (5+Yrs)'),
(68, '22', 'Children (2-5 Yrs)'),
(69, '22', 'Men & Women'),
(70, '23', 'Unsweetened, Cold Press'),
(71, '23', 'Juices'),
(72, '23', 'Syrups & Concentrates'),
(73, '24', 'Soda & Cocktail Mix'),
(74, '24', 'Cold Drinks'),
(75, '24', 'Non Alcoholic Drinks'),
(76, '24', 'Sports & Energy Drinks'),
(77, '25', 'Instant Noodles'),
(78, '25', 'Hakka Noodles'),
(79, '25', 'Vermicelli'),
(80, '25', 'Instant Pasta'),
(81, '25', 'Cup Noodles'),
(82, '25', 'Pasta & Macaroni'),
(83, '26', 'Oats & Porridge'),
(84, '26', 'Kids Cereal'),
(85, '26', 'Muesli'),
(86, '26', 'Flakes'),
(87, '26', 'Granola & Cereal Bars'),
(88, '27', 'Glucose & Milk Biscuits'),
(89, '27', 'Cream Biscuits & Wafers'),
(90, '27', 'Marie, Health, Digestive'),
(91, '27', 'Salted Biscuits'),
(92, '27', 'Cookies'),
(93, '28', 'Honey'),
(94, '28', 'Jam, Conserve, Marmalade'),
(95, '28', 'Tomato Ketchup & Sauces'),
(96, '28', 'Vinegar'),
(97, '28', 'Mayonnaise'),
(98, '28', 'Choco & Nut Spread'),
(99, '28', 'Chilli & Soya Sauce'),
(100, '28', 'Dips & Dressings'),
(101, '29', 'Chips & Corn Snacks'),
(102, '29', 'Namkeen & Savoury Snacks'),
(103, '30', 'Frozen Vegetables'),
(104, '30', 'Frozen Veg Snacks'),
(105, '30', 'Frozen Non-Veg Snacks'),
(106, '30', 'Frozen Indian Breads'),
(107, '31', 'Chocolates'),
(108, '31', 'Toffee, Candy & Lollypop'),
(109, '31', 'Mints & Chewing Gum'),
(110, '31', 'Gift Boxes'),
(111, '32', 'Papads, Ready To Fry'),
(112, '32', 'Breakfast & Snack Mixes'),
(113, '32', 'Soups'),
(114, '32', 'Home Baking'),
(115, '32', 'Dessert Mixes'),
(116, '32', 'Heat & Eat Ready Meals'),
(117, '32', 'Canned Food'),
(118, '33', 'Chutney Powder'),
(119, '33', 'Non Veg Pickle'),
(120, '33', 'Lime & Mango Pickle'),
(121, '33', 'Other Veg Pickle'),
(122, '34', 'Chikki & Gajjak'),
(123, '34', 'Tinned, Packed Sweets'),
(124, '34', 'Fresh Sweets'),
(125, '35', 'Antiseptics & Bandages'),
(126, '35', 'Ayurveda'),
(127, '35', 'Cotton & Ear Buds'),
(128, '35', 'Supplements & Proteins'),
(129, '35', 'Everyday Medicine'),
(130, '35', 'Adult Diapers'),
(131, '35', 'Sexual Wellness'),
(132, '35', 'Health Monitors'),
(133, '35', 'Slimming Products'),
(134, '36', 'Mouthwash'),
(135, '36', 'Toothpaste'),
(136, '36', 'Toothbrush'),
(137, '37', 'Sanitary Napkins'),
(138, '37', 'Panty Liners'),
(139, '37', 'Hair Removal'),
(140, '37', 'Intimate Wash & Care'),
(141, '37', 'Tampons & Menstrual Cups'),
(142, '38', 'Bathing Accessories'),
(143, '38', 'Hand Wash & Sanitizers'),
(144, '38', 'Bathing Bars & Soaps'),
(145, '38', 'Talcum Powder'),
(146, '38', 'Shower Gel & Body Wash'),
(147, '38', 'Body Scrubs & Exfoliants'),
(148, '38', 'Bath Salts & Oils'),
(149, '39', 'Shaving Care'),
(150, '39', 'Face & Body'),
(151, '39', 'Bath & Shower'),
(152, '39', 'Hair Care & Styling'),
(153, '39', 'Combos & Gift Sets'),
(154, '39', 'Moustache & Beard Care'),
(155, '40', 'Makeup Kits & Gift Sets'),
(156, '40', 'Lips'),
(157, '40', 'Eyes'),
(158, '40', 'Face'),
(159, '40', 'Nails'),
(160, '40', 'Makeup Accessories'),
(161, '41', 'Hair Oil & Serum'),
(162, '41', 'Shampoo & Conditioner'),
(163, '41', 'Hair Color'),
(164, '41', 'Hair & Scalp Treatment'),
(165, '41', 'Hair Styling'),
(166, '41', 'Tools & Accessories'),
(167, '41', 'Dry Shampoo & Conditioner'),
(168, '42', 'Eau De Toilette'),
(169, '42', 'Eau De Cologne'),
(170, '42', 'Body Sprays & Mists'),
(171, '42', 'Women''s Deodorants'),
(172, '42', 'Men''s Deodorants'),
(173, '42', 'Eau De Parfum'),
(174, '42', 'Perfume'),
(175, '42', 'Attar'),
(176, '42', 'Gift Sets'),
(177, '43', 'Body Care'),
(178, '43', 'Lip Care'),
(179, '43', 'Face Care'),
(180, '43', 'Eye Care'),
(181, '43', 'Aromatherapy'),
(182, '44', 'Dishwash Liquids & Pastes'),
(183, '44', 'Detergent Powder, Liquid'),
(184, '44', 'Fabric Pre, Post Wash'),
(185, '44', 'Detergent Bars'),
(186, '44', 'Dishwash Bars & Powders'),
(187, '45', 'Toilet Cleaners'),
(188, '45', 'Floor & Other Cleaners'),
(189, '45', 'Kitchen, Glass & Drain'),
(190, '45', 'Imported Cleaners'),
(191, '46', 'Disposable Cups & Plates'),
(192, '46', 'Gift Wraps & Bags'),
(193, '46', 'Gifts'),
(194, '47', 'Mosquito Repellent'),
(195, '47', 'Insect Repellent'),
(196, '47', 'Air Freshener'),
(197, '48', 'Exam Pads & Pencil Box'),
(198, '48', 'Umberlla'),
(199, '48', 'Scissor, Glue & Tape'),
(200, '49', 'Wet Wipe, Pocket Tissues'),
(201, '49', 'Kitchen Rolls'),
(202, '49', 'Garbage Bags'),
(203, '49', 'Toilet Paper'),
(204, '49', 'Aluminium Foil, Clingwrap'),
(205, '49', 'Paper Napkin, Tissue Box'),
(206, '50', 'Utensil Scrub-Pad, Glove'),
(207, '50', 'Brooms & Dust Pans'),
(208, '50', 'Dust Cloth & Wipes'),
(209, '50', 'Toilet & Other Brushes'),
(210, '50', 'Mops, Wipers'),
(211, '51', 'Other Plastic Ware'),
(212, '51', 'Bath Stool, Basin & Sets'),
(213, '51', 'Hangers, Clips & Rope'),
(214, '51', 'Laundry, Storage Baskets'),
(215, '51', 'Dustbins'),
(216, '51', 'Buckets & Mugs'),
(217, '51', 'Soap Cases & Dispensers'),
(218, '52', 'Camphor & Wicks'),
(219, '52', 'Lamp & Lamp Oil'),
(220, '52', 'Agarbatti, Incense Sticks'),
(221, '52', 'Candles & Match Box'),
(222, '52', 'Other Pooja Needs'),
(223, '53', 'Pet Foods'),
(224, '53', 'Pet care'),
(225, '54', 'Shoe Polish'),
(226, '54', 'Car Shampoo'),
(227, '55', 'Steel Storage Containers'),
(228, '55', 'Copper Utensils'),
(229, '55', 'Bowls & Vessels'),
(230, '55', 'Steel Lunch Boxes'),
(231, '55', 'Plates & Tumblers'),
(232, '56', 'Pressure Cookers'),
(233, '56', 'Tawa & Sauce Pan'),
(234, '56', 'Cookware Sets'),
(235, '56', 'Cook And Serve'),
(236, '56', 'Kadai & Fry Pans'),
(237, '57', 'Bakeware Moulds, Cutters'),
(238, '57', 'Bakeware Accessories'),
(239, '57', 'Baking Tools & Brushes'),
(240, '58', 'Racks & Holders'),
(241, '58', 'Wall Hooks & Hangers'),
(242, '58', 'Containers Sets'),
(243, '58', 'Water & Fridge Bottles'),
(244, '58', 'Lunch Boxes'),
(245, '59', 'Choppers & Graters'),
(246, '59', 'Lighters'),
(247, '59', 'Kitchen Tools & Other Accessories'),
(248, '59', 'Knives & Peelers'),
(249, '59', 'Strainer, Ladle, Spatula'),
(250, '60', 'Vacuum Flask'),
(251, '60', 'Casserole'),
(252, '61', 'Cutlery, Spoon & Fork'),
(253, '61', 'Glassware'),
(254, '61', 'Dinner Sets'),
(255, '61', 'Cups, Mugs & Tumblers'),
(256, '61', 'Plates & Bowls'),
(257, '62', 'Feature Phones'),
(258, '62', 'Accessories'),
(259, '63', 'Tablet'),
(260, '63', 'Tablet & iPad Accessories'),
(261, '64', 'Corded Phones'),
(262, '64', 'Cordless Phones'),
(263, '65', 'Smart Bands'),
(264, '65', 'Smart Watches'),
(265, '66', 'Computer Devices'),
(266, '66', 'Gaming'),
(267, '66', 'Peripherals'),
(268, '66', 'Software'),
(269, '66', 'Hardware'),
(270, '67', 'Home Entertainment'),
(271, '67', 'Photography'),
(272, '67', 'Audio'),
(273, '68', 'Kitchen Appliances'),
(274, '68', 'Home Appliances'),
(275, '68', 'Electrical Accessories'),
(276, '69', 'Fresh & Frozen Pork'),
(277, '70', 'Fresh Chicken'),
(278, '70', 'Frozen Chicken'),
(279, '71', 'Other Eggs'),
(280, '71', 'Protein Egg'),
(281, '72', 'Dry Fish'),
(282, '72', 'Fresh Fish'),
(283, '73', 'Mutton & Lamb'),
(284, '74', 'Canned Fruits'),
(285, '74', 'Canned Meat'),
(286, '74', 'Canned Vegetables'),
(287, '74', 'Tuna & Seafood');

SET IDENTITY_INSERT subCategoryChild OFF;

SET IDENTITY_INSERT productMaster ON;
INSERT INTO productMaster (id, name, image, subCategoryChildId) VALUES
(1, 'Tilopia', 'dist1/distpoint1/Tilopia.jpg', 18),
(2, 'Karatti-Anaabis', 'dist1/distpoint1/Karatti-Anaabis.jpg', 18),
(3, 'Vala', 'dist1/distpoint1/Vala.jpg', 18),
(4, 'A1-SKC Agmark Ghee 1L  ( JAR )', 'productPool/A1SKC Ghee JAR 1.jpg', 37),
(5, 'A1-SKC Agmark Ghee 500 ML  ( JAR )', 'productPool/A1SKC Ghee JAR 500.jpg', 37),
(6, 'A1-SKC Agmark Ghee 200 ML ( JAR )', 'productPool/A1SKC Ghee JAR 200.jpg', 37),
(7, 'A1-SKC Agmark Ghee 100 ML ( JAR )', 'productPool/A1SKC Ghee JAR 100.jpg', 37),
(8, 'A1-SKC Agmark Ghee 50 ML ( JAR )', 'productPool/A1SKC Ghee JAR 50.jpg', 37),
(9, 'A1-SKC Ghee Pouch 100 ML ( JAR )', 'productPool/A1SKC Ghee PCH 100.jpg', 37),
(10, 'A1-SKC Ghee Pouch 50 ML ( JAR )', 'productPool/A1SKC Ghee PCH 50.jpg', 37),
(11, 'A1-SKC Ghee Pouch 1 L ( JAR )', 'productPool/A1SKC Ghee PCH 1.jpg', 37),
(12, 'A1-SKC Ghee Tin 1L ( JAR )', 'productPool/A1SKC Ghee TIN 1.jpg', 37),
(13, 'A1-SKC Ghee Tin 2L ( JAR )', 'productPool/A1SKC Ghee TIN 2.jpg', 37),
(14, 'A1-SKC Ghee Tin 5L ( JAR )', 'productPool/A1SKC Ghee TIN 5.jpg', 37),
(15, 'Amul Spray 500g (TIN)', 'productPool/Amul Spray 500g (TIN).jpg', 21),
(16, 'Amul Pro 500g', 'productPool/Amul Pro 500.jpg', 21),
(17, 'Amul Dark Chocolate 150g', 'productPool/Amul Dark Chocolate 150.jpg', 107),
(18, 'Amul Fruit N Nut 150g', 'productPool/Amul Fruit N Nut 150.jpg', 107),
(19, 'Amul Milk Chocolate 150g', 'productPool/Amul Milk Chocolate 150.jpg', 107),
(20, 'Amul Choco Cracker 150g', 'productPool/Amul Choco Cracker 150.jpg', 107),
(21, 'Amul Taaza Fresh Toned Milk 500g', 'productPool/Amul Toned Milk 500.jpg', 22),
(22, 'Amul Mithai Mate 400g', 'productPool/Amul Mithai Mate 400.jpg', 115),
(23, 'Amul Mithai Mate 200g', 'productPool/Amul Mithai Mate 200.jpg', 115),
(24, 'Amul Butter 500g', 'productPool/Amul Butter 500.jpg', 37),
(25, 'Amul Butter 100g', 'productPool/Amul Butter 100.jpg', 37),
(26, 'Amul Kool Badam 200 ML', 'productPool/Amul Kool Badam 200.jpg', 74),
(27, 'Amul Kool Elaichi 200 ML', 'productPool/Amul Kool Elaichi 200.jpg', 74),
(28, 'Amul Kool Kesar 200 ML', 'productPool/Amul Kool Kesar 200.jpg', 74),
(29, 'Amulya Dairy Whitener 500g', 'productPool/Amulya Dairy Whitener 500.jpg', 21),
(30, 'Amul Malai Paneer 200g', 'productPool/Amul Malai Paneer 200.jpg', 37),
(31, 'Amul Cheese Slice 10x20g', 'productPool/Amul Cheese Slice 10x20.jpg', 37),
(32, 'Amul Cheese Spread 200g', 'productPool/Amul Cheese Spread 200.jpg', 37),
(33, 'Amul Cow Ghee 500 ML', 'productPool/Amul CowGhee 500.jpg', 37),
(34, 'Amul Cow Ghee 200 ML', 'productPool/Amul CowGhee 200.jpg', 37),
(35, 'Daawat Rozana Gold 1Kg', 'productPool/Daawat Rozana Gold 1.jpg', 31),
(36, 'Daawat Biriyapar Basmathi 1Kg', 'productPool/Daawat Biryani Basmati 1.jpg', 31),
(37, 'Daawat Super Basmathi 1Kg', 'productPool/Daawat Super Basmati 1.jpg', 31),
(38, 'AVT Premium Tea 500g', 'productPool/AVT Premium Tea 500.jpg', 60),
(39, 'AVT Premium Tea 250g', 'productPool/AVT Premium Tea 250.jpg', 60),
(40, 'AVT Premium Tea Jar 250g', 'productPool/AVT Premium Tea Jar 250.jpg', 60),
(41, 'AVT Premium Tea Bag 100 Packets', 'productPool/AVT Premium Tea Bag 100.jpg', 62),
(42, 'AVT Green Tea 250g', 'productPool/AVT Green Tea 250.jpg', 61),
(43, 'AVT Green Tea 100g', 'productPool/AVT Green Tea 100.jpg', 61),
(44, 'AVT Premium Coffee 200g', 'productPool/AVT Premium Coffee 200.jpg', 63),
(45, 'Managaldeep Lavender', 'productPool/Managaldeep Lavender.jpg', 220),
(46, 'Managaldeep Treya', 'productPool/Managaldeep Treya.jpg', 220),
(47, 'Managaldeep Sandal', 'productPool/Managaldeep Sandal.jpg', 220),
(48, 'Managaldeep Sambrani', 'productPool/Managaldeep Sambrani.jpg', 220),
(49, 'Managaldeep Pushpanjali', 'productPool/Managaldeep Pushpanjali.jpg', 220),
(50, 'Managaldeep Sadhvi', 'productPool/Managaldeep Sadhvi.jpg', 220),
(51, 'Mangaldeep Lavender 84g', 'productPool/Mangaldeep Lavender 84.jpg', 220),
(52, 'Mangaldeep Treya 84g', 'productPool/Mangaldeep Treya 84.jpg', 220),
(53, 'Savlon Disinfectant Liquid 100ml', 'productPool/Savlon Disinfectant Liquid 100ml.jpg', 188),
(54, 'Savlon Disinfectant Liquid 200ml', 'productPool/Savlon Disinfectant Liquid 100ml.jpg', 188),
(55, 'Savlon Disinfectant Liquid 500ml', 'productPool/Savlon Disinfectant Liquid 500ml.jpg', 188),
(56, 'Savlon Liquid Hand Sanitizer 9ml', 'productPool/Savlon Liquid Hand Sanitizer 9ml.jpg', 143),
(57, 'Savlon Liquid Hand Sanitizer 500ml', 'productPool/Savlon Liquid Hand Sanitizer 500ml.jpg', 143),
(58, 'Savlon Gel HandSanitizer 55ml', 'productPool/Savlon Gel HandSanitizer 55ml.jpg', 143),
(59, 'Savlon Moisture Shield 80ml', 'productPool/Savlon Moisture Shield 80ml.jpg', 143),
(60, 'Savlon Herbal Sensitive 175ml', 'productPool/Savlon Herbal Sensitive 175ml.jpg', 143),
(61, 'Savlon Deep Clean 200ml +185ml', 'productPool/Savlon Deep Clean 200ml +185ml.jpg', 143),
(62, 'Savlon Glycerine Soap 45g', 'productPool/Savlon Glycerine Soap 45.jpg', 144),
(63, 'FIAMA Talc European Fresh', 'productPool/FIAMA Talc European Fresh.jpg', 145),
(64, 'FIAMA Talc Swiss Soft', 'productPool/FIAMA Talc Swiss Soft.jpg', 145),
(65, 'FIAMA Talc French Lavendr', 'productPool/FIAMA Talc French Lavendr.jpg', 145),
(66, 'Vivel Cool Mint 100g', 'productPool/Vivel Cool Mint 100g.jpg', 144),
(67, 'Vivel Lotus Oil 100g', 'productPool/Vivel Lotus Oil 100Gms.jpg', 144),
(68, 'Aloe Vera Vivel Soap 100g', 'productPool/Aloe Vera Vivel Soap 100 gms.jpg', 144),
(69, 'Vivel Glycerin 100g(75g+25g extra)', 'productPool/vivel glycerin 100g(75g+25g extra).jpg', 144),
(70, 'Aashirvaad Superior MP 500g', 'productPool/AASHIRVAAD SUPERIOR MP 500g.jpg', 35),
(71, 'Aashirvaad Atta Multigrains 1Kg', 'productPool/Aashirvaad Atta Multigrains 1Kg.jpg', 35),
(72, 'Aashirvaad Atta 1KG', 'productPool/AASHIRVAAD ATTA 1KG.jpg', 33),
(73, 'Aashirvaad Superior MP Atta 1KG', 'productPool/AASHIRVAAD SUPERIOR MP ATTA 1KG.jpg', 33),
(74, 'Aashirvaad Sugar Release Control Atta 1 KG', 'productPool/AASHIRVAAD SUGAR RELEASE CONTROL AT 1 KG.jpg', 33),
(75, 'Aashirvaad Superior MP Atta 2KG', 'productPool/AASHIRVAAD SUPERIOR MP ATTA 2KG.jpg', 33),
(76, 'Bounce Cream Tangy Orange  34+7g', 'productPool/BOUNCE CREAM TANGY ORANGE  34+7G.jpg', 89),
(77, 'Bounce Cream Pineapple Zing', 'productPool/BOUNCE CREAM PINEAPPLE ZING.jpg', 89),
(78, 'Bounce Cream Strawberry Minis 25g', 'productPool/BOUNCE CREAM STRAWBERRY MINIS 25G.jpg', 89),
(79, 'Bounce Cream Choco Twist 34g', 'productPool/BOUNCE CREAM CHOCO TWIST 34G.jpg', 89),
(80, 'Bounce Choco Cream Cake 25g', 'productPool/BOUNCE CHOCO CREME CAKE 25G.jpg', 89),
(81, 'Dark Fantasy Choco Fills 20g', 'productPool/DARK FANTASY CHOCO FILLS 20G.jpg', 89),
(82, 'Sunfeast Glucose Biscutts 120g', 'productPool/SUNFEAST GLUCOSE BISCUTTS 120g.jpg', 88),
(83, 'Sunfeast Marie Light Rich Taste 70+15g', 'productPool/SUNFEAST MARIE LIGHT RICH TASTE 70+15G.jpg', 90),
(84, 'Bounce Cream Choco Twist 82g', 'productPool/BOUNCE CREAM CHOCO TWIST 82G.jpg', 89),
(85, 'Bounce Cream Elaichi Delight 82g', 'productPool/BOUNCE CREAM ELAICHI DELIGHT 82G.jpg', 89),
(86, 'Bounce Cream Tangy Orange 82g', 'productPool/BOUNCE CREAM TANGY ORANGE 82G.jpg', 89),
(87, 'Bounce Cream Pineapple Zing 82g', 'productPool/BOUNCE CREAM PINEAPPLE ZING 82G.jpg', 89),
(88, 'Sunfeast Marie Light Rich Taste 300g', 'productPool/SUNFEAST MARIE LIGHT RICH TASTE 300G.jpg', 90),
(89, 'Sunfeast Moms Magic Cashew & Almond 200g', 'productPool/SUNFEAST MOMS MAGIC CASHEW & ALMOND 200G.jpg', 90),
(90, 'Sunfeast Moms Magic Fruit & Milk 200g', 'productPool/SUNFEAST MOMS MAGIC FRUIT & MILK 200G.jpg', 90),
(91, 'Sunfeast Moms Magic Choco Chips 60g', 'productPool/SUNFEAST MOMS MAGIC CHOCO CHIPS 60G.jpg', 90),
(92, 'Sunfeast Moms Magic Nut Biscotti 60g', 'productPool/SUNFEAST MOMS MAGIC NUT BISCOTTI 60G.jpg', 90),
(93, 'Sunfeast Moms Magic Nuts & Raisins 60g', 'productPool/SUNFEAST MOMS MAGIC NUTS & RAISINS 60G.jpg', 90),
(94, 'Dark Fantasy Choco Fills 75g', 'productPool/DARKFANTASY CHOCO FILLS 75G.jpg', 89),
(95, 'Dark Fantasy Coffee Fills 75g(64)', 'productPool/DARK FANTASY COFFEE FILLS 75G(64).jpg', 89),
(96, 'Dark Fantasy Coffee Fills Luxuria 150g', 'productPool/DARKFANTASY CHOCO FILLS LUXURIA 150G.jpg', 89),
(97, 'Dark Fantasy Bourbon 150g', 'productPool/DARK FANTASY BOURBON 150G.jpg', 89),
(98, 'Candyman Frutiee Fun 300g', 'productPool/CANDYMAN FRUITEE FUN 300G.jpg', 108),
(99, 'Candyman Toffichoo Strawberry 270g', 'productPool/CANDYMAN TOFFICHOO STRAWBERRY 270G.jpg', 108),
(100, 'Candyman Choco Double 380g', 'productPool/CANDYMAN CHOCO DOUBLE 380G.jpg', 108),
(101, 'Wonderz Milk Fruit and Milk Mix Fruit 200ML', 'productpool/WONDERZ MILK FRT N MILK MIX FRUIT 200ML.jpg', 71),
(102, 'Wonderz Milk Fruit and Milk Mango 200 ML', 'productpool/WONDERZ MILK FRT N MILK MGO 200 ML.jpg', 71),
(103, 'Wonderz Kesar Badam Nutshake 200ML', 'productpool/WONDERZ MILK KESAR BDM NUTSKE200ML.jpg', 71),
(104, 'Aashirvaad Pure Cow Ghee 50ML', 'productpool/AASHIRVAAD PURE COW GHEE 50ML.jpg', 37),
(105, 'Aashirvaad Pure Cow Ghee 100ML ', 'productpool/AASHIRVAAD PURE COW GHEE 100ML .jpg', 37),
(106, 'Aashirvaad Pure Cow Ghee 200ML ', 'productpool/AASHIRVAAD PURE COW GHEE 200ML .jpg', 37),
(107, 'Aashirvaad Pure Cow Ghee 500ML ', 'productpool/AASHIRVAAD PURECOW GHEE500ML .jpg', 37),
(108, 'Sunfeast Dairy Whitener 200G ', 'productpool/SUNFEAST DAIRY WHITENER 200G .jpg', 21),
(109, 'Engage Blush Deo 165ml ', 'productpool/Engage Blush Deo 165ml.jpg', 170),
(110, 'Engage Drizzle Deo 165ml ', 'productpool/Engage Drizzle Deo 165ml.jpg', 170),
(111, 'Engage Frost Deo 165ml ', 'productpool/Engage Frost Deo 165ml.jpg', 170),
(112, 'Engage Mate Deo 165ml ', 'productpool/Engage Mate Deo 165ml.jpg', 170),
(113, 'Engage Rush Deo 165ml ', 'productpool/Engage Rush Deo 165ml.jpg', 170),
(114, 'Engage Spell Deo 165ml ', 'productpool/Engage Spell Deo 165ml.jpg', 170),
(115, 'Engage Tease Deo 165ml ', 'productpool/Engage Tease Deo 165ml.jpg', 170),
(116, 'Engage Urge Deo 165ml ', 'productpool/Engage Urge Deo 165ml.jpg', 170),
(117, 'Engage M1 Perfume Spray 120ml', 'productpool/Engage M1 Perfume Spray 120ml.jpg', 170),
(118, 'Engage M2 Perfume Spray 120ml', 'productpool/Engage M2 Perfume Spray 120ml.jpg', 170),
(119, 'Engage M3 Perfume Spray 120ml', 'productpool/Engage M3 Perfume Spray 120ml.jpg', 170),
(120, 'Engage M4 Perfume Spray 120ml', 'productpool/Engage M4 Perfume Spray 120ml.jpg', 170),
(121, 'Engage W1 Perfume Spray 120ml', 'productpool/Engage W1 Perfume Spray 120ml.jpg', 170),
(122, 'Engage W2 Perfume Spray 120ml', 'productpool/Engage W2 Perfume Spray 120ml.jpg', 170),
(123, 'Engage W4 Perfume2 Spray 120ml', 'productpool/Engage W4 Perfume2 Spray 120ml.jpg', 170),
(124, 'B Natural Nectar Apple Awe 200ML', 'productpool/BNATURAL NCT APPLE AWE 200ML.jpg', 71),
(125, 'B Natural Nectar Guava Gush 200ML', 'productpool/BNATURAL NCT GUAVA GUSH 200ML.jpg', 71),
(126, 'B Natural Nectar Litchi Luscious 200ML', 'productpool/BNATURAL NCT LITCHI LUSCIOUS 200ML.jpg', 71),
(127, 'B Natural Nectar Mango MAGIC 200ML', 'productpool/BNATURAL NCT MANGO MAGIC 200ML.jpg', 71),
(128, 'B Natural Nectar Mixed Fruit Merry 200ML', 'productpool/BNATURAL NCT MIXED FRUIT MRY 200ML.jpg', 71),
(129, 'B Natural Nectar Orange Oomph 200ML', 'productpool/BNATURAL NCT ORANGE OOMPH 200ML.jpg', 71),
(130, 'B Natural nectar Apple Awe 1000ML', 'productpool/BNATURAL NCT APPLE AWE 1000ML.jpg', 71),
(131, 'B Natural Nectar Guava Gush 1000ML', 'productpool/BNATURAL NCT GUAVA GUSH 1000ML.jpg', 71),
(132, 'B Natural Nectar Litchi Luscious 1000ML', 'productpool/BNATURAL NCT LITCHI LUSCIOUS1000ML.jpg', 71),
(133, 'B Natural Nectar Mango Magic 1000ML', 'productpool/BNATURAL NCT MANGO MAGIC 1000ML.jpg', 71),
(134, 'B Natural Nectar Mixed Fruit Merrry 1000ML', 'productpool/BNATURAL NCT MIXED FRUIT MRY1000ML.jpg', 71),
(135, 'B Natural Nectar Orange Oomph 1000ML', 'productpool/BNATURAL NCT ORANGE OOMPH 1000ML.jpg', 71),
(136, 'B Natural Nectar Pineapple Poise1000ML', 'productpool/BNATURAL NCT PINEAPPLE POISE1000ML.jpg', 71),
(137, 'B Natural Nectar Masala Jamun 1000ML', 'productpool/BNATURAL NCT MASALA JAMUN 1000ML.jpg', 71),
(138, 'B Natural Nectar Pomegranate 1000ML', 'productpool/BNATURAL NECTAR POMEGRANATE 1000ML.jpg', 71),
(139, 'Yippee Classic Masala noodles 70GM', 'productpool/CLASSIC MASALA 70GM.jpg', 77),
(140, 'Yippee Magic Masala noodles70GM ', 'productpool/MAGIC MASALA 70GM.jpg', 77),
(141, 'Yippee My Madly Manchurian Noodles 60G ', 'productpool/MY MADLY MANCHURIAN ND 60G.jpg', 77),
(142, 'Yippee Mood Masala Noodles 70G ', 'productpool/MOOD MASALA NOODLES 70G.jpg', 77),
(143, 'Sunfeast Yippee Power Up Noodles', 'productpool/SF YIPPEE POWER UP NOODLES.jpg', 77),
(144, 'Yippee My Crazy Chow Noodles 60G', 'productpool/MY CRAZY CHOW ND 60G.jpg', 77),
(145, 'Yippee My Mystery Masala Noodles 60G', 'productpool/MY MYSTERY MASALA ND 60G.jpg', 77),
(146, 'Yippee My Truly Chicken Noodles 60G', 'productpool/MY TRULY CHICKEN ND 60G.jpg', 77),
(147, 'Yippee Magic Masala Noodles 140GM', 'productpool/MAGIC MASALA 140GM.jpg', 77),
(148, 'Yippee Classic Masala Noodles 280GM', 'productpool/CLASSIC MASALA 280GM.jpg', 77),
(149, 'Yippee Magic Masala Noodles 280GM', 'productpool/MAGIC MASALA 280GM.jpg', 77),
(150, 'Yippee Mood Masala Noodles 280G', 'productpool/MOOD MASALA NOODLES 280G.jpg', 77),
(151, 'Yippee Magic Masala Noodles 420GM', 'productpool/MAGIC MASALA 420GM.jpg', 77),
(152, 'Bingo Mad Achaari Masti Namkeen18G', 'productpool/MAD ACHAARI MASTI NAMKEEN 18G.jpg', 101),
(153, 'Bingo  Mad Angles Achaari', 'productpool/MAD ANGLES RS.5 ACHAARI.jpg', 101),
(154, 'Bingo Mad Angles Masala', 'productpool/ MAD ANGLES RS.5 MASALA.jpg', 101),
(155, 'Bingo  Mad Angles Peri Peri', 'productpool/MAD ANGLES RS 5 PERI PERI.jpg', 101),
(156, 'Bingo  Mad Angles Tomato', 'productpool/MAD ANGLES RS.5 TOMATO.jpg', 101),
(157, 'Bingo No Rulz Cheese Free Toy', 'productpool/NO RULZ RS.5 CHEESE FREE TOY.jpg', 101),
(158, 'Bingo No Rulz Masala Free Toy', 'productpool/NO RULZ RS.5 MASALA FREE TOY.jpg', 101),
(159, 'Bingo No Rulz Tomato Free Toy', 'productpool/NO RULZ  RS.5 TOMATO FREE TOY.jpg', 101),
(160, 'Bingo Tangles Masala 18G', 'productpool/BINGO! TANGLES MASALA 18G.jpg', 101),
(161, 'Bingo Tangles Cheese', 'productpool/BINGO! TANGLES CHEESE.jpg', 101),
(162, 'Bingo Tangles Tomato 18G', 'productpool/BINGO! TANGLES TOMATO 18G.jpg', 101),
(163, 'Bingo Yumitos Cream and Onion 12g', 'productpool/YUMITOS Rs.5 Cream & Onion 12g.jpg', 101),
(164, 'Bingo Yumitos Masala 12g', 'productpool/YUMITOS Rs.5 Masala 12g.jpg', 101),
(165, 'Bingo Yumitos Salted 12g', 'productpool/YUMITOS Rs.5 Salted 12g.jpg', 101),
(166, 'Bingo Yumitos Tomato 12g', 'productpool/YUMITOS Rs.5 Tomato 12g.jpg', 101),
(167, 'Bingo Yumitos Chilli Potato Chips 12g', 'productpool/YUMITOS Chilli Potato Chips 12g.jpg', 101),
(168, 'Bingo Yumitos Tomato and Chilli  12g', 'productpool/YUMITOS Tomato & Chilli PC 12g.jpg', 101),
(169, 'Bingo Mad Angles Achari', 'productpool/MAD ANGLES RS.10 ACHAARI.jpg', 101),
(170, 'Bingo Mad Angles Fillos', 'productpool/MAD ANGLES RS10 FILLOSI.jpg', 101),
(171, 'Bingo Mad Angles Masala', 'productpool/MAD ANGLES RS.10 MASALA.jpg', 101),
(172, 'Bingo Mad Angles Peri Peri', 'productpool/MAD ANGLES RS 10 PERI PERI.jpg', 101),
(173, 'Bingo Mad Angles Tomato', 'productpool/MAD ANGLES RS.10 TOMATO.jpg', 101),
(174, 'Bingo Original Style Chilli', 'productpool/BINGO! ORIGINAL STYLE RS.10 CHILLI.jpg', 101),
(175, 'Bingo Original Style Salt', 'productpool/BINGO! ORIGINAL STYLE RS.10 SALT.jpg', 101),
(176, 'Bingo Mad Angles Masala', 'productpool/MAD ANGLES RS.20 MASALA.jpg', 101),
(177, 'Bingo Yumitos Cream and Onion 52g', 'productpool/YUMITOS Rs.20 Cream & Onion 52g.jpg', 101),
(178, 'Bingo Yumitos  Masala 52g', 'productpool/YUMITOS Rs.20 Masala 52g.jpg', 101),
(179, 'Bingo Yumitos Salted 52g', 'productpool/YUMITOS Rs.20 Salted 52g.jpg', 101),
(180, 'Bingo Yumitos Tomato 52g', 'productpool/YUMITOS Rs.20 Tomato 52g.jpg', 101),
(181, 'Bingo Original Style Chilli', 'productpool/BINGO! ORIGINAL STYLE RS.20 CHILLI.jpg', 101),
(182, 'Bingo Mad Angles Achaari', 'productpool/MAD ANGLES RS.20 ACHAARI.jpg', 101),
(183, 'Bingo Mad Angles Tomato', 'productpool/MAD ANGLES RS.20 TOMATO.jpg', 101),
(184, 'Bingo Original Style Salt', 'productpool/BINGO! ORIGINAL STYLE RS.20 SALT.jpg', 101),
(185, 'Bingo Tedhe Medhe Masala', 'productpool/TEDHE MEDHE RS.20 MASALA.jpg', 101),
(186, 'Bingo Chips Cream and Onion', 'productpool/BINGO! CHIPS RS.25 CRM&ON INSTI.jpg', 101),
(187, 'Vivel Body Wash Lavender Almond Oil 100ml', 'productpool/Vivel BW Lavender Almond Oil 100ml.jpg', 146),
(188, 'Vivel Body Wash Mint Cucumber 100ml', 'productpool/Vivel BW Mint Cucumber 100ml.jpg', 146),
(189, 'Fiama Ashwagandha and Almond Cream 100ml ', 'productpool/Fiama AG&AC Gel+Creme BW 100ml .jpg', 146),
(190, 'AASHIRVAD ATTA MP 1 KG', 'productPool/AASHIRVAD ATTA MP 1 KG.jpg', 33),
(191, 'AASHIRVAD MULTGRAIN ATTA 1KG', 'productPool/AASHIRVAD MULTGRAIN ATTA 1KG.jpg', 33),
(192, 'AASHIRVAD MULTGRAIN ATTA 1KG', 'productPool/AASHIRVAD MULTGRAIN ATTA 1KG.jpg', 33),
(193, 'AASHIRVAD SVASTI GHEE 100ML', 'productPool/AASHIRVAD SVASTI GHEE 100ML.jpg', 37),
(194, 'ABBIES PEANUT BUTTER CREAMY 510G', 'productPool/ABBIES PEANUT BUTTER CREAMY 510G.jpg', 98),
(195, 'ABBIES WHITE VINEGAR DISTILLED 473ML', 'productPool/ABBIES WHITE VINEGAR DISTILLED 473ML.jpg', 96),
(196, 'PEDIASURE CHOCOLATE 200G REFIL', 'productPool/PEDIASURE CHOCOLATE 200G REFIL.jpg', 66),
(197, 'ABBOTT PEDIASURE VANILA 200G PKT', 'productPool/ABBOTT PEDIASURE VANILA 200G PKT.jpg', 66),
(198, 'ACT II BUTTER POPCORN 35G', 'productPool/ACT II BUTTER POPCORN 35G.jpg', 101),
(199, 'ACT II MAGIC BUTTER POPCORN 30G', 'productPool/ACT II MAGIC BUTTER POPCORN 30G.jpg', 101),
(200, 'ACT II NACHOZ CHEESE 60G', 'productPool/ACT II NACHOZ CHEESE 60G.jpg', 101);
SET IDENTITY_INSERT productMaster OFF;

INSERT INTO product1 (price, shopId, productMasterId) VALUES
(280, 1, 1),
(350, 1, 2),
(240, 1, 3),
(588, 2, 4),
(305, 2, 5),
(128, 2, 6),
(70, 2, 7),
(40, 2, 8),
(62, 2, 9),
(33, 2, 10),
(583, 2, 11),
(611, 2, 12),
(1161, 2, 13),
(2839, 2, 14),
(172, 2, 15),
(160, 2, 16),
(94, 2, 17),
(94, 2, 18),
(94, 2, 19),
(141, 2, 20),
(32, 2, 21),
(96, 2, 22),
(51, 2, 23),
(212, 2, 24),
(44, 2, 25),
(24, 2, 26),
(19, 2, 27),
(24, 2, 28),
(179, 2, 29),
(66, 2, 30),
(111, 2, 31),
(76, 2, 32),
(221, 2, 33),
(14, 2, 34),
(94, 2, 35),
(207, 2, 36),
(156, 2, 37),
(142, 2, 38),
(72, 2, 39),
(88, 2, 40),
(118, 2, 41),
(212, 2, 42),
(113, 2, 43),
(78, 2, 44),
(10, 2, 45),
(10, 2, 46),
(10, 2, 47),
(15, 2, 48),
(19, 2, 49),
(33, 2, 50),
(47, 2, 51),
(47, 2, 52),
(35, 2, 53),
(60, 2, 54),
(123, 2, 55),
(47, 2, 56),
(398, 2, 57),
(73, 2, 58),
(19, 2, 59),
(34, 2, 60),
(82, 2, 61),
(10, 2, 62),
(65, 2, 63),
(65, 2, 64),
(66, 2, 65),
(26, 2, 66),
(26, 2, 67),
(26, 2, 68),
(32, 2, 69),
(28, 2, 70),
(59, 2, 71),
(57, 2, 72),
(54, 2, 73),
(61, 2, 74),
(104, 2, 75),
(5, 2, 76),
(5, 2, 77),
(10, 2, 78),
(5, 2, 79),
(10, 2, 80),
(10, 2, 81),
(10, 2, 82),
(10, 2, 83),
(10, 2, 84),
(10, 2, 85),
(10, 2, 86),
(10, 2, 87),
(29, 2, 88),
(38, 2, 89),
(38, 2, 90),
(29, 2, 91),
(29, 2, 92),
(29, 2, 93),
(29, 2, 94),
(29, 2, 95),
(57, 2, 96),
(27, 2, 97),
(47, 2, 98),
(47, 2, 99),
(94, 2, 100),
(24, 2, 101),
(24, 2, 102),
(33, 2, 103),
(32, 2, 104),
(63, 2, 105),
(117, 2, 106),
(273, 2, 107),
(67, 2, 108),
(179, 2, 109),
(179, 2, 110),
(179, 2, 111),
(179, 2, 112),
(179, 2, 113),
(179, 2, 114),
(179, 2, 115),
(179, 2, 116),
(188, 2, 117),
(188, 2, 118),
(188, 2, 119),
(188, 2, 120),
(188, 2, 121),
(188, 2, 122),
(188, 2, 123),
(19, 2, 124),
(19, 2, 125),
(19, 2, 126),
(19, 2, 127),
(19, 2, 128),
(19, 2, 129),
(94, 2, 130),
(94, 2, 131),
(94, 2, 132),
(94, 2, 133),
(94, 2, 134),
(94, 2, 135),
(94, 2, 136),
(103, 2, 137),
(104, 2, 138),
(12, 2, 139),
(12, 2, 140),
(15, 2, 141),
(15, 2, 142),
(15, 2, 143),
(15, 2, 144),
(15, 2, 145),
(17, 2, 146),
(22, 2, 147),
(43, 2, 148),
(43, 2, 149),
(52, 2, 150),
(63, 2, 151),
(5, 2, 152),
(5, 2, 153),
(5, 2, 154),
(5, 2, 155),
(5, 2, 156),
(5, 2, 157),
(5, 2, 158),
(5, 2, 159),
(5, 2, 160),
(5, 2, 161),
(5, 2, 162),
(5, 2, 163),
(5, 2, 164),
(5, 2, 165),
(5, 2, 166),
(5, 2, 167),
(5, 2, 168),
(10, 2, 169),
(10, 2, 170),
(10, 2, 171),
(10, 2, 172),
(10, 2, 173),
(10, 2, 174),
(10, 2, 175),
(19, 2, 176),
(19, 2, 177),
(19, 2, 178),
(19, 2, 179),
(19, 2, 180),
(19, 2, 181),
(19, 2, 182),
(19, 2, 183),
(19, 2, 184),
(19, 2, 185),
(24, 2, 186),
(38, 2, 187),
(38, 2, 188),
(52, 2, 189),
(58, 3, 190),
(64, 3, 191),
(64, 3, 192),
(66, 3, 193),
(350, 3, 194),
(175, 3, 195),
(295, 3, 196),
(295, 3, 197),
(20, 3, 198),
(10, 3, 199),
(30, 3, 200);