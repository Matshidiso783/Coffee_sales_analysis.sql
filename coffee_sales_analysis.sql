-- Coffee Sales Analysis SQL Project
-- 
---PROJECT OVERVIEW:
 -- This project analyzes coffee sales data to easily understand
 -- Sales performance, revenue trends, customer payment methods and coffeee prodct performance.
 --
 --DATA PREPARATION:
 -- -Combined two coffee sales datasets for analysis using UNION ALL
 -- -Identified and handled missing columns before merging.
 -- -Created a final coffee_table for analysis.
 
 --Analysis Performed:
 -- - Calculated total revenue from coffee salses.
 -- - Analyzed revenue and sales by coffee type.
 -- - Compared cash and payment performance.
 -- - Analyzed daily revenue and sales trends.
 -- - Used SQL window functions ( RANK and PARTITION BY) to identify top-performing cofffees per day and payment type.

-- Tools Used:
 -- - SQL lite
 -- - SQL
 -- - Power BI(for visualisation)
 
 --Objective:
 -- - To extract insights from coffee sales data and create a dashboard showing business performance.
 
 

-- Combine the two coffee sales table into one table using UNION ALL

CREATE TABLE coffee_table AS
  select 
       date,
       datetime,
       cash_type,
       card,
       money,
       coffee_name
  from index_1
  
  union ALL
  
  SELECT 
       date,
       datetime,
       cash_type,
       NULL as card,
       money,
       coffee_name
  from index_2;
  
  -- Preview the first rows of index_1 to  inspect the columns and data structure
  
  SELECT*
  from index_1
  limit 6;
  
  -- Preview the first rows of index_2 to  inspect the columns and data structure
   SELECT*
   from index_2
   limit 6;
   
   --Preview the final combined table
   SELECT*
   from coffee_table;
   
   --Count total transactions
   SELECT COUNT(*) AS total_records
   from coffee_table;
   
   --Calculate total revenue from coffee sales
     SELECT SUM(money) as total_revenue
     from coffee_table;
    
    --Calculate total revenue per coffee type
      SELECT coffee_name, SUM(money) as total_revenue
      fRom coffee_table
      GROUP by coffee_name
      ORDER by total_revenue DESC;
      
   -- Find the most sold coffee based on total sales
      SELECT coffee_name, COUNT(*) as total_sales
      from coffee_table
      group by coffee_name
      ORDER by total_sales DESC;
       
   --Calculate average revenue per coffee type
     SELECT coffee_name, AVG(money) as average_revenue
     from coffee_table
     group by coffee_name
     order by average_revenue DESC;
     
   --Calculate daily revenue from coffee sales
     select date, SUM(money) as total_revenue
     from coffee_table
     group by date
     order by date;
     
   -- Calculate total sales per day
     SELECT date, COUNT(*) as total_sales
     from coffee_table
     group by date
     order by date;
     
   --Calculate revenue per payment type
     Select cash_type, SUM(money) AS total_revenue
     from coffee_table
     GROUP BY cash_type
     ORDER by total_revenue;
     
  
   --Calculate total sales per payment type
    SELECT cash_type, COUNT(*) as total_sales
    from coffee_table
    group by cash_type
    ORDER BY total_sales DESc;
    
    --Find top 3 coffees sold each day based on total revenue
    SELECT*
    from (Select date,coffee_name, SUM(money) as total_revenue,
          RANK() Over(
              PARTITION by date
              order by SUM(money) DESC
            ) as revenue_rank
          from coffee_table
          group by date, coffee_name
        )
     where revenue_rank <=3;
     
    --Find top one coffees sold each day based on total revenue
    SELECT*
    from (Select date,coffee_name, SUM(money) as total_revenue,
          RANK() Over(
              PARTITION by date
              order by SUM(money) DESC
            ) as revenue_rank
          from coffee_table
          group by date, coffee_name
        )
     where revenue_rank =1;
   
   --Calculate total revenue by coffee type and payment type
     SELECT coffee_name, cash_type, SUM(money)as total_revenue
     from coffee_table
     group by coffee_name, cash_type
     order by total_revenue desc;
     
  --Find top 3 coffees per payment type based on total revenue
    SELECT*
    from (Select cash_type,coffee_name, SUM(money) as total_revenue,
          RANK() Over(
              PARTITION by cash_type
              order by SUM(money) DESC
            ) as revenue_rank
          from coffee_table
          group by cash_type, coffee_name
        )
     where revenue_rank <=3;
   
  -- Calculate average revenue per coffee type using card payments only  
     SELECT cash_type, coffee_name, AVG(money) as average_revenue
     from coffee_table
     where cash_type= 'card'
     group by coffee_name
     order by average_revenue DESC;
     
   -- find top 3 coffees by average revenue using card payment only
     SELECT*
     from ( SELECT coffee_name, cash_type, AVG(money) as average_revenue,
           RANK() OVER(
             PARTITION BY cash_type
             order by AVG(money)
            ) as revenue_rank
          from coffee_table
           WHERE cash_type = 'card'
          GROUP by coffee_name
        )
      where revenue_rank<=3;
             
           
 --
 
