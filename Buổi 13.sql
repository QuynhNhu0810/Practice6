--ex1
with cte as
(select 
  company_id, 
  title, 
  description, 
  count(job_id) AS job_count
from job_listings
group by company_id, title, description)
select count(distinct company_id) as duplicate_companies
from cte 
where job_count > 1
--ex2
select category,product,total_spend
from(
select category
,product 
,sum(spend) as total_spend
,rank() over (partition by category order by sum(spend) DESC) as ranking
from product_spend
where extract (year from transaction_date) = 2022
group by category, product
) as ranked_table
where ranking <= 2
order by category
--ex3
select count(policy_holder_id) as member_count
from 
(select policy_holder_id,
count(case_id) as total_call
from callers
group by policy_holder_id) as call_table
where total_call >=3
--ex4
select page_id
from pages as p1
where not exists (
select page_id
from page_likes as p2
where p1.page_id = p2.page_id )
--ex5
with cte as (
select user_id, extract(month from event_date) as month
from user_actions
where extract(month from event_date) in (6,7) 
and extract(year from event_date) =2022
group by user_id, extract(month from event_date)
having count(extract(month from event_date)) = 2
)

select month, count (*) as monthly_active_users
from cte
where month = 7
group by month
--ex6
SELECT
DATE_FORMAT(trans_date, '%Y-%m') AS month,
country,
COUNT(id) AS trans_count,
(SELECT COUNT(id)
FROM Transactions AS t2
WHERE t2.state = 'approved' AND
DATE_FORMAT(t2.trans_date, '%Y-%m') = DATE_FORMAT(Transactions.trans_date, '%Y-%m') AND
t2.country = Transactions.country
) AS approved_count,
SUM(amount) AS trans_total_amount,
COALESCE(
(SELECT SUM(amount)
FROM Transactions AS t3
WHERE t3.state = 'approved' AND
DATE_FORMAT(t3.trans_date, '%Y-%m') = DATE_FORMAT(Transactions.trans_date, '%Y-%m') AND
t3.country = Transactions.country
),0
) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country;
--ex7
elect product_id, year as first_year, quantity, price
from Sales
where (product_id, year) in (
select product_id, min(year)
from Sales
group by product_id)
--ex8
select customer_id
from Customer
group by customer_id
having count(distinct product_key) in (select count(*) from Product)
--ex9
