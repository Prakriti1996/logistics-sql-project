create database GLLOGISTICS;
USE GLLOGISTICS;

-- IMPORT DATA FROM py.SQL USING PANDAS.

create table employee_Details (
	e_id int primary key,
    e_name varchar(30),
    e_designation varchar(40),
    e_addr varchar(100),
    e_branch varchar(15),
    e_cont_no varchar(10)
);

create table membership (
	m_id int primary key,
    start_date text,
    end_date text
);

create table customer (
	c_id int primary key,
	m_id int,
    c_name varchar(30),
    c_email_id varchar(50),
    c_type varchar(30),
    c_addr varchar(100),
    c_cont_no varchar(10),
    foreign key (m_id) references membership(m_id)
);

create table payment_details (
	payment_id varchar(40) primary key,
    c_id int,
    sh_id varchar(6),
    amount int,
    payment_status varchar(10),
    payment_mode varchar(25),
    payment_date text,
    foreign key (c_id) references customer(c_id)
);

create table shipment_details (
	sh_id varchar(6) primary key,
    c_id int,
    sh_content varchar(40),
    sh_domain varchar(15),
    ser_type varchar(15),
    sh_weight varchar(10),
    sh_charges int,
    sr_addr varchar(100),
    ds_addr varchar(100),
    foreign key(c_id) references customer(c_id)
);

create table `status` (
	sh_id varchar(6) primary key,
	current_status varchar(15),
    sent_date text,
    delivery_date text
);

create table employee_manages_shipment (
	employee_e_id int,
    shipment_sh_id varchar(6),
    stats_sh_id varchar(6),
    foreign key (employee_e_id) references employee_Details(e_id),
    foreign key (shipment_sh_id) references shipment_details(sh_id),
    foreign key (stats_sh_id) references `status`(sh_id)
);

select * from customer;
select * from employee_details;
select * from employee_manages_shipment;
select * from membership;
select * from payment_details;
select * from shipment_details;
select * from `status`;


DESCRIBE employee_details;

--  dealing with the dates after importing the data from csv files:

select delivery_date from `status`
where str_to_date(delivery_date, '%m/%d/%Y'); # 100 rows in this format

select sent_date from `status`
where str_to_date(sent_date, '%m/%d/%Y'); -- 200 rows in this format

select payment_date from payment_details
where str_to_date(payment_date, '%Y-%m-%d'); -- 100  rows in this format

select delivery_date from `status`
where str_to_date(delivery_date, '%d/%m/%Y'); -- 41 rows in this format

select sent_date from `status`
where str_to_date(sent_date, '%d/%m/%Y'); -- 80 rows in this format

select payment_date from payment_details
where str_to_date(payment_date, '%d/%m/%Y') ;

select delivery_date from `status`
where delivery_date  is null; -- 100 null values

select sent_date from `status`
where sent_date  is null; -- no null values

select payment_date from payment_details
where payment_date  is null;  -- 100 null values

select delivery_date from `status`
where cast(substring_index(delivery_date, '/', 1) as unsigned) >12; -- checked

select sent_date from `status`
where cast(substring_index(sent_date, '/', 1) as unsigned) >12; -- checked

select delivery_date from `status` 
where cast(substring_index(delivery_date, '/', 1) as unsigned) >31; -- checked

select sent_date from `status` 
where cast(substring_index(sent_date, '/', 1) as unsigned) >31; -- checked

-- Search for the records where the month is February but the date is
-- erroneously entered as 30 and 31.

select delivery_date from `status`
where cast(substring_index(delivery_date, '/', 1) as unsigned) = 2
and
cast(substring_index(substring_index(delivery_date,'/', 2), '/', -1) as unsigned) > 29; -- checked


select sent_date from `status`
where cast(substring_index(sent_date, '/', 1) as unsigned) = 2
and
cast(substring_index(substring_index(sent_date,'/', 2), '/', -1) as unsigned) > 29; -- checked

select  payment_date from payment_details
where cast(substring_index( payment_date, '/', 1) as unsigned) = 2
and
cast(substring_index(substring_index( payment_date,'/', 2), '/', -1) as unsigned) > 29; 

-- Convert the string in the date format:

update payment_details
set payment_date = str_to_date(payment_date, '%Y-%m-%d');
	
update `status`
set delivery_date = str_to_date(delivery_date, '%Y-%m-%d'),
	sent_date = str_to_date(sent_date, '%Y-%m-%d');
    
update membership
set start_date = str_to_date(start_date, '%Y-%m-%d'),
	end_date = str_to_date(end_date, '%Y-%m-%d');


-- Change the data type of the column to DATE:

alter table payment_details 
	modify column payment_date date;
    
describe payment_details ;  -- to check data type change or not.
    
alter table `status`
	modify column delivery_date date,
	modify column sent_date date;

alter table membership
	modify column start_date date,
    modify column end_date date;
    

