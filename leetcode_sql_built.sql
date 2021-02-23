# 1 两表合并
create table Person(
    PersonId int primary key ,
    FirstName varchar(20),
    LastName varchar(20)
);
create table Address(
    AddressId int primary key ,
    PersonId int not null ,
    City varchar(50),
    State varchar(50)
);


create table if not exists Employee(
    id int primary key ,
    Salary float
);
insert into Employee
values
       (4,100),
       (5,200),
       (6,300);
create table if not exists cinema(
    seat_id int primary key,
    free int not null
);

insert into cinema
values
       (1,1),
       (2,0),
       (3,1),
       (4,1),
       (5,1);

create table if not exists logs (
    Id int primary key ,
    Num int
 );

insert into logs
values (1,1),
       (2,1),
       (3,1),
       (4,2),
       (5,1),
       (6,2),
       (7,2);

create table if not exists Employees (
    Id int primary key ,
    Name varchar(20) not null ,
    Salary int,
    DepartmentId int
);

create table if not exists Department(
    Id int primary key ,
    Name varchar(10)
);

insert into employees
values
       (1,'joe',70000,1),
       (2,'Henry',80000,2),
       (3,'Sam',60000,2),
       (4,'Max',90000,1);

insert into Department
values
       (1,'IT'),
       (2,'Sales');

create table if not exists World(
    name varchar(50),
    continent varchar(20),
    area int,
    population int,
    gdp int
);

insert into World
values
       ('Afghanistan','Asia',652230,25500100,20343000),
       ('Albania','Europe',28748,2831741,12960000),
       ('Algeria','Africa',2381741,37100000,188681000),
       ('Andorra','Eurpoe',468,78115,3712000),
       ('Angola','Africa',1246700,20609294,100990000);


create table if not exists Pemail(
    id int primary key ,
    Email varchar(30)
);

insert into Pemail
values
       (1,'john@example.com'),
       (2,'bob@example.com'),
       (3,'john@example.com');

create table if not exists seat (
    Id int primary key ,
    Student varchar(20)
);
insert into seat
values
       (1,'Abort'),
       (2,'Doris'),
       (3,'Emerson'),
       (4,'Green'),
       (5,'Jeames');

create table if not exists Employee_median (
    Id int primary key ,
    Company varchar(5),
    Salary float
);

insert into employee_median
values
       (1,'A',800),
        (2,'A',834),
        (3,'A',541),
        (4,'A',954),
        (5,'B',941),
        (6,'B',396),
        (7,'B',698),
        (8,'C',434),
        (9,'C',405),
        (0,'C',480),
        (11	,'A',643),
        (12	,'A',477),
        (13	,'B',369),
        (14	,'B',535),
        (15	,'C',725),
        (16	,'C',178),
        (17	,'A',999);

create table if not exists salary_avg (
    id int primary key ,
    employee_id int,
    amount float,
    pay_date datetime
);
insert into salary_avg
values
    (1,1,9000,'2017/3/31'),
    (2,2,6000,'2017/3/31'),
    (3,3,10000,'2017/3/31'),
    (4,1,7000,'2017/2/28'),
    (5,2,6000,'2017/2/28'),
    (6,3,8000,'2017/2/28');

create table if not exists employee_avg(
    employee_id int,
    department_id int
);
insert into employee_avg
values (1,1),(2,2),(3,2);

create table if not exists employee_manager (
    id int primary key ,
    name varchar(20),
    department varchar(5),
    managerid int
);

insert into employee_manager values
(101,'john','a',null),
(102,'dan','a',	101),
(103,'james','a',101),
(104,'amy','a',	101),
(105,'anne','a',101),
(106,'ron','b',101);

create table if not exists friend_request (
    sender_id int,
    send_to_id int,
    request_date date
);

create table if not exists request_accepted (
    requester_id int,
    accepter_id int,
    accpet_date date
);

insert into friend_request
values
       (1,2,'2016/6/1'),
       (1,3,'2016/6/1'),
       (1,4,'2016/6/1'),
       (2,3,'2016/6/2'),
       (3,4,'2016/6/9');

insert into request_accepted
values
       (1,2,'2016/6/3'),
        (1,3,'2016/6/8'),
        (2,3,'2016/6/8'),
        (3,4,'2016/6/9'),
        (3,4,'2016/6/10');

create table if not exists candidate(
    id int primary key ,
    name varchar(20)
);
create table if not exists vote(
    id int primary key,
    candidateid int
);

insert into candidate
values (1,'A'),(2,'B'),(3,'C'),(4,'D'),(5,'E');

insert into vote
values (1,2),(2,4),(3,3),(4,2),(5,5);

create table if not exists rank_scores (
    id int primary key ,
    score float
);
insert into rank_scores
values (1,3.50),(2,3.65),(3,4.00),(4,3.85),(5,4.00),(6,3.65);

create table if not exists employee_cumulative (
    id int,
    month int,
    salary int
);

insert into employee_cumulative
values (1,1,20),(2,1,20),(1,2,30),(2,2,30),(3,2,40),(1,3,40),(3,3,60),(1,4,60),(3,4,70);

create table if not exists tree (
    id int primary key,
    p_id int
);
insert into tree
values (1,null),(2,1),(3,1),(4,2),(5,2);

create table if not exists triangle(
    x int,
    y int,
    z int
);
insert into triangle
values (13,15,30),(10,20,15);

create table if not exists employees_earning(
    id int primary key ,
    name varchar(20),
    salary int,
    managerid int
);
insert into employees_earning
values
    (1,'Joe',70000,3),
    (2,'henry',80000,4),
    (3,'sam',60000,null),
    (4,'max',90000,null);

create table if not exists duplicated_email(
    id int primary key ,
    email varchar(50)
);

insert into duplicated_email
values (1,'a@b.com'),(2,'b@b.com'),(3,'a@b.com');

create table if not exists customers(
    id int primary key ,
    name varchar(20)
);
insert into customers
values (1,'joe'),(2,'henry'),(3,'sam'),(4,'max');
create table if not exists orders(
    id int,
    customerid int
);
insert into orders
values (1,3),(2,1);

create table if not exists weather(
    id int primary key ,
    recorddate date,
    temperature int
);
insert into weather
values (1,'2015/01/01',10),(2,'2015/01/02',25),(3,'2015/1/03',20),(4,'2015/1/04',30);

create table if not exists trips(
    id int primary key ,
    client_id int,
    driver_id int,
    city_id int,
    status varchar(30),
    request_at date
);
create table if not exists users(
    user_id int primary key ,
    banned bool,
    role varchar(10)
);
insert into trips
values
    (1,1,10,1,'completed','2013/10/1'),
    (2,2,11,1,'cancelled_by_driver','2013/10/1'),
    (3,3,12,6,'completed','2013/10/1'),
    (4,4,13,6,'cancelled_by_client','2013/10/1'),
    (5,1,10,1,'completed','2013/10/2'),
    (6,2,11,6,'completed','2013/10/2'),
    (7,3,12,6,'completed','2013/10/2'),
    (8,2,12,12,'completed','2013/10/3'),
    (9,3,10,12,'completed','2013/10/3'),
    (10,4,13,12,'cancelled_by_driver','2013/10/3');

