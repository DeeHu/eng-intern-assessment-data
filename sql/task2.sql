-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
With AvgRatings AS (
    SELECT product_id, AVG(rating) AS average_rating
    FROM Reviews
    GROUP BY product_id
)

SELECT P.product_id, P.product_name, A.average_rating
FROM Products P
LEFT JOIN AvgRatings A ON P.product_id = A.product_id
WHERE A.average_rating = (
    SELECT MAX(average_rating) FROM AvgRatings
)

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
GROUP BY U.user_id
HAVING COUNT(DISTINCT P.category_id) = (SELECT COUNT(*) FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT DISTINCT U.user_id, U.username
FROM Users U
JOIN Orders O1 ON U.user_id = O1.user_id
WHERE EXISTS (
    SELECT 1
    FROM Orders O2
    WHERE O1.user_id = O2.user_id
    AND (O2.order_date = DATE_ADD(O1.order_date, INTERVAL 1 DAY)
         OR O1.order_date = DATE_ADD(O2.order_date, INTERVAL 1 DAY))
)
