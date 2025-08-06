select
	oh.ORDER_ID, timestampdiff(minute, oh.ORDER_DATE, os.STATUS_DATETIME) as time_difference
from
	order_header oh
join order_status os on
	os.ORDER_ID = oh.ORDER_ID
where
	oh.ORDER_TYPE_ID = 'SALES_ORDER' and os.STATUS_ID = 'ORDER_APPROVED';

-- We were asked the time difference between order creation in shopify and approval in OMS that is
-- order date is the time when the customer ordered that is order was created in shopify then for approval
-- we went to the order status table and checked if the status is 'ORDER_APPROVED' and this is our 
-- difference and since we were asked about BOPIS order so out order type is "SALES_ORDER".


-- Execution Cost: 68,959.11
