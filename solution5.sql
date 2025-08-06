select
    ri.return_id,
    ri.return_item_seq_id,
    ri.product_id as return_item_product_id,
    pa.product_id_to as marketing_package_component_id,
    (ri.return_quantity * pa.quantity) as component_qoh_increase
from return_item ri
join product p 
    on p.product_id = ri.product_id
join product_assoc pa
    on pa.product_id = ri.product_id
   and pa.product_assoc_type_id = 'PRODUCT_COMPONENT'
where ri.status_id = 'RETURN_COMPLETED'
order by ri.return_id, pa.product_id_to;

-- We were asked about increase in QOH after return for a kit product, increase in QOH depends on the quantity of 
-- returned items and also the items with type PRODUCT_COMPONENT for that corresponding product, hence calculated it
-- as component_qoh_increase.

-- Execution Cost: 7.82

