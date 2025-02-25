
select * from customer;
select * from employee_details;
select * from employee_manages_shipment;
select * from membership;
select * from payment_details;
select * from shipment_details;
select * from `status`;
select * from logitics_emp;


-- 1) Extract all the employees whose name starts with A and ends with A.
select e_name from employee_details
where e_name like 'a%a';

-- 2) Find all the common names from Employee_Details names and Customernames.
select distinct(e_name) from employee_details
where e_name in (select c_name from customer as cus);

-- 3) Create a view 'PaymentNotDone' of those customers who have not paidthe amount.
create view  PaymentNotDone as
select * from  payment_details
where payment_status = 'not paid' ;

select * from PaymentNotDone;

-- 4) Find the frequency (in percentage) of each of the class of the paymentmode. (Using a Subquery)
select payment_mode,
round((count(payment_mode) / (select count(*) from payment_details)) *100, 2)
AS Percentage_Contribution
from payment_details
group by payment_mode;

--  5) Create a new column 'Total_Payable_Charges' using shipping cost and price of  the product.
alter table logitics_emp
	add column Total_Payable_Charges float after amount;

select * from logitics_emp;

update logitics_emp
	set Total_Payable_Charges = sh_charges + amount;

select * from logitics_emp;

-- 6) What is the highest total payable amount ?
select max(Total_Payable_Charges) as highest_total_payable_amount from logitics_emp;

-- 7) Extract the customer id and the customer name of the customers who were or
-- will be the member of the branch for more than 10 years.
select c_id, c_name, start_date, end_date,
round(datediff(end_date , start_date)/365,0) as membership_years
from logitics_emp
where ROUND(DATEDIFF(end_date, start_date) / 365, 0) > 10;

-- 8) Who got the product delivered on the next day the product was sent?
select * from logitics_emp
having delivery_date - sent_date = 1;
-- alternate way
select * from logitics_emp
having datediff(delivery_date , sent_date) = 1;

-- 9) Which shipping content had the highest total amount (Top 5).
select sh_content, sum(amount) as content_wise_amount
from logitics_emp
group by sh_content
order by content_wise_amount desc limit 5;

-- 10) Which product categories from shipment content are transferred more?
select sh_content, count(sh_content) as content_wise_count
from logitics_emp
group by sh_content
order by content_wise_count desc limit 5;

-- 11) Create a new view 'TXLogistics' where employee branch is Texas.
create view TXLogistics as
select * from employee_details
where e_branch = 'tx';

select * from txLogistics;

-- 12) Texas(TX) branch is giving 5% discount on total payable amount. Createa new
-- column 'New_Price' for payable price after applying discount.

alter table logitics_emp
	add column new_price decimal(10,2);
    
update logitics_emp
set new_price = amount - ((amount * 5) / 100) 
where e_branch = 'tx';
    
select *from logitics_emp;


-- 13) Drop the view TXLogistics
drop view TXLogistics;

-- 14) The employee branch in New York (NY) is shutdown temporarily. Thus,
-- the branch needs to be replaced to New Jersy (NJ).
select e_branch from logitics_emp where e_branch = 'ny';

update logitics_emp 
	set e_branch = 'nj'
    where e_branch = 'ny';
    
select e_branch from logitics_emp where e_branch = 'ny';

-- 15) Finding the unique designations of the employees.
select distinct(e_designation) from employee_details;

-- 16) We will see the frequency of each customer type (in percentage). 
 select c_type,
 (count(c_type) * 100 / (select count(*) from customer)) as contribution
 from customer
 group by C_TYPE;
 
 -- 18) Rename the column SER_TYPE to SERVICE_TYPE
 alter table shipment_details
 change SER_TYPE SERVICE_TYPE varchar(40);
 
 select * from shipment_details;
 
 -- 19) Which service type is preferred more?
 select service_type , count(service_type) as total_s_type
 from shipment_details
 group by service_type
 order by total_s_type desc;
 
 -- 20) Find the shipment id and shipment content where the weight is greater than
-- the average weight.
 
select sh_id , sh_content, SH_WEIGHT
from shipment_details
where SH_WEIGHT > (select avg(SH_WEIGHT) from shipment_details);
 