insert into users
values 
    (1,false,'client'),
    (2,true,'client'),
    (3,false,'client'),
    (4,false,'client'),
    (10,false,'driver'),
    (11,false,'driver'),
    (12,false,'driver'),
    (13,false,'driver');

create table if not exists numbers(
    number int primary key ,
    frequency int
);

insert into numbers
values
       (0,7),(1,1),(2,3),(3,1);

create table if not exists employee_bonus(
    empid int primary key ,
    name  varchar(20),
    supervisor int,
    salary int
);
insert into employee_bonus
values
       (1,'john',3,1000),
       (2,'dan',3,2000),
       (3,'brad',null,4000),
       (4,'thomas',3,4000);

create table if not exists bonus(
    empid int primary key ,
    bonus int
);
insert into bonus
values (2,500),(4,2000);

drop table if exists survey_log ;
create  table survey_log(
    uid int ,
    action varchar(20),
    question_id int,
    answer_id int,
    q_num int,
    timestamp varchar(20)
);
# delete from survey_log;
insert into survey_log
values 
    (5,'show',285,null,1,123),
    (5,'answer',285,null,1,124),
    (5,'show',369,null,2,125),
    (5,'skip',369,null,2,126);

create table if not exists student_d(
    student_id int primary key ,
    student_name varchar(20),
    gender character,
    dept_id int
);
drop table if exists department;
create table if not exists department(
    dept_id int primary key,
    dept_name varchar(20)
);
insert into student_d
values
    (1,'Jack','M',1),
    (2,'Jane','F',1),
    (3,'Mark','M',2);

insert into department
values
    (1,'Engineering'),
    (2,'Science'),
    (3,'Law');

create table if not exists temp1(
    id int primary key ,
    val int
);
create table if not exists rtemp(
    id int,
    val int
);
insert into temp1
values
    (1,1),
    (2,2),
    (3,3),
    (4,4),
    (5,5),
    (6,6),
    (7,7),
    (8,8),
    (9,9),
    (10,10);
insert into rtemp
values
    (1,1),
    (1,2),
    (1,3),
    (1,4),
    (1,5),
    (1,6),
    (1,7),
    (1,8),
    (1,9),
    (1,10);

create table if not exists referee(
    id int primary key ,
    name varchar(50),
    referee_id int
);

insert into referee
values
    (1,'Will',NULL),
    (2,'Jane',NULL),
    (3,'Alex',2),
    (4,'Bill',NULL),
    (5,'Zack',1),
    (6,'Mark',2);

create table if not exists insurance(
    pid int primary key ,
    tiv_2015 numeric(15,2),
    tiv_2016 numeric(15,2),
    lat numeric(5,2),
    lon numeric(5,2)
);

insert into insurance
values 
    (1,10,5,10,10),
    (2,20,20,20,20),
    (3,10,30,20,20),
    (4,10,40,40,40);

create table if not exists orders_max (
    order_number int,
    customer_number int,
    order_date date,
    required_date date,
    shipped_date date,
    status char(15),
    comment char(200)
);
insert into orders_max
values 
    (1,1,'2017-04-09','2017-04-13','2017-04-12','Closed',''),
    (2,2,'2017-04-15','2017-04-20','2017-04-18','Closed',''),
    (3,3,'2017-04-16','2017-04-25','2017-04-20','Closed',''),
    (4,3,'2017-04-18','2017-04-28','2017-04-25','Closed','');

create table if not exists class_studnet(
    student char primary key ,
    class varchar(20)
);

insert into class_studnet
values 
    ('A','Math'),      
    ('B','English'),  
    ('C','Math'),      
    ('D','Biology'),  
    ('E','Math'),      
    ('F','Computer'),  
    ('G','Math'),      
    ('H','Math'),      
    ('I','Math');

create table if not exists stadium(
    id int primary key,
    visit_date date,
    people int
);
insert into stadium
values
    (1,'2017-01-01',10),
    (2,'2017-01-02',109),
    (3,'2017-01-03',150),
    (4,'2017-01-04',99),
    (5,'2017-01-05',145),
    (6,'2017-01-06',1455),
    (7,'2017-01-07',199),
    (8,'2017-01-08',188);

create table if not exists request_accpeted_most(
    requester_id int,
    accepter_id int,
    accept_date date
);
insert into request_accpeted_most
values
    (1,2,'2016_06-03'),
    (1,3,'2016-06-08'),
    (2,3,'2016-06-08'),
    (3,4,'2016-06-09');

create table if not exists salesperson(
    sales_id int,
    name varchar(20),
    salary int,
    commission_rate int,
    hire_date date
);
insert into salesperson
values
    (1,'John',100000,6,'2006/4/1'),
    (2,'Amy',120000,5,'2010/5/1'),
    (3,'Mark',65000,12,'2008/12/25'),
    (4,'Pam',25000,25,'2005/1/1'),
    (5,'Alex',50000,10,'2007/2/3');
create table if not exists company(
    com_id int,
    name varchar(50),
    city varchar(30)
);
insert into company
values
    (1,	'RED','Boston'),
    (2,	'ORANGE','New York'),
    (3,	'YELLOW','Boston'),
    (4,	'GREEN','Austin');
create table if not exists orders_sales(
    order_id int,
    date date,
    com_id int,
    sales_id int,
    amount int
);
insert into orders_sales
values
    (1,'2014/1/1',3,4,100000),
    (2,'2014/2/1',4,5,5000),
    (3,'2014/3/1',1,1,50000),
    (4,'2014/4/1',1,4,25000);

create table if not exists point_2d(
    x int,
    y int
);
insert into point_2d
values
(-1,-1),(0,0),(-1,-2);

create table if not exists point(
    x int
);
insert into point
values
(-1),(0),(2);

create table if not exists follow(
    followee char,
    follower char
);
insert into follow
values
('A','B'),('B','C'),('B','D'),('D','E');

create table if not exists student_geo(
    name varchar(20),
    continent varchar(50)
);
insert into student_geo
values
    ('Jack','America'),
    ('Pascal','Europe'),
    ('Xi','Asia'),
    ('Jane','America');

create table if not exists my_number(
    num int
);
insert into my_number
values
    (8),
    (8),
    (3),
    (3),
    (1),
    (4),
    (5),
    (6);

create table if not exists movies(
    id int primary key ,
    movie varchar(100),
    description varchar(30),
    rating float
);
insert into movies
values
    (1,'War','great 3D',8.9),
    (2,'Science','fiction',8.5),
    (3,'irish','boring',6.2),
    (4,'Icesong','Fantacy',8.6),
    (5,'Housecard','Interesting',9.1);

create table if not exists swap_salary(
    id int,
    name varchar(20),
    sex char,
    salary int
);

insert into swap_salary
values
    (1,'A','m',2500),
    (2,'B','f',1500),
    (3,'C','m',5500),
    (4,'D','f',500);

