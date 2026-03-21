CREATE TABLE User (
user_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
email VARCHAR(255) UNIQUE NOT NULL,
password VARCHAR(255) NOT NULL,
role VARCHAR(50) NOT NULL,
admin BOOLEAN DEFAULT FALSE,
end_user BOOLEAN DEFAULT TRUE
);

CREATE TABLE Category (
category_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL
);

CREATE TABLE SubCategory (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
category_id INT NOT NULL,
FOREIGN KEY (category_id) REFERENCES Category(category_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE Item (
item_id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(255) NOT NULL,
description TEXT,
condition VARCHAR(100),
subcategory_id INT,
FOREIGN KEY (subcategory_id) REFERENCES SubCategory(id)
ON DELETE SET NULL
ON UPDATE CASCADE
);

CREATE TABLE Auction (
auction_id INT PRIMARY KEY AUTO_INCREMENT,
item_id INT NOT NULL,
start_price DECIMAL(10, 2) NOT NULL,
reserve_price DECIMAL(10, 2),
start_time DATETIME NOT NULL,
end_time DATETIME NOT NULL,
bid_increment DECIMAL(10, 2) NOT NULL DEFAULT 1.00,
status VARCHAR(50) NOT NULL DEFAULT 'active',
FOREIGN KEY (item_id) REFERENCES Item(item_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CHECK (start_price > 0),
CHECK (reserve_price IS NULL OR reserve_price >= start_price),
CHECK (end_time > start_time),
CHECK (bid_increment > 0)
);

CREATE TABLE Bid (
bid_id INT PRIMARY KEY AUTO_INCREMENT,
auction_id INT NOT NULL,
user_id INT NOT NULL,
amount DECIMAL(10, 2) NOT NULL,
bid_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (auction_id) REFERENCES Auction(auction_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CHECK (amount > 0)
);

CREATE TABLE AutoBid (
auction_id INT NOT NULL,
user_id INT NOT NULL,
max_amount DECIMAL(10, 2) NOT NULL,
PRIMARY KEY (auction_id, user_id),
FOREIGN KEY (auction_id) REFERENCES Auction(auction_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CHECK (max_amount > 0)
);

CREATE TABLE Alert (
alert_id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT NOT NULL,
subcategory_id INT,
keywords TEXT,
min_price DECIMAL(10, 2),
max_price DECIMAL(10, 2),
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (subcategory_id) REFERENCES SubCategory(id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CHECK (min_price IS NULL OR min_price >= 0),
CHECK (max_price IS NULL OR max_price >= 0),
CHECK (min_price IS NULL OR max_price IS NULL OR max_price >= min_price)
);

CREATE TABLE watches (
user_id INT NOT NULL,
alert_id INT NOT NULL,
PRIMARY KEY (user_id, alert_id),
FOREIGN KEY (user_id) REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (alert_id) REFERENCES Alert(alert_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE sets (
user_id INT NOT NULL,
auction_id INT NOT NULL,
PRIMARY KEY (user_id, auction_id),
FOREIGN KEY (user_id) REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (auction_id) REFERENCES AutoBid(auction_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE sells (
user_id INT NOT NULL,
item_id INT NOT NULL,
PRIMARY KEY (user_id, item_id),
FOREIGN KEY (user_id) REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (item_id) REFERENCES Item(item_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE places (
user_id INT NOT NULL,
bid_id INT NOT NULL,
PRIMARY KEY (user_id, bid_id),
FOREIGN KEY (user_id) REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (bid_id) REFERENCES Bid(bid_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE filters (
alert_id INT NOT NULL,
subcategory_id INT NOT NULL,
PRIMARY KEY (alert_id, subcategory_id),
FOREIGN KEY (alert_id) REFERENCES Alert(alert_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (subcategory_id) REFERENCES SubCategory(id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE groups (
subcategory_id INT NOT NULL,
item_id INT NOT NULL,
PRIMARY KEY (subcategory_id, item_id),
FOREIGN KEY (subcategory_id) REFERENCES SubCategory(id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (item_id) REFERENCES Item(item_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE has (
subcategory_id INT NOT NULL,
category_id INT NOT NULL,
PRIMARY KEY (subcategory_id, category_id),
FOREIGN KEY (subcategory_id) REFERENCES SubCategory(id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (category_id) REFERENCES Category(category_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE listedin (
item_id INT NOT NULL,
auction_id INT NOT NULL,
PRIMARY KEY (item_id, auction_id),
FOREIGN KEY (item_id) REFERENCES Item(item_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (auction_id) REFERENCES Auction(auction_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE includes (
auction_id INT NOT NULL,
bid_id INT NOT NULL,
PRIMARY KEY (auction_id, bid_id),
FOREIGN KEY (auction_id) REFERENCES Auction(auction_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (bid_id) REFERENCES Bid(bid_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE Question (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    question_text TEXT NOT NULL,
    answer_text TEXT,
    answered_by INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    answered_at DATETIME,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES User(user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (answered_by) REFERENCES User(user_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
