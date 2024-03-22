--Bài 1--
SELECT EXTRACT(YEAR FROM transaction_date) as year, product_id,
spend as curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id ),
ROUND(((spend - LAG(spend) OVER(PARTITION BY product_id ORDER BY transaction_date))*100/LAG(spend) OVER(PARTITION BY product_id)),2) as yoy_rate
FROM user_transactions

--Bài 2--
WITH A AS( SELECT card_name, issued_amount, issue_month || '-' || issue_year as year
FROM monthly_cards_issued)
  
SELECT DISTINCT card_name, 
FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY year) as issued_amount
FROM A
ORDER BY issued_amount DESC

--Bài 3--
WITH A AS (
SELECT user_id, spend, transaction_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) as num  
FROM transactions)

SELECT user_id, spend, transaction_date
FROM A
WHERE num ='3'

--Bài 4--
WITH A AS (
SELECT product_id, user_id, spend, transaction_date,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS rank
FROM user_transactions)

SELECT transaction_date, user_id, count(*)
FROM A
WHERE rank = 1
GROUP BY transaction_date, user_id

--Bài 5--
WITH A AS(
SELECT user_id, tweet_date, tweet_count,
LAG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) as lag1,
LAG(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) as lag2
FROM tweets)

SELECT user_id, tweet_date,
CASE
  WHEN lag1 IS NULL THEN ROUND(tweet_count,2)
  WHEN lag1 IS NOT NULL AND lag2 IS NULL THEN ROUND(CAST((tweet_count + lag1) AS DECIMAL)/2,2)
  WHEN lag1 IS NOT NULL AND lag2 IS NOT NULL THEN ROUND(CAST((tweet_count + lag1 + lag2) AS DECIMAL)/3,2)
END rolling_avg_3d
FROM A

--Bài 6--
