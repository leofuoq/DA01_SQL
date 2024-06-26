--Bài 1-- 
WITH A AS(SELECT FORMAT_DATE('%Y-%m',created_at) as year_month,
user_id,order_id, status 
from bigquery-public-data.thelook_ecommerce.orders
order by year_month)
SELECT year_month, count(user_id) as total_user, 
SUM(CASE WHEN status='Complete' THEN 1 else 0 END) as total_order_completed
FROM A
GROUP BY year_month
ORDER BY year_month

--Bài 2--
WITH A AS (SELECT FORMAT_DATE('%Y-%m',created_at) as year_month,
user_id,order_id, sale_price
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE created_at between '2019-01-01' and '2022-04-30' )

SELECT year_month, count(DISTINCT user_id) as distinct_users,
sum(sale_price)/count(order_id) AS average_order_value
FROM A
GROUP BY year_month
ORDER BY year_month
--Bài 3--
WITH A AS(select distinct first_name, last_name, gender, age,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY age) AS rank,
FROM bigquery-public-data.thelook_ecommerce.order_items as a
JOIN bigquery-public-data.thelook_ecommerce.users as b
ON a.user_id = b.id
WHERE a.created_at between '2019-01-01' and '2022-04-30'),
B AS(select distinct first_name, last_name, gender, age,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY age DESC) AS rank,
FROM bigquery-public-data.thelook_ecommerce.order_items as a
JOIN bigquery-public-data.thelook_ecommerce.users as b
ON a.user_id = b.id
WHERE a.created_at between '2019-01-01' and '2022-04-30'),
youngest AS(
SELECT distinct first_name, last_name, gender, age,
CASE WHEN rank = 1 Then 'youngest' END tag
FROM A),
oldest AS(
SELECT distinct first_name, last_name, gender, age,
CASE WHEN rank = 1 Then 'oldest' END tag
FROM B) 

(SELECT first_name, last_name, gender, age,tag FROM youngest WHERE tag ='youngest')
UNION ALL
(SELECT first_name, last_name, gender, age,tag FROM oldest WHERE tag ='oldest')
ORDER BY tag

--Bài 4--
WITH A AS(SELECT FORMAT_DATE('%Y-%m',created_at) as year_month,
a.id as product_id, a.name as product_name, ROUND(b.sale_price,2) as sales, ROUND(a.cost,2), ROUND(b.sale_price - a.cost,2) as profit1
FROM bigquery-public-data.thelook_ecommerce.products a
JOIN bigquery-public-data.thelook_ecommerce.order_items b
ON a.id = b.product_id
WHERE b.status = 'Complete'),
B AS(
SELECT year_month, product_id, sum(profit1) as profit
FROM A
GROUP BY year_month, product_id),
C AS(SELECT kaka.year_month, kaka.product_id, kaka.product_name, kaka.sales, haha.profit,
DENSE_RANK() OVER(PARTITION BY kaka.year_month ORDER BY profit DESC) as rank_per_month 
FROM A as kaka
JOIN B as haha
ON kaka.year_month = haha.year_month and kaka.product_id = haha.product_id)
SELECT * FROM C
WHERE rank_per_month <=5
order by year_month
--Bài 5--
WITH A AS(SELECT
CASE
  WHEN b.created_at between '2022-01-15' and '2022-02-15' THEN '15/1-15/2'
  WHEN b.created_at between '2022-02-15' and '2022-03-15' THEN '15/2-15/3'
  WHEN b.created_at between '2022-03-15' and '2022-04-15' THEN '15/3-15/4'
END year_month,
a.category as category, ROUND(b.sale_price,2) as sale
FROM bigquery-public-data.thelook_ecommerce.products a
JOIN bigquery-public-data.thelook_ecommerce.order_items b
ON a.id = b.product_id
WHERE b.status = 'Complete'
AND b.created_at between '2022-01-15' and '2022-04-15'),
B AS(
SELECT year_month, category, ROUND(sum(sale),2) as revenue
FROM A
GROUP BY year_month, category)
SELECT * FROM B
ORDER BY year_month

