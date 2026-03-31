Data Cleaning after loading for each table -- 

UPDATE customers
SET time_to_2nd_purchase = NULL
WHERE time_to_2nd_purchase = '';

UPDATE customers
SET total_orders = CAST(total_orders AS UNSIGNED),
    total_revenue = CAST(total_revenue AS DECIMAL(12,2)),
    average_order_value = CAST(average_order_value AS DECIMAL(12,2)),
    time_to_2nd_purchase = CAST(time_to_2nd_purchase AS UNSIGNED);
    
UPDATE meta_ads_campaigns
SET 
    campaign_date = CASE
        WHEN campaign_date LIKE '%/%' 
            THEN STR_TO_DATE(campaign_date, '%m/%d/%Y')
        ELSE campaign_date
    END,
    launch_date = CASE
        WHEN launch_date LIKE '%/%' 
            THEN STR_TO_DATE(launch_date, '%m/%d/%Y')
        ELSE launch_date
    END;
    
    
ALTER TABLE customers
MODIFY first_order_date DATE,
MODIFY last_purchase_date DATE,
MODIFY total_orders INT,
MODIFY total_revenue DECIMAL(12,2),
MODIFY average_order_value DECIMAL(12,2),
MODIFY time_to_2nd_purchase INT;




UPDATE inventory_snapshot
SET units_in_stock = NULLIF(units_in_stock, ''),
    units_sold_7days = NULLIF(units_sold_7days, ''),
    units_sold_30days = NULLIF(units_sold_30days, ''),
    days_of_inventory_left = NULLIF(days_of_inventory_left, ''),
    date = NULLIF(date, '');


UPDATE inventory_snapshot
SET units_in_stock = CAST(units_in_stock AS DOUBLE),
    units_sold_7days = CAST(units_sold_7days AS DOUBLE),
    units_sold_30days = CAST(units_sold_30days AS DOUBLE),
    days_of_inventory_left = CAST(days_of_inventory_left AS DECIMAL(6,3));


UPDATE inventory_snapshot
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE inventory_snapshot
MODIFY COLUMN units_in_stock DOUBLE,
MODIFY COLUMN units_sold_7days DOUBLE,
MODIFY COLUMN units_sold_30days DOUBLE,
MODIFY COLUMN days_of_inventory_left DECIMAL(6,3),
MODIFY COLUMN date DATE;



UPDATE meta_ads_campaigns
SET 
    results = NULLIF(results, ''),
    amount_spent_inr = NULLIF(amount_spent_inr, ''),
    spend = NULLIF(spend, ''),
    reach = NULLIF(reach, ''),
    impressions = NULLIF(impressions, ''),
    frequency = NULLIF(frequency, ''),
    link_clicks = NULLIF(link_clicks, ''),
    ctr_link = NULLIF(ctr_link, ''),
    add_to_cart = NULLIF(add_to_cart, ''),
    initiate_checkout = NULLIF(initiate_checkout, ''),
    purchases = NULLIF(purchases, ''),
    purchase_conversion_value = NULLIF(purchase_conversion_value, ''),
    cac = NULLIF(cac, ''),
    roas = NULLIF(roas, ''),
    hook_rate = NULLIF(hook_rate, ''),
    campaign_date = NULLIF(campaign_date, ''),
    launch_date = NULLIF(launch_date, '');
    
UPDATE meta_ads_campaigns
SET 
    results = CAST(results AS UNSIGNED),
    amount_spent_inr = CAST(amount_spent_inr AS DECIMAL(12,2)),
    spend = CAST(spend AS DECIMAL(12,2)),
    reach = CAST(reach AS UNSIGNED),
    impressions = CAST(impressions AS UNSIGNED),
    frequency = CAST(frequency AS DECIMAL(6,2)),
    link_clicks = CAST(link_clicks AS UNSIGNED),
    ctr_link = CAST(ctr_link AS DECIMAL(6,4)),
    add_to_cart = CAST(add_to_cart AS UNSIGNED),
    initiate_checkout = CAST(initiate_checkout AS UNSIGNED),
    purchases = CAST(purchases AS UNSIGNED),
    purchase_conversion_value = CAST(purchase_conversion_value AS DECIMAL(12,2)),
    cac = CAST(cac AS DECIMAL(10,2)),
    roas = CAST(roas AS DECIMAL(10,2)),
    hook_rate = CAST(hook_rate AS DECIMAL(6,3));
    
