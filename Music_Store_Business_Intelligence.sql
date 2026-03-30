create database music_store;
use music_store;

-- Creation of the tables.

-- 1. Genre and MediaType
CREATE TABLE Genre (
genre_id INT PRIMARY KEY,
name VARCHAR(120)
);
CREATE TABLE MediaType (
media_type_id INT PRIMARY KEY,
name VARCHAR(120)
);

-- 2. Employee
CREATE TABLE Employee (
employee_id INT PRIMARY KEY,
last_name VARCHAR(120),
first_name VARCHAR(120),
title VARCHAR(120),
reports_to INT,
levels VARCHAR(255),
birthdate DATE,
hire_date DATE,
address VARCHAR(255),
city VARCHAR(100),
state VARCHAR(100),
country VARCHAR(100),
postal_code VARCHAR(20),
phone VARCHAR(50),
fax VARCHAR(50),
email VARCHAR(100)
);

-- 3. Customer
CREATE TABLE Customer (
customer_id INT PRIMARY KEY,
first_name VARCHAR(120),
last_name VARCHAR(120),
company VARCHAR(120),
address VARCHAR(255),
city VARCHAR(100),
state VARCHAR(100),
country VARCHAR(100),
postal_code VARCHAR(20),
phone VARCHAR(50),
fax VARCHAR(50),
email VARCHAR(100),
support_rep_id INT,
FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
);

-- 4. Artist
CREATE TABLE Artist (
artist_id INT PRIMARY KEY,
name VARCHAR(120)
);

-- 5. Album
CREATE TABLE Album (
album_id INT PRIMARY KEY,
title VARCHAR(160),
artist_id INT,
FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
);

-- 6. Track
CREATE TABLE Track (
track_id INT PRIMARY KEY,
name VARCHAR(200),
album_id INT,
media_type_id INT,
genre_id INT,
composer VARCHAR(220),
milliseconds INT,
bytes INT,
unit_price DECIMAL(10,2),
FOREIGN KEY (album_id) REFERENCES Album(album_id),
FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id),
FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
);

-- 7. Invoice
CREATE TABLE Invoice (
invoice_id INT PRIMARY KEY,
customer_id INT,
invoice_date DATE,
billing_address VARCHAR(255),
billing_city VARCHAR(100),
billing_state VARCHAR(100),
billing_country VARCHAR(100),
billing_postal_code VARCHAR(20),
total DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- 8. InvoiceLine
CREATE TABLE InvoiceLine (
invoice_line_id INT PRIMARY KEY,
invoice_id INT,
track_id INT,
unit_price DECIMAL(10,2),
quantity INT,
FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
FOREIGN KEY (track_id) REFERENCES Track(track_id)
);

-- 9. Playlist
CREATE TABLE Playlist (
playlist_id INT PRIMARY KEY,
name VARCHAR(255)
);

-- 10. PlaylistTrack
CREATE TABLE PlaylistTrack (
playlist_id INT,
track_id INT,
PRIMARY KEY (playlist_id, track_id),
FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
FOREIGN KEY (track_id) REFERENCES Track(track_id)
);

-- Importing table

-- Importing Track csv file with alternate method
SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE  track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price);

Select * from genre;
Select * from mediatype;
Select * from employee;
Select * from customer;
Select * from artist;
Select * from album;
Select * from track;
Select * from invoice;
Select * from invoiceline;
Select * from playlist;
Select * from playlisttrack;

-- Data Importing is done
-------------------------------------------
-- Q1. Who is the senior most employee based on job title?
Select First_name,Last_Name,title,hire_date,reports_to
from employee
where reports_to is Null; 

Note:
 Mohan Madan, holding the position of Senior General Manager, is the top-most employee in the hierarchy. His experience makes him highly valuable for leadership development and knowledge sharing.



------------------------------------------
-- Q2. Which countries have the most Invoices?
select Billing_country,
count(invoice_id) as Total_invoices
from invoice
group by Billing_country
order by total_invoices desc;

Note:
The USA records the highest number of invoices, indicating it is the most active market with heavy sales and operational demand.

----------------------------------------------
-- Q3. What are the top 3 values of total invoice?
select Billing_country,total
from invoice
order by total desc
limit 3;

Note:
Top invoice amounts are around $23.76 and $19.80, which represent the upper range of customer purchase values.
-------------------------------------------------
-- Q4. Which city has the best customers? 
-- We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select Billing_city,
sum(total) as Invoices_Total
from invoice
group by Billing_city
order by Invoices_Total desc
limit 1;

Note:
Prague generates the highest total revenue, showing strong customer purchasing power despite having fewer transactions.

----------------------------------------------------
-- Q5. Who is the best customer? - The customer who has spent the most money will be declared the best customer.
--  Write a query that returns the person who has spent the most money

select c.customer_id,concat(c.first_name," ",c.last_name) as The_Best_Customer,
sum(i.total) as Total_spent
from
customer c
inner join
invoice i on c.customer_id = i.customer_id
group by c.customer_id,The_Best_Customer
order by Total_Spent desc
Limit 1;

