create database if not exists Walmart_Sales_Analysis;

use walmart_sales_analysis;
create table if not exists Walmart_Sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) Not null,
    city varchar(30) Not Null,
    customer_type varchar(30) not null,
    gender varchar (10)not null,
    product_line varchar(100) not null,
    unit_price decimal (10,2) not null,
    quantity int not null,
    vat float not null,
    total decimal (12, 4) not null,
    date datetime not null,
    time Time not null,
    payment_method varchar(15),
    cogs decimal (10, 2),
    Gross_margin_pct float ,
    gross_income decimal(12, 4) not null,
    rating float 
    ); 

   select * from Walmart_Sales;

-- -----------------------------------------------------------------------------------------------
-- -------------------------------Feature Engineering---------------------------------------------

-- Time of Day

select 
	time,
    (case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
    end) as Time_of_date
from walmart_sales;

Alter table walmart_sales add column time_of_day varchar(20);

update walmart_sales
set Time_of_Day = (
case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
end
);

-- Day Name
select 
	date,
    dayname(date)
from walmart_sales;

alter table walmart_sales add column Day_Name varchar (10);

update walmart_sales
set Day_name = (dayname(date));

-- Month Name
select 
	date,
    monthname(date)
from walmart_sales;

alter table walmart_sales add column month_name varchar (10);

update walmart_sales
set month_name = (monthname(date));

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------

-- How many unique cities does the data have?
select
    count(distinct(city)) as Distinct_city
from walmart_sales;

-- In which city is each branch?

select distinct(Branch)
from walmart_sales;

select 
	distinct(City),
	branch
from walmart_sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------

-- 1. How many unique product lines does the data have?
select 
	distinct(product_line)
from walmart_sales;

-- 2. What is the most common payment method?
select payment_method, count(payment_method) as used_payment_method
from walmart_sales 
group by payment_method
order by used_payment_method desc;


-- 3. What is the most selling product line?
select product_line, count(product_line) as selling_Product
from walmart_sales
group by product_line
order by selling_product desc;

-- 4. What is the total revenue by month?
select
	month_name,
    sum(total) as total_revenue
from walmart_sales
group by month_name
order by total_revenue desc;

-- 5.What month had the largest COGS?
select
	month_name,
    sum(cogs) as Month_Cogs
from walmart_sales
group by month_name
order by month_cogs;

-- 6. What product line had the largest revenue?
select 
	product_line,
    sum(total) as Total_Revenue
from walmart_sales
group by product_line
order by total_revenue desc;

-- 7. What is the city with the largest revenue?
select 
	city,
    sum(total) as Total_Revenue
from walmart_sales
group by city
order by total_revenue desc;

-- 8. What product line had the largest VAT?
select 
	product_line,
    avg(vat) as avg_vat
from walmart_sales
group by product_line
order by avg_vat desc; -- home and lifestyle have high vat whereas fashion and accessories have low vat

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM walmart_sales;

select 
	product_line,
	case
	 when AVG(quantity) > 6 then "Good"
	 else "Bad"
	end as Remark
from walmart_sales
group by product_line;

-- 10. Which branch sold more products than average product sold?
select avg(quantity) from walmart_sales;
select branch,
	sum(quantity)
from walmart_sales
group by branch
having sum(quantity) > (select avg(quantity) from walmart_sales);

-- 11. What is the most common product line by gender?
select 
	gender,
	product_line,
    count(product_line) as cnt
from walmart_sales
group by gender, product_line
order by cnt;

-- 12. What is the average rating of each product line?
select product_line, round(avg(rating), 2) as avg_rating
from walmart_sales
group by product_line
order by avg_rating desc;  

-- -- --------------------------------------------------------------------
-- ------------------------------ Sales -----------------------------------

-- 1. Number of sales made in each time of the day per per day
select 
	time_of_day,
	count(*)
from walmart_sales
group by time_of_day;

-- 2. Which of the customer types brings the most revenue?
select customer_type,
	round(sum(total), 2) as Total_Revenue
from walmart_sales
group by customer_type
order by total_revenue desc;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,
	round(avg(vat), 2) as Vat
from walmart_sales
group by city
order by vat desc;

-- 4. Which customer type pays the most in VAT?
select customer_type,
	round(avg(vat), 2) as Vat
from walmart_sales
group by customer_type
order by vat desc;

-- -- --------------------------------------------------------------------
-- ------------------------------ Customer -------------------------------
-- 1. How many unique customer types does the data have?
select distinct(customer_type)
from walmart_sales;

-- 2. How many unique payment methods does the data have?
select distinct(payment_method)
from walmart_sales;

-- 3. What is the most common customer type?
select 
	customer_type,
	count(*) as cnt
from walmart_sales
group by customer_type
order by cnt desc;

-- 4. Which customer type buys the most?
select 
	customer_type,
	count(*) as cnt
from walmart_sales
group by customer_type;


-- 5. What is the gender of most of the customers?
select 
	gender,
	count(*) as cnt
from walmart_sales
group by gender;

-- 6. What is the gender distribution per branch?
select branch,
	gender,
count(*)
from walmart_sales
group by branch, gender
order by branch;

-- 7. Which time of the day do customers give most ratings?
select 
	time_of_day,
	Round(avg(rating),2) as rating
from walmart_sales
group by time_of_day
order by rating desc;


-- 8. Which time of the day do customers give most ratings per branch?
select 
    time_of_day,
	Round(avg(rating),2) as rating
from walmart_sales
where branch = "a"
group by time_of_day
order by rating desc;


-- 9. Which day fo the week has the best avg ratings?

select day_name,
	avg(rating) as avg_rating
from walmart_sales
group by day_name
order by avg_rating desc;



-- 10. Which day of the week has the best average ratings per branch?
select day_name,
	avg(rating) as avg_rating
from walmart_sales
where branch = "A"
group by day_name
order by avg_rating desc;