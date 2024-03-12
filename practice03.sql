--Bài 1--
select name from students
where marks > 75
order by right(name,3), id

--Bài 2--
Select user_id, concat(upper(left(name,1)),lower(substr(name,2,length(name)-1)))  as name 
from users
order by user_id

--Bài 3--
SELECT manufacturer, '$' ||round(sum(total_sales)/1000000,0)||' million' as sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY sum(total_sales) DESC, manufacturer ASC

--Bài 4--
SELECT EXTRACT( month from submit_date) as mth,
product_id, round(avg(stars),2)
FROM reviews
GROUP BY EXTRACT( month from submit_date),product_id
ORDER BY mth, product_id

--Bài 5--
SELECT sender_id,count(message_id)
FROM messages
where sent_date BETWEEN '2022-07-31' and  '2022-09-01' 
GROUP BY sender_id
ORDER BY count(message_id) DESC
limit 2

--Bài 6--
select tweet_id from Tweets 
where length(content) > 15

--Bài 7--

--Bài 8--
select count(id) from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date) = 2022

--Bài 9--
select position('a' in first_name) from worker
where first_name = 'Amitah'

--Bài 10--
select substr(title,length(winery)+1,5)
from winemag_p2
where country ='Macedonia'
