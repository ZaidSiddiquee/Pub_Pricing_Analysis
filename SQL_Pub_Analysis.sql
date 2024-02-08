#Pub Pricing Analysis

#(I am a Pricing Analyst working for a pub chain called 'Pubs "R" Us'
# I  have been tasked with analysing the drinks prices and sales to gain a greater insight into how the pubs in your chain are performing.)

#Pubs Table
CREATE TABLE pubs (
pub_id INT PRIMARY KEY,
pub_name VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50)
);

INSERT INTO pubs (pub_id, pub_name, city, state, country)
VALUES
(1, 'The Red Lion', 'London', 'England', 'United Kingdom'),
(2, 'The Dubliner', 'Dublin', 'Dublin', 'Ireland'),
(3, 'The Cheers Bar', 'Boston', 'Massachusetts', 'United States'),
(4, 'La Cerveceria', 'Barcelona', 'Catalonia', 'Spain');

SELECT * FROM pubs;

# Beverages Table
CREATE TABLE beverages (
beverage_id INT PRIMARY KEY,
beverage_name VARCHAR(50),
category VARCHAR(50),
alcohol_content FLOAT,
price_per_unit DECIMAL(8, 2)
);

INSERT INTO beverages (beverage_id, beverage_name, category, alcohol_content, price_per_unit)
VALUES
(1, 'Guinness', 'Beer', 4.2, 5.99),
(2, 'Jameson', 'Whiskey', 40.0, 29.99),
(3, 'Mojito', 'Cocktail', 12.0, 8.99),
(4, 'Chardonnay', 'Wine', 13.5, 12.99),
(5, 'IPA', 'Beer', 6.8, 4.99),
(6, 'Tequila', 'Spirit', 38.0, 24.99);

SELECT * FROM beverages;

# Sales Table 
CREATE TABLE sales (
sale_id INT PRIMARY KEY,
pub_id INT,
beverage_id INT,
quantity INT,
transaction_date DATE,
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id),
FOREIGN KEY (beverage_id) REFERENCES beverages(beverage_id)
);
INSERT INTO sales (sale_id, pub_id, beverage_id, quantity, transaction_date)
VALUES
(1, 1, 1, 10, '2023-05-01'),
(2, 1, 2, 5, '2023-05-01'),
(3, 2, 1, 8, '2023-05-01'),
(4, 3, 3, 12, '2023-05-02'),
(5, 4, 4, 3, '2023-05-02'),
(6, 4, 6, 6, '2023-05-03'),
(7, 2, 3, 6, '2023-05-03'),
(8, 3, 1, 15, '2023-05-03'),
(9, 3, 4, 7, '2023-05-03'),
(10, 4, 1, 10, '2023-05-04'),
(11, 1, 3, 5, '2023-05-06'),
(12, 2, 2, 3, '2023-05-09'),
(13, 2, 5, 9, '2023-05-09'),
(14, 3, 6, 4, '2023-05-09'),
(15, 4, 3, 7, '2023-05-09'),
(16, 4, 4, 2, '2023-05-09'),
(17, 1, 4, 6, '2023-05-11'),
(18, 1, 6, 8, '2023-05-11'),
(19, 2, 1, 12, '2023-05-12'),
(20, 3, 5, 5, '2023-05-13');

SELECT * FROM sales;

# Rating Table
CREATE TABLE ratings ( 
rating_id INT PRIMARY KEY, 
pub_id INT, 
customer_name VARCHAR(50), 
rating FLOAT, 
review TEXT, 
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id) );

INSERT INTO ratings (rating_id, pub_id, customer_name, rating, review)
VALUES
(1, 1, 'John Smith', 4.5, 'Great pub with a wide selection of beers.'),
(2, 1, 'Emma Johnson', 4.8, 'Excellent service and cozy atmosphere.'),
(3, 2, 'Michael Brown', 4.2, 'Authentic atmosphere and great beers.'),
(4, 3, 'Sophia Davis', 4.6, 'The cocktails were amazing! Will definitely come back.'),
(5, 4, 'Oliver Wilson', 4.9, 'The wine selection here is outstanding.'),
(6, 4, 'Isabella Moore', 4.3, 'Had a great time trying different spirits.'),
(7, 1, 'Sophia Davis', 4.7, 'Loved the pub food! Great ambiance.'),
(8, 2, 'Ethan Johnson', 4.5, 'A good place to hang out with friends.'),
(9, 2, 'Olivia Taylor', 4.1, 'The whiskey tasting experience was fantastic.'),
(10, 3, 'William Miller', 4.4, 'Friendly staff and live music on weekends.');

