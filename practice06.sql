-- BAI KHO QUA, CHO E XIN THEM MOT CHUT THOI GIAN NHE, TOI NAY A NGU SOM MAI TIET KTL ROI CHECK NHA, YEU ANH--
--Bài 1--
WITH list2 AS (
SELECT company_id	,title, description,count(company_id) 
FROM job_listings
GROUP BY company_id,title, description)
SELECT count(*) FROM list2
WHERE count >1

--Bài 2--
WITH app AS(
SELECT category, product, SUM(spend) AS total_spend 
FROM product_spend
WHERE category = 'appliance'
GROUP BY category, product
order  by  category, product DESC
limit 2),
elec AS(
SELECT category, product, SUM(spend) AS total_spend 
FROM product_spend
WHERE category = 'electronics'
GROUP BY category, product
order  by  category, product DESC
limit 2)
SELECT category, product, total_spend FROM app 
UNION SELECT category, product, total_spend FROM elec


--Bài 3--
WITH list AS (
SELECT policy_holder_id, COUNT(call_received) FROM callers 
GROUP BY policy_holder_id
HAVING COUNT(call_received) >= 3 )
SELECT COUNT(*) FROM list

--Bài 4--
SELECT a.page_id 
FROM pages AS a 
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
WHERE b.page_id IS NULL

--Bài 5-- 
WITH list AS(
SELECT EXTRACT(MONTH FROM event_date) AS month, user_id
FROM user_actions 
GROUP BY month, user_id)

SELECT b.month, count(b.user_id) AS monthly_active_users 
FROM list as a  JOIN list as b 
ON a.month = b.month -1 
AND a.user_id = b.user_id
WHERE b.month = 7
GROUP BY b.month
  
--Bài 6-- 
SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(id) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) as trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country

--Bài 7--
WITH firstY AS(
SELECT product_id , min(year) AS first_year 
FROM Sales 
GROUP BY product_id)
SELECT  a.product_id, b.first_year, a.quantity, a.price FROM Sales as a
JOIN firstY as b
USING(product_id)
WHERE a.year = b.first_year

--Bài 8--
SELECT customer_id FROM customer 
GROUP BY customer_id
HAVING COUNT(distinct product_key ) = (SELECT count(*) FROM product)

--Bài 9--
SELECT employee_id FROM Employees 
WHERE  salary <30000 
AND manager_id NOT IN (SELECT employee_id FROM Employees )
ORDER BY employee_id

--Bài 10--
WITH list2 AS (
SELECT company_id	,title, description,count(company_id) 
FROM job_listings
GROUP BY company_id,title, description)
SELECT count(*) FROM list2
WHERE count >1

--Bài 11-- 
WITH listCus AS (
SELECT distinct user_id, count(movie_id),user.name as name from MovieRating JOIN Users as user USING(user_id)
GROUP BY user_id 
ORDER BY count(movie_id) DESC, user.name
limit 1),
list_id AS (SELECT distinct movie_id, avg(rating), movie.title as title FROM MovieRating  JOIN Movies as movie using(movie_id) 
WHERE DATE_FORMAT(created_at, '%Y-%m') = '2020-02'
GROUP BY movie_id
ORDER BY AVG(rating) DESC, movie.title  
limit 1)
(SELECT name as results from listCus)
UNION ALL
(SELECT title  FROM list_id)
  
--Bài 12--
WITH list AS ((SELECT requester_id AS id FROM RequestAccepted)
UNION ALL (SELECT accepter_id FROM RequestAccepted))
SELECT id, COUNT(id) AS num FROM list
GROUP BY id
ORDER BY COUNT(id) DESC LIMIT 1
