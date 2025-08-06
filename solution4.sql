select
    order_id,
    order_item_seq_id,
    issued_date_time
from item_issuance
where order_id in (
    select order_id
    from item_issuance
    group by order_id
    -- checks if issued date does not lie in the same month 
    having count(distinct date_format(issued_date_time, '%Y-%m')) > 1
)
order by order_id, issued_date_time;

-- We here wanted such orders where the items were fulfilled in two different months, since we know that after
-- an order is fulfilled/shipped it is updated in the item issuance table. This table gives us the order_id, item_id
-- and the time of order fulfillment, so I took all the details from this table itself and applied the constraint
-- which checks whether or not items are fulfilled in different months.

-- Execution Cost: 50,529.35

