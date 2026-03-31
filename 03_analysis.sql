Understanding customer behavior, retention, and channel performance to identify growth opportunities.

Analysis Part 1 : 

-- ======================================
-- 1. Digital Active vs Inactive Customers
-- ======================================

Customers -->  Website Sessions  

WITH session_summary AS (
    SELECT DISTINCT customer_id
    FROM website_sessions
)
SELECT 
    COUNT(*) AS total_users,
    COUNT(s.customer_id) AS active_users,
    COUNT(*) - COUNT(s.customer_id) AS inactive_users
FROM customers c
LEFT JOIN session_summary s
    ON c.customer_id = s.customer_id;
         
 

O/P:
Total Users:16865
Active Users:12580	
Inactive Users:4285

Insight + Impact :~25% users are inactive → re-engagement opportunity

(For recheck , used for inactive count: SELECT COUNT(a.customer_id) as inactive_users 
                                        FROM customers a
                                        WHERE NOT EXISTS (
                                                           SELECT 1 
                                                           FROM website_sessions ws
                                                           WHERE ws.customer_id = a.customer_id  )




-- ========================================
-- 2. Repeat Buyers for Customer Retention
-- ========================================

select count(distinct customer_id) as total_customers
from customers
where time_to_2nd_purchase is not null 

OR

select count(distinct customer_id) as total_customer
from customers
where repurchased='Y';

O/P : 
Total Customers with 2nd Purchase - 7748

Insight + Impact : -- ~46% customers are repeat buyers, indicating a strong retention base.
                   -- Business Impact: Opportunity to increase Customer Lifetime Value (CLV) via loyalty programs and personalized marketing.


-- =================
-- 3. AOV per Order
-- =================

select ROUND(SUM(total_revenue)/SUM(total_orders),2) as AOV
from customers;

AOV - 2533.57

Insight + Impact : -- AOV is relatively stable (~2533), indicating consistent purchasing behavior.
                   -- Should focus on increasing conversion rate and purchase frequency rather than pricing changes.


-- ===========================
-- 4. Average Repurchase Time
-- ===========================

Query : select customer_id , DATEDIFF(last_purchase_date , first_order_date) as daydifference , time_to_2nd_purchase
from customers
where repurchased='Y'

Sample O/P (time_to_2nd_purchase already present in table) : 

CUST-0000004	450	449
CUST-0000007	303	303
CUST-0000009	60	60
CUST-0000019	149	149
CUST-0000030	705	705
CUST-0000036	443	74
CUST-0000040	708	708
CUST-0000042	1036	100

Observations : This is the last purchase date and not the second purchase date , some users might have more than 2 purchases .

Checking the order table : 

with order_time_2nd_purchase as ( 
select customer_id , order_datetime , ROW_NUMBER() over (partition by customer_id order by order_datetime) as rn 
from orders
)

select customer_id , 
TIMESTAMPDIFF(Day,MAX(case when rn=1 then order_datetime else null end) ,MAX(case when rn=2 then order_datetime else null end)) as time_difference
from order_time_2nd_purchase
group by customer_id
having TIMESTAMPDIFF(Day,MAX(case when rn=1 then order_datetime else null end) ,MAX(case when rn=2 then order_datetime else null end))>0


O/P:
CUST-0000004	449
CUST-0000007	303
CUST-0000009	60
CUST-0000019	149
CUST-0000030	705
CUST-0000036	74
CUST-0000040	708
CUST-0000042	100
CUST-0000043	166                             ---Now ordered and correct . 

(Average day per customer to re-order (Including all customers) - 412)

Insight + Impact :  -- Average time to 2nd purchase is ~412 days (very long cycle)
                    -- Indicates low repurchase frequency → opportunity for retention campaigns



-- ======================================
-- 5. Acquisition and Share per channel 
-- ======================================


with customer_aggregate as  ( 
select customer_id , SUM(order_value_net) as total_amount , COUNT(*) as total_orders_done 
from orders 
where delivery_status='Delivered'
group by customer_id
),

acquisition_channel as ( select a.acquisition_channel , SUM(total_amount) as channel_amount , SUM(total_amount)/SUM(total_orders_done) as avg_order_value_per_order , 
SUM(total_amount)/count(*) as avg_order_value_per_customer 
from customers a 
join customer_aggregate b 
on a.customer_id=b.customer_id
group by a.acquisition_channel
order by  SUM(total_amount) desc )

select acquisition_channel , channel_amount , avg_order_value_per_order , avg_order_value_per_customer , 
100.0*(channel_amount / SUM(channel_amount) over ()) as share_of_channel
from acquisition_channel

O/P :  
acquisition_channel                  channel_amount          avg_order_value_per_order    avg_order_value_per_customer    share_of_channel
Meta                                 21231533                2524.558                      3766.46                        43.22
Influencer                            7940379                2519.955                      3761.43                        16.16
Google                                7823279                2549.961                     3685.011                        15.93
Organic Instagram                     3697066                2535.711                     3855.126                        7.53
Email/SMS                             3368115                2511.644                       3814.4                        6.86
Offline(Friends/Family)               2568816                2530.853                     3880.387                        5.23
Instagram DM                          2492341                2569.424                     3805.101                        5.07

Insight + Impact:
-- Meta Channel has the maximum potential with 43.2% share among the incoming revenue.
-- Organic Instagram (Free posting) has also considerable share among other platforms.
-- Combining Infulencer/Organic Instagram/Instagram DM , platform shows a high revenue combined 



-- ============================================
-- 6. Additional Insights of Tier based Revenue
-- ============================================

Tier 1 : Ahmedabad , Bengaluru , Chennai , Delhi , Hyderabad , Kolkata , Mumbai , Pune
Tier 2 : Bhopal , Bhubaneswar , Chandigarh, Coimbatore , Dehradun , Gurgaon , Indore , Jaipur , Kanpur , Kochi , Lucknow , Ludhiana , Mysuru , Nagpur , Nashik , Noida , Patna , Rajkot , Ranchi , Surat , Vadodara , Visakhapatnam 
																														


Query : 

with customer_aggregate as  ( 
select customer_id , SUM(order_value_net) as total_amount , COUNT(*) as total_orders_done 
from orders 
where delivery_status='Delivered'
group by customer_id
),

acquisition_channels as ( select a.acquisition_channel ,  a.tier , SUM(total_amount) as channel_amount
from customers a 
join customer_aggregate b 
on a.customer_id=b.customer_id
group by a.acquisition_channel  , a.tier
order by  SUM(total_amount) desc )

select acquisition_channel , tier , channel_amount , 
ROUND(100.0*(channel_amount / SUM(channel_amount) over ()),2) as share_of_channel
from acquisition_channels
order by share_of_channel desc


O/P : 

acquisition_channel          tier        channel_amount      share_of_channel
Meta                         Tier 2      10915728            22.22
Meta                         Tier 1      10315805            21
Influencer                   Tier 1      4013632             8.17
Influencer                   Tier 2      3926747             7.99
Google                       Tier 1      3918902             7.98
Google                       Tier 2      3904377             7.95
Organic Instagram            Tier 1      1881725             3.83
Organic Instagram            Tier 2      1815341             3.7
Email/SMS                    Tier 1      1713401             3.49
Email/SMS                    Tier 2      1654714             3.37
Instagram DM                 Tier 2      1381371             2.81
Offline(Friends/Family)      Tier 2      1344896             2.74
Offline(Friends/Family)      Tier 1      1223920             2.49
Instagram DM                 Tier 1      1110970             2.26


Insight + Impact: -- Tier 2 contributes nearly equal revenue as Tier 1 across major platforms, indicating strong expansion potential beyond primary markets(Tier 1)


--> Rechecking values for Meta Channel /  Tier 2 to confirm:
 
with customer_aggregate as  ( 
select customer_id , SUM(order_value_net) as total_amount , COUNT(*) as total_orders_done 
from orders 
where delivery_status='Delivered'
group by customer_id
)

select a.tier , a.acquisition_channel , sum(b.total_amount) as total
from customers a
join customer_aggregate b 
on a.customer_id=b.customer_id
where a.tier like '%Tier 2%' 
AND a.acquisition_channel like '%Meta%'
group by a.tier , a.acquisition_channel

)