drop table activity;
create table if not exists activity(
    player_id int,
    device_id int,
    event_date date,
    games_played int
);
insert into activity
values
    (1,2,'2016-03-01',5),
    (1,2,'2016-05-02',6),
    (2,3,'2017-06-25',1),
    (3,1,'2016-03-02',0),
    (3,4,'2018-07-03',5);
# 因为题42的数据与目前的不吻合,所以清空目前的数据
# delete from activity;
insert into activity
values
    (1,2,'2016-03-01',5),
    (1,2,'2016-03-02',6),
    (2,3,'2017-06-25',1),
    (3,1,'2016-03-02',0),
    (3,4,'2018-07-03',5);

create table if not exists ActorDirector(
    actor_id int,
    director_id int,
    timestamp int,
    primary key (timestamp)
);

insert into ActorDirector
values
    (1,1,0),
    (1,1,1),
    (1,1,2),
    (1,2,3),
    (1,2,4),
    (2,1,5),
    (2,1,6);

create table if not exists sales_year(
    sales_id int,
    product_id int,
    year int,
    quantity int,
    price int,
    primary key (sales_id,year),
    foreign key (product_id) references product_year(product_id)
);
create table if not exists product_year(
    product_id int primary key ,
    product_name varchar(40)
);
insert into sales_year
values
    (1,100,2008,10,5000),
    (2,100,2009,12,5000),
    (7,200,2011,15,9000);
insert into product_year
values
(100,'Nokia'),
(200,'Apple'),
(300,'Samsung');

create table if not exists project_workyear(
    project_id int,
    employee_id int,
    primary key (project_id,employee_id),
    foreign key (employee_id) references employee_workyear(employee_id)
);
create table if not exists employee_workyear(
    employee_id int,
    name varchar(30),
    experience_year int,
    primary key (employee_id)
);
insert into employee_workyear
values
    (1,'Khaled',3),
    (2,'Ali',2),
    (3,'John',1),
    (4,'Doe',2);
insert into project_workyear
values
    (1,1),
    (1,2),
    (1,3),
    (2,1),
    (2,4);
create table if not exists product_salemax(
    product_id int,
    product_name varchar(40),
    unit_price int,
    primary key (product_id)
);
create table if not exists salesmax(
    seller_id int,
    product_id int,
    buyer_id int,
    sale_date date,
    quantity int,
    price int
);
insert into product_salemax
values
    (1,'S8',1000),
    (2,'G4',800 ),
    (3,'iPhone',1400);
insert into salesmax
values
    (1,1,1,'2019-01-21',2,2000),
    (1,2,2,'2019-02-17',1,800),
    (2,2,3,'2019-06-02',1,800),
    (3,3,4,'2019-05-13',2,2800);

# 更新玩家状态表activity
# delete from activity;
insert into activity
values
    (1,2,'2016-03-01',5),
    (1,2,'2016-03-02',6),
    (2,3,'2017-06-25',1),
    (3,1,'2016-03-01',0),
    (3,4,'2016-07-03',5);

create table if not exists books(
    book_id int,
    name varchar(50),
    available_from date,
    primary key (book_id)
);
create table if not exists orders_book(
    order_id int,
    book_id int,
    quantity int,
    dispatch_date date,
    primary key (order_id),
    foreign key (book_id) references books(book_id)
);
insert into books
values
    (1,'Kalila And Demna','2010-01-01'),
    (2,'28 Letters','2012-05-12'),
    (3,'The Hobbit','2019-06-10'),
    (4,'13 Reasons Why','2019-06-01'),
    (5,'The Hunger Games','2008-09-21');
insert into orders_book
values
    (1,1,2,'2018-07-26'),
    (2,1,1,'2018-11-05'),
    (3,3,8,'2019-06-11'),
    (4,4,6,'2019-06-05'),
    (5,4,5,'2019-06-20'),
    (6,5,9,'2009-02-02'),
    (7,5,8,'2010-04-13');

create table if not exists Traffic(
    user_id int,
    activity enum ('login', 'logout', 'jobs', 'groups', 'homepage') ,
    activity_date date
);
insert into Traffic
values
    (1,'login','2019-05-01'),
    (1,'homepage','2019-05-01'),
    (1,'logout','2019-05-01'),
    (2,'login','2019-06-21'),
    (2,'logout','2019-06-21'),
    (3,'login','2019-01-01'),
    (3,'jobs','2019-01-01'),
    (3,'logout','2019-01-01'),
    (4,'login','2019-06-21'),
    (4,'groups','2019-06-21'),
    (4,'logout','2019-06-21'),
    (5,'login','2019-03-01'),
    (5,'logout','2019-03-01'),
    (5,'login','2019-06-21'),
    (5,'logout','2019-06-21');

create table if not exists Enrollments(
    student_id int,
    course_id int,
    grade int,
    primary key (student_id,course_id)
);
insert into enrollments
values
    (2,2,95),
    (2,3,95),
    (1,1,90),
    (1,2,99),
    (3,1,80),
    (3,2,75),
    (3,3,82);

create table if not exists actions_report(
    user_id int,
    post_id int,
    action_date date,
    action enum ('view', 'like', 'reaction', 'comment', 'report', 'share'),
    extra varchar(50)
);
insert into actions_report
values
    (1,1,'2019-07-01','view',null),
    (1,1,'2019-07-01','like',null),
    (1,1,'2019-07-01','share',null),
    (2,4,'2019-07-04','view',null),
    (2,4,'2019-07-04','report','spam'),
    (3,4,'2019-07-04','view',null),
    (3,4,'2019-07-04','report','spam'),
    (4,3,'2019-07-02','view',null),
    (4,3,'2019-07-02','report','spam'),
    (5,2,'2019-07-04','view',null),
    (5,2,'2019-07-04','report','racism'),
    (5,5,'2019-07-04','view',null),
    (5,5,'2019-07-04','report','racism');

create table if not exists activity_report(
    business_id int,
    event_type varchar(50),
    occurences int,
    primary key (business_id,event_type)
);
insert into activity_report
values
    (1,'reviews',7),
    (3,'reviews',3),
    (1,'ads',11),
    (2,'ads',7),
    (3,'ads',6),
    (1,'page views',3),
    (2,'page views',12);

create table if not exists Spending(
    user_id int,
    spend_date date,
    platform enum ('desktop', 'mobile'),
    amount int
);
insert into spending
values
    (1,'2019-07-01','mobile',100),
    (1,'2019-07-01','desktop',100),
    (2,'2019-07-01','mobile',100),
    (2,'2019-07-02','mobile',100),
    (3,'2019-07-01','desktop',100),
    (3,'2019-07-02','desktop',100);

