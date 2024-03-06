--Bài 1--
select NAME from CITY
WHERE COUNTRYCODE = "USA" and POPULATION > 120000

--Bài 2--
select * from CITY 
where COUNTRYCODE = "JPN"

--Bài 3-- 
select city, state from STATION

--Bài 4--
select distinct city from station
where (city like "u%" or city like "e%" or
      city like "o%" or city like "a%" or city like "i%")

--Bài 5--
select distinct city from station
where (city like "%u" or city like "%e" or
      city like "%o" or city like "%a" or city like "%i")
            
--Bài 6-- 
select distinct city from station
where substr(city,1,1) not in ('u','e','o','a','i')

--Bai 7--
select name from employee order by name

--Bài 8--
select name from employee
where salary > 2000 and months < 10
order by employee_id

--Bài 9--
select product_id from products
where low_fats = 'Y' and recyclable = 'Y'

--Bài 10--
select name from customer
where referee_id is null or referee_id <> 2

--Bài 11--
select name, population, area from world
where area >= 3000000 or population >= 25000000

--Bài 12--
select distinct author_id as id from views
where author_id = viewer_id
order by author_id

--Bài 13--
SELECT part, assembly_step from parts_assembly 
where finish_date is null

--Bài 14--
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000

--Bài 15--
select distinct advertising_channel from uber_advertising
where money_spent > 100000
