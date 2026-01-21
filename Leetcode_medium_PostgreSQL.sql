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