create table if not exists ad_actions(
    user_id int,
    post_id int,
    action_date date,
    action enum ('view', 'like', 'reaction', 'comment', 'report', 'share'),
    extra varchar(50)
);
# drop table removals;
create table if not exists removals(
    post_id int,
    remove_date date,
    primary key (post_id)
);
insert into ad_actions
values
    (1,1,'2019-07-01','like',null),
    (1,1,'2019-07-01','share ',null),
    (2,2,'2019-07-04','view',null),
    (2,2,'2019-07-04','report','spam'),
    (3,4,'2019-07-04','view',null),
    (3,4,'2019-07-04','report','spam'),
    (4,3,'2019-07-02','view',null),
    (4,3,'2019-07-02','report','spam'),
    (5,2,'2019-07-03','view',null),
    (5,2,'2019-07-03','report','racism'),
    (5,5,'2019-07-03','view',null),
    (5,5,'2019-07-03','report','racism');
insert into removals
values
    (2,'2019-07-20'),
    (3,'2019-07-18');

create table if not exists activity_users(
    user_id int,
    session_id int,
    activity_date date,
    activity_type enum('open_session', 'end_session', 'scroll_down', 'send_message')
);
insert into activity_users
values
    (1,1,'2019-07-20','open_session'),
    (1,1,'2019-07-20','scroll_down'),
    (1,1,'2019-07-20','end_session'),
    (2,4,'2019-07-20','open_session'),
    (2,4,'2019-07-21','send_message'),
    (2,4,'2019-07-21','end_session'),
    (3,2,'2019-07-21','open_session'),
    (3,2,'2019-07-21','send_message'),
    (3,2,'2019-07-21','end_session'),
    (4,3,'2019-06-25','open_session'),
    (4,3,'2019-06-25','end_session');
# delete from activity_users;
insert into activity_users
values
(1,1,'2019-07-20','open_session'),
(1,1,'2019-07-20','scroll_down'),
(1,1,'2019-07-20','end_session'),
(2,4,'2019-07-20','open_session'),
(2,4,'2019-07-21','send_message'),
(2,4,'2019-07-21','end_session'),
(3,2,'2019-07-21','open_session'),
(3,2,'2019-07-21','send_message'),
(3,2,'2019-07-21','end_session'),
(3,5,'2019-07-21','open_session'),
(3,5,'2019-07-21','scroll_down'),
(3,5,'2019-07-21','end_session'),
(4,3,'2019-06-25','open_session'),
(4,3,'2019-06-25','end_session');

create table if not exists views(
    article_id int,
    author_id int,
    viewer_id int,
    view_data date
);

insert into views
values
(1,3,5,'2019-08-01'),
(1,3,6,'2019-08-02'),
(2,7,7,'2019-08-01'),
(2,7,6,'2019-08-02'),
(4,7,1,'2019-07-22'),
(3,4,4,'2019-07-21'),
(3,4,4,'2019-07-21');

create table if not exists user_registers(
    user_id int,
    join_date date,
    favorite_brand varchar(50),
    primary key (user_id)
);
drop table orders_info;
create table if not exists orders_info(
    order_id int,
    order_date date,
    item_id int,
    buyer_id int,
    seller_id int,
    primary key (order_id),
    foreign key (item_id) references item(item_id),
    foreign key (buyer_id) references user_registers(user_id),
    foreign key (seller_id) references user_registers(user_id)
);
create table if not exists item(
    item_id int,
    item_brand varchar(50),
    primary key (item_id)
);
insert into user_registers
values
(1,'2018-01-01','Lenovo'),
(2,'2018-02-09','Samsung'),
(3,'2018-01-19','LG'),
(4,'2018-05-21','HP');
insert into orders_info
values
(1,'2019-08-01',4,1,2),
(2,'2018-08-02',2,1,3),
(3,'2019-08-03',3,2,3),
(4,'2018-08-04',1,4,2),
(5,'2018-08-04',1,3,4),
(6,'2019-08-05',2,2,4);
insert into item
values
(1,'Samsung'),
(2,'Lenovo'),
(3,'LG'),
(4,'HP');

create table if not exists product_price(
    product_id int,
    new_price int,
    change_date date,
    primary key (product_id,change_date)
);
insert into product_price
values
(1,20,'2019-08-14'),
(2,50,'2019-08-14'),
(1,30,'2019-08-15'),
(1,35,'2019-08-16'),
(2,65,'2019-08-17'),
(3,20,'2019-08-18');

create table if not exists user_favorite(
    user_id int,
    join_date date,
    favorite_brand varchar(50),
    primary key (user_id)
);
create table if not exists order_favorite(
    order_id int,
    order_date date,
    item_id int,
    buyer_id int,
    seller_id int,
    primary key (order_id),
    foreign key (buyer_id) references user_favorite(user_id),
    foreign key (seller_id) references user_favorite(user_id)
);
insert into user_favorite
values
(1,'2019-01-01','Lenovo'),
(2,'2019-02-09','Samsung'),
(3,'2019-01-19','LG'),
(4,'2019-05-21','HP');
insert into order_favorite
values
(1,'2019-08-01',4,1,2),
(2,'2019-08-02',2,1,3),
(3,'2019-08-03',3,2,3),
(4,'2019-08-04',1,4,2),
(5,'2019-08-04',1,3,4),
(6,'2019-08-05',2,2,4);

create table if not exists delivery(
    delivery_id int,
    customer_id int,
    order_date date,
    cumtoer_per_deliver_date date,
    primary key (delivery_id)
);
insert into delivery
values
(1,1,'2019-08-01','2019-08-02'),
(2,5,'2019-08-02','2019-08-02'),
(3,1,'2019-08-11','2019-08-11'),
(4,3,'2019-08-24','2019-08-26'),
(5,4,'2019-08-21','2019-08-22'),
(6,2,'2019-08-11','2019-08-13');
# delete from delivery;
insert into delivery
values
(1,1,'2019-08-01','2019-08-02'),
(2,2,'2019-08-02','2019-08-02'),
(3,1,'2019-08-11','2019-08-12'),
(4,3,'2019-08-24','2019-08-24'),
(5,3,'2019-08-21','2019-08-22'),
(6,2,'2019-08-11','2019-08-13'),
(7,4,'2019-08-09','2019-08-09');

create table if not exists department_revenue(
    id int,
    revenue int,
    month enum('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')
);
insert into department_revenue
values
(1,8000 ,'Jan'),
(2,9000 ,'Jan'),
(3,10000,'Feb'),
(1,7000 ,'Feb'),
(1,6000 ,'Mar');

create table if not exists Transactions(
    id int,
    country varchar(40),
    state enum('declined','approved'),
    amount int,
    trans_date date
);
insert into transactions
values
(121,'US','approved',1000,'2018-12-18'),
(122,'US','declined',2000,'2018-12-19'),
(123,'US','approved',2000,'2019-01-01'),
(124,'DE','approved',2000,'2019-01-07');

create table if not exists players(
    player_id int,
    group_id int,
    primary key (player_id)
);
create table if not exists matches(
    match_id int,
    first_player int,
    second_player int,
    first_score int,
    second_score int,
    primary key (match_id)
);
insert into players
values
(15,1),
(25,1),
(30,1),
(45,1),
(10,2),
(35,2),
(50,2),
(20,3),
(40,3);
insert into matches
values
(1,15,45,3,0),
(2,30,25,1,2),
(3,30,15,2,0),
(4,40,20,5,2),
(5,35,50,1,1);

