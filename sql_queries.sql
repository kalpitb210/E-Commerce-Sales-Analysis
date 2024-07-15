Use ecommerce;

-- List all unique cities where customers are located.
SELECT DISTINCT Customer_City FROM Customers;


-- Count the number of orders placed in 2017.
SELECT COUNT(*) from Orders WHERE YEAR(order_purchase_timestamp)=2017;


-- Count the Number of Customers from each state.
SELECT Customer_State, COUNT(*) FROM Customers GROUP BY Customer_State;


-- Calculate the percentage of orders that were paid in installments.
SELECT CONCAT((SUM(CASE WHEN payment_installments > 1 THEN 1 ELSE 0 END) / COUNT(*))*100, " %") 
	   AS Installment_Ratio
FROM Payments;


-- Find the total sales per Category.




-- Calculate the number of orders per month in 2018.
SELECT 
	MONTHNAME(order_purchase_timestamp) "Month", 
	COUNT(*) "Order_Count"
FROM Orders 
WHERE YEAR(order_purchase_timestamp)=2018
GROUP BY MONTHNAME(order_purchase_timestamp);


-- Find the average number of products per order, grouped by customer city.

















-- Find the total sales per category.
/*
Total Sales = Order_Items( price+freight_value ) as per payments table through order_id)
*/
WITH temp AS
(SELECT 
	pr.product_category "Product_Category", 
	or_i.price + or_i.freight_value "Total_Sales"
FROM 
	Products pr LEFT JOIN Order_Items or_i ON pr.product_id = or_i.product_id
)
SELECT Product_Category, SUM(Total_Sales) FROM temp GROUP BY Product_Category;

 select upper(products.product_category) category, 
round(sum(payments.payment_value),2) sales
from products join order_items 
on products.product_id = order_items.product_id
join payments 
on payments.order_id = order_items.order_id
group by category



