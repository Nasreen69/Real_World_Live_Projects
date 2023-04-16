-- Task 1: For a high-level overview of the hotels, provide us the top 5 most voted hotels in the delivery category.

select name,votes,rating from zomato where type = 'delivery' order by votes desc
limit 5 ;

-- Task 2: The rating of a hotel is a key identifier in determining a restaurant’s performance. Hence for a particular location called Banashankari find out the top 5 highly rated hotels in the delivery category.

SELECT name, rating,location, type FROM zomato WHERE type = 'delivery' AND location = 'Banashankari' ORDER BY rating DESC
LIMIT 5;

-- Task 3: Compare the ratings of the cheapest and most expensive hotels in Indiranagar.
SELECT 
  (SELECT rating FROM zomato WHERE location = 'Indiranagar' ORDER BY approx_cost ASC LIMIT 1) AS rating1, 
  (SELECT rating FROM zomato WHERE location = 'Indiranagar' ORDER BY approx_cost DESC LIMIT 1) AS rating2;
  
-- Task 4: Online ordering of food has exponentially increased over time. Compare the total votes of restaurants that provide online ordering services and those that don’t provide online ordering services.
SELECT online_order, Sum(votes) AS total_votes
FROM zomato
WHERE online_order = 'Yes'
UNION
SELECT online_order, SUM(votes) AS total_votes
FROM zomato
WHERE online_order = 'No';

-- Task 5: Number of votes defines how much the customers are involved with the service provided by the restaurants For each Restaurant type, find out the number of restaurants, total votes, and average rating. Display the data with the highest votes on the top( if the first row of output is NA display the remaining rows).
SELECT
    type,
    COUNT(type) AS num_restaurants,
    SUM(votes) AS total_votes,
    AVG(rating) AS avg_rating
FROM
    zomato
WHERE
    type IS NOT NULL
    AND type != 'NA'
GROUP BY
    type
ORDER BY
    total_votes DESC,
    type;
    
-- Task 6: What is the most liked dish of the most-voted restaurant on Zomato(as the restaurant has a tie-up with Zomato, the restaurant compulsorily provides online ordering and delivery facilities.
SELECT name, dish_liked, rating, votes
FROM zomato
WHERE name = (SELECT name
              FROM zomato
              WHERE online_order = 'Yes'
              and name = 'Brew and Barbeque - A Microbrewery Pub'
              GROUP BY name
              ORDER BY max(votes) DESC
              LIMIT 1)
LIMIT 1;

-- Task 7: To increase the maximum profit, Zomato is in need to expand its business. For doing so Zomato wants the list of the top 15 restaurants which have min 150 votes, have a rating greater than 3, and is currently not providing online ordering. Display the restaurants with the highest votes on the top.
SELECT name, rating, votes, online_order
FROM zomato
WHERE online_order = 'No' AND rating > 3 AND votes >= 150
ORDER BY votes DESC
LIMIT 15;