create table if not exists Queue(
    person_id int,
    person_name varchar(20),
    weight int,
    turn int,
    primary key (person_id)
                                );

insert into queue
values
(5,'George Washington',250,1),
(3,'John Adams',350,2),
(6,'Thomas Jefferson',400,3),
(2,'Will Johnliams',200,4),
(4,'Thomas Jefferson',175,5),
(1,'James Elephant',500,6);

create table if not exists transactions_a(
    id int,
    country varchar(40),
    state enum('approved','declined'),
    amount int,
    trans_date date,
    primary key (id)
);
create table if not exists Chargebacks(
    trans_id int,
    charge_date date
);
insert into transactions_a
values
(101,'US','approved',1000,'2019-05-18'),
(102,'US','declined',2000,'2019-05-19'),
(103,'US','approved',3000,'2019-06-10'),
(104,'US','declined',4000,'2019-06-13'),
(105,'US','approved',5000,'2019-06-15');
insert into chargebacks
values
(102,'2019-05-29'),
(101,'2019-06-30'),
(105,'2019-09-18');

create table if not exists Queries(
    query_name varchar(40),
    result varchar(40),
    position int,
    rating int
);
insert into queries
values
('Dog','Golden Retriever',1,5),
('Dog','German Shepherd',2,5),
('Dog','Mule',200,1),
('Cat','Shirazi',5,2),
('Cat','Siamese',3,3),
('Cat','Sphynx',7,4);

create table if not exists Teams(
    team_id int,
    team_name varchar(30),
    primary key (team_id)
);
create table if not exists Matches_a(
    match_id int,
    host_team int,
    guest_team int,
    host_goals int,
    guest_goals int,
    primary key (match_id)
);
insert into Teams
values
(10,'Leetcode FC'),
(20,'NewYork FC'),
(30,'Atlanta FC'),
(40,'Chicago FC'),
(50,'Toronto FC');
insert into matches_a
values
(1,10,20,3,0),
(2,30,10,2,2),
(3,10,50,5,1),
(4,20,30,1,0),
(5,50,30,1,0);

create table if not exists Failed(
    fail_date date primary key
);
create table if not exists Succeeded(
    success_date date primary key
);
insert into failed
values
('2018-12-28'),
('2018-12-29'),
('2019-01-04'),
('2019-01-05');
insert into succeeded
values
('2018-12-30'),
('2018-12-31'),
('2019-01-01'),
('2019-01-02'),
('2019-01-03'),
('2019-01-06');

create table if not exists Submissions(
    sub_id int,
    parent_id int
);
insert into submissions
values
(1,Null),
(2,Null),
(1,Null),
(12,Null),
(3,1),
(5,2),
(3,1),
(4,1),
(9,1),
(10,2),
(6,7);

create table if not exists Prices_avg(
    product_id int,
    start_date date,
    end_date date,
    price int,
    primary key (product_id,start_date,end_date)
);
create table if not exists UnitsSold(
    product_id int,
    purchase_date date,
    units int
);
insert into prices_avg
values
(1,'2019-02-17','2019-02-28',5),
(1,'2019-03-01','2019-03-22',20),
(2,'2019-02-01','2019-02-20',15),
(2,'2019-02-21','2019-03-31',30);

insert into UnitsSold
values
(1,'2019-02-25',100),
(1,'2019-03-01',15 ),
(2,'2019-02-10',200),
(2,'2019-03-22',30 );

create table if not exists Friendship(
    user1_id int,
    user2_id int,
    primary key (user1_id,user2_id)
);
create table if not exists likes(
    uer_id int,
    page_id int,
    primary key (uer_id,page_id)
);
insert into friendship
values
(1,2),
(1,3),
(1,4),
(2,3),
(2,4),
(2,5),
(6,1);
insert into likes
values
(1,88),
(2,23),
(3,24),
(4,56),
(5,11),
(6,33),
(2,77),
(3,77),
(6,88);

create table if not exists Employees_report(
    employee_id int,
    employee_name varchar(50),
    manage_id int,
    primary key (employee_id)
);
insert into employees_report
values
(1,'Boss',1),
(3,'Alice',3),
(2,'Bob',1),
(4,'Daniel',2),
(7,'Luis',4),
(8,'Jhon',3),
(9,'Angela',8),
(77,'Robert',1);

create table if not exists Students_a(
    student_id int,
    student_name varchar(20),
    primary key (student_id)
);
create table if not exists Subjects(
    subject_name varchar(50) primary key
);
create table if not exists examinations(
    student_id int,
    subject_name varchar(50)
);
insert into Students_a
values
(1,'Alice'),
(2,'Bob'),
(13,'John'),
(6,'Alex');
insert into Subjects
values
('Math'),
('Physics'),
('Programming');
insert into Examinations
values
(1,'Math'),
(1,'Physics'),
(1,'Programming'),
(2,'Programming'),
(1,'Physics'),
(1,'Math'),
(13,'Math'),
(13,'Programming'),
(13,'Physics'),
(2,'Math'),
(1,'Math');

create table if not exists logs_a(
    log_id int primary key
);
insert into logs_a
values
(1),
(2),
(3),
(7),
(8),
(10);

create table if not exists Countries(
    country_id int primary key ,
    country_name varchar(50)
);
create table if not exists weather_c(
    country_id int,
    weather_state varchar(50),
    day date,
    primary key (country_id,day)
);
insert into countries
values
(2,'USA'),
(3,'Australia'),
(7,'Peru'),
(5,'China'),
(8,'Morocco'),
(9,'Spain');
insert into weather_c
values
(2,15,'2019-11-01'),
(2,12,'2019-10-28'),
(2,12,'2019-10-27'),
(3,-2,'2019-11-10'),
(3,0,'2019-11-11'),
(3,3,'2019-11-12'),
(5,16,'2019-11-07'),
(5,18,'2019-11-09'),
(5,21,'2019-11-23'),
(7,25,'2019-11-28'),
(7,22,'2019-12-01'),
(7,20,'2019-12-02'),
(8,25,'2019-11-05'),
(8,27,'2019-11-15'),
(8,31,'2019-11-25'),
(9,7,'2019-10-23'),
(9,3,'2019-12-23');

create table if not exists Employee_total(
    employee_id int primary key ,
    team_id int
);
insert into employee_total
values
(1,8),
(2,8),
(3,8),
(4,7),
(5,9),
(6,9);

create table if not exists score_bysex(
    player_name varchar(30),
    gender varchar(5),
    day date,
    score_points int,
    primary key (gender,day)
);
insert into score_bysex
values
('Aron','F','2020-01-01',17),
('Alice','F','2020-01-07',23),
('Bajrang','M','2020-01-07',7),
('Khali','M','2019-12-25',11),
('Slaman','M','2019-12-30',13),
('Joe','M','2019-12-31',3),
('Jose','M','2019-12-18',2),
('Priya','F','2019-12-31',23),
('Priyanka','F','2019-12-30',17);

