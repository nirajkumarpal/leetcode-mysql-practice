USE zomato;

-- 2.find all the movies made by top 3 directors(in terms of total gross income)
SELECT * FROM users
WHERE user_id NOT IN (SELECT DISTINCT(user_id) 
                        FROM orders);
 
WITH top_directors AS (SELECT director 
					FROM movies
					GROUP BY director
					ORDER BY SUM(gross) DESC
					LIMIT 3) 
SELECT * FROM movies
WHERE director IN (SELECT * FROM top_directors);
                    
-- 3.Find all movies of all those actors whose filmography's rating > 8.5(take 25000 votes as cutoff)
SELECT * FROM movies
WHERE star IN (SELECT star FROM movies
WHERE votes > 25000
GROUP BY star
HAVING AVG(score) > 8.5);


-- TABLE SUBQUERY(multi col mul row)
-- 1.Find the most profitable movies of year
SELECT * FROM movies
WHERE (year,gross - budget) IN (SELECT year,MAX(gross - budget)
									FROM movies
									GROUP BY year);
                                    
                                    
-- 2.Find the highest rated movie of each genere votes cutoff 25000
SELECT * FROM movies 
WHERE (genre,score) IN (SELECT genre,MAX(score)
							FROM movies
							WHERE votes > 25000
							GROUP BY  genre);
                            

-- 3.Find the highest grossing movies of top 5 actor/director combo in terms of total gross income
WITH top_duos AS (SELECT star,director,MAX(gross)
						FROM movies
						GROUP BY star,director
						ORDER BY SUM(gross) DESC LIMIT 5

)
SELECT * FROM movies
WHERE (star,director,gross) IN (SELECT * FROM top_duos);

-- Correlated subquery
-- 1.find all the movies that a rating higher than the average rating of movies in the same genre.[Animation]
SELECT * FROM movies m1
WHERE  score > (SELECT AVG(score) FROM movies m2 WHERE m2.genre = m1.genre);

-- 3.Find the favourite food of each customer

SELECT * FROM users
WHERE user_id NOT IN (SELECT DISTINCT(user_id) FROM orders);

WITH fav_food AS (
		SELECT name,f_name,COUNT(*) AS 'frequency' FROM users t1
		JOIN orders t2 ON t1.user_id = t2.user_id
		JOIN order_details t3 ON t2.order_id = t3.order_id
		JOIN food t4 ON t3.f_id = t4.f_id
		GROUP BY t2.user_id,t3.f_id

)
SELECT * FROM Fav_food 
WHERE frequency = (SELECT MAX(frequency) FROM fav_food f2 
                                          WHERE f2.user_id = f1.user_id);
                                          

