-- Joining more than 2 tables

-- 1. Find order_id, name, and city by joining users and orders. 
SELECT t1.order_id,t2.name,t2.city 
FROM flipkart.orders t1
JOIN flipkart.users t2
on t1.user_id = t2.user_id 

-- 2.Find order_id, and product category by joining order_details and category 
-- Filtering Rows 
SELECT t1.order_id,t2.vertical
FROM flipkart.order_details t1
JOIN flipkart.category t2
on t1.category_id = t2.category_id 


-- 3.Find all the orders placed in Pune 
SELECT * FROM flipkart.users t1
JOIN flipkart.orders t2
ON t1.user_id = t2.user_id
WHERE city = 'pune'

-- 4.Find all orders under the Chairs category 
select * from flipkart.order_details t1
join flipkart.category t2
on t1.category_id = t2.category_id
where vertical = 'chairs'

-- Practice Questions
-- 1.Find all profitable orders 
SELECT t2.order_id,SUM(t1.profit)
FROM flipkart.order_details t1
JOIN flipkart.orders t2
ON t1.order_id = t2.order_id
GROUP BY order_id
HAVING SUM(t1.profit) > 0

-- 2.find the customer who has placed max number of orders
SELECT name,COUNT(*) AS num_orders FROM flipkart.orders t1
JOIN flipkart.users t2
ON t1.user_id = t2.user_id
GROUP BY t2.name
ORDER BY num_orders  DESC LIMIT 1

-- 3.find the most porfitable category

SELECT t2.vertical,SUM(profit) FROM flipkart.order_details t1
JOIN flipkart.category t2
ON t1.category_id = t2.category_id
GROUP BY t2.vertical
ORDER BY SUM(profit) ASC LIMIT 1

-- 4.Which is the most profitable state 
SELECT state,SUM(profit) FROM flipkart.orders t1
JOIN flipkart.order_details t2
ON t1.order_id = t2.order_id
JOIN flipkart.users t3
ON t1.user_id = t3.user_id
GROUP BY state
ORDER BY SUM(profit) DESC LIMIT 1

-- 5.find all categories with profit higher than 5000

SELECT t2.vertical,SUM(profit) FROM flipkart.order_details t1
JOIN flipkart.category t2
ON t1.category_id = t2.category_id
GROUP BY t2.vertical
HAVING SUM(profit) > 5000