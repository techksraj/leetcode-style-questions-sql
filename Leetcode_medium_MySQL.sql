USE leetcode;

-------------X----------------X--------------------X-------------------

--https://leetcode.com/problems/managers-with-at-least-5-direct-reports

--570. Managers with at Least 5 Direct Reports



Create table If Not Exists Employee (id int, name varchar(255), department varchar(255), managerId int);

Truncate table Employee;

insert into Employee (id, name, department, managerId) values ('101', 'John', 'A', NULL);

insert into Employee (id, name, department, managerId) values ('102', 'Dan', 'A', '101');

insert into Employee (id, name, department, managerId) values ('103', 'James', 'A', '101');

insert into Employee (id, name, department, managerId) values ('104', 'Amy', 'A', '101');

insert into Employee (id, name, department, managerId) values ('105', 'Anne', 'A', '101');

insert into Employee (id, name, department, managerId) values ('106', 'Ron', 'B', '101');



select * from Employee;



--SOLUTION

SELECT emp.name FROM Employee emp WHERE emp.id IN (

SELECT managerId FROM (

SELECT e.managerId, COUNT(*) AS count

FROM Employee e

WHERE e.managerId IS NOT NULL

GROUP BY e.managerId

HAVING COUNT(*) >= 5

) ee

);



--BEST SOLUTION

SELECT b.name

FROM Employee a

JOIN Employee b ON a.managerId = b.id

GROUP BY b.id

HAVING COUNT(*) >= 5;

------------------------------------------------------------------

--1934. Confirmation Rate

--https://leetcode.com/problems/confirmation-rate/description/



Create table If Not Exists Signups (user_id int, time_stamp datetime);

Create table If Not Exists Confirmations (user_id int, time_stamp datetime, action ENUM('confirmed','timeout'));

Truncate table Signups;

insert into Signups (user_id, time_stamp) values ('3', '2020-03-21 10:16:13');

insert into Signups (user_id, time_stamp) values ('7', '2020-01-04 13:57:59');

insert into Signups (user_id, time_stamp) values ('2', '2020-07-29 23:09:44');

insert into Signups (user_id, time_stamp) values ('6', '2020-12-09 10:39:37');

Truncate table Confirmations;

insert into Confirmations (user_id, time_stamp, action) values ('3', '2021-01-06 03:30:46', 'timeout');

insert into Confirmations (user_id, time_stamp, action) values ('3', '2021-07-14 14:00:00', 'timeout');

insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-12 11:57:29', 'confirmed');

insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-13 12:58:28', 'confirmed');

insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-14 13:59:27', 'confirmed');

insert into Confirmations (user_id, time_stamp, action) values ('2', '2021-01-22 00:00:00', 'confirmed');

insert into Confirmations (user_id, time_stamp, action) values ('2', '2021-02-28 23:59:59', 'timeout');





SELECT conf.user_id, ROUND(SUM(conf.confirmation_count)/COUNT(*),2) as confirmation_rate 

FROM (

SELECT s.user_id, 

CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END as confirmation_count

FROM Signups s LEFT JOIN Confirmations c

ON s.user_id = c.user_id

) conf

GROUP BY conf.user_id;



--BEST SOLUTION

select s.user_id, round(avg(if(c.action="confirmed",1,0)),2) as confirmation_rate

from Signups as s left join Confirmations as c on s.user_id= c.user_id group by user_id;

---------------------------------------------------------------------------

--1193. Monthly Transactions I

--https://leetcode.com/problems/monthly-transactions-i/description



Create table If Not Exists Transactions (id int, country varchar(4), state enum('approved', 'declined'), amount int, trans_date date);

Truncate table Transactions;

insert into Transactions (id, country, state, amount, trans_date) values ('121', 'US', 'approved', '1000', '2018-12-18');

insert into Transactions (id, country, state, amount, trans_date) values ('122', 'US', 'declined', '2000', '2018-12-19');

insert into Transactions (id, country, state, amount, trans_date) values ('123', 'US', 'approved', '2000', '2019-01-01');

