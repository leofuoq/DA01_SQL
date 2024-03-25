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
