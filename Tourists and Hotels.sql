# Tourism & Hotel Booking Insights :--

Create database touristsHotel;
use touristsHotel;

CREATE TABLE Tourists (
    Tourist_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Gender VARCHAR(10),
    Country VARCHAR(50),
    Age INT,
    Membership_Level VARCHAR(20)  -- e.g., Silver, Gold, Platinum
);


create table Cities(
	City_ID INT primary key auto_increment,
    City_Name varchar(100),
    Country varchar(50),
    Region varchar(50) -- e.g, North, South, East, West
);

create table Hotels (
	Hotel_ID INT PRIMARY KEY AUTO_INCREMENT,
    Hotel_Name VARCHAR(100),
    City_ID INT,
    Star_Rating INT,         -- e.g., 3, 4, 5 stars
    Total_Rooms INT,
    FOREIGN KEY (City_ID) REFERENCES Cities(City_ID) 
);

CREATE TABLE Bookings (
    Booking_ID INT PRIMARY KEY AUTO_INCREMENT,
    Tourist_ID INT,
    Hotel_ID INT,
    CheckIn_Date DATE,
    CheckOut_Date DATE,
    Room_Count INT,
    Booking_Status VARCHAR(20),  -- e.g., Completed, Cancelled
    FOREIGN KEY (Tourist_ID) REFERENCES Tourists(Tourist_ID),
    FOREIGN KEY (Hotel_ID) REFERENCES Hotels(Hotel_ID)
);

CREATE TABLE Payments (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Booking_ID INT,
    Amount DECIMAL(10,2),
    Payment_Method VARCHAR(20),  -- e.g., Card, UPI, Cash
    Payment_Date DATE,
    FOREIGN KEY (Booking_ID) REFERENCES Bookings(Booking_ID)
);

# Inserting rows into Tables :--

INSERT INTO Cities (City_Name, Country, Region) VALUES
('Delhi', 'India', 'North'),
('Mumbai', 'India', 'West'),
('Bangalore', 'India', 'South'),
('Chennai', 'India', 'South'),
('Kolkata', 'India', 'East'),
('Jaipur', 'India', 'North'),
('Hyderabad', 'India', 'South'),
('Pune', 'India', 'West'),
('Ahmedabad', 'India', 'West'),
('Lucknow', 'India', 'North');

INSERT INTO Tourists (Name, Gender, Country, Age, Membership_Level) VALUES
('Rohit Sharma', 'Male', 'India', 32, 'Gold'),
('Sara Johnson', 'Female', 'USA', 28, 'Silver'),
('Liam Brown', 'Male', 'UK', 40, 'Platinum'),
('Aisha Khan', 'Female', 'UAE', 26, 'Gold'),
('Rahul Verma', 'Male', 'India', 34, 'Silver'),
('Olivia Davis', 'Female', 'Canada', 29, 'Gold'),
('Arjun Mehta', 'Male', 'India', 30, 'Silver'),
('Sophia Lee', 'Female', 'Singapore', 25, 'Platinum'),
('David Miller', 'Male', 'Australia', 36, 'Gold'),
('Priya Nair', 'Female', 'India', 31, 'Silver');

INSERT INTO Hotels (Hotel_Name, City_ID, Star_Rating, Total_Rooms) VALUES
('Taj Palace', 1, 5, 200),
('Oberoi Mumbai', 2, 5, 180),
('ITC Gardenia', 3, 5, 220),
('Marina Inn', 4, 4, 150),
('Park Street Hotel', 5, 4, 130),
('Leela Palace', 1, 5, 250),
('Trident Hyderabad', 7, 5, 210),
('Blue Diamond Pune', 8, 4, 160),
('Courtyard Ahmedabad', 9, 4, 175),
('Clarks Avadh', 10, 4, 140);

INSERT INTO Bookings (Tourist_ID, Hotel_ID, CheckIn_Date, CheckOut_Date, Room_Count, Booking_Status) VALUES
(1, 1, '2025-01-05', '2025-01-09', 1, 'Completed'),
(2, 2, '2025-02-10', '2025-02-14', 2, 'Cancelled'),
(3, 3, '2025-03-01', '2025-03-05', 1, 'Completed'),
(4, 4, '2025-04-15', '2025-04-18', 1, 'Completed'),
(5, 5, '2025-05-20', '2025-05-23', 2, 'Completed'),
(6, 6, '2025-06-02', '2025-06-05', 1, 'Cancelled'),
(7, 7, '2025-07-12', '2025-07-15', 2, 'Completed'),
(8, 8, '2025-08-08', '2025-08-11', 1, 'Completed'),
(9, 9, '2025-09-09', '2025-09-13', 1, 'Completed'),
(10, 10, '2025-10-01', '2025-10-04', 2, 'Cancelled');