insert into Transactions (id, country, state, amount, trans_date) values ('124', 'DE', 'approved', '2000', '2019-01-07');



SELECT * FROM Transactions;



SELECT DATE_FORMAT(t.trans_date,'%Y-%m') AS month, t.country, COUNT(*) AS trans_count, SUM(IF(t.state='approved',1,0)) AS approved_count, 

	SUM(t.amount) AS trans_total_amount, SUM(IF(t.state='approved',t.amount,0)) AS approved_total_amount 

FROM Transactions t

GROUP BY country,DATE_FORMAT(t.trans_date,'%Y-%m');

-----------------------------------------------------------------------------
--30-Nov-2024

--1174. Immediate Food Delivery II

--https://leetcode.com/problems/immediate-food-delivery-ii



Create table If Not Exists Delivery (delivery_id int, customer_id int, order_date date, customer_pref_delivery_date date);

Truncate table Delivery;

insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('1', '1', '2019-08-01', '2019-08-02');

insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('2', '2', '2019-08-02', '2019-08-02');

insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('3', '1', '2019-08-11', '2019-08-12');

insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('4', '3', '2019-08-24', '2019-08-24');

insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('5', '3', '2019-08-21', '2019-08-22');

insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('6', '2', '2019-08-11', '2019-08-13');

insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('7', '4', '2019-08-09', '2019-08-09');



SELECT ROUND((SUM(IF(del.delivery_type='immediate',1,0))/COUNT(delivery_type))*100,2) AS immediate_percentage



SELECT ROUND((SUM(IF(del.delivery_type='immediate',1,0))/COUNT(delivery_type))*100,2) AS immediate_percentage

FROM (

SELECT d.delivery_id, d.customer_id, d.order_date, d.customer_pref_delivery_date,

		IF(d.order_date = d.customer_pref_delivery_date,'immediate','scheduled') AS delivery_type,

		ROW_NUMBER() OVER(PARTITION BY d.customer_id ORDER BY d.order_date) as rn 

FROM Delivery d

) del 

WHERE rn = 1;

-------------------------------------------------------------------------------

--176. Second Highest Salary

--https://leetcode.com/problems/second-highest-salary/description/

DROP TABLE Employee;

Create table If Not Exists Employee (id int, salary int);
Truncate table Employee;
insert into Employee (id, salary) values ('1', '100');
insert into Employee (id, salary) values ('2', '200');
insert into Employee (id, salary) values ('3', '300');
-- commit;

SELECT * FROM Employee e;

select
(select distinct Salary 
from Employee order by salary desc 
limit 1 offset 1) 
as SecondHighestSalary;

SELECT IFNULL(
	(SELECT DISTINCT salary
	FROM Employee
	ORDER BY salary DESC
	LIMIT 1 OFFSET 1)
, null) AS SecondHighestSalary;


-------------------------------------------------------------------------------
--177. Nth Highest Salary

--https://leetcode.com/problems/nth-highest-salary/description/

Create table If Not Exists Employee (Id int, Salary int)
Truncate table Employee
insert into Employee (id, salary) values ('1', '100')
insert into Employee (id, salary) values ('2', '200')
insert into Employee (id, salary) values ('3', '300')

select * from Employee e;

select emp.salary
from (
    select distinct e.salary, dense_rank() over (order by e.salary desc) as dr
    from Employee e
) emp  where emp.dr = 2;


CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
select emp.salary
from (
    select distinct e.salary, dense_rank() over (order by e.salary desc) as dr
    from Employee e
) emp  where emp.dr = N
);
END;

SELECT getNthHighestSalary(2) FROM Employee e;

-------------------------------------------------------------------------------

--178. Rank Scores

--https://leetcode.com/problems/rank-scores/

Create table If Not Exists Scores (id int, score DECIMAL(3,2));
Truncate table Scores;
insert into Scores (id, score) values ('1', '3.5');
insert into Scores (id, score) values ('2', '3.65');
insert into Scores (id, score) values ('3', '4.0');
insert into Scores (id, score) values ('4', '3.85');
insert into Scores (id, score) values ('5', '4.0');
insert into Scores (id, score) values ('6', '3.65');