UPDATE meta_ads_campaigns
SET 
    campaign_date = STR_TO_DATE(campaign_date, '%m/%d/%Y'),
    launch_date = STR_TO_DATE(launch_date, '%m/%d/%Y');
    
ALTER TABLE meta_ads_campaigns
MODIFY COLUMN campaign_date DATE,
MODIFY COLUMN launch_date DATE,
MODIFY COLUMN results INT,
MODIFY COLUMN amount_spent_inr DECIMAL(12,2),
MODIFY COLUMN spend DECIMAL(12,2),
MODIFY COLUMN reach INT,
MODIFY COLUMN impressions INT,
MODIFY COLUMN frequency DECIMAL(6,2),
MODIFY COLUMN link_clicks INT,
MODIFY COLUMN ctr_link DECIMAL(6,4),
MODIFY COLUMN add_to_cart INT,
MODIFY COLUMN initiate_checkout INT,
MODIFY COLUMN purchases INT,
MODIFY COLUMN purchase_conversion_value DECIMAL(12,2),
MODIFY COLUMN cac DECIMAL(10,2),
MODIFY COLUMN roas DECIMAL(10,2),
MODIFY COLUMN hook_rate DECIMAL(6,3);



UPDATE order_line_items
SET 
    mrp = NULLIF(mrp, ''),
    selling_price = NULLIF(selling_price, ''),
    discount_pct = NULLIF(discount_pct, '');

UPDATE order_line_items
SET 
    mrp = CAST(mrp AS DECIMAL(10,2)),
    selling_price = CAST(selling_price AS DECIMAL(10,2)),
    discount_pct = CAST(discount_pct AS DECIMAL(5,2));


ALTER TABLE order_line_items
MODIFY COLUMN mrp DECIMAL(10,2),
MODIFY COLUMN selling_price DECIMAL(10,2),
MODIFY COLUMN discount_pct DECIMAL(5,2);



UPDATE orders
SET 
    order_value_gross = NULLIF(order_value_gross, ''),
    order_value_net = NULLIF(order_value_net, ''),
    discount_applied_amount = NULLIF(discount_applied_amount, ''),
    discount_applied_percent = REPLACE(NULLIF(discount_applied_percent, ''), '%', ''),
    order_datetime = NULLIF(order_datetime, '');
    
UPDATE orders
SET 
    order_value_gross = CAST(order_value_gross AS DECIMAL(12,2)),
    order_value_net = CAST(order_value_net AS DECIMAL(12,2)),
    discount_applied_amount = CAST(discount_applied_amount AS DECIMAL(12,2)),
    discount_applied_percent = CAST(discount_applied_percent AS DECIMAL(5,2));
    
ALTER TABLE orders
MODIFY COLUMN order_datetime DATETIME,
MODIFY COLUMN order_value_gross DECIMAL(12,2),
MODIFY COLUMN order_value_net DECIMAL(12,2),
MODIFY COLUMN discount_applied_amount DECIMAL(12,2),
MODIFY COLUMN discount_applied_percent DECIMAL(5,2);



UPDATE purchase_orders
SET
    order_quantity = NULLIF(order_quantity, ''),
    cost_per_unit = NULLIF(cost_per_unit, ''),
    order_date = NULLIF(order_date, ''),
    expected_delivery = NULLIF(expected_delivery, ''),
    actual_delivery = NULLIF(actual_delivery, ''),
    lead_time = NULLIF(lead_time, '');
    
   UPDATE purchase_orders
SET
    order_quantity = CAST(order_quantity AS UNSIGNED),
    cost_per_unit = CAST(cost_per_unit AS DECIMAL(12,2)),
    lead_time = CAST(lead_time AS UNSIGNED);
    
UPDATE purchase_orders
SET
    order_date = STR_TO_DATE(order_date, '%Y-%m-%d'),
    expected_delivery = STR_TO_DATE(expected_delivery, '%Y-%m-%d'),
    actual_delivery = STR_TO_DATE(actual_delivery, '%Y-%m-%d');
    
