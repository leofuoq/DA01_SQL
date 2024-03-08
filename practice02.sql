--Bài 1--
select distinct city from station
where id % 2 = 0

--Bài 2--
select distinct count(city) - count(distinct city) from station

--Bài 3--
  Dạy đi
--Bài 4--
select sum(item_count)/sum(order_occurrences) as mean FROM items_per_order

--Bài 5--
SELECT distinct candidate_id FROM candidates
where skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING count(skill) = 3

--Bài 6--
SELECT user_id,
date(max(post_date)) - date(min(post_date)) as days_between 
FROM posts
WHERE post_date BETWEEN '2020-12-31' and '2022-01-31'
GROUP BY user_id
having count(post_id) >1

--Bài 7--
SELECT card_name,  max(issued_amount) - min(issued_amount) as difference
FROM monthly_cards_issued
Group by card_name
ORDER BY difference DESC

--Bài 8--
SELECT manufacturer, 
count(product_id), abs(sum(cogs - total_sales)) as total_loss
FROM pharmacy_sales
where cogs > total_sales
GROUP BY manufacturer
order by total_loss DESC

--Bài 9--
select id, movie, description, rating 
from Cinema
where id % 2 <>0 and description <> 'Boring'
order by rating desc

--Bài 10--
select teacher_id, count(distinct subject_id ) as cnt 
from Teacher
group by teacher_id

--Bài 11--
select user_id, count(follower_id) as followers_count
from Followers 
group by user_id

--Bài 12--
select class
from courses
group by class
having count(student) >=5
