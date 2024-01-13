-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT C.category_id, C.category_name, SUM(OI.quantity * OI.unit_price) AS total_sales
FROM Categories C
JOIN Products P ON C.category_id = P.category_id
JOIN Order_Items OI ON P.product_id = OI.product_id
GROUP BY C.category_id, C.category_name
ORDER BY total_sales DESC
LIMIT 3;



-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P1 ON OI.product_id = P1.product_id
JOIN Categories C1 ON P1.category_id = C1.category_id
WHERE C1.category_name = 'Toys & Games'
GROUP BY U.user_id, U.username
HAVING COUNT(DISTINCT P1.product_id) = (
    SELECT COUNT(DISTINCT P2.product_id)
    FROM Products P2
    JOIN Categories C2 ON P2.category_id = C2.category_id
    WHERE C2.category_name = 'Toys & Games'
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
-- Subquery to find the highest price in each category
WITH MaxPricePerCategory AS (
    SELECT 
        category_id, 
        MAX(price) AS max_price
    FROM Products
    GROUP BY category_id
)

SELECT 
    P.product_id, 
    P.product_name, 
    P.category_id, 
    P.price
FROM Products P
INNER JOIN MaxPricePerCategory MPC ON P.category_id = MPC.category_id
WHERE P.price = MPC.max_price;



-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ConsecutiveOrders AS (
    SELECT
        o.user_id,
        o.order_date,
        LEAD(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) as next_order_date
    FROM Orders o
)
SELECT DISTINCT
    u.user_id,
    u.username
FROM Users u
JOIN ConsecutiveOrders co ON u.user_id = co.user_id
WHERE DATEDIFF(co.next_order_date, co.order_date) = 1
AND EXISTS (
    SELECT 1
    FROM ConsecutiveOrders co2
    WHERE co2.user_id = co.user_id
    AND (
        DATEDIFF(co2.order_date, co.order_date) = 2
        OR DATEDIFF(co2.order_date, co.order_date) = -2
    )
);