create table if not exists Customer_by7day(
    customer_id int,
    name varchar(30),
    visited_on date,
    amount int,
    primary key (customer_id,visited_on)
);
insert into customer_by7day
values
(1,'Jhon','2019-01-01',100),
(2,'Daniel','2019-01-02',110),
(3,'Jade','2019-01-03',120),
(4,'Khaled','2019-01-04',130),
(5,'Winston','2019-01-05',110),
(6,'Elvis','2019-01-06',140),
(7,'Anna','2019-01-07',150),
(8,'Maria','2019-01-08',80),
(9,'Jaze','2019-01-09',110),
(1,'Jhon','2019-01-10',130),
(3,'Jade','2019-01-10',150);

create table if not exists ads(
    ad_id int,
    user_id int,
    action enum('Clicked', 'Viewed', 'Ignored'));
insert into ads
values
(1,1,'Clicked'),
(2,2,'Clicked'),
(3,3,'Viewed'),
(5,5,'Ignored'),
(1,7,'Ignored'),
(2,7,'Viewed'),
(3,5,'Clicked'),
(1,4,'Viewed'),
(2,11,'Viewed'),
(1,2,'Clicked');

create table if not exists products_y(
    product_id int primary key ,
    product_name varchar(20),
    product_category varchar(20)
);
create table if not exists orders_y(
    product_id int,
    order_date date,
    unit int
);
insert into products_y
values
(1,'Leetcode Solutions','Book'),
(2,'Jewelsof Stringology','Book'),
(3,'HP','Laptop'),
(4,'Lenovo','Laptop'),
(5,'Leetcode Kit','T-shirt');

insert into orders_y
values
(1,'2020-02-05',60),
(1,'2020-02-10',70),
(2,'2020-01-18',30),
(2,'2020-02-11',80),
(3,'2020-02-17',2),
(3,'2020-02-24',3),
(4,'2020-03-01',20),
(4,'2020-03-04',30),
(4,'2020-03-04',60),
(5,'2020-02-25',50),
(5,'2020-02-27',50),
(5,'2020-03-01',50);

create table if not exists Visits(
    user_id int,
    visit_date date,
    primary key (user_id,visit_date)
);
create table if not exists Transactions_b(
    user_id int,
    transaction_date date,
    amount int
);
insert into visits
values
(1,'2020-01-01'),
(2,'2020-01-02'),
(12,'2020-01-01'),
(19,'2020-01-03'),
(1,'2020-01-02'),
(2,'2020-01-03'),
(1,'2020-01-04'),
(7,'2020-01-11'),
(9,'2020-01-25'),
(8,'2020-01-28');

insert into Transactions_b
values
(1,'2020-01-02',120),
(2,'2020-01-03',22),
(7,'2020-01-11',232),
(1,'2020-01-04',7),
(9,'2020-01-25',33),
(9,'2020-01-25',66),
(8,'2020-01-28',1),
(9,'2020-01-25',99);

create table if not exists Movies_a(
    movie_id int primary key,
    movie_title varchar(50)
);
create table if not exists user_movies(
    user_id int primary key ,
    name varchar(50)
);
create table if not exists movie_rating(
    movie_id int,
    user_id int,
    rating int,
    create_at date,
    primary key (movie_id,user_id)
);
insert into movies_a
values
(1,'Avengers'),
(2,'Frozen 2'),
(3,'Joker');
insert into user_movies
values
(1,'Daniel'),
(2,'Monica'),
(3,'Maria'),
(4,'James');
insert into movie_rating
values
(1,1,3,'2020-01-12'),
(1,2,4,'2020-02-11'),
(1,3,2,'2020-02-12'),
(1,4,1,'2020-01-01'),
(2,1,5,'2020-02-17'),
(2,2,2,'2020-02-01'),
(2,3,2,'2020-03-01'),
(3,1,3,'2020-02-22'),
(3,2,4,'2020-02-25');

drop table deparments_info;
create table if not exists deparments_info(
    id int primary key ,
    name varchar(40)
);
create table if not exists student_info(
    id int primary key ,
    name varchar(20),
    department_id int
);
insert into deparments_info
values
(1,'Electrical Engineering'),
(7,'Computer Engineering'),
(13,'Bussiness Administration');
insert into student_info
values
(23,'Alice',1),
(1,'Bob',7),
(5,'Jennifer',13),
(2,'John',14),
(4,'Jasmine',77),
(3,'Steve',74),
(6,'Luis',1),
(8,'Jonathan',7),
(7,'Daiana',33),
(11,'Madelynn',1);

create table if not exists friends_a(
    id int primary key ,
    name varchar(20),
    activity varchar(30)
);
insert into friends_a
values
(1,'Jonathan D.','Eating'),
(2,'Jade W.','Singing'),
(3,'Victor J.','Singing'),
(4,'Elvis Q.','Eating'),
(5,'Daniel A.','Eating'),
(6,'Bob B.','Horse Riding');

create table if not exists Customers_info(
    customer_id int primary key ,
    customer_name varchar(30),
    email varchar(40)
);
create table if not exists Contacts(
    user_id int,
    contact_name varchar(40),
    contact_email varchar(40),
    primary key (user_id,contact_email)
);
create table if not exists Invoices(
    invoice_id int primary key ,
    price int,
    user_id int
);
insert into customers_info
values
(1,'Alice','alice@leetcode.com'),
(2,'Bob','bob@leetcode.com'),
(13,'John','john@leetcode.com'),
(6,'Alex','alex@leetcode.com');
insert into contacts
values
(1,'Bob','bob@leetcode.com'),
(1,'John','john@leetcode.com'),
(1,'Jal','jal@leetcode.com'),
(2,'Omar','omar@leetcode.com'),
(2,'Meir','meir@leetcode.com'),
(6,'Alice','alice@leetcode.com');
insert into Invoices
values
(77,100,1),
(88,200,1),
(99,300,2),
(66,400,2),
(55,500,13),
(44,60,6);

create table if not exists UserActivity(
    user_name varchar(30),
    activity varchar(30),
    startDate date,
    endDate date
);
insert into UserActivity
values
('Alice','Travel','2020-02-12','2020-02-20'),
('Alice','Dancing','2020-02-21','2020-02-23'),
('Alice','Travel','2020-02-24','2020-02-28'),
('Bob','Travel','2020-02-11','2020-02-18');

create table if not exists Employees_unique(
    id int primary key,
    name varchar(30)
);

create table if not exists EmployeeUNI(
    id int,
    unique_id int,
    primary key (id,unique_id)
);
insert into employees_unique
values
(1,'Alice'),
(7,'Bob'),
(11,'Meir'),
(90,'Winston'),
(3,'Jonathan');
insert into EmployeeUNI
values
(3,1),
(11,2),
(90,3);

create table if not exists Product_c(
    product_id int primary key ,
    product_name varchar(50)
);
create table if not exists sales_c(
    product_id int primary key ,
    period_start date,
    period_end date,
    average_daily_sales int
);
insert into product_c
values
(1,'LC Phone'),
(2,'LC T-Shirt'),
(3,'LC Keychain');
insert into sales_c
values
(1,'2019-01-25','2019-02-28',100),
(2,'2018-12-01','2020-01-01',10),
(3,'2019-12-01','2020-01-31',1);

