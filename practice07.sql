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
WITH A AS(SELECT transaction_id, merchant_id, credit_card_id, amount,
EXTRACT( HOUR FROM LEAD(transaction_timestamp) over( PARTITION BY merchant_id ORDER BY transaction_timestamp) - transaction_timestamp)*60
+ EXTRACT( minute FROM LEAD(transaction_timestamp) over( PARTITION BY merchant_id ORDER BY transaction_timestamp) - transaction_timestamp) as minute
FROM transactions)
SELECT COUNT(*) 
FROM A
WHERE minute <10

--Bài 7--
WITH A AS (SELECT category, product, sum(spend) as total_spend,
RANK() OVER(PARTITION BY category ORDER BY sum(spend) DESC) AS rank,
EXTRACT(YEAR FROM transaction_date) AS year
FROM product_spend
GROUP BY category, product, year)

SELECT category, product, total_spend FROM A
WHERE rank IN (1,2)
ORDER BY category, total_spend DESC

--Bài 8--
WITH A AS
(SELECT artist_name, count(rank) as count_song,
DENSE_RANK() OVER(ORDER BY count(rank) DESC) AS artist_rank
FROM artists as at JOIN songs as s USING(artist_id)
JOIN global_song_rank AS rank USING (song_id)
WHERE rank.rank <= 10
GROUP BY artist_name)
SELECT artist_name, artist_rank 
FROM A
WHERE artist_rank <6
ORDER BY artist_rank 
