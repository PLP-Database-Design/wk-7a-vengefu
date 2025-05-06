-- Create normalized tables

QUESTION 1

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

CREATE TABLE OrderProducts (
    OrderProductID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    Product VARCHAR(50) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert order data (assuming original table exists)
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM ProductDetail;

-- Insert split product data (SQL Server syntax)
INSERT INTO OrderProducts (OrderID, Product)
SELECT 
    OrderID,
    TRIM(value) AS Product
FROM ProductDetail
CROSS APPLY STRING_SPLIT(Products, ',');

-- Alternative for MySQL (without STRING_SPLIT):
/*
INSERT INTO OrderProducts (OrderID, Product) VALUES
    (101, 'Laptop'),
    (101, 'Mouse'),
    (102, 'Tablet'),
    (102, 'Keyboard'),
    (102, 'Mouse'),
    (103, 'Phone');
*/

QUESTION 2

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL UNIQUE
);

-- Create OrderItems junction table
CREATE TABLE OrderItems (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Populate Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName 
FROM OrderDetails;

-- Populate Products table
INSERT INTO Products (ProductName)
SELECT DISTINCT Product 
FROM OrderDetails;

-- Populate OrderItems table
INSERT INTO OrderItems (OrderID, ProductID, Quantity)
SELECT 
    od.OrderID,
    p.ProductID,
    od.Quantity
FROM OrderDetails od
JOIN Products p ON od.Product = p.ProductName;