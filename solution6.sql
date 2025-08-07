select
-- allows grouping together of (A->B) and (B->A) as (A,B) to compute movement
    least(it.facility_id, it.facility_id_to) as facility_1,
    greatest(it.facility_id, it.facility_id_to) as facility_2,
    p.internal_name as product_internal_name,
    sum(
        case
            when it.facility_id < it.facility_id_to then it.quantity
            else -it.quantity
        end
    ) as net_transfer_quantity
from inventory_transfer it
join product p on p.product_id = it.product_id
group by
    least(it.facility_id, it.facility_id_to),
    greatest(it.facility_id, it.facility_id_to),
    p.internal_name
having sum(
    case
        when it.facility_id < it.facility_id_to then it.quantity
        else -it.quantity
    end
) != 0;
-- !=0 condition is checked because if net movement is 0 it is not required by us to calculate the transfer

-- Execution Cost: 0.7