Analysis Part 2:

Website sessions totaled 475,658 rows, representing 475,644 distinct sessions. 
Only 14 duplicates were observed, likely due to logging retries. This confirms the session-level data is reliable for funnel and platform engagement analysis.


-- ========================================
-- 1. Participation Funnel Using Sessions                 (Using website_session table -- Participation Funnel): 
-- ========================================         

with session_based_flags as ( 
select session_id,
case when sessions < 1 or session_id is null then 0 else 1 end as session_flag , 
case when product_views <1 or product_views is null then 0 else 1 end as product_view_flag , 
case when add_to_cart <1 or add_to_cart is null then 0 else 1 end as add_to_cart_flag , 
case when begin_checkout<1 or begin_checkout is null then 0 else 1 end as begin_checkout_flag ,
case when purchased<1 or purchased is null then 0 else 1 end as purchased_flag
from website_sessions
),

combine_data as ( 
select 1 as stage , 'total_session' as session_stage , count(*) as total
from session_based_flags
UNION ALL
select 2 as stage ,  'product_view_flag' as session_stage , SUM(product_view_flag) as total
from session_based_flags
UNION ALL
select 3 as stage ,  'add_to_cart_flag' as session_stage ,  SUM(add_to_cart_flag) as total
from session_based_flags
UNION ALL
select 4 as stage , 'begin_checkout_flag' as session_stage , SUM(begin_checkout_flag) as total
from session_based_flags
UNION ALL
select 5 as stage , 'purchased_flag' as session_stage ,  SUM(purchased_flag) as total
from session_based_flags),

