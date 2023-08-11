CREATE DATABASE swiggy;

USE swiggy;

--  1) FIND CUSTOMERS WHO HAVE NEVER ORDERED

SELECT name, user_id
FROM users
WHERE user_id NOT IN ( SELECT user_id FROM orders);

-- 2) AVERAGE PRICE/DISH

SELECT f.f_name,round(avg(price)) as " Avg Price "
FROM menu m
JOIN food f 
ON m.f_id = f.f_id
group by m.f_id,f.f_name ;

-- 3) FIND TOP RESTAURANT IN TERMS OF NUMBER OF ORDERS FOR A GIVEN MONTH

SELECT r.r_name,Count(*) as "Month"
FROM ORDERS o
join restaurants r
ON o.r_id = r.r_id
WHERE monthname(DATE) LIKE "JUNE"
GROUP BY o.r_id,r.r_name
order by count(*) desc limit 1;

select  r.r_name, count(*) as "Month"
from orders o
join restaurants r
ON o.r_id= r.r_id
where monthname(date) like "may"
group by o.r_id, r.r_name
order by count(*) desc limit 1;

-- 4) Restaurant with monthly sales > x for

select r.r_name,sum(amount) as "Revenue"
from orders o
join restaurants r
ON o.r_id = r.r_id
where monthname(date) like "June"
group by r.r_id, r.r_name
having revenue> 500;

-- 5) Show all orders with order details for a particular customer in particular date range

select o.order_id, r.r_name
from orders o
join restaurants r 
on r.r_id = o.r_id
where user_id = (select user_id FROM users where name like "ankit")
AND ( date > " 2022-06-10" AND date < "2022-07-10"); 



select o.order_id, r.r_name,f.f_name,f.type
from orders o
JOIN restaurants r 
ON r.r_id = o.r_id
JOIN order_details od
ON od.order_id = o.order_id
JOIN food f
ON f.f_id = od.f_id
where user_id = ( select user_id from  users where name like "nitish")
AND ( date > "2022-06-10" AND date < '2022-07-10' );


-- 6)  FIND CUSTOMERS WITH ONE OR MAX REPEATED  ORDERS (LOYAL CUST)

select r_name, count(*) as "Loyal Customers"
from ( SELECT  r_id, user_id, COUNT(*) as visits 
      FROM ORDERS 
	group by R_ID,user_id
	  having visits > 1
      
	) t
join restaurants r
on r.r_id = t.r_id
group by  t.r_id,r_name
order by "loyal customers"  desc limit 2;


-- 7) Month over Month revenue growth by Swiggy

select month, round(((revenue - prev)/prev) * 100) as growth from (
with Sales as
	(
    select monthname(date) as month, sum(amount) as Revenue
	from orders
	group by month
    )

select month,revenue,lag (revenue,1) over(order by revenue) as prev from sales

 ) t;
 

-- 8) Customer --> favorite food



with temp as (
				select o.user_id,od.f_id, count(*) as "Frequency"
				from orders o
				join order_details od
				on o.order_id = od.order_id
				group by o.user_id,od.f_id
			 )

SELECT u.name,f.f_name
 from temp t1 
 join users u
 on u.user_id = t1.user_id
 join food f
 on f.f_id = t1.f_id
 where t1.frequency = ( 
	select max(frequency) 
	from temp t2
	where t2.user_id = t1.user_id ) 	