select * from ratings;

SELECT * FROM pubs;
select * from beverages;
select * from sales;
select * from ratings;

# Q1.  How many pubs are located in each country??
SELECT country, count(pub_id) from pubs
group by country;

# Q2. What is the total sales amount for each pub, including the beverage price and quantity sold?
SELECT p.pub_name, sum(b.price_per_unit*s.quantity) as Total_Sales from pubs as p
join sales as s on p.pub_id = s.pub_id
join beverages as b on b.beverage_id = s.beverage_id
 group by p.pub_name;
 
# Q3. Which Pub has the heighest average rating?

SELECT p.pub_name, avg(r.rating) as Heighest_Ratings from pubs as p
join ratings as r
on p.pub_id = r.pub_id
group by p.pub_name
order by Heighest_Ratings  desc
limit 1;

# Q4. What are top 5 beverages by sales across all pubs?
SELECT b.beverage_name as Beverage_Name, sum(b.price_per_unit*s.quantity) as Total_sales
from beverages as b join sales as s
on b.beverage_id = s.beverage_id
group by Beverage_Name
order by Total_sales desc
limit 5;
# Total Number of Quantity per Beverage Name, Top 5
SELECT b.beverage_name as Beverage_Name, sum(s.quantity) as Quantity
from beverages as b join sales as s
on b.beverage_id = s.beverage_id
group by Beverage_Name
order by Quantity desc
limit 5;

# Q5. How many sales transaction occured on each date?
SELECT COUNT(sale_id), transaction_date from sales
group by transaction_date;

# Q6. Find the name of the someone that had cocktail and which pub they had it in?

SELECT r.customer_name as Name,  b.category, p.pub_name from ratings as r
join pubs as p  on r.pub_id = p.pub_id
join sales as s on s.pub_id = p.pub_id
join beverages as b on b.beverage_id = s.beverage_id
where b.category = "Cocktail";


SELECT * FROM pubs;
select * from beverages;
select * from sales;
select * from ratings;

# Q7. What is the average price per unit for each category of beverages excluding the category sprit?
SELECT category, avg(b.price_per_unit) as Avg_Price from beverages as b
 group by category
having category != "Spirit";
#or
SELECT AVG(price_per_unit) as Avg_price, category
from beverages
where category in ("Beer", "Whiskey","Cocktail","Wine","Beer")
group by  category;
 
# Q8. Which pubs have a rating higher than the avarage rating of all pubs?
 
SELECT p.pub_name, round(avg(r.rating),1) as avg_rating from 
pubs as p join ratings as r
on p.pub_id = r.pub_id
where r.rating > (select avg(rating) from ratings)
group by p.pub_name;



SELECT * FROM pubs;
select * from beverages;
select * from sales;
select * from ratings;



# Q9. What is the running total of sales amount for each pub, orderd by the transaction date
with table2 as 
(SELECT p.pub_id, (b.price_per_unit*s.quantity) as Sales, s.transaction_date
from pubs as p join sales as s on p.pub_id = s.pub_id
join beverages as b on s.beverage_id = b.beverage_id)
SELECT distinct(pub_id), transaction_date, SUM(sales) OVER (partition by pub_id order by transaction_date asc) Total_Sales
from table2;

# (Q10. For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages
# across all categories)

with cte as
(SELECT p.country, avg(b.price_per_unit*s.quantity) as Avg_Sales, b.category from pubs as p 
join sales as s on s.pub_id = p.pub_id
join beverages as b on s.beverage_id = b.beverage_id
group by  b.category,  p.country)
SELECT category,Avg_Sales,country, Avg(Avg_Sales) over (partition by country) as Overall_average_price from 
cte order by Overall_average_price;

#(Q11. For each pub, what is the percentage contribution of each categoryof beverages to the tota sales 
# amount, and what is the pub's overall sales amount)?


SELECT pub_name, category, Total_Sales, Overall_total_Sales, CONCAT((Total_Sales*100/Overall_Total_Sales),"%") as Sales_Percentage
from 
(with cte as 
(SELECT p.pub_name,b.category, sum(b.price_per_unit*s.quantity) as Total_Sales from pubs as p 
join sales as s on s.pub_id = p.pub_id
join beverages as b on s.beverage_id = b.beverage_id
group by  b.category, p.pub_name)
SELECT category, pub_name, Total_Sales, SUM(Total_Sales) over (PARTITION BY pub_name)as Overall_Total_Sales
from cte) a
 












 














  



 


 