----
WITH A AS(SELECT FORMAT_DATE('%Y-%m',created_at) as year_month,
order_item.order_id ,
product.category as product_category,
order_item.sale_price,
product.cost
FROM bigquery-public-data.thelook_ecommerce.order_items order_item
JOIN bigquery-public-data.thelook_ecommerce.products product
ON order_item.product_id = product.id
WHERE order_item.status = 'Complete'),
B AS(
SELECT year_month, product_category, ROUND(sum(sale_price),2) as TPV, count(order_id) as TPO, 
ROUND(sum(cost),2) as total_cost
FROM A
GROUP BY year_month, product_category
ORDER BY year_month, product_category)
CREATE VIEW vw_ecommerce_analyst AS (
SELECT year_month, product_category, TPV,TPO,
ROUND((TPV - LAG(TPV) OVER(PARTITION BY product_category ORDER BY year_month))*100/LAG(TPV) OVER(PARTITION BY product_category ORDER BY year_month),2) ||' '||'%'  AS Revenue_growth,
ROUND(( TPO - LAG(TPO) OVER(PARTITION BY product_category ORDER BY year_month))*100/LAG(TPO) OVER(PARTITION BY product_category ORDER BY year_month),2) ||' '||'%'  AS Order_growth,
total_cost, ROUND(TPV - total_cost,2) AS total_profit, 
ROUND((TPV - total_cost)/total_cost,2) AS Profit_to_cost_ratio
FROM B) -- lệnh create view k chạy được phải tự làm bằng tay--
/* III
1) Sử dụng câu lệnh SQL để tạo ra 1 dataset như mong muốn và lưu dataset đó vào VIEW đặt tên là vw_ecommerce_analyst
*/

With category_data as
(
Select 
FORMAT_DATE('%Y-%m', t1.created_at) as Month,
FORMAT_DATE('%Y', t1.created_at) as Year,
t2.category as Product_category,
round(sum(t3.sale_price),2) as TPV,
count(t3.order_id) as TPO,
round(sum(t2.cost),2) as Total_cost
from bigquery-public-data.thelook_ecommerce.orders as t1 
Join bigquery-public-data.thelook_ecommerce.products as t2 on t1.order_id=t2.id 
Join bigquery-public-data.thelook_ecommerce.order_items as t3 on t2.id=t3.id
Group by Month, Year, Product_category
)
Select Month, Year, Product_category, TPV, TPO,
round(cast((TPV - lag(TPV) OVER(PARTITION BY Product_category ORDER BY Year, Month))
      /lag(TPV) OVER(PARTITION BY Product_category ORDER BY Year, Month) as Decimal)*100.00,2) || '%'
       as Revenue_growth,
round(cast((TPO - lag(TPO) OVER(PARTITION BY Product_category ORDER BY Year, Month))
      /lag(TPO) OVER(PARTITION BY Product_category ORDER BY Year, Month) as Decimal)*100.00,2) || '%'
       as Order_growth,
Total_cost,
round(TPV - Total_cost,2) as Total_profit,
round((TPV - Total_cost)/Total_cost,2) as Profit_to_cost_ratio
from category_data
Order by Product_category, Year, Month

/* 
2) Cohort chart
*/
With a as
(Select user_id, amount, FORMAT_DATE('%Y-%m', first_purchase_date) as cohort_month,
created_at,
(Extract(year from created_at) - extract(year from first_purchase_date))*12 
  + Extract(MONTH from created_at) - extract(MONTH from first_purchase_date) +1
  as index
from 
(
Select user_id, 
round(sale_price,2) as amount,
Min(created_at) OVER (PARTITION BY user_id) as first_purchase_date,
created_at
from bigquery-public-data.thelook_ecommerce.order_items 
) as b),
cohort_data as
(
Select cohort_month, 
index,
COUNT(DISTINCT user_id) as user_count,
round(SUM(amount),2) as revenue
from a
Group by cohort_month, index
ORDER BY INDEX
),
--CUSTOMER COHORT-- 
Customer_cohort as
(
Select 
cohort_month,
Sum(case when index=1 then user_count else 0 end) as m1,
Sum(case when index=2 then user_count else 0 end) as m2,
Sum(case when index=3 then user_count else 0 end) as m3,
Sum(case when index=4 then user_count else 0 end) as m4
from cohort_data
Group by cohort_month
Order by cohort_month
),
--RETENTION COHORT--
retention_cohort as
(
Select cohort_month,
round(100.00* m1/m1,2) || '%' as m1,
round(100.00* m2/m1,2) || '%' as m2,
round(100.00* m3/m1,2) || '%' as m3,
round(100.00* m4/m1,2) || '%' as m4
from customer_cohort
)
--CHURN COHORT--
Select cohort_month,
(100.00 - round(100.00* m1/m1,2)) || '%' as m1,
(100.00 - round(100.00* m2/m1,2)) || '%' as m2,
(100.00 - round(100.00* m3/m1,2)) || '%' as m3,
(100.00 - round(100.00* m4/m1,2))|| '%' as m4
from customer_cohort
