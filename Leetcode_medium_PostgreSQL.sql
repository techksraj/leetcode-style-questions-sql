use leetcode;

-------------X----------------X--------------------X-------------------

--https://leetcode.com/problems/investments-in-2016/description/

--585. Investments in 2016

Create Table If Not Exists Insurance (pid int, tiv_2015 float, tiv_2016 float, lat float, lon float);
Truncate table Insurance;
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('1', '10', '5', '10', '10');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('2', '20', '20', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('3', '10', '30', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('4', '10', '40', '40', '40');


SELECT 
    cast(sum(tiv_2016) as DECIMAL(10,2)) as tiv_2016
FROM insurance
WHERE (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
)
AND tiv_2015 IN (
    SELECT tiv_2015
    FROM insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
);



-------------X----------------X--------------------X-------------------

--https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/

--602. Friend Requests II: Who Has the Most Friends

Create table If Not Exists RequestAccepted (requester_id int not null, accepter_id int null, accept_date date null);
Truncate table RequestAccepted;
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');

 
select id, count(*) as num
from
(
select requester_id as id
from RequestAccepted
union all
select accepter_id
from RequestAccepted as id
) friends
group by id
order by count(*) desc
limit 1;


-------------X----------------X--------------------X-------------------

--https://leetcode.com/problems/tree-node/description/

--608. Tree Node

Create table If Not Exists Tree (id int, p_id int);
Truncate table Tree;
insert into Tree (id, p_id) values ('1', NULL);
insert into Tree (id, p_id) values ('2', '1');
insert into Tree (id, p_id) values ('3', '1');
insert into Tree (id, p_id) values ('4', '2');
insert into Tree (id, p_id) values ('5', '2');


SELECT id,

    CASE 
        WHEN p_id IS NULL THEN 'Root'
        WHEN id IN (SELECT p_id FROM Tree)THEN 'Inner'
        ELSE 'Leaf'
        END AS type
 FROM Tree;


-------------X----------------X--------------------X-------------------

--https://leetcode.com/problems/exchange-seats/description/

--626. Exchange Seats

Create table If Not Exists Seat (id int, student varchar(255));
Truncate table Seat;
insert into Seat (id, student) values ('1', 'Abbot');
insert into Seat (id, student) values ('2', 'Doris');
insert into Seat (id, student) values ('3', 'Emerson');
insert into Seat (id, student) values ('4', 'Green');
insert into Seat (id, student) values ('5', 'Jeames');


select id,
case when id % 2 = 1 and id = max(id) then student
	 when id % 2 = 0 then (select student from seat1 where id = id - 1)
	 else (select student from seat1 where id = id + 1)
from seat;

select max(id) from seat;


select 
case when id % 2 =1 and id+1 in (select id from Seat) then id+1
     when id % 2 =0 then id-1
     else id
     end as id, 
student
from Seat
order by id;


-------------X----------------X--------------------X-------------------

--https://leetcode.com/problems/customers-who-bought-all-products/

--1045. Customers Who Bought All Products

Create table If Not Exists Customer (customer_id int, product_key int);
Create table Product (product_key int);
Truncate table Customer;
insert into Customer (customer_id, product_key) values ('1', '5');
insert into Customer (customer_id, product_key) values ('2', '6');
insert into Customer (customer_id, product_key) values ('3', '5');
insert into Customer (customer_id, product_key) values ('3', '6');
insert into Customer (customer_id, product_key) values ('1', '6');
Truncate table Product;
insert into Product (product_key) values ('5');
insert into Product (product_key) values ('6');

select customer_id
from customer 
group by customer_id 
having count(distinct product_key) = (select count(distinct product_key) from product);
 
-------------X----------------X--------------------X-------------------

--https://leetcode.com/problems/product-sales-analysis-iii/description/

--1070. Product Sales Analysis III

Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Truncate table Sales;
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');

select product_id, year as first_year, quantity, price 
from (
select rank() over (partition by product_id order by year) as rn, product_id, year, quantity, price
from sales) 
where rn = 1;

-------------X----------------X--------------------X-------------------

--https://leetcode.com/problems/market-analysis-i/description/

--1158. Market Analysis I

Create table If Not Exists Users (user_id int, join_date date, favorite_brand varchar(10));
Create table If Not Exists Orders (order_id int, order_date date, item_id int, buyer_id int, seller_id int);
Create table If Not Exists Items (item_id int, item_brand varchar(10));
Truncate table Users;
insert into Users (user_id, join_date, favorite_brand) values ('1', '2018-01-01', 'Lenovo');
insert into Users (user_id, join_date, favorite_brand) values ('2', '2018-02-09', 'Samsung');
insert into Users (user_id, join_date, favorite_brand) values ('3', '2018-01-19', 'LG');
insert into Users (user_id, join_date, favorite_brand) values ('4', '2018-05-21', 'HP');
Truncate table Orders;
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('1', '2019-08-01', '4', '1', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('2', '2018-08-02', '2', '1', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('3', '2019-08-03', '3', '2', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('4', '2018-08-04', '1', '4', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('5', '2018-08-04', '1', '3', '4');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('6', '2019-08-05', '2', '2', '4');
Truncate table Items;
insert into Items (item_id, item_brand) values ('1', 'Samsung');
insert into Items (item_id, item_brand) values ('2', 'Lenovo');
insert into Items (item_id, item_brand) values ('3', 'LG');
insert into Items (item_id, item_brand) values ('4', 'HP');


-------------X----------------X--------------------X-------------------

--https://leetcode.com/problems/product-price-at-a-given-date/description/

--1164. Product Price at a Given Date

Create table If Not Exists Products (product_id int, new_price int, change_date date);
Truncate table Products;
insert into Products (product_id, new_price, change_date) values ('1', '20', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('2', '50', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('1', '30', '2019-08-15');
insert into Products (product_id, new_price, change_date) values ('1', '35', '2019-08-16');
insert into Products (product_id, new_price, change_date) values ('2', '65', '2019-08-17');
insert into Products (product_id, new_price, change_date) values ('3', '20', '2019-08-18');

select product_id, COALESCE((
select new_price from products pr where pr.product_id = p.product_id and change_date <= '2019-08-16' order by change_date desc limit 1
), 10) as price
from products p
group by product_id;

with latest_rank as (select product_id, new_price, rank() over (partition by product_id order by change_date desc) as latest_rank
from products
where change_date<= '2019-08-16')
select product_id, new_price as price
from latest_rank
where latest_rank = 1
union all
select distinct product_id, 10 as price
from products
where product_id not in (select product_id from latest_rank);

































