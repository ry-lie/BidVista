INSERT INTO Category (name) VALUES
('Electronics'),
('Collectibles'),
('Fashion'),
('Home & Garden'),
('Sports & Outdoors');

INSERT INTO SubCategory (name, category_id) VALUES
('Smartphones', 1),
('Laptops', 1),
('Cameras', 1),
('Baseball Cards', 2),
('Vintage Toys', 2),
('Coins', 2),
('Mens Clothing', 3),
('Womens Clothing', 3),
('Furniture', 4),
('Tools', 4),
('Camping', 5),
('Fitness', 5);

INSERT INTO User (name, email, password, role, admin, end_user) VALUES
('John Smith', 'john.smith@auction.com', 'password123', 'buyer', FALSE, TRUE),
('Sarah Johnson', 'sarah.j@auction.com', 'secure456', 'seller', FALSE, TRUE),
('Mike Davis', 'mike.davis@auction.com', 'mike2024', 'buyer', FALSE, TRUE),
('Emily Wilson', 'emily.w@auction.com', 'emily789', 'seller', FALSE, TRUE),
('Admin User', 'admin@auction.com', 'admin123', 'administrator', TRUE, FALSE),
('Customer Rep', 'rep@auction.com', 'rep123', 'customer_representative', FALSE, FALSE),
('Support Agent', 'support@auction.com', 'support456', 'customer_representative', FALSE, FALSE);

INSERT INTO Item (title, description, condition, subcategory_id) VALUES
('iPhone 14 Pro Max 256GB', 'Latest Apple iPhone in excellent condition. Barely used for 3 months. Includes original box and charger.', 'Like New', 1),
('MacBook Pro M2 13-inch', 'Powerful laptop perfect for development and design. 16GB RAM, 512GB SSD. No scratches.', 'Very Good', 2),
('Canon EOS R6 Full Frame Camera', 'Professional mirrorless camera with 20.1MP sensor. Perfect for photography enthusiasts.', 'New', 3),
('1989 Ken Griffey Jr. Rookie Card', 'Mint condition Upper Deck rookie card. Professionally graded PSA 9.', 'Very Good', 4),
('Vintage 1950s Robot Toy', 'Rare collectible tin robot from Japan. Wind-up mechanism works perfectly.', 'Good', 5),
('American Silver Eagle Coin Set', 'Complete set from 2010-2020. All coins in protective cases.', 'New', 6);

INSERT INTO Auction (item_id, start_price, reserve_price, start_time, end_time, bid_increment, status) VALUES
(1, 800.00, 950.00, '2025-12-01 10:00:00', '2025-12-15 22:00:00', 25.00, 'active'),
(2, 1200.00, NULL, '2025-12-02 12:00:00', '2025-12-16 20:00:00', 50.00, 'active'),
(3, 2000.00, 2200.00, '2025-12-03 09:00:00', '2025-12-17 18:00:00', 100.00, 'active'),
(4, 50.00, 75.00, '2025-12-04 14:00:00', '2025-12-14 16:00:00', 5.00, 'active'),
(5, 150.00, NULL, '2025-12-05 11:00:00', '2025-12-18 21:00:00', 10.00, 'active'),
(6, 500.00, 600.00, '2025-12-06 08:00:00', '2025-12-20 19:00:00', 25.00, 'active');

INSERT INTO sells (user_id, item_id) VALUES
(2, 1),
(2, 2),
(4, 3),
(4, 4),
(2, 5),
(4, 6);

INSERT INTO listedin (item_id, auction_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

INSERT INTO Bid (auction_id, user_id, amount, bid_time) VALUES
(1, 1, 825.00, '2025-12-02 11:30:00'),
(1, 3, 850.00, '2025-12-03 14:20:00'),
(2, 1, 1250.00, '2025-12-03 16:45:00'),
(3, 1, 2100.00, '2025-12-04 10:15:00'),
(4, 3, 55.00, '2025-12-05 12:00:00'),
(4, 1, 60.00, '2025-12-05 15:30:00');

INSERT INTO places (user_id, bid_id) VALUES
(1, 1),
(3, 2),
(1, 3),
(1, 4),
(3, 5),
(1, 6);

INSERT INTO includes (auction_id, bid_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(4, 6);

INSERT INTO groups (subcategory_id, item_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

INSERT INTO has (subcategory_id, category_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 2),
(7, 3),
(8, 3),
(9, 4),
(10, 4),
(11, 5),
(12, 5);