INSERT INTO Payments (Booking_ID, Amount, Payment_Method, Payment_Date) VALUES
(1, 28000.00, 'Card', '2025-01-05'),
(3, 25000.00, 'UPI', '2025-03-01'),
(4, 15000.00, 'Cash', '2025-04-15'),
(5, 20000.00, 'Card', '2025-05-20'),
(7, 32000.00, 'UPI', '2025-07-12'),
(8, 27000.00, 'Card', '2025-08-08'),
(9, 35000.00, 'UPI', '2025-09-09');

-- 1. How many total tourists are there?
select count(*) AS Total_tourists from tourists;

-- 2. How many cities are available for travel?
select count(*) AS Total_Cities FROM cities;

-- 3. How many tourists are from each country?
select Country, count(*) AS Total_Tourists
from tourists
GROUP BY Country;

-- 4. What is the total revenue generated?
Select sum(Amount) "Total Revenue" FROM Payments;

-- 5. What is the total number of bookings?
Select count(*) AS Total_Bookings From bookings;

-- 6. How many bookings were cancelled?
select count(*) AS Cancelled_Bookings
From Bookings 
Where Booking_Status = "Cancelled";

-- 7. What is the average stay duration of tourists?
select round(avg(datediff(CheckOut_Date, CheckIn_Date)), 1) AS Avg_Stay_Day
FROM Bookings
Where booking_Status = "Completed";

-- 8. Which city got the highest number of bookings?
SELECT c.City_Name, COUNT(b.Booking_ID) AS Total_Bookings
FROM Bookings b
JOIN Hotels h ON b.Hotel_ID = h.Hotel_ID
JOIN Cities c ON h.City_ID = c.City_ID
WHERE b.Booking_Status = 'Completed'
GROUP BY c.City_Name
ORDER BY Total_Bookings DESC
LIMIT 1;

-- 💸9. What is the total revenue earned by each city?
SELECT c.City_Name, SUM(p.Amount) AS Total_Revenue
FROM Payments p
JOIN Bookings b ON p.Booking_ID = b.Booking_ID
JOIN Hotels h ON b.Hotel_ID = h.Hotel_ID
JOIN Cities c ON h.City_ID = c.City_ID
GROUP BY c.City_Name
ORDER BY Total_Revenue DESC;

-- 10. Which hotel earned the most money?
SELECT h.Hotel_Name, SUM(p.Amount) AS Total_Revenue
FROM  Payments p
JOIN Bookings b ON p.Booking_ID = b.Booking_ID
JOIN Hotels h ON h.Hotel_ID = b.Hotel_ID
group by h.hotel_Name
order by Total_Revenue
Limit 1;
 
 -- 11. What are the most used payment methods?
 SELECT Payment_Method, count(*) AS Used_Count
 FROM Payments
 group by Payment_Method
 order by Used_Count DESC;
 
 -- 12. Who are the top 5 highest-spending tourists?
 SELECT t.Name, SUM(p.Amount) AS "Top Spending"
 FROM payments p
 JOIN Bookings b ON b.Booking_ID  = p.Booking_ID
 JOIN Tourists t ON t.Tourist_ID = b.Tourist_ID
 group by t.Name
 order by "Top Spending" DESC
 limit 5;

-- 13. How many bookings were made each month?
Select month(CheckIn_Date) AS Month, count(*) AS Total_Booking
FROM Bookings
WHERE Booking_Status = 'Completed'
GROUP BY MONTH(CheckIn_Date)
order by Month;

-- 14. What’s the average rating of hotels by city?
SELECT c.City_Name, round(AVG(h.Star_Rating), 1) AS Avg_Rating
FROM hotels h
JOIN cities c ON h.City_ID = c.City_ID
group by c.City_Name;

-- 15. What’s the occupancy percentage for each hotel?
SELECT 
    h.Hotel_Name,
    ROUND(SUM(b.Room_Count) / h.Total_Rooms * 100, 2) AS Occupancy_Percentage
FROM Bookings b
JOIN Hotels h ON b.Hotel_ID = h.Hotel_ID
WHERE b.Booking_Status = 'Completed'
GROUP BY h.Hotel_Name, h.Total_Rooms
ORDER BY Occupancy_Percentage DESC;

-- 16. Which membership level brings in most revenue?
Select t.Membership_Level, SUM(p.Amount) AS Total_Revenue
FROM Payments p
JOIN Bookings b ON b.Booking_ID = p.Booking_ID
JOIN tourists t ON t.Tourist_ID = b.Tourist_ID
GROUP BY t.Membership_Level
ORDER BY Total_Revenue DESC;

-- 17. Which country’s tourists spend the most?
SELECT t.Country, SUM(p.Amount) AS Most_Spend
FROM payments p
JOIN Bookings b ON b.Booking_ID = p.Booking_ID
JOIN Tourists t ON t.Tourist_ID = b.Tourist_ID
GROUP BY t.Country
ORDER BY Most_Spend DESC;

-- 18. Which tourist booked the longest stay?
SELECT t.Name, 
	DATEDIFF(CheckOut_Date, CheckIN_Date) AS Long_Stay