create table if not exists Stocks(
    stock_name varchar(20),
    operation enum('Sell','Buy'),
    operation_day int,
    price int,
    primary key (stock_name,operation_day)
);
insert into stocks
values
('Leetcode','Buy',1,1000),
('Corona Masks','Buy',2,10),
('Leetcode','Sell',5,9000),
('Handbags','Buy',17,30000),
('Corona Masks','Sell',3,1010),
('Corona Masks','Buy',4,1000),
('Corona Masks','Sell',5,500),
('Corona Masks','Buy',6,1000),
('Handbags','Sell',29,7000),
('Corona Masks','Sell',10,10000);

create table if not exists Customers_d(
    customer_id int primary key ,
    customer_name varchar(30)
);
drop table orders_d;
create table if not exists orders_d(
    order_id int primary key ,
    customer_id int,
    product_name varchar(30)
);
insert into customers_d
values
(1,'Daniel'),
(2,'Diana'),
(3,'Elizabeth'),
(4,'Jhon');
insert into orders_d
values
(10,1,'A'),
(20,1,'B'),
(30,1,'D'),
(40,1,'C'),
(50,2,'A'),
(60,3,'A'),
(70,3,'B'),
(80,3,'D'),
(90,4,'C');

create table if not exists users_dist(
    id int primary key ,
    name varchar(30)
);
create table if not exists rides_dist(
    id int primary key ,
    user_id int,
    distance int
);
insert into users_dist
values
(1,'Alice'),
(2,'Bob'),
(3,'Alex'),
(4,'Donald'),
(7,'Lee'),
(13,'Jonathan'),
(19,'Elvis');
insert into rides_dist
values
(1,1,120),
(2,2,317),
(3,3,222),
(4,7,100),
(5,13,312),
(6,19,50),
(7,7,120),
(8,19,400),
(9,7,230);

create table if not exists student_medium(
    student_id int primary key ,
    student_name varchar(30)
);
create table if not exists exam_medium(
    exam_id int,
    student_id int,
    score int,
    primary key (exam_id,student_id)
);
insert into student_medium
values
(1,'Daniel'),
(2,'Jade'),
(3,'Stella'),
(4,'Jonathan'),
(5,'Will');
insert into exam_medium
values
(10,1,70),
(10,2,80),
(10,3,90),
(20,1,80),
(30,1,70),
(30,3,80),
(30,4,90),
(40,1,60),
(40,2,70),
(40,4,80);

create table if not exists npv(
    id int,
    year int,
    npv int,
    primary key (id,year)
);

create table if not exists Queries_npv(
    id int,
    year int,
    primary key (id,year)
);
insert into npv
values
(1,2018,100),
(7,2020,30),
(13,2019,40),
(1,2019,113),
(2,2008,121),
(3,2009,12),
(11,2020,99),
(7,2019,0);
insert into Queries_npv
values
(1,2019),
(2,2008),
(3,2009),
(7,2018),
(7,2019),
(7,2020),
(13,2019);

create table if not exists Sessions(
    session_id int primary key ,
    duration int
);
insert into sessions
values
(1,30),
(2,199),
(3,299),
(4,580),
(5,1000);

create table if not exists Variables(
    name varchar(30) primary key ,
    value int
);
create table if not exists Expressions(
    left_operand varchar(5),
    operator enum('<', '>', '='),
    right_operant varchar(5),
    primary key (left_operand,operator,right_operant)
);
insert into variables
values
('x',66),
('y',77);

insert into expressions
values
('x','>','y'),
('x','<','y'),
('x','=','y'),
('y','>','x'),
('y','<','x'),
('x','=','x');

# drop table fruits_sales;
create table if not exists fruits_sales(
    sale_date date,
    fruit enum('apples','oranges'),
    sold_num int,
    primary key (sale_date,fruit)
);
insert into fruits_sales
value
('2020-05-01','apples',10),
('2020-05-01','oranges',8),
('2020-05-02','apples',15),
('2020-05-02','oranges',15),
('2020-05-03','apples',20),
('2020-05-03','oranges',0),
('2020-05-04','apples',15),
('2020-05-04','oranges',16);

create table if not exists Accounts(
    id int primary key ,
    name varchar(30)
);
create table if not exists logins(
    id int,
    login_date date
);
insert into accounts
values
(1,'Winston'),
(7,'Jonathan');
insert into logins
values
(7,'2020-05-30'),
(1,'2020-05-30'),
(7,'2020-05-31'),
(7,'2020-06-01'),
(7,'2020-06-02'),
(7,'2020-06-02'),
(7,'2020-06-03'),
(1,'2020-06-07'),
(7,'2020-06-10');

create table if not exists employee_above(
    id int primary key ,
    name varchar(20),
    salary int,
    managerid int
);
insert into employee_above
values
(1,'Joe',70000,3),
(2,'Henry',80000,4),
(3,'Sam',60000,NULL),
(4,'Max',90000,NULL);

create table if not exists find_email(
    id int primary key,
    email varchar(40)
);
insert into find_email
values
(1,'a@b.com'),
(2,'c@d.com'),
(3,'a@b.com');

create table if not exists customer_none(
    id int primary key ,
    name varchar(20)
);
create table if not exists orders_none(
    id int,
    customer_id int
);
insert into customer_none
values
(1,'Joe'),
(2,'Henry'),
(3,'Sam'),
(4,'Max');
insert into orders_none
values
(1,3),
(2,1);

create table if not exists customer_all(
    customer_id int,
    product_key int,
    foreign key (product_key) references Product_all(product_key)
);
create table if not exists Product_all(
    product_key int primary key
);
insert into customer_all
values
(1,5),
(2,6),
(3,5),
(3,6),
(1,6);
insert into product_all
values
       (5),
       (6);

create table if not exists points(
    id int primary key ,
    x_value int,
    y_value int
);
insert into points
values
(1,2,8),
(2,4,7),
(3,2,10);

create table if not exists Salaries_tax(
    company_id int,
    employee_id int,
    employee_name varchar(30),
    salary int,
    primary key (company_id,employee_id)
);
insert into salaries_tax
values
(1,1,'Tony',2000),
(1,2,'Pronub',21300),
(1,3,'Tyrrox',10800),
(2,1,'Pam',300),
(2,7,'Bassem',450),
(2,9,'Hermione',700),
(3,7,'Bocaben',100),
(3,2,'Ognjen',2200),
(3,13,'Nyancat',3300),
(3,15,'Morninngcat',1866);

