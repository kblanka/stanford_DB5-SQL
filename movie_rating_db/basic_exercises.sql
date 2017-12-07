-- Q1
-- Find the titles of all movies directed by Steven Spielberg. 

SELECT title FROM Movie
WHERE director = "Steven Spielberg";

-- Q2
-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

SELECT DISTINCT year FROM Movie
JOIN Rating ON Movie.mID = Rating.mID
WHERE stars >= 4 ORDER BY year;

-- Q3
-- Find the titles of all movies that have no ratings. 

SELECT title FROM Movie
LEFT JOIN Rating ON Movie.mID = Rating.mID
WHERE Rating.mID IS NULL;

-- Q4
-- Some reviewers didn't provide a date with their rating. 
-- Find the names of all reviewers who have ratings with a NULL value for the date. 

SELECT name FROM Reviewer
JOIN Rating ON Reviewer.rID = Rating.rID
WHERE ratingDate IS NULL;

-- Q5
-- Write a query to return the ratings data in a more readable format: 
-- reviewer name, movie title, stars, and ratingDate. 
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

SELECT name, title, stars, ratingDate FROM Rating
JOIN Movie ON Rating.mID = Movie.mID
JOIN Reviewer ON rating.rID = Reviewer.rID
ORDER BY name, title, stars;

-- Q6
-- For all cases where the same reviewer rated the same movie twice and 
-- gave it a higher rating the second time, return the reviewer's name and the title of the movie.

SELECT name, title
FROM Movie, Reviewer, 
    (SELECT R1.rID, R1.mID
    FROM Rating R1, Rating R2
    WHERE R1.rID = R2.rID 
    AND R1.mID = R2.mID
    AND R1.stars < R2.stars
    AND R1.ratingDate < R2.ratingDate) C
WHERE Movie.mID = C.mID
AND Reviewer.rID = C.rID;

-- Q7
-- For each movie that has at least one rating, find the highest number of stars
-- that movie received. Return the movie title and number of stars. Sort by movie title. 

SELECT title, MAX(stars) FROM Movie
JOIN Rating ON Movie.mID = Rating.mID
GROUP BY title
ORDER BY title;

-- Q8
-- For each movie, return the title and the 'rating spread', 
-- that is, the difference between highest and lowest ratings given to that movie.
-- Sort by rating spread from highest to lowest, then by movie title. 

SELECT title, MAX(stars) - MIN(stars) AS rating_spread FROM Movie
JOIN Rating ON Movie.mID = Rating.mID
GROUP BY title
ORDER BY rating_spread DESC, title

-- Q9
-- Find the difference between the average rating of movies released before 1980
-- and the average rating of movies released after 1980. (Make sure to calculate 
-- the average rating for each movie, then the average of those averages for movies 
-- before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

SELECT AVG(before_1980.avg_rating) - AVG(after_1980.avg_rating) FROM
    (SELECT AVG(stars) AS avg_rating FROM Rating 
    JOIN Movie ON Rating.mID = Movie.mID
    WHERE year < 1980
    GROUP BY Rating.mID) AS before_1980,
    
    (SELECT AVG(stars) AS avg_rating FROM Rating 
    JOIN Movie ON Rating.mID = Movie.mID
    WHERE year >= 1980
    GROUP BY Rating.mID) AS after_1980
;