FROM Bookings b
JOIN Tourists t ON t.Tourist_ID = b.Tourist_ID
WHERE Booking_Status = 'Completed'
ORDER BY Long_Stay DESC
Limit 1;

-- 19. What’s the average booking amount per hotel?
SELECT h.Hotel_Name, 
	ROUND(AVG(p.Amount)) AS "Avg_Booking_Revenue"
FROM Payments p
JOIN Bookings b ON b.Booking_ID = p.Booking_Id
JOIN Hotels h ON h.Hotel_ID = b.Hotel_ID
GROUP BY h.Hotel_Name
ORDER BY Avg_Booking_Revenue DESC
Limit 1;

-- 20. What is the total number of nights booked in total?
SELECT SUM(DATEDIFF(CheckOut_Date, CheckIn_Date)) AS Total_Nights
FROM Bookings
WHERE Booking_Status = 'Completed';

-- 21. Which region has the most tourists visiting?
SELECT c.Region, count(b.Booking_ID) AS Total_Bookings
FROM Bookings b 
JOIN Hotels h ON h.Hotel_ID = b.Hotel_ID
JOIN Cities c ON c.City_ID = h.City_ID
WHERE Booking_Status = 'Completed'
GROUP BY c.Region;

-- 22. What is the gender distribution of tourists?
SELECT Gender, COUNT(*) AS Gender_Count
FROM Tourists
GROUP BY Gender;

-- 23. What is the average revenue per booking?
SELECT ROUND(SUM(Amount)/count(Distinct Booking_ID)) AS "Avg Revenue per booking"
FROM payments;

-- 24. What is the top-rated hotel per city?
SELECT c.City_Name, h.Hotel_Name, h.Star_Rating AS "Top Rated Hotels"
FROM Hotels h
JOIN Cities c ON c.City_ID = h.City_ID
WHERE (h.City_ID, h.Star_Rating) IN (
	SELECT City_ID, MAX(Star_Rating)
    FROM Hotels
    Group BY City_ID
);

-- 25. Find all bookings with missing payment records.
SELECT 
    b.Booking_ID,
    t.Name AS Missing_Payments
FROM Bookings b
JOIN Tourists t ON t.Tourist_ID = b.Tourist_ID
LEFT JOIN Payments p ON p.Booking_ID = b.Booking_ID
WHERE p.Payment_ID IS NULL;

-- WINDOWS FUNCTION'S:-

-- 26. Rank Hotels by Star Rating per Region?
SELECT
	h.Hotel_Name,
    c.Region,
    h.Star_Rating,
	RANK() OVER(partition by c.Region ORDER By h.Star_Rating DESC) AS RegionWise_Rating
FROM Hotels h
JOIN Cities c ON h.City_ID = c.City_ID;

-- 27. Total & Running Revenue per City?
SELECT 
	c.City_Name,
    p.Payment_Date,
    sum(p.Amount) AS Daily_Revenue,
    sum(sum(p.Amount)) OVER(PARTITION BY p.Payment_Date ORDER BY p.Payment_Date) AS "Running_Revenue"
FROM Payments p
JOIN Bookings b ON p.Booking_ID = b.Booking_ID
JOIN Hotels h ON h.Hotel_ID = b.Hotel_ID
JOIN Cities c ON c.City_ID = h.City_ID
GROUP BY c.City_Name, p.Payment_Date;

-- 28. Rank Tourists by Total Spending?
SELECT 
	t.Name,
	t.Country,
    SUM(p.Amount) AS Total_Spanding,
    RANK() OVER(ORDER BY SUM(p.Amount) DESC) AS "Rank_Spanding"
FROM Tourists t
JOIN Bookings b ON b.Tourist_ID = t.Tourist_ID
JOIN Payments p ON p.Booking_ID = b.Booking_ID
GROUP BY t.Name, t.Country;

-- 29. Compare Each Booking’s Amount to Previous Booking?
SELECT 
    Booking_ID,
    Payment_Date,
    Amount,
    LAG(Amount) OVER (ORDER BY Payment_Date) AS Previous_Amount,
    Amount - LAG(Amount) OVER (ORDER BY Payment_Date) AS Amount_Change
FROM Payments;

-- 30. Find the most frequently booked hotels?
SELECT 
    h.Hotel_Name,
    COUNT(b.Booking_ID) AS Total_Bookings,
    DENSE_RANK() OVER (ORDER BY COUNT(b.Booking_ID) DESC) AS Popularity_Rank
FROM Hotels h
JOIN Bookings b ON h.Hotel_ID = b.Hotel_ID
GROUP BY h.Hotel_Name;

-- 31. Show Top 3 Hotels per City?
SELECT *
FROM (
    SELECT 
        h.Hotel_Name,
        c.City_Name,
        h.Star_Rating,
        ROW_NUMBER() OVER (PARTITION BY c.City_Name ORDER BY h.Star_Rating DESC) AS Rank_In_City
    FROM Hotels h
    JOIN Cities c ON h.City_ID = c.City_ID
) AS Ranked
WHERE Rank_In_City <= 3;