footfall as ( select stage , session_stage , total , LAG(total) over (order by stage) as previous_total
from combine_data
)

select stage , session_stage , total , ROUND(IFNULL(100.0*(previous_total - total) / (previous_total),0),2) as precentage_decrease
from  footfall


O/P: 

stage   session_stage           total        precentage_decrease
1	total_session	        475658	     0.00
2	product_view_flag	456128	     4.11
3	add_to_cart_flag	 64708	     85.81
4	begin_checkout_flag	 49048	     24.20
5	purchased_flag	         29983	     38.87


Insight + Impact: -- Insight: ~86% drop between product view → add to cart (major conversion bottleneck)
                  -- Business Impact: Indicates friction in product page (pricing, UX, trust signals, or intent mismatch)




-- ======================================
-- 2. Session Analysis using Platform
-- ====================================== 

with traffic_source_platform as  ( 
select traffic_source as platform,
case when sessions < 1 or session_id is null then 0 else 1 end as session_flag , 
case when product_views <1 or product_views is null then 0 else 1 end as product_view_flag , 
case when add_to_cart <1 or add_to_cart is null then 0 else 1 end as add_to_cart_flag , 
case when begin_checkout<1 or begin_checkout is null then 0 else 1 end as begin_checkout_flag ,
case when purchased<1 or purchased is null then 0 else 1 end as purchased_flag
from website_sessions
)

select platform , 
SUM(session_flag) as session_flag , SUM(product_view_flag) as product_view_flag , SUM(add_to_cart_flag) as add_to_cart_flag , 
SUM(begin_checkout_flag) as begin_checkout_flag , SUM(purchased_flag) as purchased_flag ,
ROUND(100.0*SUM(product_view_flag)/SUM(session_flag),2) as view_percentage , 
ROUND(100.0*SUM(add_to_cart_flag)/SUM(session_flag),2) as add_to_cart_percentage , 
ROUND(100.0*SUM(begin_checkout_flag)/SUM(session_flag),2) as begin_checkout_percentage , 
ROUND(100.0*SUM(purchased_flag)/SUM(session_flag),2) as purchased_percentage 
from traffic_source_platform
group by platform



O/P : 

Meta	             228192	218834	29811	22201	12936	95.90	13.06	9.73	5.67
Google	              85288	 81759	11190	8382	4912	95.86	13.12	9.83	5.76
Influencer	      85937	 82413	11096	8286	4850	95.90	12.91	9.64	5.64
Organic Instagram     38077	 36496	7716	6546	5219	95.85	20.26	17.19	13.71
Email/SMS	      38164	 36626	4895	3633	2066	95.97	12.83	9.52	5.41


Insight + Impact: -- Meta has the highest volumne out of all platforms.
                  -- Organic Instagram has the best conversion rate out of all the platforms. (~13–14%)
                  -- Investing more towards high conversion channels and simultaneously optimising Meta for efficiency.



-- =========================================================
-- 3. Session and Purchase Conversion based on Platform/Year    (Time Series partitcipation funnel analysis):
-- =========================================================

with traffic_source_platform as  ( 
select traffic_source as platform, event_date ,
case when sessions < 1 or session_id is null then 0 else 1 end as session_flag , 
case when product_views <1 or product_views is null then 0 else 1 end as product_view_flag , 
case when add_to_cart <1 or add_to_cart is null then 0 else 1 end as add_to_cart_flag , 
case when begin_checkout<1 or begin_checkout is null then 0 else 1 end as begin_checkout_flag ,
case when purchased<1 or purchased is null then 0 else 1 end as purchased_flag
from website_sessions
)

select platform , YEAR(event_date) as event_date,
SUM(session_flag) as session_flag , SUM(product_view_flag) as product_view_flag , SUM(add_to_cart_flag) as add_to_cart_flag , 
SUM(begin_checkout_flag) as begin_checkout_flag , SUM(purchased_flag) as purchased_flag ,
ROUND(100.0*SUM(product_view_flag)/SUM(session_flag),2) as view_percentage , 
ROUND(100.0*SUM(add_to_cart_flag)/SUM(session_flag),2) as add_to_cart_percentage , 
ROUND(100.0*SUM(begin_checkout_flag)/SUM(session_flag),2) as begin_checkout_percentage , 
ROUND(100.0*SUM(purchased_flag)/SUM(session_flag),2) as purchased_percentage 
from traffic_source_platform
group by platform , YEAR(event_date)
order by platform , YEAR(event_date)


