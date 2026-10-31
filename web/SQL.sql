CREATE TABLE Users (
    user_id VARCHAR(6) NOT NULL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(20) NOT NULL,
    ic VARCHAR(14) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contact_number VARCHAR(12),
    role VARCHAR(10) NOT NULL CHECK (role IN ('customer', 'staff', 'manager')),
    security_question VARCHAR(100) NOT NULL,
    security_answer VARCHAR(100) NOT NULL
);

-- Create Customer table (extends User)
CREATE TABLE Customer (
    user_id VARCHAR(6) NOT NULL PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create Staff table (extends User)
CREATE TABLE Staff (
    user_id VARCHAR(6) NOT NULL PRIMARY KEY,
    hired_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create Manager table (extends User)
CREATE TABLE Manager (
    user_id VARCHAR(6) NOT NULL PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Insert Manager
INSERT INTO Users VALUES 
('MA0001', 'aliciaNg131', 'Aa0011', '990223-03-1788', 'aliciaNg@opticare.com', '0123456789', 'manager', 'Hello' , 'World'),
('MA0002', 'rachelWong67', 'rW4453', '970803-10-1228', 'rachelWong@opticare.com', '0189956744', 'manager', 'Nice to meet' , 'not nice');

INSERT INTO Manager VALUES 
('MA0001'),
('MA0002');

-- Insert Staff
INSERT INTO Users VALUES 
('ST0001', 'jasonLiu', 'JSliu2477', '001128-06-3448', 'jsaonLiu@opticare.com', '0189906755', 'staff', 'My favourite book' , 'Mr Jhon'),
('ST0002', 'buddyLyn', 'budLyn3838', '021210-09-1322', 'buddyLyn@opticare.com', '0134476755', 'staff', 'Today is' , 'Nice');

INSERT INTO Staff VALUES 
('ST0001', '2014-01-23', 2500.00),
('ST0002', '2014-01-10', 2500.00);

-- Insert Customers
INSERT INTO Users VALUES 
('CU0001', 'wongYuan1121', 'wy8900q', '120315-03-3898', 'winy77@gmail.com', '0198894577', 'customer', 'my favorite movie' , 'none'),
('CU0002', 'limErn222', 'ler8955', '040719-01-3128', 'lern566@gmail.com', '0177756433', 'customer', 'my best friends' , 'wong');

INSERT INTO Customer VALUES 
('CU0001'),
('CU0002');


-- Insert Category
INSERT INTO Category VALUES
('CA0001', 'Adults');
INSERT INTO Category VALUES
('CA0002', 'Kids');
INSERT INTO Category VALUES
('CA0003', 'Lenses');
INSERT INTO Category VALUES
('CA0004', 'Sunglasses');


-- Product table
CREATE TABLE Product (
    product_id VARCHAR(6) NOT NULL PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL UNIQUE,
    product_description VARCHAR(80) NOT NULL,
    image BLOB,
    quantity INTEGER NOT NULL,
    price DOUBLE NOT NULL,
    category_id VARCHAR(6) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
);

-- Insert Product 1
INSERT INTO Product VALUES
('PR0001', 'ONXY','Stylish multicolor frame (black and transparent)', NULL, 100, 200.00, 'CA0001' );


-- Cart table
CREATE TABLE Cart (
    cart_id VARCHAR(6) PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'IN_CART',
    user_id VARCHAR(6) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Cart item table
CREATE TABLE CartItem (
    cart_item_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    cart_id VARCHAR(6) NOT NULL, 
    product_id VARCHAR(6),  
    quantity INT, 
    price DECIMAL(10,2),  
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);


-- Order table
CREATE TABLE Orders (
    order_id VARCHAR(6) PRIMARY KEY,
    cart_id VARCHAR(6) NOT NULL,
    user_id VARCHAR(6) NOT NULL,
    total_amount DOUBLE NOT NULL,
    order_status VARCHAR(10) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    shipping_address VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id)
);


-- Payment table
CREATE TABLE Payment (
    payment_id VARCHAR(6) PRIMARY KEY,
    payment_method VARCHAR(20) NOT NULL,
    delivery_fees DECIMAL(10,2) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    shipping_address VARCHAR(100) NOT NULL, 
    total_amount DECIMAL(10,2) NOT NULL,
    card_type VARCHAR(20),
    card_name VARCHAR(50),
    card_number VARCHAR(20), 
    ewallet_type VARCHAR(20),
    ewallet_phone VARCHAR(20),
    status VARCHAR(20),
    order_id VARCHAR(6),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


-- Promotion table
CREATE TABLE Promotion (
    promo_id VARCHAR(6) PRIMARY KEY, 
    image_name VARCHAR(255),
    promo_text VARCHAR(255)
);


INSERT INTO Promotion (promo_id, image_name, promo_text)
VALUES 
('P001', 'PromotionImage1.png', 'Flash Sale Alert!
20% OFF on trending frames and lenses.
Hurry - limited time only!'),
('P002', 'PromotionImage2.png', 'Enjoy 25% OFF on all eyewear.
Terms & Conditions apply.'),
('P003', 'PromotionImage3.png', 'Celebrate Your Special Day with FOUR EYES!
Valid only in your birthday month. 
Terms & Conditions apply');


CREATE TABLE Rating (
    rating_id VARCHAR(6) PRIMARY KEY,
    product_id VARCHAR(6) NOT NULL,
    user_id VARCHAR(6) NOT NULL,
    rating_value INT NOT NULL CHECK (rating_value BETWEEN 1 AND 5),
    comment VARCHAR(500),
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);