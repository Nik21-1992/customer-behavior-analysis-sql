LOAD DATA INFILE '/path/to/your/customers.csv'                          -- Data Loading 
INTO TABLE customers
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE customers (
    customer_id VARCHAR(20),
    name VARCHAR(100),
    first_order_date VARCHAR(20),     
    total_orders VARCHAR(10),          
    total_revenue VARCHAR(20),         
    average_order_value VARCHAR(20),   
    time_to_2nd_purchase VARCHAR(10),  
    last_purchase_date VARCHAR(20),   
    city VARCHAR(50),
    tier VARCHAR(20),
    acquisition_channel VARCHAR(50),
    repurchased VARCHAR(5)
);

CREATE TABLE inventory_snapshot (
    sku VARCHAR(20),
    category VARCHAR(50),
    size VARCHAR(10),
    units_in_stock VARCHAR(10),          
    units_sold_7days VARCHAR(10),        
    units_sold_30days VARCHAR(10),       
    units_sold_60days VARCHAR(10),       
    days_of_inventory_left VARCHAR(20),  
    dead_stock_flag VARCHAR(5),
    date VARCHAR(20)                      
);

CREATE TABLE meta_ads_campaigns (
    campaign_date VARCHAR(20),
    campaign_name VARCHAR(100),
    adset_name VARCHAR(100),
    results VARCHAR(10),
    amount_spent_inr VARCHAR(20),
    spend VARCHAR(20),
    reach VARCHAR(20),
    impressions VARCHAR(20),
    frequency VARCHAR(10),
    link_clicks VARCHAR(10),
    ctr_link VARCHAR(10),
    add_to_cart VARCHAR(10),
    initiate_checkout VARCHAR(10),
    purchases VARCHAR(10),
    purchase_conversion_value VARCHAR(20),
    cac VARCHAR(20),
    roas VARCHAR(10),
    creative_type VARCHAR(50),
    launch_date VARCHAR(20),
    hook_rate VARCHAR(10)
);

CREATE TABLE orders_line_items (
    order_id VARCHAR(30),
    sku_id VARCHAR(20),
    category VARCHAR(50),
    size VARCHAR(10),
    color VARCHAR(30),
    mrp VARCHAR(10),
    selling_price VARCHAR(10),
    discount_percent VARCHAR(10),
    returned VARCHAR(5),
    return_reason VARCHAR(100)
);

CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_datetime VARCHAR(50),
    product VARCHAR(100),
    order_value_gross VARCHAR(50),
    order_value_net VARCHAR(50),
    discount_applied_amount VARCHAR(50),
    discount_applied_percent VARCHAR(20),
    payment_mode VARCHAR(50),
    shipping_city VARCHAR(100),
    pincode VARCHAR(20),
    first_order_vs_repeat VARCHAR(20),
    channel_source_last_touch VARCHAR(50),
    delivery_status VARCHAR(50)
);

CREATE TABLE purchase_orders (
    sku VARCHAR(50),
    vendor VARCHAR(100),
    order_quantity VARCHAR(20),
    cost_per_unit VARCHAR(20),
    order_date VARCHAR(50),
    expected_delivery VARCHAR(50),
    actual_delivery VARCHAR(50),
    lead_time VARCHAR(20)
);

CREATE TABLE sku_catalog (
    sku VARCHAR(50),
    category VARCHAR(50),
    vendor VARCHAR(100),
    mrp VARCHAR(20),
    cost_per_unit VARCHAR(20)
);

CREATE TABLE website_daily (
    event_date VARCHAR(50),
    traffic_source VARCHAR(50),
    campaign_name VARCHAR(100),
    device_category VARCHAR(50),
    sessions VARCHAR(20),
    product_views VARCHAR(20),
    add_to_cart VARCHAR(20),
    begin_checkout VARCHAR(20),
    purchases VARCHAR(20),
    revenue VARCHAR(50),
    conversion_rate VARCHAR(20),
    aov VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    purchased VARCHAR(10)
);


CREATE TABLE website_sessions (
    session_id VARCHAR(50),
    event_date VARCHAR(50),
    traffic_source VARCHAR(50),
    campaign_name VARCHAR(100),
    device_category VARCHAR(50),
    city VARCHAR(50),
    sessions VARCHAR(20),
    product_views VARCHAR(20),
    add_to_cart VARCHAR(20),
    begin_checkout VARCHAR(20),
    purchased VARCHAR(20),
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    revenue VARCHAR(50)
);