Note:
František Wichterlová is the top-spending customer, making him crucial for retention strategies and loyalty programs.

----------------------------------------------------
-- Q6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners.
 -- Return your list ordered alphabetically by email starting with A
 
 select * from genre
 where genre_id = 1;
 
 -- Notes : From this we get to know Genre Id - 1 is genre "Rock"

 select y.customer_id,y.Email,y.First_name,y.Last_Name,
 case
 when x.genre_id = 1 then "Rock" 
 else "Wrong_Gnere" end as Genre
 from
(select t.genre_id,t.track_id,l.invoice_id
 from track t
inner join invoiceline l on t.track_id = l.track_id
where genre_id=1
order by genre_id)x
left join
(select c.customer_id,C.Email,C.First_name,C.Last_Name,I.invoice_id
from customer c
inner join invoice I on C.customer_id = I.customer_id
order by Email asc)y on x.invoice_id = y.invoice_id
group by y.customer_id
order by y.Email asc;

Note:
Rock genre is universally popular, with every customer purchasing at least one Rock track, proving it as the core genre of the business.

----------------------------------------------------
-- Q7. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands

select ar.artist_id,name as Artist_Name,
count(x.artist_id) as Total_Tracks
from
artist ar
inner join
(select a.*
from track t
inner join
album a on t.album_id = a.album_id
where t.genre_id = 1)x on ar.artist_id = x.artist_id
group by artist_id
order by Total_Tracks desc
limit 10;


Note:
Led Zeppelin and U2 have the highest number of Rock tracks, making them key contributors and reliable assets for inventory investment.
----------------------------------------------------
-- Q8. Return all the track names that have a song length longer than the average song length.-
-- Return the Name and Milliseconds for each track. Order by the song length, with the longest songs listed first

select Name,Milliseconds,
round((Milliseconds / 60000),2)  as Length_mins from Track
where milliseconds > (select 
round(avg(milliseconds),2) 
from track )
order by Length_mins desc;

Note:
A large portion of tracks are longer than average, indicating a significant presence of long-duration or niche content that may need targeted pricing strategies.


----------------------------------------------------
-- Q9. Find how much amount is spent by each customer on artists? 
-- Write a query to return customer name, artist name and total spent

select A.customer_id,A.Customer_name,B.name as Artist_name,
sum(B.unit_price*B.quantity) as Total_Spent
from
(select I.customer_id, concat(C.first_name," ",C.last_name) as Customer_Name,I.invoice_id
from invoice I
inner join customer C on c.customer_id = I.customer_id)A
inner join
(select y.name,y.artist_id,x.invoice_id,x.unit_price,x.quantity
from
(select t.track_id,l.invoice_id,t.album_id,l.unit_price,l.quantity
 from track t
inner join invoiceline l on t.track_id = l.track_id)x
left join
(select ar.name,al.artist_id,al.album_id
from 
artist ar
inner join album al on ar.artist_id = al.artist_id)y
on x.album_id = y.album_id)B
on A.invoice_id = B.Invoice_id
group by A.customer_id,A.customer_name,B.name
order by Total_spent desc;


Note:
Customer spending is distributed across multiple artists, suggesting the need for personalized recommendations rather than generalized marketing.

----------------------------------------------------
-- Q10. We want to find out the most popular music Genre for each country.
-- We determine the most popular genre as the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. 
-- For countries where the maximum number of purchases is shared, return all Genres

with cte as (
select I.Billing_country as Country,
g.name as Genre_Name, sum(Il.quantity) as Total_Purchase,
rank() over (partition by I.Billing_country order by sum(Il.quantity) desc) as Genre_Rank
from 
Invoice I
inner join 
Invoiceline Il on I.invoice_Id = Il.Invoice_id
inner join
Track t on Il.track_id = t.track_id
inner join 
genre G on g.genre_id = t.genre_id
group by I.Billing_country,Genre_Name)
select Country, Genre_Name,Total_Purchase
from cte
where Genre_Rank = 1
order by Country asc , Total_Purchase desc; 

Note:
Rock dominates globally across most countries, except Argentina where Alternative & Punk is more popular, indicating a niche market opportunity.

----------------------------------------------------
-- Q11. Write a query that determines the customer that has spent the most on music for each country.
--  Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount

with cte as(
select i.Billing_country as Country, concat(c.first_name," ",c.last_name) as Customer_Name,
sum(i.total) as Total_spent, rank() over (partition by i.Billing_country order by sum(i.total) desc) as rank_country
from
Invoice I
inner join 
Customer C on i.customer_id = c.customer_id
group by i.Billing_country,customer_name )
select Country,Customer_name, Total_spent
from cte
where Rank_Country = 1
order by country asc,total_spent desc;

Note:
The analysis successfully identified the top-spending customer in each country, enabling targeted marketing and high-value customer engagement strategies.

-----------------------------------------------------

