--Bài 1-- Đổi kiểu dữ liệu
alter table sales_dataset_rfm_prj alter column ordernumber type numeric using ordernumber::numeric;
alter table sales_dataset_rfm_prj alter column quantityordered  type numeric using quantityordered::numeric;
alter table sales_dataset_rfm_prj alter column priceeach  type numeric using priceeach::numeric;
alter table sales_dataset_rfm_prj alter column orderlinenumber  type numeric using orderlinenumber::numeric;
alter table sales_dataset_rfm_prj alter column sales  type numeric using sales::numeric;
alter table sales_dataset_rfm_prj alter column orderdate  type date using orderdate::date;
alter table sales_dataset_rfm_prj alter column msrp  type numeric using msrp::numeric;

--Bài 2-- Check null
SELECT * FROM sales_dataset_rfm_prj WHERE ORDERNUMBER IS NULL OR LENGTH(NULLIF(LTRIM(RTRIM(ORDERNUMBER)), '')) = 0;
SELECT * FROM sales_dataset_rfm_prj WHERE QUANTITYORDERED IS NULL OR LENGTH(NULLIF(LTRIM(RTRIM(QUANTITYORDERED)), '')) = 0;
SELECT * FROM sales_dataset_rfm_prj WHERE PRICEEACH IS NULL OR LENGTH(NULLIF(LTRIM(RTRIM(PRICEEACH)), '')) = 0;
SELECT * FROM sales_dataset_rfm_prj WHERE ORDERLINENUMBER IS NULL OR LENGTH(NULLIF(LTRIM(RTRIM(ORDERLINENUMBER)), '')) = 0;
SELECT * FROM sales_dataset_rfm_prj WHERE SALES IS NULL OR LENGTH(NULLIF(LTRIM(RTRIM(SALES)), '')) = 0;
SELECT * FROM sales_dataset_rfm_prj WHERE ORDERDATE IS NULL OR LENGTH(NULLIF(LTRIM(RTRIM(ORDERDATE)), '')) = 0;

--Bài 3--
--Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME.--
Alter table sales_dataset_rfm_prj add CONTACTLASTNAME varchar
Alter table sales_dataset_rfm_prj add CONTACTFIRSTNAME varchar

UPDATE sales_dataset_rfm_prj
SET CONTACTLASTNAME = SUBSTRING(
    CONTACTFULLNAME, 
    POSITION('-' IN CONTACTFULLNAME) + 1, 
    LENGTH(CONTACTFULLNAME) - POSITION('-' IN CONTACTFULLNAME)
)
UPDATE sales_dataset_rfm_prj
SET CONTACTFIRSTNAME = SUBSTRING(
    CONTACTFULLNAME,1, 
    POSITION('-' IN CONTACTFULLNAME)-1)

--Chuẩn hóa theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường--
UPDATE sales_dataset_rfm_prj
SET CONTACTFIRSTNAME = CONCAT(
    UPPER(SUBSTRING(CONTACTFIRSTNAME, 1, 1)), 
    LOWER(SUBSTRING(CONTACTFIRSTNAME, 2))
);

UPDATE sales_dataset_rfm_prj
SET CONTACTLASTNAME = CONCAT(
    UPPER(SUBSTRING(CONTACTLASTNAME, 1, 1)), 
    LOWER(SUBSTRING(CONTACTLASTNAME, 2))
);

--Bài 4--Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
--Tạo bảng--
Alter table sales_dataset_rfm_prj add QTR_ID varchar;
Alter table sales_dataset_rfm_prj add MONTH_ID varchar;
Alter table sales_dataset_rfm_prj add YEAR_ID varchar;
--Add dữ liệu--
UPDATE sales_dataset_rfm_prj
SET QTR_ID =
CASE
	WHEN EXTRACT(MONTH FROM orderdate) IN (1,2,3) THEN 1
	WHEN EXTRACT(MONTH FROM orderdate) IN (4,5,6) THEN 2
	WHEN EXTRACT(MONTH FROM orderdate) IN (7,8,9) THEN 3
	WHEN EXTRACT(MONTH FROM orderdate) IN (10,11,12) THEN 4
END 

UPDATE sales_dataset_rfm_prj
SET MONTH_ID = EXTRACT(MONTH FROM orderdate) 

UPDATE sales_dataset_rfm_prj
SET YEAR_ID = EXTRACT(YEAR FROM orderdate)

--Bài 5-- Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)
--Box plot--
WITH min_max AS (
SELECT (q1 - 1.5*iqr) as Min_value,
	   (q3 + 1.5*iqr) as Max_value
FROM (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) as Q1,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) as Q3,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) -  percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS iqr
from sales_dataset_rfm_prj) AS abc)

SELECT quantityordered from sales_dataset_rfm_prj
WHERE quantityordered > (select max_value from min_max)
OR quantityordered < (select min_value from min_max)