ALTER TABLE purchase_orders
MODIFY COLUMN order_quantity INT,
MODIFY COLUMN cost_per_unit DECIMAL(12,2),
MODIFY COLUMN order_date DATE,
MODIFY COLUMN expected_delivery DATE,
MODIFY COLUMN actual_delivery DATE,
MODIFY COLUMN lead_time INT;



UPDATE sku_catalog
SET
    mrp = NULLIF(mrp, ''),
    cost_per_unit = NULLIF(cost_per_unit, '');
    
UPDATE sku_catalog
SET
    mrp = CAST(mrp AS DECIMAL(12,2)),
    cost_per_unit = CAST(cost_per_unit AS DECIMAL(12,2));
    
    
ALTER TABLE sku_catalog
MODIFY COLUMN mrp DECIMAL(12,2),
MODIFY COLUMN cost_per_unit DECIMAL(12,2);



UPDATE Website_daily
SET
    sessions = NULLIF(sessions, ''),
    product_views = NULLIF(product_views, ''),
    add_to_cart = NULLIF(add_to_cart, ''),
    begin_checkout = NULLIF(begin_checkout, ''),
    purchases = NULLIF(purchases, ''),
    revenue = NULLIF(revenue, ''),
    conversion_rate = REPLACE(NULLIF(conversion_rate, ''), '%', ''),
    aov = NULLIF(aov, ''),
    purchased = NULLIF(purchased, ''),
    event_date = NULLIF(event_date, '');
    
UPDATE Website_daily
SET
    sessions = CAST(sessions AS UNSIGNED),
    product_views = CAST(product_views AS UNSIGNED),
    add_to_cart = CAST(add_to_cart AS UNSIGNED),
    begin_checkout = CAST(begin_checkout AS UNSIGNED),
    purchases = CAST(purchases AS UNSIGNED),
    revenue = CAST(revenue AS DECIMAL(12,2)),
    conversion_rate = CAST(conversion_rate AS DECIMAL(5,2)),
    aov = CAST(aov AS DECIMAL(12,2)),
    purchased = CAST(purchased AS UNSIGNED);
    
UPDATE Website_daily
SET event_date = STR_TO_DATE(event_date, '%Y-%m-%d');

ALTER TABLE Website_daily
MODIFY COLUMN event_date DATE,
MODIFY COLUMN sessions INT,
MODIFY COLUMN product_views INT,
MODIFY COLUMN add_to_cart INT,
MODIFY COLUMN begin_checkout INT,
MODIFY COLUMN purchases INT,
MODIFY COLUMN revenue DECIMAL(12,2),
MODIFY COLUMN conversion_rate DECIMAL(5,2),
MODIFY COLUMN aov DECIMAL(12,2),
MODIFY COLUMN purchased INT;



UPDATE Website_sessions
SET
    sessions = NULLIF(sessions, ''),
    product_views = NULLIF(product_views, ''),
    add_to_cart = NULLIF(add_to_cart, ''),
    begin_checkout = NULLIF(begin_checkout, ''),
    purchased = NULLIF(purchased, ''),
    revenue = NULLIF(revenue, ''),
    event_date = NULLIF(event_date, '');
    
UPDATE Website_sessions
SET
    sessions = CAST(sessions AS UNSIGNED),
    product_views = CAST(product_views AS UNSIGNED),
    add_to_cart = CAST(add_to_cart AS UNSIGNED),
    begin_checkout = CAST(begin_checkout AS UNSIGNED),
    purchased = CAST(purchased AS UNSIGNED),
    revenue = CAST(revenue AS DECIMAL(12,2));
    
UPDATE Website_sessions
SET event_date = STR_TO_DATE(event_date, '%Y-%m-%d');

ALTER TABLE Website_sessions
MODIFY COLUMN event_date DATE,
MODIFY COLUMN sessions INT,
MODIFY COLUMN product_views INT,
MODIFY COLUMN add_to_cart INT,
MODIFY COLUMN begin_checkout INT,
MODIFY COLUMN purchased INT,
MODIFY COLUMN revenue DECIMAL(12,2);



