-- We are to find here if an order is rejected from store and if it is with variance like out of stock
-- then the orders containing th same product are also affected, list all of this.

-- Execution Cost: 20,060.58

select
	oisg.order_id as Rejected_Order_ID,
	oi.product_id as Rejected_Product_ID,
	group_concat(distinct oi1.order_id) as Affected_Orders
from
	-- Fetching the facility details of the brokered order
	order_item_ship_group oisg
join order_item oi 
    on
	-- Getting the product id and item_status of the order
	oi.order_id = oisg.order_id
	and oi.ship_group_seq_id = oisg.ship_group_seq_id
join order_item oi1
    on
	oi1.product_id = oi.PRODUCT_ID
	-- First match the orders with the same product and then ensures that we do not take the same rejected
	-- orders again
	and oi1.order_id <> oi.order_id
join order_item_ship_group oisg1 on
	oi1.order_id = oisg1.order_id
	-- Making sure that the order items are brokered on the same facility
	and oi1.ship_group_seq_id = oisg1.ship_group_seq_id
	and oisg.facility_id = oisg1.facility_id
where
	-- Item should be rejected by the facility after approval
	oisg.facility_ID = 'REJECTED_ITM_PARKING'
	and oi.status_id = 'ITEM_CANCELLED'
group by
	oisg.order_id,
	oi.product_id;

