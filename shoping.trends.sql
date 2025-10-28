---ALL RECORDS WHERE SIZE IS MISSING AND THE PURCHASE AMOUNT IS GREATER THAN 50.
SELECT customer_id, size, purchase_amount, item_purchased
FROM SHOPING.PUBLIC.TRENDS
WHERE size IS NULL
AND purchase_amount>50;
-----------------------------------------------------------------------------

---TOTAL NUMBER OF PURCHASES GROUPED BY SEASON,TREATING NULL VALUES AS 'UNKNOWN SEASON'.
SELECT
    IFNULL(season,'unknown_season') AS season,
    COUNT(item_purchased) AS total_purchases 
FROM SHOPING.PUBLIC.TRENDS
GROUP BY IFNULL(season,'unknown_season');
------------------------------------------------------------------------------

---HOW MANY CUSTOMERS USED EACH PAYMENT METHOD,TREAT NULL AS 'NOT PROVIDED'.
SELECT
    IFNULL (payment_method,'not provided') AS payment_method,
    COUNT(customer_id) as customer_count
FROM SHOPING.PUBLIC.TRENDS
GROUP BY IFNULL (payment_method,'not provided');



---CUSTOMERS WHERE PROMO CODE USED IS NULL AND REVIEW RATING IS BELOW 3.0.
SELECT customer_id, promo_code_used, review_rating, item_purchased
FROM SHOPING.PUBLIC.TRENDS
WHERE promo_code_used IS NULL
AND review_rating <3.0;
-----------------------------------------------------------------------------


---GROUP CUSTOMERS BY SHIPPING,RETURN THE AVERAGE PURCHASE AMOUNT,TREATING MISSING VALUES AS 0 
SELECT shipping_type,
    AVG (COALESCE(purchase_amount,0)) AS average_purchase_amount,
FROM SHOPING.PUBLIC.TRENDS
GROUP BY shipping_type;
-----------------------------------------------------------------------------


---NUMBER OF PURCHASES PER LOCATION ONLY FOR THOSE WITH MORE THAN ONE 5 PURCHASES AND NO NULL PAYMENT METHOD.
SELECT location,
    COUNT (payment_method) as total_purchases
FROM SHOPING.PUBLIC.TRENDS
WHERE payment_method IS NOT NULL
GROUP BY location
HAVING COUNT(payment_method)>5;
-----------------------------------------------------------------------------


---CREATE COLUMN SPENDER CATEGORY THAT CLASSIFIES CUSTOMERS USING CASE.
SELECT customer_id,
    COALESCE (purchase_amount,0) AS purchase_amount,
CASE 
    WHEN purchase_amount >80 THEN 'high'
 WHEN purchase_amount BETWEEN 50 AND 80 THEN 'medium'
 ELSE 'low'
END AS spender_category
FROM SHOPING.PUBLIC.TRENDS;
-----------------------------------------------------------------------------


---CUSTOMERS WHO HAVE NO PREVIOUS PURCHASES VALUE BUT WHOSE COLOR IS NOT NULL.
SELECT customer_id, color, previous_purchases
FROM SHOPING.PUBLIC.TRENDS
WHERE previous_purchases IS NULL
AND color IS NOT NULL;
-----------------------------------------------------------------------------


---GROUP RECORDS BY FREQUENCY OF PURCHASES AND SHOW THE TOTAL AMOUNT SPENT PER GROUP TREATING NULL FREQUENCIES AS 'UNKNOWN'
SELECT 
    IFNULL (frequency_of_purchases,'unknown') AS frequency_of_purchases,
    SUM (purchase_amount) as total_purchase_amount
FROM SHOPING.PUBLIC.TRENDS
GROUP BY frequency_of_purchases;
-----------------------------------------------------------------------------


---DISPLAY A LIST OF ALL CATEGORY VALUES WITH THE NUMBER OF TIMES EACH WAS PURCHASED,EXCLUDING ROWS WHERE CATEGORY IS NULL.
SELECT category,
    COUNT (previous_purchases) AS total_purchases
FROM SHOPING.PUBLIC.TRENDS
WHERE category IS NOT NULL
GROUP BY category;
-----------------------------------------------------------------------------


