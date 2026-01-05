-- Question based on Grouping and sorting

-- 1.Group smartphones by brand and get the count, average price, max rating, avg screen size, and avg battery capacity
SELECT brand_name,COUNT(*) AS 'num_phone',
ROUND(AVG(price),2) AS 'avg price',
MAX(rating) AS 'max_rating',
ROUND(AVG(screen_size),2) AS 'avg_screen_size',
ROUND(AVG(battery_capacity),2) AS 'avg_battery_capacity'
FROM campusx.smartphones
GROUP BY brand_name
ORDER BY num_phone DESC 


-- 2.Group smartphones by whether they have an NFC and get the average price and rating
SELECT has_nfc,
ROUND(AVG(price),2) AS 'avg_price',
ROUND(AVG(rating),2) AS 'avg_rating'
FROM campusx.smartphones
GROUP BY has_nfc

-- 3.Group smartphones by the extended memory available and get the average price
-- 3.same as 2 

-- 4.Group smartphones by the brand and processor brand and get the count of models and the average primary camera resolution (rear)
SELECT brand_name,processor_brand,COUNT(*) AS 'num_phones',
ROUND(AVG(primary_camera_rear),2) AS 'avg camera resolution'
FROM campusx.smartphones
GROUP BY brand_name,processor_brand
ORDER BY brand_name,processor_brand ASC 

-- 5.Find the top 5 most costly phone brands
SELECT brand_name,
SUM(price) AS 'Total_price'
FROM campusx.smartphones
GROUP BY brand_name
ORDER BY Total_price DESC LIMIT 5
 
-- 6.Which brand makes the smallest-screen smartphones
SELECT brand_name ,
ROUND(AVG(screen_size),2) AS 'avg_screen_size'
FROM campusx.smartphones
GROUP BY brand_name
ORDER BY avg_screen_size ASC LIMIT 1

-- 7.AVG price of 5g phones vs avg price of non 5g phones
SELECT has_5g ,
AVG(price) AS 'avg_price'
FROM campusx.smartphones
GROUP BY has_5g

-- 8.Group smartphones by the brand, and find the brand with the highest number of models that have both NFC and an IR blaster
SELECT brand_name,COUNT(*) AS 'count'
FROM campusx.smartphones
WHERE has_nfc = 'True'AND has_ir_blaster = 'True'
GROUP BY brand_name
ORDER BY count DESC LIMIT 1

-- 9.Find all Samsung 5g enabled smartphones and find out the avg price for NFC and Non-NFC phones
SELECT brand_name,has_5g,has_nfc,
ROUND(AVG(price),2) AS 'agv_price'
FROM campusx.smartphones
WHERE brand_name = 'samsung' AND has_5g = 'True'
GROUP BY has_nfc


HAVING clause

SELECT brand_name,
COUNT(*) AS 'count',
AVG(price) AS 'avg_price'
FROM campusx.smartphones
GROUP BY brand_name
HAVING count > 40
ORDER BY avg_price DESC

-- 1.Costliest Brand which has at least 20 phones.
SELECT brand_name,
COUNT(*) AS 'count',
ROUND(AVG(rating),2) AS 'avg_rating'
FROM campusx.smartphones
GROUP BY brand_name
HAVING count >20
ORDER BY avg_rating DESC

-- 2.Find the top 3 brands with the highest avg ram that has a refresh rate of at least 90 Hz and fast charging available and don't consider brands that have less than 10 phones
SELECT brand_name ,
COUNT(*) AS 'count',
AVG(ram_capacity) AS 'avg_ram_capacity'
FROM campusx.smartphones
WHERE refresh_rate >=90 AND fast_charging_available = 1 
GROUP BY brand_name
HAVING count = 20
ORDER BY avg_ram_capacity DESC LIMIT 3

-- 3.Find the avg price of all the phone brands with avg rating of 70 and num_phones more than 10 among all 5g enabled phones
COUNT(*) AS 'count',
AVG(price) AS 'avg_price',
AVG(rating) AS 'avg_rating'
FROM campusx.smartphones
WHERE  has_5g = True 
GROUP BY brand_name
HAVING count > 10 AND avg_rating > 70
ORDER BY avg_price, avg_rating DESC 

-- Practice on IPL Dataset
-- 1.find the top 5 batsmen in IPL
SELECT batter ,
SUM(batsman_run)
FROM campusx.ipl
GROUP BY batter
ORDER BY SUM(batsman_run) DESC LIMIT 5

-- 2.find the 2nd highest 6 hitters in IPL
SELECT batter,
COUNT(*) AS 'total_sixes'
FROM campusx.ipl
WHERE batsman_run = 6
GROUP BY batter
ORDER BY total_sixes DESC LIMIT 1,1

-- 3. Find Virat Kohli's performance against all IPL teams [info not available- bowling team]

SELECT batter, ID,SUM(batsman_runs) AS 'score'
FROM campusx.ipl
GROUP BY batter,ID
HAVING 'score' >= 100
ORDER BY 'score' DESC