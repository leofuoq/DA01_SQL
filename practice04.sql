--Bài 1--
SELECT 
sum(
CASE
  WHEN device_type = 'laptop' THEN 1
  else 0
END) AS laptop_views,
sum(
CASE
  WHEN device_type in ('tablet','phone') THEN 1
  else 0
END) AS mobile_views
FROM viewership

--Bài 2--
SELECT x,y,z,
CASE 
    WHEN x + y - z > 0 and x + z - y > 0 and y + z - x > 0 THEN 'Yes'
    ELSE 'No'
END triangle
FROM Triangle 

--Bài 3-- bai nay chay deo duoc
SELECT 
ROUND(sum(CASE
WHEN call_category = 'n/a' AND call_category is null then 1
END)*100/count(case_id),1) as call_percentage
FROM callers

--Bài 4--
SELECT name FROM Customer
WHERE coalesce(referee_id,'1') != 2

--Bài 5--
select survived,
SUM(
CASE
    WHEN pclass = '1' AND survived in ('1','0') THEN 1
    ELSE 0
END) AS first_class,
SUM(
CASE
    WHEN pclass = '2' AND survived in ('1','0') THEN 1
    ELSE 0
END) AS second_classs,
SUM(
CASE
    WHEN pclass = '3' AND survived in ('1','0') THEN 1
    ELSE 0
END) AS third_class
FROM titanic
GROUP BY survived
