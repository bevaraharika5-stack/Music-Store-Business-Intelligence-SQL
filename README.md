**_🎶 Music Store Business Intelligence (SQL Anaylsis)_**

**📌 Overview**
This project focuses on analyzing a Music Store database using SQL to extract meaningful business insights. By working with a fully relational database, the project demonstrates how data can be transformed into actionable intelligence for decision-making.
**⚙️ Tools & Technologies**
SQL (MySQL)
Relational Database Management System (RDBMS)
CSV Data Import

**Database Structure**
The database consists of 11 interconnected tables, organized into key business domains:
**Sales**: Invoice, InvoiceLine
**Inventory:** Track, Album, Artist, Genre, MediaType
**Customers & Employees**: Customer, Employee
**Others:** Playlist, PlaylistTrack
All tables are connected using Primary Keys (PK) and Foreign Keys (FK) to ensure data consistency and integrity.

**Business Questions & Technical Solutions**
The analysis is structured into three levels of complexity, demonstrating a clear progression in data exploration and SQL proficiency:

****1. Operational Foundations ****
Hierarchy Analysis: Identified the most senior employee based on job title to understand the organizational structure.
Market Analysis: Determined which countries generate the highest number of invoices to highlight the most active markets.
Top Location Identification: Found the city with the highest total revenue to recommend the best location for hosting a promotional Music Festival.
**2. Customer & Genre Intelligence **
Top Artists Analysis: Developed queries to identify the top 10 rock artists based on total track count.
Targeted Marketing: Extracted details of all Rock music listeners to support genre-specific email marketing campaigns.
Content Analysis: Evaluated track durations to identify songs longer than the average, useful for playlist optimization and niche content strategies.
**3. Strategic Growth & Advanced SQL **
Revenue by Artist: Leveraged CTEs to determine which customers spend the most on specific artists, connecting artist popularity with customer value.
Regional Preferences: Applied Window Functions to identify the most popular genre in each country based on purchase behavior.
High-Value Customer Identification: Used advanced query logic to find the top customer in every country, enabling targeted VIP engagement and loyalty programs.

**Project Structure**
music_store.sql


