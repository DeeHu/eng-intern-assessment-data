-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT *
FROM Products
JOIN Categories ON Products.category_id = Categories.category_id
WHERE Categories.category_name = "Sports";


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT U.user_id, U.username, COUNT(Orders.order_id) AS total_orders_number
FROM Users U
LEFT JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT P.product_id, P.product_name, AVG(R.rating) AS average_rating
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
GROUP BY P.product_id;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT U.user_id, U.username, SUM(P.amount) AS total_spent
FROM Users U
LEFT JOIN Orders O ON U.user_id = O.user_id
LEFT JOIN Payments P on O.order_id = P.order_id
GROUP BY U.user_id
ORDER BY total_spent DESC
LIMIT 5;