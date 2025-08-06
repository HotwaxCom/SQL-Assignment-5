  select
  	dest.product_id as low_stock_item_id,
  	dest.facility_id as destination_facility,
  	src.facility_id as recommended_source_facility,
  	src.quantity_on_hand_total - src.minimum_stock as transferable_quantity,
  	round(3959 * ACOS(cos(radians(gp.latitude)) * cos(radians(gp1.latitude))
  	* cos(radians(gp1.longitude) - radians(gp.longitude)) 
  	+ sin(radians(gp.latitude)) * sin(radians(gp1.latitude))),2) as distance_miles
  from
  (SELECT 
        ii.product_id,
        ii.facility_id,
        SUM(ii.quantity_on_hand_total) AS quantity_on_hand_total,
        pf.minimum_stock
    FROM inventory_item ii
    JOIN product_facility pf 
        ON pf.product_id = ii.product_id
       AND pf.facility_id = ii.facility_id
    GROUP BY ii.product_id, ii.facility_id, pf.minimum_stock
    HAVING SUM(ii.quantity_on_hand_total) <= pf.minimum_stock) dest
    join (
     SELECT 
        ii.product_id,
        ii.facility_id,
        SUM(ii.quantity_on_hand_total) AS quantity_on_hand_total,
        pf.minimum_stock
    FROM inventory_item ii
    JOIN product_facility pf 
        ON pf.product_id = ii.product_id
       AND pf.facility_id = ii.facility_id
    GROUP BY ii.product_id, ii.facility_id, pf.minimum_stock
    HAVING SUM(ii.quantity_on_hand_total) > pf.minimum_stock
) src
	on dest.product_id = src.product_id
join facility_location_geo_point flgp 
	on flgp.facility_id = dest.facility_id
join geo_point gp
	on gp.geo_point_id = flgp.geo_point_id
join facility_location_geo_point flgp1
	on flgp1.facility_id = src.facility_id
join geo_point gp1
	on gp1.geo_point_id = flgp1.geo_point_id 
having distance_miles <= 200
order by dest.product_id;

-- Started by finding the destination_facility_id of the product from inventory_item and then by taking sum of the QOH
-- per product and comparing them with minimum stock we get the item low in stock and the facility corresponding to
-- this becomes our destination facility id.

-- To find the recommended source facility, we follow the same approach and compare which facility has that product
-- greater than the minimum stock and this way we get our recommended facility id.

-- To find the transferrable quantity we can transfer the quantity such that minimum stock is maintained, so we calculate
-- this by subtracting the QOH and minimum stock from the source facility

-- To calculate the distance in miles we first apply join on facility_location_geo_point using facility_id. Through this,
-- after applying join on geo_point we get the latitude and longitutde of the facility, to which we apply the 
-- Haversine Great Circle Distance Formula and at the end applied a condition which ensures that facility location lies 
-- within 200 miles.

-- Execution Cost: 803,586,986.8