create table if not exists orders_byweek(
    order_id int,
    customer_id int,
    order_date date,
    item_id varchar(30),
    quantity int,
    primary key (order_id,item_id)
);
create table if not exists items_byweek(
    item_id int primary key ,
    item_name varchar(50),
    item_category varchar(30)
);
insert into orders_byweek
values
(1,1,'2020-06-01',1,10),
(2,1,'2020-06-08',2,10),
(3,2,'2020-06-02',1,5),
(4,3,'2020-06-03',3,5),
(5,4,'2020-06-04',4,1),
(6,4,'2020-06-05',5,5),
(7,5,'2020-06-05',1,10),
(8,5,'2020-06-14',4,5),
(9,5,'2020-06-21',3,5);
insert into items_byweek
values
(1,'LC Alg.Book','Book'),
(2,'LC DB.Book','Book'),
(3,'LC Smarth Phone','Phone'),
(4,'LC Phone 2020','Phone'),
(5,'LC Smart Glass','Glasses'),
(6,'LC T-Shirt XL','T-Shirt');

create table if not exists Activities_c(
    sell_date date,
    product varchar(30)
);

insert into activities_c
values
('2020-05-30','Headphone'),
('2020-06-01','Pencil'),
('2020-06-02','Mask'),
('2020-05-30','Basketball'),
('2020-06-01','Bible'),
('2020-06-02','Mask'),
('2020-05-30','T-Shirt');

# drop table tvprogram;
create table if not exists TVProgram(
    program_date datetime,
    content_id int,
    channel varchar(30),
    primary key (program_date,content_id)
);
create table if not exists Content(
    content_id int primary key ,
    title varchar(40),
    kids_content enum('Y','N'),
    content_type varchar(10)
);
insert into TVProgram
values
('2020-06-10 08:00',1,'LC-Channel'),
('2020-05-11 12:00',2,'LC-Channel'),
('2020-05-12 12:00',3,'LC-Channel'),
('2020-05-13 14:00',4,'Disney Ch'),
('2020-06-18 14:00',4,'Disney Ch'),
('2020-07-15 16:00',5,'Disney Ch');
insert into content
values
(1,'Leetcode Movie','N','Movies'),
(2,'Alg.for Kids','Y','Series'),
(3,'Database Sols','N','Series'),
(4,'Aladdin','Y','Movies'),
(5,'Cinderella','Y','Movies');

create table if not exists person_i(
    id int primary key ,
    name varchar(30),
    phone_number varchar(13)
);
create table if not exists Country_i(
    name varchar(20),
    country_code varchar(5) primary key
);
create table if not exists Calls(
    caller_id int,
    callee_id int,
    duration int
);
insert into person_i
values
(3,'Jonathan','051-1234567'),
(12,'Elvis','051-7654321'),
(1,'Moncef','212-1234567'),
(2,'Maroua','212-6523651'),
(7,'Meir','972-1234567'),
(9,'Rachel','972-0011100');
insert into country_i
values
('Peru','051'),
('Israel','972'),
('Morocco','212'),
('Germany','049'),
('Ethiopia','251');
insert into calls
values
(1,9,33),
(2,9,4),
(1,2,59),
(3,12,102),
(3,12,330),
(12,3,5),
(7,9,13),
(7,1,3),
(9,7,1),
(1,7,7);

create table if not exists Customers_f(
    customer_id int primary key ,
    name varchar(20),
    country varchar(10)
);
create table if not exists Product_f(
    product_id int primary key ,
    description varchar(30),
    price int
);
create table if not exists Orders_f(
    order_id int primary key ,
    customer_id int,
    product_id int,
    order_date date,
    quantity int
);
insert into customers_f
values
(1,'Winston','USA'),
(2,'Jonathan','Peru'),
(3,'Moustafa','Egypt');
insert into product_f
values
(10,'LC Phone',300),
(20,'LC T-Shirt',10),
(30,'LC Book',45),
(40,'LC Keychain',2);
insert into Orders_f
values
(1,1,10,'2020-06-10',1),
(2,1,20,'2020-07-01',1),
(3,1,30,'2020-07-08',2),
(4,2,10,'2020-06-15',2),
(5,2,40,'2020-07-01',10),
(6,3,20,'2020-06-24',2),
(7,3,30,'2020-06-25',2),
(9,3,30,'2020-05-08',3);

create table if not exists Users_regex(
    user_id int primary key ,
    name varchar(20),
    mail varchar(40)
);
insert into users_regex
values
(1,'Winston','winston@leetcode.com'),
(2,'Jonathan','jonathanisgreat'),
(3,'Annabelle','bella-@leetcode.com'),
(4,'Sally','sally.come@leetcode.com'),
(5,'Marwan','quarz#2020@leetcode.com'),
(6,'David','david69@gmail.com'),
(7,'Shapiro','.shapo@leetcode.com');

# drop table patients;
create table if not exists Patients(
    patient_id int primary key,
    patient_name varchar(20),
    conditions varchar(40)
);
insert into Patients
values
(1,'Daniel','YFEV COUGH'),
(2,'Alice',''),
(3,'Bob','DIAB100 MYOP'),
(4,'George','ACNE DIAB100'),
(5,'Alain','DIAB201');

create table if not exists customer_recent(
    customer_id int primary key ,
    name varchar(20)
);
create table if not exists Orders_recent(
    order_id int primary key,
    order_date date,
    customer_id int,
    cost int
);
insert into customer_recent
values
(1,'Winston'),
(2,'Jonathan'),
(3,'Annabelle'),
(4,'Marwan'),
(5,'Khaled');

insert into orders_recent
values
(1,'2020-07-31',1,30),
(2,'2020-07-30',2,40),
(3,'2020-07-31',3,70),
(4,'2020-07-29',4,100),
(5,'2020-06-10',1,1010),
(6,'2020-08-01',2,102),
(7,'2020-08-01',3,111),
(8,'2020-08-03',1,99),
(9,'2020-08-07',2,32),
(10,'2020-07-15',1,2);

# drop table sales_upper;
create table if not exists sales_upper(
    sale_id int primary key,
    product_name varchar(50),
    sale_date date
);
insert into sales_upper
values
(1,'     LCPHONE   ','2000-01-16'),
(2,'   LCPhone     ','2000-01-17'),
(3,'    LcPhOnE    ','2000-02-18'),
(4,'     LCKeyCHAiN','2000-02-19'),
(5,'  LCKeyChain   ','2000-02-28'),
(6,'Matryoshka     ','2000-03-31');

create table if not exists Customers_rec(
    customer_id int primary key ,
    name varchar(20)
);
create table if not exists Orders_rec(
    order_id int primary key ,
    order_date date,
    customer_id int,
    product_id int
);
create table if not exists Products_rec(
    product_id int,
    product_name varchar(20),
    price int
);
insert into customers_rec
values
(1,'Winston'),
(2,'Jonathan'),
(3,'Annabelle'),
(4,'Marwan'),
(5,'Khaled');
insert into orders_rec
values
(1,'2020-07-31',1,1),
(2,'2020-07-30',2,2),
(3,'2020-08-29',3,3),
(4,'2020-07-29',4,1),
(5,'2020-06-10',1,2),
(6,'2020-08-01',2,1),
(7,'2020-08-01',3,1),
(8,'2020-08-03',1,2),
(9,'2020-08-07',2,3),
(10,'2020-07-15',1,2);
insert into Products_rec
values
(1,'keyboard',120),
(2,'mouse',80),
(3,'screen',600),
(4,'hard disk',450);
