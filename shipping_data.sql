-- Part 1
-- 1. List of shipped transaction in 2/2018
select
	*
from
	Study.shipping_data ct
WHERE
	status = 'Shipped'
	and MONTH (transaction_date) = 2
	
-- 2. Transaction from midnight to 9am
SELECT
	*
FROM
	Study.shipping_data ct
WHERE
	HOUR (transaction_date) >= 0
	AND HOUR (transaction_date) <= 9
	
	-- 3. Last transaction
select
	vendor,
	transaction_date
FROM
	Study.shipping_data ct
WHERE
	transaction_date IN (
	select
		MAX(transaction_date)
	from
		Study.shipping_data
	group by
		vendor)
order by
	vendor asc
	
	-- 4. Second last transaction
with cte as(
	select
		vendor,
		transaction_date, 
			row_number() over (PARTITION BY vendor
	ORDER BY
		transaction_date DESC) as rn
	from
		Study.shipping_data ct )
select
	vendor,
	transaction_date
from
	cte
where
	rn = 2
	
	-- 5. Canceled trans quant each day per vendor
select
	ct.vendor, 
		DATE_FORMAT(transaction_date, '%d-%c-%Y') as trans_date, 
		COUNT(ct.order_id) as trans_quant
from
	Study.shipping_data ct
WHERE
	ct.status = 'Cancelled'
group by
	1, 2
	
	-- 6. Customer made more than 1 shipped purchases
select
	ct.customer_id,
	COUNT(ct.order_id) as morethan1
from
	Study.shipping_data ct
WHERE
	ct.status = 'shipped'
GROUP by
	1
having
	morethan1 > 1
	
	-- 7. Category each vendor
	-- Shipped quantity
with shipped as (
	select
		vendor,
		count(order_id) as shipped_count
	from
		Study.shipping_data ct
	where
		status = 'Shipped'
	group by 1),
	-- cancelled quantity
	cancelled as (
	select
		vendor,
		count(order_id) as cancelled_count
	from
		Study.shipping_data ct
	where
		status = 'Cancelled'
	group by 1)
	
	-- classify each vendor
select
	s.vendor,
		case
		when s.shipped_count > 2 and isnull(c.cancelled_count) then 'Superb'
		when s.shipped_count > 2 and c.cancelled_count >= 1 then 'Good'
		else 'Normal'
	END as Category,
		count(ct2.order_id) as Total_Trans
from
	shipped s left join cancelled c on s.vendor = c.vendor
	left join Study.shipping_data ct2 on ct2.vendor = s.vendor
group by 1, 2
order by
	(	case
		when Category = 'Superb' then 1
		when Category = 'Good' then 2
		else 3
	end) asc,
	Total_Trans DESC

-- 8. Trans quant by hour
select
	HOUR(ct.transaction_date) as 'Hour of the Day', 
		COUNT(order_id) as 'Total Transaction'
from
	Study.shipping_data ct
group by 1

-- 9. Group transaction by day
select
	DATE_FORMAT(ct.transaction_date, '%Y-%c-%d') as Date,
		sum(case when ct.status = 'Shipped' then 1 else 0 end) as Shipped,
		sum(case when ct.status = 'Cancelled' then 1 else 0 end) as Cancelled,
		sum(case when ct.status = 'Processing' then 1 else 0 end) as Processing
from
	Study.shipping_data ct
group by 1

	-- 10. Avg, min, max of days interval
with cte as(
	select
		transaction_date,
		LEAD(transaction_date) OVER(
		ORDER by transaction_date) as next_trans
	from
		Study.shipping_data ct)
select
	avg(DATEDIFF(next_trans, transaction_date)) as AvgInt,
		MIN(DATEDIFF(next_trans, transaction_date)) as MinInt,
		MAX(DATEDIFF(next_trans, transaction_date)) as MaxInt
from cte

	-- Part 2:
	-- 1. Total value shipped 
select
	td.product_name,
		sum(td.quantity * td.price) as Value,
		case
		when sum(td.quantity) > 100 then sum(td.quantity * td.price) * 0.04
		else sum(td.quantity * td.price) * 0.02
	end as 'Distributor Commission'
from
	trans_detail td
left join shipping_data ct on
	td.trx_id = ct.Id
group by 1

	-- 2. Quant of Indomie shipped in Feb 2018
select
	sum(td.quantity) as total_quantity
from
	trans_detail td
left join shipping_data ct on
	td.trx_id = ct.Id
where
	product_name like 'Indomie%'
	and ct.status = 'Shipped'
	and YEAR(ct.transaction_date) = 2018
	and MONTH(ct.transaction_date) = 2
	
	-- 3. Last transaction ID for each product
select
	product_name,
	max(trx_id) as 'Last Transaction ID'
from
	trans_detail td
group by 1

select * from trans_detail td 