---TOP 5 LOCATION WITH THE HIGHEST TOTAL PURCHASE_AMOUNT, REPLACING NULLS IN AMOUNT WITH 0.
SELECT location,
    SUM (COALESCE(purchase_amount,0)) AS total_purchase_amount
FROM SHOPING.PUBLIC.TRENDS
GROUP BY location
ORDER BY SUM (purchase_amount) DESC
LIMIT 5;
-----------------------------------------------------------------------------


---GROUP CUSTOMERS BY GENDER AND SIZE AND COUNT HOW MANY ENTRIES HAVE A NULL COLOUR.
SELECT gender,size,
    COUNT (color) AS null_color_count
FROM SHOPING.PUBLIC.TRENDS
WHERE color IS NULL
GROUP BY gender,size;
-----------------------------------------------------------------------------


---ITEMS PRCHASED WHERE MORE THAN 3 PURCHASES HAD NULL NULL SHIPPING TYPE.
SELECT item_purchased,
    COUNT (shipping_type) AS null_shipping_type_count
FROM SHOPING.PUBLIC.TRENDS
WHERE shipping_type IS NULL
GROUP by item_purchased
HAVING  count (shipping_type)>3;
-----------------------------------------------------------------------------


---HOW MANY CUSTOMERS PER PAYMENT METHOD HAVE NULL REVIEW RATING.
SELECT payment_method,
    COUNT (review_rating) AS missing_review_rating_count
FROM SHOPING.PUBLIC.TRENDS   
WHERE review_rating IS NULL
GROUP BY payment_method;
-----------------------------------------------------------------------------


---GROUP BY CATEGORY AND RETURN THE AVERAGE REVIEW RATING, REPLACING NULLS WITH 0 AND FILTER ONLY WHERE AVERAGE IS GREATER THAN 3.5.
SELECT category,
    AVG (COALESCE(review_rating,0)) AS average_review_rating
FROM SHOPING.PUBLIC.TRENDS
GROUP BY category
HAVING AVG (COALESCE(review_rating,0))>=3.5;
-----------------------------------------------------------------------------

---COLORS THAT ARE MISSIG IN AT LEAST 2 ROWS AD THE AVERAGE AGE OF CUSTOMERS FOR THOSE ROWS.
SELECT color,
    AVG (age) AS average_age
FROM SHOPING.PUBLIC.TRENDS   
where color IS NULL
GROUP BY color
HAVING COUNT (color) >=2;
-----------------------------------------------------------------------------


---CREATE COLUMN DELIVERY SPEED, THEN COUNT HOW MANY CUSTOMERS FALL INTO EACH CATEGORY.
SELECT 
    CASE 
    WHEN shipping_type IN ('express,next_day_air') THEN 'fast'
    WHEN  shipping_type = 'standard' THEN 'slow'
ELSE 'other'
END AS delivery_speed,
    COUNT (customer_id) AS customer_count
FROM SHOPING.PUBLIC.TRENDS 
GROUP BY delivery_speed;
-----------------------------------------------------------------------------


---CUSTOMERS WHOSE PURCHASE_AMOUNT IS NULL AND WHOSE PROMO CODE USED IS YES.
SELECT customer_id, purchase_amount, promo_code_used
FROM SHOPING.PUBLIC.TRENDS 
WHERE purchase_amount = null
AND promo_code_used = 'yes';
-----------------------------------------------------------------------------


---GROUP BY LOCATION AND SHOW MAXIMUM PREVIOUS PURCHASES, REPLACING NULLS WITH 0,ONLY WHERE THE AVERAGE RATING IS ABOVE 4.0.
SELECT location,
    MAX(previous_purchases) AS max_previous_purchase,
    AVG (review_rating) AS avg_review_rating
FROM SHOPING.PUBLIC.TRENDS 
GROUP BY location
HAVING AVG (review_rating) >4.0;
-----------------------------------------------------------------------------


---CUSTOMERS WHO HAVE NULL SHIPPING TYPE BUT MADE PURCHASES IN RANGE OF 30 TO 40 USD.
SELECT customer_id, shipping_type, purchase_amount, item_purchased
FROM SHOPING.PUBLIC.TRENDS 
WHERE shipping_type IS NULL
    AND purchase_amount BETWEEN 30  AND 70;
