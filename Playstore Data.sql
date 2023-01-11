CREATE database playstoredb;


CREATE TABLE `playstoredb`.`App_Data` (
    `App` VARCHAR(225) NULL,
    `Category` VARCHAR(225) NULL,
    `Rating` FLOAT NULL,
    `Reviews` FLOAT NULL,
    `Size` VARCHAR(225) NULL,
    `Installs` FLOAT NULL,
    `Type` VARCHAR(225) NULL,
    `Price` FLOAT NULL,
    `Content_Rating` VARCHAR(225) NULL,
    `Genres` VARCHAR(225) NULL,
    `Last_Updated` DATETIME NULL,
    `Current_Ver` VARCHAR(225) NULL,
    `Android_Ver` VARCHAR(225) NULL
);


SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Final_cleanedapps.csv' 
INTO TABLE app_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM app_data;


CREATE TABLE `playstoredb`.`App_Reviews` (
    `App` VARCHAR(225) NULL,
    `Translated_Review` VARCHAR(3000) NULL,
    `Sentiment` VARCHAR(3000) NULL,
    `Sentiment_Polarity` FLOAT NULL,
    `Sentiment_Subjectivity` FLOAT NULL
);


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Final_cleanedreviews.csv' 
INTO TABLE app_reviews
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) FROM app_reviews;

#1
SELECT 
    App, Rating
FROM
    app_data
ORDER BY rating DESC , App;


#2
SELECT 
    App, Installs, Reviews, Rating
FROM
    app_data
ORDER BY Reviews DESC;


#3
SELECT 
    App, Category, Reviews
FROM
    app_data
ORDER BY Reviews DESC
LIMIT 1;


#4
SELECT 
    SUM(Price) AS Total_Revenue
FROM
    app_data;


#5
SELECT DISTINCT
    Category, Installs
FROM
    app_data
ORDER BY Installs DESC , Category;


#6
SELECT 
    COUNT(App) AS app_count, Genres
FROM
    app_data
GROUP BY Genres
ORDER BY app_count DESC;


#7
SELECT DISTINCT
    App, Category, Installs
FROM
    app_data
WHERE
    Category = 'GAME'
ORDER BY Installs DESC;


#8
SELECT 
    *
FROM
    app_data
WHERE
    Android_Ver LIKE '%4.0.3%';


#9
SELECT 
    App, Type
FROM
    app_data
WHERE
    type = 'Free';
SELECT 
    COUNT(App) AS num_paid_app
FROM
    app_data
WHERE
    type = 'Paid';


#10
SELECT 
    App, Reviews
FROM
    APp_data
WHERE
    Genres = 'Dating'
ORDER BY Reviews DESC;


#11
SELECT 
    SUM(Sentiment = 'Positive') AS Positive_review,
    SUM(Sentiment = 'Negative') AS Negative_Review
FROM
    app_reviews
WHERE
    App LIKE '10 best foods for you';


#12
SELECT 
    APP, Translated_Review as Comment, Sentiment_Polarity, Sentiment_Subjectivity
FROM
    app_reviews
WHERE
    App = 'ASUS SuperNote'
        AND Sentiment_polarity = 1
        AND Sentiment_Subjectivity = 1;


#13
SELECT 
    APP, Sentiment, Translated_Review
FROM
    app_reviews
WHERE
    App = 'Abs Training-Burn belly fat'
        AND Sentiment = 'neutral';


#14
SELECT 
    APP, Sentiment, Sentiment_Polarity, Sentiment_Subjectivity
FROM
    app_reviews
WHERE
    App = 'Adobe Acrobat Reader'
        AND Sentiment = 'negative';
        
        