O/P: 

Email/SMS	            2022	7912	7590	999	700	375	95.93	12.63	8.85	4.74
Google	                    2022	18048	17324	2302	1709	933	95.99	12.75	9.47	5.17
Influencer	            2022	18240	17531	2226	1612	883	96.11	12.20	8.84	4.84
Meta	                    2022	48168	46145	6077	4405	2467	95.80	12.62	9.15	5.12
Organic Instagram	    2022	7986	7649	1539	1297	1026	95.78	19.27	16.24	12.85
Email/SMS	            2023	10074	9674	1293	985	567	96.03	12.84	9.78	5.63
Google	                    2023	22344	21392	2973	2227	1311	95.74	13.31	9.97	5.87
Influencer	            2023	22457	21501	2979	2248	1343	95.74	13.27	10.01	5.98
Meta	                    2023	60063	57581	8013	5970	3545	95.87	13.34	9.94	5.90
Organic Instagram	    2023	9962	9547	2040	1725	1384	95.83	20.48	17.32	13.89
Email/SMS	            2024	10044	9623	1283	974	551	95.81	12.77	9.70	5.49
Google	                    2024	22387	21460	2884	2154	1283	95.86	12.88	9.62	5.73
Influencer	            2024	22730	21787	2907	2196	1284	95.85	12.79	9.66	5.65
Meta	                    2024	60112	57717	7933	5900	3412	96.02	13.20	9.82	5.68
Organic Instagram	    2024	10036	9593	2071	1747	1404	95.59	20.64	17.41	13.99
Email/SMS	            2025	10134	9739	1320	974	573	96.10	13.03	9.61	5.65
Google	                    2025	22509	21583	3031	2292	1385	95.89	13.47	10.18	6.15
Influencer	            2025	22510	21594	2984	2230	1340	95.93	13.26	9.91	5.95
Meta	                    2025	59849	57391	7788	5926	3512	95.89	13.01	9.90	5.87
Organic Instagram	    2025	10093	9707	2066	1777	1405	96.18	20.47	17.61	13.92


Observations : 
Meta has the highest total sessions every year, showing it’s your dominant traffic source.
Google and Influencer are mid-tier , while Email/SMS and Organic Instagram are smaller.
Most platforms show gradual growth , e.g. : Meta increases from 48k → 60k sessions, Email/SMS 7.9k → 10.1k.
Meta dominates in volume, while Organic Instagram is smaller but highly engaged(All platforms of Instagram),


Similarly for Sequential Funnel for a true stage conversion , This query can be modified by staging all conversion flags in one go.



-- =====================================================================
-- 4. Additional Insight based on Session based orders vs Overall Orders    
-- =====================================================================


-- Check % of orders with session
SELECT 
  COUNT(DISTINCT b.order_id) AS orders_with_session,
  COUNT(DISTINCT a.order_id) AS total_orders,
  ROUND(100.0 * COUNT(DISTINCT b.order_id)/COUNT(DISTINCT a.order_id),2) AS pct_orders_with_session
FROM orders a
LEFT JOIN website_sessions b
  ON a.order_id = b.order_id;


O/P:
orders_with_session           total_orders        pct_orders_with_session
18382	                      30000	          61.27


Insight + Impact: -- ~39 percent orders are not present in Sessions . 
                  -- Multiple orders per customer, not every order generates a session (e.g., offline orders, call center, app-only, or system logging gaps).
                  -- Some orders might never have been captured in website_sessions, which is expected if the session table only tracks web activity.




-- ======================================
-- FINAL BUSINESS SUMMARY
-- ======================================

-- 1. Conversion Issue:
-- ~86% drop from product view → add to cart → biggest growth bottleneck

-- 2. Channel Strategy:
-- Meta drives ~43% revenue (scale channel)
-- Organic Instagram has highest conversion → underutilized growth lever

-- 3. Retention Opportunity:
-- ~46% repeat customers (strong base)
-- However, 412 days avg repurchase time → needs improvement

-- 4. Customer Engagement Gap:
-- ~25% customers digitally inactive → re-engagement opportunity

-- 5. Market Expansion:
-- Tier 2 cities contribute nearly equal to Tier 1 → strong expansion potential

-- Overall Recommendation:
-- Focus on improving conversion funnel, scaling high-performing channels,
-- and reducing repurchase cycle to drive sustainable growth
