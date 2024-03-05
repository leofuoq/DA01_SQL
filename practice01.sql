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
            