SELECT * FROM Scores;

SELECT s.score, DENSE_RANK() OVER (ORDER BY s.score DESC) AS 'rank'
FROM Scores s;


-------------------------------------------------------------------------------

--180. Consecutive Numbers

--https://leetcode.com/problems/consecutive-numbers/description/

Create table If Not Exists Logs (id int, num int)
Truncate table Logs
insert into Logs (id, num) values ('1', '1');
insert into Logs (id, num) values ('2', '1');
insert into Logs (id, num) values ('3', '1');
insert into Logs (id, num) values ('4', '2');
insert into Logs (id, num) values ('5', '1');
insert into Logs (id, num) values ('6', '2');
insert into Logs (id, num) values ('7', '2');

commit;

SELECT * FROM Logs;

SELECT DISTINCT num AS ConsecutiveNums
FROM
(
SELECT num,LEAD(num,1) OVER(ORDER BY id) AS 'lead_num', LAG(num,1) OVER (ORDER BY id) AS 'lag_num'
FROM Logs
)t
WHERE num=lead_num and num=lag_num;

-------------------------------------------------------------------------------

--184. Department Highest Salary

--https://leetcode.com/problems/department-highest-salary/description/

Drop table Employee;
Drop table Department;

Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int);
Create table If Not Exists Department (id int, name varchar(255));
Truncate table Employee;
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '70000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Jim', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('3', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('5', 'Max', '90000', '1');
Truncate table Department;
insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');

SELECT res.Department, res.Employee, res.Salary
FROM (
SELECT d.name AS Department, e.name AS Employee, e.salary AS Salary, 
	DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) as dr
FROM Employee e 
	JOIN Department d 
	ON (e.departmentId = d.id)
) res
WHERE res.dr = 1;

-- OTHER WAY SAME SOLUTION WITH CTE
WITH cte AS (
SELECT d.name AS Department, e.name AS Employee, e.salary AS Salary, 
	DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) as dr
FROM Employee e 
	JOIN Department d 
	ON (e.departmentId = d.id)
)
SELECT Department, Employee, Salary
FROM cte 
WHERE dr = 1;

-- Faster solution

select dp.name as Department, em.name as Employee, em.salary as Salary
from Employee as em join Department as dp 
on em.departmentId = dp.id 
where Salary = ( select max(salary) from Employee where departmentId = dp.id );

-------------------------------------------------------------------------------

--196. Delete Duplicate Emails (EASY)

--https://leetcode.com/problems/delete-duplicate-emails/description/

DROP TABLE Person;


Create table If Not Exists Person (Id int, Email varchar(255));
Truncate table Person;
insert into Person (id, email) values ('1', 'john@example.com');
insert into Person (id, email) values ('2', 'bob@example.com');
insert into Person (id, email) values ('3', 'john@example.com');

DELETE FROM Person WHERE ID IN (
	SELECT id FROM (
		SELECT id, email, ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) as rn
		FROM Person
	) dp 
	WHERE rn > 1
);

-- ANOTHER FASTER SOLUTION

with dup_list as (select min(id) dup from Person group by email)
Delete from Person
where id not in (select dup from dup_list)
;

-------------------------------------------------------------------------------

--1757. 1164. Product Price at a Given Date (MEDIUM)

--https://leetcode.com/problems/product-price-at-a-given-date/description/

DROP TABLE Products;

Create table If Not Exists Products (product_id int, new_price int, change_date date);
Truncate table Products;
insert into Products (product_id, new_price, change_date) values ('1', '20', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('2', '50', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('1', '30', '2019-08-15');
insert into Products (product_id, new_price, change_date) values ('1', '35', '2019-08-16');
insert into Products (product_id, new_price, change_date) values ('2', '65', '2019-08-17');
insert into Products (product_id, new_price, change_date) values ('3', '20', '2019-08-18');

SELECT * FROM Products;



--------------------
