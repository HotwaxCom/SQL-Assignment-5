-- This gives us the total quantity of product for POS sale in a given date range
SELECT
  oi.product_id,
    p.product_name,
  SUM(oi.quantity) AS total_pos_sales_qty
FROM order_header oh
JOIN order_item oi ON oi.order_id = oh.order_id
join product p
	on p.product_id = oi.product_id
WHERE
  oh.sales_channel_enum_id = 'POS_SALES_CHANNEL'
  AND date(oh.order_date) BETWEEN date('2024-10-01') AND date('2024-10-30')
group by oi.product_id;

-- Execution Cost: 33,496.04

-- This gives us the variance during a POS Order
SELECT
  ii.product_id,
  p.product_name,
  SUM(iiv.quantity_on_hand_var) AS total_pos_variance
FROM inventory_item_variance iiv
JOIN inventory_item ii ON ii.inventory_item_id = iiv.inventory_item_id
join product p
	on p.product_id = ii.product_id
WHERE date(iiv.created_stamp) BETWEEN date('2024-10-01') AND date('2024-10-30')
GROUP BY ii.product_id;

-- Execution Cost: 2,697,119.15

-- Union to get the variance and total quantity of POS orders together
 




