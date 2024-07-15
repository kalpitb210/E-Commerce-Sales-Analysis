Use ecommerce;

-- List all unique cities where customers are located.
SELECT DISTINCT Customer_City FROM Customers;


-- Count the number of orders placed in 2017.
SELECT COUNT(*) "Number of Orders" from Orders WHERE YEAR(order_purchase_timestamp)=2017;


-- Count the Number of Customers from each state.
SELECT Customer_State, COUNT(*) FROM Customers GROUP BY Customer_State;


-- Calculate the percentage of orders that were paid in installments.
SELECT CONCAT((SUM(CASE WHEN payment_installments > 1 THEN 1 ELSE 0 END) / COUNT(*))*100, " %") 
	   AS Installment_Ratio
FROM Payments;


-- Find the total sales per Category.
SELECT 
	Upper(pro.product_category) "Category", 
	Round(SUM(pay.payment_value), 2) "Sales"
FROM products pro Join Order_items or_i 
ON pro.product_id = or_i.product_id Join payments pay 
ON pay.order_id = or_i.order_id
GROUP BY 
	Category;


-- Calculate the number of orders per month in 2018.
SELECT 
	MONTHNAME(order_purchase_timestamp) "Month", 
	COUNT(*) "Order_Count"
FROM Orders 
WHERE YEAR(order_purchase_timestamp)=2018
GROUP BY MONTHNAME(order_purchase_timestamp)
ORDER BY MONTHNAME(order_purchase_timestamp);


-- Find the Average number of products per order, grouped by customer city.
WITH Count_Per_Order AS 
(SELECT 
	ord.Order_id, 
	ord.Customer_id, 
	count(or_i.Order_id) AS "Order_Count"
FROM Orders ord Join Order_Items or_i ON ord.Order_id = or_i.Order_id
GROUP BY 
	ord.Order_id, ord.Customer_id)
SELECT c.customer_city, round(AVG(c1.Order_Count),2) "Average_orders"
FROM Customers c Join count_per_order c1
ON c.Customer_id = c1.Customer_id
GROUP BY c.Customer_city ORDER BY Average_orders DESC;


-- Calculate the percentage of total revenue contributed by each product category.
SELECT 
	Upper(pro.product_category) "Category", 
	Round((SUM(pay.payment_value)/(SELECT SUM(payment_value) FROM payments))*100,2) "Sales_Percentage"
FROM products pro Join Order_Items or_i 
ON pro.product_id = or_i.product_id Join payments pay 
ON pay.order_id = or_i.order_id
GROUP BY 
	Category 
ORDER BY 
	Sales_Percentage DESC;
    

-- Identify the correlation between product price and the number of times a product has been purchased.


-- Calculate the moving average of order values for each customer over their order history.
WITH temp AS
(SELECT ord.customer_id, ord.order_purchase_timestamp, 
pay.payment_value AS Payment 
FROM Payments pay Join Orders ord
ON pay.Order_id = ord.Order_id
)
SELECT 
	Customer_id, 
    Order_purchase_timestamp, 
	Payment,
	AVG(payment) OVER(PARTITION BY Customer_id ORDER BY Order_purchase_timestamp
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Mov_avg
FROM
	temp;


-- Calculate the year-over-year growth rate of total sales.
WITH temp AS
(
SELECT 
	Year(ord.order_purchase_timestamp) AS "Years",
	Round(SUM(pay.payment_value), 2) AS "Payment" 
FROM Orders ord Join Payments pay
ON ord.order_id = pay.order_id
GROUP BY 
	Years 
ORDER BY 
	Years)
SELECT 
	Years, 
	((payment - LAG(payment, 1) OVER(ORDER BY Years))/ LAG(payment, 1) OVER(ORDER BY Years)) * 100 
    "Year ON Year % Growth" 
From temp;



