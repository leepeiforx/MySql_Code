# 1.组合两个表
select * from Person left join Address on Person.PersonId = Address.AddressId;

# 2.选择第二高的薪酬
# 方案1,排序,然后筛选
select id,Salary from (
    select id,Salary,dense_rank() over (order by Salary desc ) as rnk from Employee)as r
where r.rnk = 2;
# 方案2
# 排序(降序),然后limit偏移(这种只适用于salary不包含重复值的情况)
select id,Salary from employee order by Salary desc limit 2 offset 1;

# 3.选择第N高的薪酬
select id,Salary from (
    select id,Salary,dense_rank() over (order by Salary desc ) as rnk from Employee)as r
where r.rnk = 3;

# 4 成绩排名(相同成绩并列,且不跳系列)
# 思路,窗口函数
# 常用排序窗口函数
# .row_number() 排序策略，连续排序，它会为查询出来的每一行记录生成一个序号，依次排序且不会重复
# dense_rank()  排序策略，连续排序，如果有两个同一级别时，接下来是第二级别 ，例如1,2,2,3
# rank() 排序策略， 跳跃排序，如果有两个同一级别时，接下来是第三级别,例如1,2,2,4
select score,dense_rank() over (order by score desc ) as 'rank' from rank_scores;

# 5.连续数字(至少3次)
# 首先用row_number()对id进行排序,(为了防止id字段出现断点)
# 使用partition by num对num分组（也就是num相同的作为一组），然后再用order by对相同的num组里面的id进行排序
select num,count(*) from (
    select
       id,
       num,
       row_number() over (order by Id) - row_number() over (partition by Num order by id)
           as orde from logs)
    as r
group by num, orde
having count(*) > 1;

# 6以获取收入超过他们经理的员工的姓名。
# 思路,按题目要求,用职工表做左连接(managerid=id)其中左侧雇员工资>右侧经理工资的,即为符合条件的记录,选择其中的employee字段即可
select employee from (
select if(ea.salary>ea2.salary,ea.name,null) as employee  from employee_above as ea
left join employee_above as ea2
on ea.managerid = ea2.id
                  )as r
where r.employee is not null;

# 7 查找重复邮箱
select email from find_email
having count(Email)>1;

# 8 从不订购的客户
select name from customer_none
where id not in (select customer_id from orders_none);

# 9 各部门工资最高的员工
# 思路,由内而外首先连接employees 和department两张表,取需要的字段,然后对salary用窗口函数排序(按departmen部门分组),
# 最外层筛选出rnk=1,即最高的部分即可
select Department,Employee,Salary from(
    select
       d.dept_name as Department,
       e.Name as Employee,
       Salary,
       dense_rank() over (partition by d.dept_name order by Salary desc) as rnk
from Employees as e left join department as d
on e.DepartmentId = d.dept_id
) as r
where r.rnk = 1;

# 10,部门前三薪水
# 思路,基本同上,只需要最后筛选是限制rnk<=3即可
select Department,Employee,Salary from(
    select
       d.dept_name as Department,
       e.Name as Employee,
       Salary,
       dense_rank() over (partition by d.dept_name order by Salary desc) as rnk
from Employees as e left join department as d
on e.DepartmentId = d.dept_id
) as r
where r.rnk = 3;

# 11.删除重复邮箱
delete p1 from pemail as p1,pemail as p2
where p1.Email = p2.Email and p1.id > p2.id;
select * from pemail;

# 12 上升的温度
# 考察日期函数的应用
select wt1.id as id from weather as wt1,weather as wt2
where to_days(wt1.recorddate) - to_days(wt2.recorddate) = 1 and wt1.temperature>wt2.temperature;

# 13.非禁止用户的取消率(行程和用户)
# 思路,先找到被禁的用户,过滤到其相关的记录
select request_at,ifnull(round(sum(if(status<>'completed',1,0))/count(*),2),0) as rate
from trips
where client_id not in (select user_id from users where banned is true)
      and request_at between '2013/10/01' and '2013/10/03'
group by request_at;

# 14.游戏玩法分析1
# 写一条 SQL 查询语句获取每位玩家 第一次登陆平台的日期。
# 思路,使用窗口函数,按player_id分组,event_date排序,取rnk=1即可
select
       player_id,
       event_date
from (
     select player_id,
            event_date,
            rank() over (partition by player_id order by event_date) as rnk
     from activity)as s
where s.rnk = 1;

# 15.游戏玩法分析2
# 请编写一个 SQL 查询，描述每一个玩家首次登陆的设备名称
select
       player_id,
       event_date
from (
     select player_id, event_date
            event_date,
            rank() over (partition by player_id order by event_date) as rnk
     from activity)as s
where s.rnk = 1;

# 16 游戏玩法分析3
# 编写一个 SQL 查询，同时报告每组玩家和日期，以及玩家到目前为止玩了多少游戏。
select  player_id,sum(games_played) over (partition by player_id order by event_date) games_played_so_far
from activity;

# 17 游戏玩法分析4
# 计算首日登陆的用户在次日也登陆了且玩了游戏
select s1.event_date as d1 ,count(*) as ct from activity as a1
left join (select
event_date,player_id
from (
    select player_id,event_date,
           rank() over (partition by player_id order by event_date) as rnk
    from activity) as r
where r.rnk = 1)as s1
on a1.player_id = s1.player_id
where games_played <>0 and date_add(s1.event_date,interval 1 day) = a1.event_date
group by a1.event_date;

# 两表合并
select
       first_load_date,
       frist_date_num as install,
       round(ifnull(ct/frist_date_num,0),2) as day1_retention
from (
      select
             event_date as first_load_date ,count(distinct player_id) as frist_date_num
      from (
          select player_id,event_date,
                 rank() over (partition by player_id order by event_date) as rnk
          from activity) as r
      where r.rnk = 1
      group by event_date
    )as l1
left join (
    select s1.event_date as d1 ,count(*) as ct from activity as a1
    left join (select
    event_date,player_id
    from (
        select player_id,event_date,
               rank() over (partition by player_id order by event_date) as rnk
        from activity) as r
    where r.rnk = 1)as s1
    on a1.player_id = s1.player_id
    where games_played <>0 and date_add(s1.event_date,interval 1 day) = a1.event_date
    group by a1.event_date
    )as r1
on l1.first_load_date = r1.d1;

# 18.雇员收入中位数
# 方案1. 利用窗口函数,对salary进行分组排序(正反顺序都要做),如果其中rnk1 = rnk2,则它就是该分组的中位数,
# 对于偶数情况下,则abs(rnk1 - rnk2) = 1,这两个数就是中位数
select id,Company,Salary from (
    select id, company, salary,
           row_number() over (partition by Company order by Salary) as id1,
           row_number() over (partition by Company order by Salary desc) as id2
    from employee_median
    order by Company
    ) as r
where r.id1 = r.id2 or abs(cast(id1 as signed )-cast(id2 as signed)) = 1;

# 19 查询手下员工>=5 的经理姓名
# 思路,首先以managerid统计员工数,having筛选除大于5的 managerid,再利用该ID为条件筛选出姓名
select name from employee_manager
where id in (
    select managerid from employee_manager
    group by  managerid
    having count(*) >=5
    );

# 20 给定数字的频率查询中位数
# 思路1 正逆序在中间的位置
select avg(number) as medium from(
    select
       number,
       sum(frequency) over(order by number) as rnk,
       sum(frequency) over(order by number desc) as drnk,
       sum(frequency) over() as cnt
       from numbers)as r
where rnk>=cnt/2 and drnk>=cnt/2;

# 思路2.
# '中位数的频数一定是会大于等于它上半部分频数总和与下半部分频数总和之差。然后求得中位数频数后再avg一下就可以得到中位数了'
select avg(n.number) median
from numbers as n
where n.frequency >= abs((select sum(frequency) from numbers where number<=n.number) -
                         (select sum(frequency) from numbers where number>=n.number));
# 思路3,直接用pandas来求

# 21 当选者,选举获胜
# 思路,首先按被选举人得票情况统计,筛出得票最多的人的id,在按照id筛选出姓名,
# 考虑到多人得票相同的情况,可以用窗口函数按ct排个序,在外层按rnk=1获取id,其他相同
select name from candidate where id in (
    select candidateid as ct from vote
    group by candidateid
    order by count(*) desc limit 1
    );

# 22.员工奖金(查看员工奖金<2000的记录)
# 思路,左连接,然后筛选bonus<2000的记录,注意条件为空的,要多加一个is null的条件
select name,bonus from employee_bonus
left join bonus b on employee_bonus.empid = b.empid
where bonus <2000 or bonus is null ;

# 23 查看回答率最高的记录
# 首先求回答率,然后作为嵌套查询找到question_id,最后分组找到比例最高的那个
select
    question_id
from
     (select question_id,
             ifnull(round(sum(if(action='answer',1,0))/sum(if(action='show',1,0))*100,2),0) as answer_rate
     from survey_log
     group by question_id) as r1
group by question_id
having max(answer_rate);

# 24 查询员工的累计薪水
# 分组计算累加(不包括最近的一个月)
# 思路,窗口函数+where条件筛选
select id,month,sum(salary) over (partition by id order by month) as salary from employee_cumulative
where month <> (select max(month) from employee_cumulative)
order by id, month desc;

# 25 统计各专业学生数量
# 思路,为了保证所有科目均显示,所以用课程表左连接学生选课表
select dept_name, count(student_id) as ct from department
left join student_d sd on department.dept_id = sd.dept_id
group by dept_name;

# 26 寻找用户推荐人
# 返回一个编号列表，列表中编号的推荐人的编号都不是2
# 注意referee_id<>2是会排除掉为空的部分,所以要单独拿出来再写一个is null的条件
select name from referee
where referee_id <> 2 or referee_id is null;

# 27.2016年的投资
# 写一个查询语句，将 2016 年 的(TIV_2016) 所有成功投资的金额加起来，保留 2 位小数。
# 思路,先找到满足符合的id,在相加
# 条件
    # 1. 他在 2015 年的投保额 (TIV_2015) 至少跟一个其他投保人在 2015 年的投保额相同
    # 2. 他所在城市的经纬度是独一无二的。
# 1,投保额相同
# 注,这两个条件之间存在交集,所以不能直接通过嵌套搞定,所以最好是分开写两个条件,最后取交集(这里经纬度的条件取反,所以最后是求差集)
select pid from insurance where pid not in (
    select pid  from insurance
    group by tiv_2015
    having count(*) = 1
    );
# 2,经纬度相同
select i1.pid from insurance as i1,insurance as i2
where i1.lat = i2.lat and i1.lon = i2.lon and i1.pid <> i2.pid;

# 3.两者取差集
select sum(tiv_2016) from insurance
where pid not in (
    select i1.pid from insurance as i1,insurance as i2
    where i1.lat = i2.lat and i1.lon = i2.lon and i1.pid <> i2.pid
    ) and pid in(select pid from insurance where pid not in (
    select pid  from insurance
    group by tiv_2015
    having count(*) = 1
));
# 窗口函数
select round(sum(TIV_2016), 2) TIV_2016
from
(
    select
        *,
        count(*) over(partition by TIV_2015) as cnt1,
        count(*) over(partition by LAT, LON) as cnt2
    from
        insurance
) t
where t.cnt1 > 1 and t.cnt2 <= 1;

# 28.订单最多的客户
# .在表 orders 中找到订单数最多客户对应的 customer_number
# 注 考察分类汇总求最值问题,思路1,按照统计项排序,随后取limit 1
# 如果同时存在相同的最值,则考虑使用嵌套
# (直接取分组最大值比较麻烦,这里取巧给计数值直接用窗口函数做出rank,按照降序排列,最后只需要rnk=1即可
select customer_number from orders_max
group by customer_number
order by count(*) desc limit 1;

select customer_number from (
    select customer_number,dense_rank() over (order by count(*) desc)as rnk
    from orders_max
    group by customer_number
    )as r
where r.rnk = 1;

# 29.大国
# 考察where 和 and,or的配合使用
select name,population,area from world
WHERE area > 3000000 OR population > 25000000;

# 30.列出所有超过或等于5名学生的课。
# 考察group by 和 having的组合使用
select class from class_studnet
group by class
having count(*) >=5;

# 31.好友申请 I ：总体通过率
# 思路,实际就是算request_accepted表中的计数(非重复数量)和friend_request(非重复)计数的比值
select
       ifnull(round(count(distinct requester_id,accepter_id)/count(distinct sender_id,send_to_id),2),0) as accept_rate
from friend_request,request_accepted;

# 考虑如何计算 每月的申请通过率,
# 思路:按月分开计算申请数和达成数,然后合并求比例
select left(accpet_date, 7) as accept_date, count(distinct requester_id,accepter_id) from request_accepted;
select left(request_date,7) as request_month , count(distinct sender_id,send_to_id) from friend_request;
select accept_month,ifnull(round(accepted_num/request_num,2),0) as rate
from
     (select left(request_date,7) as request_month , count(distinct sender_id,send_to_id) request_num
     from friend_request) as l1
left join (
    select left(accpet_date, 7) as accept_month, count(distinct requester_id,accepter_id) accepted_num
    from request_accepted)as r1
on l1.request_month = r1.accept_month;

# 按日计算的类似,相当于计算当天通过的请求率 (这里按请求日计算)
select l1.request_date, ifnull(round(accepted_num/request_num,2)*100,0)  as 'rate(%)'
from
     (select request_date , count(distinct sender_id,send_to_id) request_num
     from friend_request group by request_date) as l1
left join  (
    select accpet_date , count(distinct requester_id,accepter_id) accepted_num
    from request_accepted group by accpet_date )as r1
on l1.request_date = r1.accpet_date;

# 32.体育馆的人流量
# 请编写一个查询语句，找出人流量的高峰期。高峰期时，至少连续三行记录中的人流量不少于100
# 思路,题目说明id随日期增长而延伸,为了以防万一,还是用日期来计算连续三行(就是连续三天)
# 还有题设并未说明是从上往下,还是从下往上,所以两种情况都要考虑进去,还是从中间往两边计算
select s1.* from stadium as s1,stadium as s2 ,stadium as s3
# 从上往下数
where ((datediff(s1.visit_date,s2.visit_date)=1 and datediff(s1.visit_date,s3.visit_date) = 2)
# 从中间往两边算
or( datediff(s2.visit_date,s1.visit_date)=1 and datediff(s3.visit_date,s2.visit_date) = 1)
# 从下往上数
or (datediff(s3.visit_date,s2.visit_date)=1 and datediff(s2.visit_date,s1.visit_date) = 1))
and s1.people>=100 and s2.people>=100 and s3.people>=100
order by s1.visit_date;

# 33.好友申请 II ：谁有最多的好友（union all）
# 写一个查询语句，求出谁拥有最多的好友和他拥有的好友数目。
# 思路,因为该表实际上就是已经结成朋友的关表,所以一对请求接受就是一对朋友,所以把两个字段合并起来,然后计数就可以算出朋友最多的id
select
id,count(*) as num
from (
    select requester_id as id from request_accpeted_most
    union all
    select accepter_id as id from request_accpeted_most
    )as r
group by id
order by num desc limit 1;

# 考虑到可能最大值为多个人的可能性,以上脚本可以进一步优化(利用窗口函数,对计数项排名,最后取第一即可)

select
    id,
    num
from (
    select
    id,
    count(*) as num,
    dense_rank() over (order by count(*) desc) as rnk
from (
    select requester_id as id from request_accpeted_most
    union all
    select accepter_id as id from request_accpeted_most
    )as r
group by id
)as s
where s.rnk = 1;

# 34.连续空余座位
# 思路,cinema 表自连接,判断连续条件1是id前后相差1;2,其后续状态应该是一致的,即都为0或都为1
select distinct c1.seat_id from cinema as c1,cinema as c2
where abs(c1.seat_id - c2.seat_id)= 1
and c1.free = c2.free
order by  c1.seat_id;

# 35.输出所有表 salesperson 中，没有向公司 'RED' 销售任何东西的销售员。
# 思路,找到'RED'公司的com_id,筛选出出售产品的sale_id,最后用这些sale_id取反来筛选出销售员
select * from salesperson
where sales_id not in (
    select sales_id from orders_sales where com_id in (
        select com_id from company where name ='RED'));

# 36,树节点
# 思路,p_id 为空的几位根节点,如果其id在p_id中,(排除为null的)则为inner节点,其他的则为leaf节点
# 考察if的用法
select id,if(isnull(p_id),'root',if(id in (select p_id from tree),'inner','leaf')) as 'type' from tree;

#37.判断三角形
# 三角形构成条件,任意两边之和<=第三边
# 考察case when的应用
select x,y,z,
       if(x+y<=z or x+z<=y or y+z<=x ,'yes','no') as triangle
from triangle;

# 38.平面上的最近距离
# 考察mysql里面的内置函数使用
select min(round(sqrt(power(p1.x-p2.x,2)+power(p1.y-p2.y,2)),2)) as distance from point_2d as p1,point_2d as p2
where p1.x <> p2.x and p1.y <> p2.y;

# 39.直线上的最近距离
select min(abs(p1.x-p2.x)) as shortest_distance from point as p1, point as p2
where p1.x <> p2.x;

# 40.二级关注者
# 请写一个 sql 查询语句，对每一个关注者，查询关注他的关注者的数目
# 思路,就是计算在关注者列表里面的被关注者的关注者数量
select followee as follower ,count(*) as ct from follow
where followee in (select follower from follow)
group by followee
order by ct;

# 41.平均工资：部门与公司比较
# 思路构造1.分组平均值表.2各月品均值表,3.这两个表关联,
# 1.分组平均值表
select
       left(pay_date,7) as pay_month,
       department_id,
       avg(amount) as avg_a
from salary_avg as sa, employee_avg as ea
where sa.employee_id = ea.employee_id
group by pay_month,department_id;

# 2.salary&employee合并后的分组求和表
select left(pay_date,7) as pay_month,avg(amount) from salary_avg
group by pay_month;

# 两表合并
select
       l1.pay_month,
       l1.department_id,
       case when avg_d_m > avg_m then 'higher'
            when avg_d_m < avg_m then 'lower'
            else 'same' end as 'comparison'
from (
    select
       left(pay_date,7) as pay_month,
       department_id,
       avg(amount) as avg_d_m
    from salary_avg as sa, employee_avg as ea
    where sa.employee_id = ea.employee_id
    group by pay_month,department_id) as l1
left join (
    select left(pay_date,7) as pay_month,avg(amount) avg_m from salary_avg
    group by pay_month)as r1
on l1.pay_month = r1.pay_month
order by l1.pay_month;

# 窗口函数
select distinct pay_month, department_id,
       case when dep_avg > total_avg then 'higher'
            when dep_avg = total_avg then 'same'
            else 'lower' end as comparison
from
(
  # 平均部门工资, 公司平均工资
    select department_id,
           avg(amount) over(partition by department_id, date_format(pay_date, '%Y-%m')) dep_avg,
           date_format(pay_date, '%Y/%m') pay_month,
           avg(amount) over(partition by date_format(pay_date, '%Y/%m')) total_avg
    from salary_avg s left join employee_avg
    using(employee_id)
) t;

# 42.学生地理信息报告（row_number）
# .写一个查询语句实现对大洲（continent）列的 透视表
select
       max(case when continent='America' then name end) as 'America',
       max(case when continent='Asia' then name end) as 'Asia',
       max(case when continent='Europe' then name end) as 'Europe'
from
(
    select row_number() over(partition by continent order by name) as id, name, continent
    from student_geo)t group by id;

# 方案2
select America, Asia, Europe
from
(
    select name America, row_number() over(order by name) rnk
    from student_geo
    where continent='America'
) a
left join
(
    select name Asia, row_number() over(order by name) rnk
    from student_geo
    where continent='Asia'
) b
using(rnk)
left join
(
    select name Europe, row_number() over(order by name) rnk
    from student_geo
    where continent='Europe'
) c
using(rnk);

# 43.只出现一次的最大数字
# 思路,嵌套查询,首先找到出现次数为一的数值,然后取其中最大的部分
select
       max(num) as num
from (
    select num from my_number
    group by num
    having count(*) = 1)as s;

# 44.有趣的电影
# 找出所有影片描述为非 boring (不无聊) 的并且 id 为奇数 的影片，结果请按等级 rating 排列
select * from movies
where id%2 <> 0 and description <>'boring'
order by rating desc;

# 45.换座位
# 思路,修改ID字段,如果id为偶数,则对应-1,如果是奇数且=MAX(id)则保持不变,其余奇数id对应+1,
# 其他同正常操作,最后再按照id排序即可.
select
    case
        when Id%2=0 then id -1
        when Id%2<>0 and Id = (select max(Id) from seat) THEN Id
        ELSE Id+1
    end as id,
    Student
from seat
order by id;

# 46.交换工资
# .只使用一个更新（Update）语句，并且没有中间的临时表(更新男女)
select * from swap_salary;
update swap_salary set sex = if(sex='f','m','f');
select * from swap_salary;

# 47.买下所有产品的客户
# 从 Customer 表中查询购买了 Product 表中所有产品的客户的 id。
# 思路,购买所有产品意味着Customer中按照用户id分组的话,count(distinct product_key) =
select customer_id from customer_all
group by customer_id
having count(distinct product_key) = (select count(distinct product_key) from Product_all);

# 19,雇员收入>其经理收入的记录
# 思路,表格自连接,用manageid连接id,判别两边的salary,取出符合条件的雇员姓名
select e.name as employee from employees_earning as e
left join employees_earning as m
on e.managerid = m.id
where e.salary > m.salary;

# 48.合作过至少三次的演员和导演
# 写一条SQL查询语句获取合作过至少三次的演员和导演的 id 对 (actor_id, director_id)
# 思路,将actor_id, director_id更改为char类型,然后做文本合并,作为计数项
# 考察,concat文本合并,cast字段数据类型转换
select actor_id,director_id
from ActorDirector
group by actor_id, director_id
having count(concat(cast(actor_id as CHAR),cast(director_id as char))) >=3;

# 49.产品销售分析 I
# 查询语句获取产品表 Product 中所有的 产品名称 product name 以及 该产品在 Sales 表中相对应的 上市年份 year 和 价格 price。
select product_name,year,price
from sales_year as s
    left join product_year py
        on py.product_id = s.product_id;

# 50.产品销售分析 II
# 编写一个 SQL 查询，按产品 id product_id 来统计每个产品的销售总量。
select product_id,sum(quantity) from sales_year
group by product_id;

# 51.产品销售分析 III（group by 陷阱）
# 编写一个 SQL 查询，选出每个销售产品的 第一年 的 产品 id、年份、数量 和 价格
select
       product_id,
       first_year,
       quantity,
       price
from (
    select
           product_id,
           year as first_year,
           quantity,
           price,
           rank() over (partition by product_id order by year) as rnk from sales_year) as s
where s.rnk = 1;

# 52.项目员工 I
# 查询每一个项目中员工的平均工作年限，精确到小数点后两位。
select project_id,round(avg(experience_year),2) as avg_years from project_workyear
left join employee_workyear ew on ew.employee_id = project_workyear.employee_id
group by project_id;

# 53.项目员工II
# 编写一个SQL查询，报告所有雇员最多的项目。
select
       project_id
from (
    select project_id,rank() over (order by count(*) desc) as rnk from project_workyear
    left join employee_workyear ew on ew.employee_id = project_workyear.employee_id
    group by project_id)as s
where s.rnk = 1;

# 54.项目员工 III
# 报告在每一个项目中经验最丰富的雇员是谁。(同样的并列出来)
# 为了方便看出结果,所以更新数据
update employee_workyear set experience_year = 3 where name='John';

select project_id,employee_id from(
             select project_id,ew.employee_id,rank() over (partition by project_id order by experience_year desc ) as rnk
from project_workyear as p left join employee_workyear ew on ew.employee_id = p.employee_id
                 )as r
where r.rnk =1 ;

# 55.销售分析 I
# 编写一个SQL查询，查询总销售额最高的销售者，如果有并列的，就都展示出来
SELECT seller_id FROM
(
    select seller_id,rank() over (ORDER BY SUM(price) desc) as rnk from salesmax
    GROUP BY seller_id
    )as s
where s.rnk = 1;

# 56.销售分析 II
# 编写一个 SQL 查询，查询购买了 S8 手机却没有购买 iPhone 的买家。注意这里 S8 和 iPhone 是 Product 表中的产品
# 思路:分开查询,然后取交集,从购买s8的客户里面找到没买iPhone的即可
select buyer_id from (
    select buyer_id from salesmax left join product_salemax ps on salesmax.product_id = ps.product_id
    WHERE product_name = 'S8') as s1
where buyer_id in (select buyer_id from salesmax left join product_salemax ps on salesmax.product_id = ps.product_id
WHERE product_name <> 'iPhone');

# 57.销售分析III
# 编写一个SQL查询，报告2019年春季才售出的产品。即仅在2019-01-01至2019-03-31（含）之间出售的商品。
# 注意题目,要求只在春季发售,如果在其他时间发售的则要去除,所以要使用groupby分组,找到最迟发售和最早发售都在春季的记录
select ps.product_id,product_name from salesmax
left join product_salemax ps on salesmax.product_id = ps.product_id
group by ps.product_id, product_name
having(max(sale_date) between '2019-01-01' and '2019-03-01' )
   and(min(sale_date)  between '2019-01-01' and '2019-03-01');

# 58.游戏玩法分析 V
# 编写一个 SQL 查询，报告每个安装日期、当天安装游戏的玩家数量和第一天的保留时间
# 将某个日期 X 的第 1 天保留时间定义为安装日期为 X 的玩家的数量，他们在 X 之后的一天重新登录，除以安装日期为 X 的玩家的数量
# 首日登陆
select
event_date as first_load_date ,count(distinct player_id) as frist_date_num
from (
    select player_id,event_date,
           rank() over (partition by player_id order by event_date) as rnk
    from activity) as r
where r.rnk = 1
group by event_date ;

# 59.小众书籍
# 筛选出过去一年中订单总量 少于10本 的 书籍
# 不考虑 上架（available from）距今 不满一个月 的书籍。并且 假设今天是 2019-06-23 。
# 思路,该题无法用首先求出<10的书籍记录和书籍清单关联,因为<10排除掉的记录和书籍清单关联时(left join)左侧为空的部分无法说明时因为>10还是
# 没有订购记录,所以最好的办法是将两表直接关联,然后按条件筛除掉不符合的记录
select distinct b.book_id,b.name from books as b
left join orders_book ob on b.book_id = ob.book_id
where available_from < '2019-06-23' - interval 1 month
group by b.book_id,year(dispatch_date)
having sum(quantity) < 10 or sum(quantity) is null;

# 60.每日新用户统计
# SQL 查询从今天起最多 90 天内，每个日期该日期首次登录的用户数。假设今天是 2019-06-30.
# 思路,先计算首次登陆,然后再卡登陆日期;不能先筛选90天内的记录,因为这里面可能存在同时在3.30号之前和之内都登陆的记录
# 这样的话,在随后的计算中也会将其计算在首次登陆中,同定义不符,所以应该先统计首次登陆,在卡登陆日期.
select activity_date,
       count(*)
from (
    select activity_date,user_id,
           rank() over (partition by user_id order by activity_date) as rnk from traffic
    where activity ='login')as r
where r.rnk = 1 and (activity_date between '2019-06-30' - interval 90 day  and '2019-06-30')
group by activity_date;

# 先计算登陆日期的结果(X)
select
       activity_date,user_id,
       rank() over (partition by user_id order by activity_date) as rnk
from traffic
where activity_date between '2019-06-30' - interval 90 day  and '2019-06-30';

# 61.每位学生的最高成绩
#查询每位学生获得的最高成绩和它所对应的科目，若科目成绩并列，取 course_id 最小的一门。查询结果需按 student_id 增序进行排序
# 思路,考察窗口函数排序,第一步按照student_id分组,然后按成绩降序排序,找到各个学生得分最高的记录,然后取它min(course_id)的部分
select student_id,min(course_id),grade from (
              select
                     student_id,course_id,grade,
                     rank() over (partition by student_id order by grade desc ) as rnk
              from enrollments
                )as r
where r.rnk = 1
group by student_id
order by student_id;

# 62.报告的记录
# 查询每种 报告理由（report reason）在昨天的报告数量。假设今天是 2019-07-05。
# 思路,考察日期函数的使用,
select extra,count(distinct user_id) from actions_report
where action_date = '2019/7/5'-interval 1 day and extra is not null
group by extra;

# 63.查询活跃业务
# 来查询所有活跃的业务
# 如果一个业务的某个事件类型的发生次数大于此事件类型在所有业务中的平均发生次数，
# 并且该业务至少有两个这样的事件类型，那么该业务就可被看做是活跃业务
# 思路,首先制作分类均值的r表,随后用activity_report和r表左连接,
# 再用business_id进行分类计数,再用having卡计数项>=2即可
select business_id from activity_report as ar
left join (select event_type,avg(occurences) as avg_o from activity_report
group by event_type) as r
on ar.event_type = r.event_type
where ar.occurences > r.avg_o
group by business_id
having count(ar.event_type) >=2;

# 64.用户购买平台 *
# 查找每天仅使用手机端用户、仅 使用桌面端用户和 同时 使用桌面端和手机端的用户人数和总支出金额
# 思路,根据题意,如果是仅使用某一项客户端的话,那么按照日期和用户分组统计他的platform应该计数=1,根据该条件可以
# 求出他的sum(amount) 和count(user_id),但是这样的话,会缺省没有记录值的部分,
# 所以要构造一个temp表(里面包含所有的spend_date和platfrom信息)然后和之前求出表做关联(left join)
# 设置值为null的部分为0即可

select spend_date,
       if(count(distinct platform)=1,platform,'both') as platform,
       sum(amount),
       COUNT(user_id) from spending
group by spend_date, user_id;

select
       l.spend_date,
       l.platform,
       ifnull(r.total_amount,0),
       ifnull(r.total_users,0)
from (select
    distinct spend_date,
    b.platform
from spending as s ,
     (select 'desktop' as platform
     union
     select 'mobile' as platform
     union
     select 'both' as platform)as b) as l
left join (
    select
           spend_date,
           if(count(distinct platform)=1,platform,'both') as platform,
           sum(amount)as total_amount,
           COUNT(user_id) as total_users from spending
group by spend_date, user_id)as r
on l.spend_date =r.spend_date and l.platform = r.platform;

# 65.报告的记录 II
# 在被报告为垃圾广告的帖子中，被移除的帖子的每日平均占比，四舍五入到小数点后 2 位。
# 思路,首先关联ad_action和removal表,随后按照extram='spam'按照帖子日期分组统计垃圾帖子数和删帖数,求商,然后再最外层求平均值
select
       round(avg(ct)*100,2) as average_daily_percent
from (
    select
           count(r.post_id)/count(l.post_id) as ct
    from (
        select action_date,post_id from ad_actions where extra='spam')as l
        left join removals as r
            on l.post_id = r.post_id
    group by l.action_date)as r1;

# 66.查询近30天活跃用户数
#查询出截至 2019-07-27（包含2019-07-27），近 30天的每日活跃用户数（当天只要有一条活动记录，即为活跃用户）
# mysql的between包含边缘值(即为闭区间)
select activity_date,count(distinct user_id) from activity_users
where activity_date between '2019/07/27'-interval 30 day  and '2019/07/27'
group by activity_date;

# 67.过去30天的用户活动 II
# 查找截至2019年7月27日（含）的30天内每个用户的平均会话数
# 一个完整的回话包含open~end
# 思路,一个完整回话应该是一个用户id对应一个回话id完成三个状态,所以按照user_id,session_id分组计数(activity_type)=3,
# 求出每个用户id后包含实现完整回话的会话id数,最后在对计数项求和,除以用户数求均值
select
       sum(ct)/count(distinct user_id) as average_sessions_per_user
from (
    select
           user_id,
           count(distinct session_id) as ct
    from(select user_id,session_id,COUNT(distinct activity_type) as ct from activity_users
    group by user_id,session_id
    having ct =3)as r
group by user_id)as r1;

# 68.文章浏览 I
#  查询以找出所有浏览过自己文章的作者，结果按照 id 升序排列

select distinct v1.author_id as id from mydb.views as v1, mydb.views as v2
where v1.author_id = v2.viewer_id
order by id;

# 69.文章浏览 II
# 查询来找出在同一天阅读至少两篇文章的人，结果按照 id 升序排序。
select viewer_id as id from mydb.views
group by viewer_id
having COUNT(distinct article_id) >= 2;

# 70.市场分析 I
# 查询每个用户的注册日期和在 2019 年作为买家的订单总数
# 考察where筛选的位置,以及null的处理
select u.user_id as buyer_id ,join_date,count(order_id) as ord_in_2019 from user_registers as u
left join (select * from orders_info where year(order_date) = 2019) as r
on u.user_id = r.buyer_id
group by r.buyer_id, join_date;


# 71.市场分析 II
# 查找在 2019-08-16 时全部产品的价格，假设所有产品在修改前的价格都是 10。2
# 思路,首先筛选出<2019-8-16的记录,随后根据datediff(product_id,2019-8-16)和分组取最小值即可
# 同时,因为该表中保存的是修改后的数据,所以如果其他数据没有被修改,则不会出现在该表中,所以需要构造一个temp表保存所有product_id,然后left join
# 为空的部分用10填充

select distinct p1.product_id,ifnull(r2.new_price ,10) from product_price as p1
left join (
    select product_id,new_price
from (
    select
    product_id,new_price,rank() over (partition by product_id order by abs(datediff(change_date,'2019/8/16'))) as rnk
    from product_price
    where change_date <='2019/8/16')as r
    where r.rnk = 1
    )as r2
on p1.product_id = r2.product_id;

# 72.指定日期的产品价格 *
# 查询确定每一个用户按日期顺序卖出的第二件商品的品牌是否是他们最喜爱的品牌。如果一个用户卖出少于两件商品，查询的结果是 no
# 将三张表关联起来,用窗口函数得到每个卖家第二天所卖的产品id和品牌,关联user_favorite表得到用户最喜欢的品牌表,使用
# where rnk =2 得到每个卖家第二天所卖的产品信息和最喜欢的品牌信息,如果两者相同,则保留
# 为保证得到所有卖家信息(无论是否出售产品,所以需要用user_favorite表构造卖家表,
select user_id as seller_id,
       if(user_id in (select seller_id from (select seller_id,order_date,item_brand,favorite_brand,
       rank() over (partition by seller_id order by order_date) as rnk from order_favorite
           left join item i on order_favorite.item_id = i.item_id
           left join user_favorite uf on uf.user_id = order_favorite.seller_id)as r
       where r.rnk = 2 and item_brand = favorite_brand),'yes','no')as 2nd_item_fav_brand
from user_favorite;

# 73.即时食物配送 I
# .查询语句获取即时订单所占的比例， 保留两位小数
# 备注,count内的if(条件,结果1,结果2)不要设置成1,0,因为count也会计算0的数量,所以设置成Null,
# 考察count和if的嵌套使用
select round(COUNT(if(order_date=cumtoer_per_deliver_date,1,null))/count(delivery_id)*100,2) as immediate_percentage
from delivery;

# 74.即时食物配送 II
# 查询语句获取即时订单在所有用户的首次订单中的比例。保留两位小数。
# 基本同上面类似,不过首先要利用窗口函数筛选出所有的首批订单,然后在利用count+if计算出即时订单
select round(COUNT(if(order_date=cumtoer_per_deliver_date,1,null))/count(delivery_id)*100,2) as immediate_percentage
from (select order_date,cumtoer_per_deliver_date,delivery_id,customer_id,
       rank() over (partition by customer_id order by order_date)as rnk from delivery) as r
where r.rnk = 1;

# 75.重新格式化部门表
# 写一个 SQL 查询来重新格式化表，使得新的表中有一个部门 id 列和一些对应 每个月 的收入（revenue）列
# 行转列
# 思路,笨办法,用sumif非别构造每个字段
select id,
       sum(if(month='Jan',revenue,null)) as Jan_revenue,
       sum(if(month='Feb',revenue,null)) as Feb_revenue,
       sum(if(month='Mar',revenue,null)) as Mar_revenue,
       sum(if(month='Apr',revenue,null)) as Apr_revenue,
       sum(if(month='May',revenue,null)) as May_revenue,
       sum(if(month='Jun',revenue,null)) as Jun_revenue,
       sum(if(month='Jul',revenue,null)) as Jul_revenue,
       sum(if(month='Aug',revenue,null)) as Aug_revenue,
       sum(if(month='Sep',revenue,null)) as Sep_revenue,
       sum(if(month='Oct',revenue,null)) as Oct_revenue,
       sum(if(month='Nov',revenue,null)) as Nov_revenue,
       sum(if(month='Dec',revenue,null)) as Dec_revenue
       from department_revenue
group by id;


# 76.每月交易 I（date_format）
# 编写一个 sql 查询来查找每个月和每个国家/地区的事务数及其总金额、已批准的事务数及其总金额。
# 考察日期函数date_format,以及sum+if,count+if的使用
select date_format(trans_date,'%Y-%m') as mon ,
       country,
       sum(amount) as total_amount ,
       sum(if(state='approved',amount,0)) as approved_total,
       count(id) as ct,
       count(if(state='approved',1,null)) as approved_ct from transactions
group by mon,country;

# 77.锦标赛优胜者
# 查询来查找每组中的获胜者。如果平局，player_id 最小 的选手获胜。
# 思路,首先将playes和matches表连接,使用if或case when找到获胜者和得分,
# 然后按照,利用窗口函数对group_id分组,按得分排序,找出
# 找出头名
# noinspection SqlRedundantOrderingDirection

select group_id,winner
from (
    select
           group_id,
           if(first_score>=second_score,first_player,second_player) as winner,
           rank() over (partition by group_id order by
               if(first_score>=second_score,first_score,second_score) desc ,
               if(first_score>=second_score,first_player,second_player) asc) as rnk
    from matches as m
        left join players as p
            on m.first_player = p.player_id
         )as r
where r.rnk = 1;

# 78.最后一个能进入电梯的人（累加/变量/窗口函数）
# 语句查找最后一个能进入电梯且不超过重量限制的 person_name 。题目确保队列中第一位的人可以进入电梯 。
# 考察sum+over做累计求和,然后找到<=1000的记录,倒序排列找到最接近1000的记录即可
select person_name from
(select person_name,sum(weight) over(order by turn) as sum_weight from queue)as r
where r.sum_weight <= 1000
order by sum_weight desc limit 1;

# 79.每月交易II（union all）*
# 找每个月和每个国家/地区的已批准交易的数量及其总金额、退单的数量及其总金额
# 分成两部分统计,一部分是approved部分,一部分是退单数据,两个表按month合并
# 问题,怎么删除空行.
select * from (
              select l.mon,
      ifnull(r.approved_amount,0),
      ifnull(r.approved_count,0),
       l.chargeback_amount,
       l.chargeback_count
from (select date_format(charge_date,'%Y-%m') as mon,
       country,
       sum(if(c.charge_date is not null ,amount,0)) as chargeback_amount,
       count(if(c.charge_date is not null ,1, null)) as chargeback_count
       from transactions_a as ta left join chargebacks as c
           on ta.id = c.trans_id
group by mon,country) as l
left join (
    select date_format(trans_date,'%Y-%m') as mon,
       country,
       sum(if(state='approved',amount,0)) as approved_amount,
       count(if(state='approved',1,null)) as approved_count
       from transactions_a
group by mon,country
)as r
on l.mon = r.mon) as t
where t.mon is not null;



# 80.查询结果的质量和占比
# 评分小于 3 的查询结果占全部查询结果的百分比。
# 考察sql函数,count+if
select query_name,
       round(avg((rating/position)),2) as quality,
       round(count(if(rating<3,1,null))/count(*)*100,2) as poor_query_percentage
from queries
group by query_name;

# 81.查询球队积分
# 查询每个队的 team_id，team_name 和 num_points。
# 结果根据 num_points 降序排序，如果有两队积分相同，那么这两队按 team_id  升序排序。/
# 思路,按照胜负平三种情况统计两种表(胜负一种,平局因为双方各得一分,所以单独为一张表()

select
       team_id,
       team_name,
       ifnull(goals,0) as goals from teams as t
left join (
    select winner as players,sum(winner_goals) as goals from
    (
    select
    if(host_goals>guest_goals,host_team,if(host_goals<guest_goals,guest_team,null)) as winner,
    3 as 'winner_goals'
    from matches_a
    union all
    select equal_team,equal_goal from
    (
    select if(host_goals=guest_goals,host_team,null) as equal_team,1 as equal_goal from matches_a
    union
    select if(host_goals=guest_goals,guest_team,null) as equal_team,1 as equal_goal from matches_a
    )as r
    )as r1
    where r1.winner is not null
    group by players
)as r2
on t.team_id = r2.players
order by goals desc ,team_id;

# 82.报告系统状态的连续日期（date_sub + over）
# 查询 2019-01-01 到 2019-12-31 期间任务连续同状态 period_state 的起止日期（start_date 和 end_date）。
# 即如果任务失败了，就是失败状态的起止日期，如果任务成功了，就是成功状态的起止日期

# 先计算出各个状态下的连续天数
# 然后按照分类和cls(统计连续天数)字段分类汇总数据,取日期的最值(记得having筛选掉只有1天的记录)
select type as period_state,min(date) as start_date,max(date) as end_date from
(select date,type,datediff(date,'2018/01/01')- rank() over (partition by type order by date) as cls from
(select fail_date as date,'failure' as type from failed
union all
select success_date as date,'succeed'as type from succeeded) as l)as l2
group by type,cls
having count(*) > 1;

# 83.每个帖子的评论数
# 编写 SQL 语句以查找每个帖子的评论数。
# 思路,首先找到所有的帖子,然后和构造的每个内容id的评论数相关联
select distinct s.sub_id as post_id,ifnull(ct,0) as number_of_comments
from submissions as s
left join (
    select parent_id as sub_id ,count(distinct sub_id) as ct from submissions
    where parent_id is not null
    group by parent_id)as r
on s.sub_id = r.sub_id
where parent_id is null;

# 84.平均售价
# SQL查询以查找每种产品的平均售价
# 思路,两表联立,然后卡订购时间,最后在使用统计函数
select u.product_id,round(sum(price*units)/sum(units),2) as average_price from unitssold as u
left join prices_avg pa on u.product_id = pa.product_id
where purchase_date between start_date and end_date
group by u.product_id;

# 85.页面推荐（union）
# 写一段SQL向user_id = 1 的用户，推荐其朋友们喜欢的页面。不要推荐该用户已经喜欢的页面
# 思路,先筛选出user_id= 1的用户的朋友id,在通过朋友id找到他们喜欢的page_id再和user_id=1喜欢的id取差集
# 注,因为friendship表中每一行都代表一对朋友关系,所以要考虑到user_1,user_2 =1的情况,同时,根据题目要求,需要把user_id=1本身喜欢
# 的page_id剔除出去

select distinct page_id as recommended_page from likes
where uer_id in (select * from
    (
    select if(user1_id=1,user2_id,if(user2_id=1,user1_id,NULL)) as id from friendship
    )as l1
    where l1.id is not null) and page_id not in (select distinct page_id from likes where uer_id = 1)
order by recommended_page;

# 86.向公司CEO汇报工作的所有人
# SQL 查询出所有直接或间接向公司 CEO 汇报工作的职工的 employee_id 。
# 思路,分级求汇报给CEO的employee_id然后union all
# 考察多层嵌套查询


select employee_id from (
#     1级别
    select employee_id from employees_report where manage_id = 1 and employee_id <> 1
union all
#     2级别
    select employee_id from employees_report
    where manage_id in (select employee_id
    from employees_report where manage_id = 1 and employee_id <> 1)
union all
# 3级别
    select employee_id from employees_report
    where manage_id in (select employee_id from employees_report
    where manage_id in (select employee_id
    from employees_report where manage_id = 1 and employee_id <> 1))
) as r;


# 87.学生们参加各科测试的次数
# 查询出每个学生参加每一门科目测试的次数，结果按 student_id 和 subject_name 排序。
# 考察笛卡尔积
# Write your MySQL query statement below
select
       l.student_id,l.subject_name,l.subject_name,
       ifnull(ct,0) as attended_exams
from (select * from students_a as st cross join subjects) as l
left join
    (select student_id,subject_name,count(*) as ct from examinations
    group by student_id, subject_name) as r
on l.student_id= r.student_id and l.subject_name = r.subject_name;

select * from students_a;
select * from subjects;
select * from students_a as st cross join subjects;

# 88.找到连续区间的开始和结束数字（dense_rank连续排名）
# 查询得到 Logs 表中的连续区间的开始数字和结束数字。
# 思路,首先利用窗口函数构造出各个连续区间,然后按照窗口函数,分组从而找出各个组间的最值,即为各个连续区间的开始,结束值
select min(log_id) as start_id,max(log_id) as end_id
from(select log_id,log_id - rank() over (order by log_id) as rnk from logs_a
)as r
group by rnk;

# 89.不同国家的天气类型
# 找到表中每个国家在 2019 年 11 月的天气类型。
# 考察if和SQL统计函数的使用,首先按照要求求出各country_id的天气类型,然后和countries连接,对应国家名称
select c.country_name,l.weather_type from (
    select country_id,
           if(avg(weather_state)>=25,'Hot',if(avg(weather_state)>15,'Warm','Cold')) as  weather_type
    from weather_c
    where month(day) = 11
    group by country_id) as l
left join countries as c
on l.country_id = c.country_id;

# 90.求团队人数
# 求得每个员工所在团队的总人数。
# 思路,首先构造出每个团队的人数temp表,然后和雇员表关联即可
select et.employee_id,ct as team_size from employee_total as et
left join (
    select team_id,count(*) as ct from employee_total group by team_id)as r
on et.team_id = r.team_id;

# 91.不同性别每日分数总计（累加/变量/窗口函数）
# 查询每种性别在每一天的总分，并按性别和日期对查询结果排序
# 考察sum+窗口函数实现分组累计求和
select gender,day,sum(score_points) over (partition by gender order by day) as total from score_bysex;

# 92.餐馆营业额变化增长（over窗口函数）
# 写一条 SQL 查询计算以 7 天（某日期 + 该日期前的 6 天）为一个时间段的顾客消费平均值
# 方案1,构造笛卡尔积,然后卡条件,筛出日期符合要求即0<=(date1-date2)<7的区间,随后再计算其他字段
select c1.visited_on,sum(c2.amount) as amount ,round(sum(c2.amount)/7,2) as avg_amount
from (
    select customer_id,name,visited_on,sum(amount) as amount from customer_by7day group by visited_on
    order by visited_on
)as c1
join (select customer_id,name,visited_on,sum(amount) as amount from customer_by7day group by visited_on
    order by visited_on) as c2
on datediff(c1.visited_on,c2.visited_on) < 7 and datediff(c1.visited_on,c2.visited_on) >=0
group by c1.visited_on
having count(*) > 6;

# 窗口函数
# LAG(<expression>[,offset[, default_value]]) OVER (
#     PARTITION BY expr,...
#     ORDER BY expr [ASC|DESC],...
# )
# LAG()函数返回expression当前行之前的行的值，其值为offset 其分区或结果集中的行数。
# rows between ...  and ... 意思是：在XXX之前和XXX之后的所有记录
select visited_on,ant,
       lag(visited_on,6) over (order by visited_on) lg,
       sum(ant) over (order by visited_on rows between 6 preceding and current row ) as amount
from (
select visited_on,sum(amount) ant from customer_by7day
group by visited_on order by visited_on) as t1;

# 93.广告效果
# 查询每一条广告的 ctr
# 考察count+if,以及SQL统计函数
select ad_id,
       ifnull(round(count(if(action='Clicked',1,null))/count(if(action<>'Ignored',1,null))*100,2),0) as ctr
from ads
group by ad_id;

# 94.列出指定时间段内所有的下单产品
# 获取在 2020 年 2 月份下单的数量不少于 100 的产品的名字和数目。
# 考察分类汇总
select py.product_name,ut
from (select product_id,sum(unit) as ut from orders_y
where month(order_date) = 02
group by product_id
having ut >=100) as r
left join products_y as py
on  r.product_id = py.product_id;

# 95.每次访问的交易次数
#  查询多少客户访问了银行但没有进行任何交易，多少客户访问了银行进行了一次交易等等
select transactions_count,ifnull(visit_ct,0) as ct from(select 0 transactions_count
union all
# 因为交易数的max肯定不会超过交易表的行数,所以直接按该表的最大行数来构造(因为缺失了0次,所以需要Union上)
select row_number() over(order by transaction_date) transactions_count from transactions_b)as l
left join (
    select
    trans_ct,count(*) as visit_ct
from
(
        select v.user_id,visit_date,count(amount) as trans_ct from visits as v
            left join transactions_b as tb on tb.user_id = v.user_id and tb.transaction_date = v.visit_date
        group by v.user_id,visit_date
        order by trans_ct
    )as t1
    group by trans_ct
    )as r
on l.transactions_count = r.trans_ct;

# 96.电影评分
# 查找评论电影数量最多的用户名。如果出现平局，返回字典序较小的用户名。
# 首先构造出每个用户的电影评论数,然后和用户表关联,筛选出应聘最多的,(因为可能存在相同的情况,所以窗口函数)
# 随后取id最小的即可
select um.name from (
select user_id,rank() over (order by count(movie_id) desc) as rnk from movie_rating
group by user_id
order by user_id
)as l
left join user_movies as um
on l.user_id = um.user_id
where l.rnk =1
having min(l.user_id);
# 96.电影评分plus
# 查找在 2020 年 2 月 平均评分最高 的电影名称。如果出现平局，返回字典序较小的电影名称。
# 基本同上
select ma.movie_title from(
select movie_id,rank() over (order by avg(rating) desc) as rnk from Movie_Rating
where date_format(create_at,'%Y-%m') = '2020-02'
group by movie_id
)as l
left join movies_a as ma
on l.movie_id = ma.movie_id
where l.rnk =1
having min(l.movie_id);

# 97.院系无效的学生
# 查询那些所在院系不存在的学生的 id 和姓名
select id, name from student_info
where department_id not in (select deparments_info.id from deparments_info);

# 98.活动参与者（any函数）
# SQL 查询那些既没有最多，也没有最少参与者的活动的名字
# 思路,找到最多和最少的,然后pass掉即可(窗口函数正反排序,正序,逆序都不等于一,即为非最值),
select
activity
from(
    select activity,
       rank() over (order by count(*) desc) as drnk,
       rank() over (order by count(*)) as rnk
    from friends_a
    group by activity
)as r
where r.rnk<>1 and r.drnk<>1;

# 99.顾客的可信联系人数量
# 为每张发票 invoice_id 编写一个SQL查询以查找以下内容：
# customer_name：与发票相关的顾客名称。
# price：发票的价格。
# contacts_cnt：该顾客的联系人数量。
# trusted_contacts_cnt：可信联系人的数量：既是该顾客的联系人又是商店顾客的联系人数量（即：可信联系人的电子邮件存在于客户表中）。
# 将查询的结果按照 invoice_id 排序。
# 分成三个表,第一个表为发票信息,(invoice_id,customer_name,price)
# 第二个表为联系人数量
# 第三个标为可信联系人数量
# 随后三个表关联
select invoice_id,customer_name,price,ifnull(contacts_cnt,0),ifnull(trusted_contacts_cnt,0)
from(
    select invoice_id,customer_name,price,user_id from invoices as i left join customers_info as ci
        on i.user_id = ci.customer_id) as s1
left join (select user_id,count(*) as contacts_cnt  from Contacts group by user_id) as s2
    on s1.user_id = s2.user_id
left join (select user_id,count(*) as trusted_contacts_cnt from contacts,customers_info
where contacts.contact_email = customers_info.email group by user_id)as s3
    on s2.user_id=s3.user_id;

# 100.获取最近第二次的活动（over窗口函数）
# 写一条SQL查询展示每一位用户最近第二次的活动
# 思路,分两部分,第一部分,如果活动项目>=2的,按照开始时间和结束时间分别排名第二筛选出来,然后再把只有一次的部分给Union起来
select
user_name,activity,startDate,endDate
from (
    select user_name,activity,startDate,endDate,
           rank() over (partition by user_name order by startDate) as srnk,
           rank() over (partition by user_name order by endDate) as ernk
    from useractivity
    )as s1
where s1.ernk = 2 and s1.srnk = 2
union
select user_name,activity,startDate,endDate from useractivity
group by user_name
having count(*) = 1;

# 101.使用唯一标识码替换员工ID
# 展示每位用户的 唯一标识码（unique ID ）；如果某位员工没有唯一标识码，使用 null 填充即可。
# 两表关联即可
select unique_id,name from employees_unique as eu left join employeeuni as e
on eu.id = e.id
order by unique_id;

# 102.按年度列出销售总额
# 查询每个产品每年的总销售额，并包含 product_id, product_name 以及 report_year 等信息。
# 思路,分成三个报告年份
# 比如考察2018报告年份的,如果其实时间>='2018/01/01'则输出起始时间,否则按'2018/01/01'计算
# 如果结束时间<='2018/12/31'的,则按结束时间计算,否则按'2018/12/31'计算
# 其他2019,2020年同理,随后三表union即可

select
product_id,product_name,report_year,sum(total_amount)
from(
    select product_id,'2018' as report_year,
           (datediff(if(period_end<='2018/12/31',period_end,date('2018/12/31')),
               if(period_start>='2018/1/1',period_start,date('2018/01/01')))+1)*average_daily_sales as total_amount
    from sales_c
    having total_amount >=0
    union all
    select product_id,'2019' as report_year,
           (datediff(if(period_end<='2019/12/31',period_end,date('2019/12/31')),
               if(period_start>='2019/1/1',period_start,date('2019/01/01')))+1)*average_daily_sales as total_amount
    from sales_c
    having total_amount >=0
    union all
    select product_id,'2020' as report_year,
           (datediff(if(period_end<='2020/12/31',period_end,date('2020/12/31')),
               if(period_start>='2020/1/1',period_start,date('2020/01/01')))+1)*average_daily_sales as total_amount
    from sales_c
    having total_amount >=0)as l
left join product_c
using (product_id)
group by product_id, product_name, report_year
order by product_id,report_year;

# 103.股票的资本损益
# 写一个SQL查询来报告每支股票的资本损益。
#考察SUM+IF 分组求和
select
       stock_name,
       sum(if(operation='Sell',price,0)) - sum(if(operation='Buy',price,0)) as capital_gain_loss
from stocks
group by stock_name;

# 104.购买了产品A和产品B却没有购买产品C的顾客
# 查询来报告购买了产品 A 和产品 B 却没有购买产品 C 的顾客的 ID 和
# 姓名（ customer_id 和 customer_name ），我们将基于此结果为他们推荐产品 C 。
# 嵌套查询 找到购买了A的用户id,在用这些用户id筛选出购买B的用户,再在这些用户里面找到没有购买C的
# 就是在AB里面提出掉ABC,剩下的就是AB(非C)
with temp as (
    select customer_id from orders_d
where product_name = 'B' and customer_id in (select customer_id from orders_d where product_name ='A')
and customer_id not in(select distinct customer_id from orders_d
where customer_id in (select customer_id from orders_d
where product_name = 'B' and customer_id in (select customer_id from orders_d
where product_name ='A')
)and product_name='c')
)

select cd.* from temp left join customers_d as cd
on  temp.customer_id = cd.customer_id;

select customer_id, customer_name
from customers_d
where
    customer_id in (select customer_id from orders_d where product_name='A')
    and
    customer_id in (select customer_id from orders_d where product_name='B')
    and
    customer_id not in (select customer_id from orders_d where product_name='C')
order by customer_id;

# 105.排名靠前的旅行者
# 写一段SQL,报告每个用户的旅行距离.
select name,ifnull(sum(distance),0) as dist from users_dist as ud
left join rides_dist as rd
on ud.id = rd.user_id
group by name
order by dist desc ,name;

# 106.查找成绩处于中游的学生
# 找出在所有测验中都处于中游的学生 (student_id, student_name)。
# 思路,原本是打算直接找到所有成绩中游的学生,但是后来发现存在直考了两门的学生,所以换个思路,找到最高分,最低分的学生id,
# 在所有参加考试的学生id中排除掉这部分学生,然后再和学生表关联,即可

select sm.* from (
              select distinct student_id from exam_medium
where student_id not in (
    select distinct student_id from
(select student_id,score,exam_id,rank() over (partition by exam_id order by score) as rnk ,
       rank() over (partition by exam_id order by score desc) as drnk from exam_medium
order by exam_id,score)as r
where r.rnk= 1 or r.drnk=1)) as l1
left join student_medium as sm
on l1.student_id = sm.student_id;

# 107.净现值查询
# 找到 Queries 表单中每一次查询的净现值.
select qn.*,ifnull(npv,0)
from queries_npv as qn left join npv n
on qn.year = n.year and qn.id = n.id;

# 108.制作会话柱状图
# Write an SQL query to report the (bin, total) in any order.
# 思路,分多个表构建满足条件的记录,然后union合并
select '[0-5>' as bin,count(if(duration/60 >=0 and duration/60<5 ,1,null)) as total from sessions
union
select '[5-10>' as bin,count(if(duration/60 >=5 and duration/60<10 ,1,null)) as total from sessions
union
select '[10-15>' as bin,count(if(duration/60 >=10 and duration/60< 15 ,1,null)) as total from sessions
union
select '15 or more' as bin,count(if(duration/60 >=15,1,null)) as total from sessions;

# 109.计算布尔表达式的值（case when then else end）
# Write an SQL query to evaluate the boolean expressions in Expressions table.
# 考察case when的嵌套使用
select left_operand,operator,right_operant,
       if(operator='<',if(leftvalue<rightvalue,'True','False'),
           if(operator='>',if(leftvalue>rightvalue,'True','False'),
               if(leftvalue=rightvalue,'True','False'))) as value2
from (
    select left_operand,leftvalue,operator,right_operant,v2.value as rightvalue
    from (
        select left_operand,value as leftvalue,operator,right_operant
        from expressions  as e left join variables as v
            on e.left_operand = v.name
        )as l1
        left join variables as v2
            on l1.right_operant = v2.name
    )as l2;


# 110.苹果和桔子
# 报告每一天 苹果 和 桔子 销售的数目的差异.
# 考察sum+if分类汇总
select
       sale_date,
       sum(if(fruit='apples',sold_num,0))-sum(if(fruit='oranges',sold_num,0)) as diff from fruits_sales
group by sale_date;

# 111.活跃用户（连续dense_rank排名函数）
# 108.Write an SQL query to find the id and the name of active users.
# 考察如何查询连续天数,(使用窗口函数对id进行分组,以日期排序)然后使用date与其相减,如果是连续的日期,则差值对应相等,
# 然后按照id和diff_date分组统计,得到各个连续时间的长度,取>=5的即可
select
       r.id,ac.name
from (select id,login_date,
       datediff(login_date,'2020/1/1')-rank() over (partition by id order by login_date) as cday
from logins) as r left join accounts as ac
on r.id = ac.id
group by id, cday
having count(*) >= 5;

# 112.矩形面积
#  报告由表中任意两点可以形成的所有可能的矩形.
select p1.id,p2.id,abs((p2.y_value-p1.y_value)*(p2.x_value-p1.x_value)) as area  from points as p1,points as p2
where  p1.id < p2.id and p1.x_value<>p2.x_value and p1.y_value<>p2.y_value
order by area desc,p1.id,p2.id;

# 113.计算税后工资
# 如果这个公司员工最高工资不到 1000 ，税率为 0%
# 如果这个公司员工最高工资在 1000 到 10000 之间，税率为 24%
# 如果这个公司员工最高工资大于 10000 ，税率为 49%
# 按任意顺序返回结果，税后工资结果取整
# 思路,做出各公司最高工资的temp表,然后和原表做关联,随后使用if判断

select st.company_id,employee_id,employee_name,
       if(m_salary<=1000,salary,if(m_salary<=10000,salary*0.76,salary*0.51)) as salary
from salaries_tax as st
left join (
    select company_id ,max(salary) as m_salary from salaries_tax
group by company_id)as r
on st.company_id = r.company_id;

# 114.周内每天的销售情况（dayname星期几）
# dayname 函数返回英文星期几，dayofweek返回第几天，周天是1
# date_format + %w，周天返回 0，%W，返回英文星期几
select ib.item_category,
       sum(if(date_format(order_date,'%W')='Sunday',quantity,0)) as 'Sunday',
       sum(if(date_format(order_date,'%W')='Monday',quantity,0)) as 'Monday',
       sum(if(date_format(order_date,'%W')='Tuesday',quantity,0)) as 'Tuesday',
       sum(if(date_format(order_date,'%W')='Wednesday',quantity,0)) as 'Wednesday',
       sum(if(date_format(order_date,'%W')='Thursday',quantity,0)) as 'Thursday',
       sum(if(date_format(order_date,'%W')='Friday',quantity,0)) as 'Friday',
       sum(if(date_format(order_date,'%W')='Saturday',quantity,0)) as 'Saturday'
from items_byweek as ib
left join orders_byweek ob on ib.item_id = ob.item_id
group by ib.item_category;

# 115.按日期分组销售产品
# group_concat()
# group by 产生的同一个分组中的值连接起来，返回一个字符串结果。
# 语法：group_concat( [distinct] 要连接的字段 [order by 排序字段 asc/desc ] [separator '分隔符'] )
# distinct可以去重，order by子句 排序；separator是一个字符串值，缺省为一个逗号
select sell_date,
       count(distinct product) as num_sold ,
       group_concat(distinct product) as products from activities_c
group by sell_date;

# 116.Friendly Movies Streamed Last Month
# Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.
select distinct title from tvprogram
left join content c on tvprogram.content_id = c.content_id
where content_type='movies' and Kids_content='Y' and  date_format(program_date,'%Y-%m')='2020-06';

# 117.可以放心投资的国家
# 该公司想要投资的国家是: 该国的平均通话时长要严格地大于全球平均通话时长.
# 写一段 SQL, 找到所有该公司可以投资的国家.
# 构造两个表,表1为各个国家的平均通话时长,表2为所有国家的平均通话时长(根据题意,需要将celler_id 和cellee_id两个字段合并,统计duration,然后再
# 分开计算各个所属地国家的duration

select distinct country_name
from (
     select country_name,
       if(avg(duration)<(select avg(duration)from(select caller_id as call_id,duration from calls
       union all select callee_id as call_id ,duration from calls)as s1
           left join (select id,ci.name as country_name from person_i as pi
               left join country_i ci on left(pi.phone_number,3) = ci.country_code) as s2
on s1.call_id = s2.id),0,1) as res
from(
    select caller_id as call_id,duration from calls
    union all
    select callee_id as call_id ,duration from calls
)as s1 left join (select id,ci.name as country_name from person_i as pi
left join country_i ci on left(pi.phone_number,3) = ci.country_code) as s2
on s1.call_id = s2.id
group by country_name
         )as r
where r.res = 1;

# 118.Customer Order Frequency
# Write an SQL query to report the customer_id and customer_name of customers
# who have spent at least $100 in each month of June and July 2020.
# 首先6,7月当月消费都>=100的记录,卡date_formate,以及sum的值,随后和customer_f表关联,找到用户的名称,
# 卡计数=2(因为6,7月都存在记录的话,计数=2)
select cf.name
from
     (select date_format(order_date,'%Y/%m')as month,
       customer_id,
       sum(quantity*price)as total_amount
     from orders_f as o left join  product_f as pf on o.product_id = pf.product_id
     group by month,customer_id
     having total_amount >= 100 and month in ('2020/06','2020/07')
         )as r
left join customers_f as cf
on r.customer_id = cf.customer_id
group by name
having count(*) = 2;

# 119.Find Users With Valid E-Mails（正则表达式）
# ^ 表示开头
# + 匹配一个或多个,不包括空
# [] 表示集合里的任意一个
# \\ 用于转义特殊字符
# a{m,n} 匹配m到n个a，左侧不写为0，右侧不写为任意
# $ 表示以什么为结尾
# regexp + pattern 使用正则表达式匹配

select * from users_regex
where mail regexp '^[a-zA-Z]+[0-9a-zA-Z\.\\-]*@leetcode.com$';


# 120.Patients With a Condition（like）
# Write an SQL query to report the patient_id, patient_name all conditions of patients
# who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix

# mysql 通配符
# %（百分号），_（下划线）就是通配符，%表示任何字符出现任意次数(可以是0次)，_表示单个字符
select * from patients
where conditions like '%DIAB1%';

# 121.The Most Recent Three Orders（dense_rank + over窗口函数）
# Write an SQL query to find the most recent 3 orders of each user.
# If a user ordered less than 3 orders return all of their orders.
select name,customer_id,order_id,order_date from
(
    select cr.name,cr.customer_id,order_id,order_date,
       dense_rank() over (partition by ord.customer_id order by order_date desc ) as rnk
    from orders_recent as ord
        left join customer_recent as cr
            on ord.customer_id = cr.customer_id
    )as r
where r.rnk<=3
order by name,order_date desc;

# 122.Fix Product Name Format（trim去空格+upper/lower大小写）
# MYSQL的文本函数
# 大写upper\ucase,小写lower\lcase
# trim去除空格，ltrim、rtrim只去除左侧或者右侧空格
select
    product_name,sale_date,count(*)
from (select
       lcase(trim(product_name)) as product_name,
       date_format(sale_date,'%Y/%m') as sale_date
from sales_upper
)as r
group by product_name, sale_date;

# 直接汇总的话,因为名称存在冲突,所以MYSQL会默认为是原来的字段名,结果出来就是原先的,如下
select
       lcase(trim(product_name)) as product_name,
       date_format(sale_date,'%Y/%m') as sale_date,
       count(*)
from sales_upper
group by product_name,sale_date;

# 要么重新命名字段(要么就嵌套查询)
select
       lcase(trim(product_name)) as ProductName,
       date_format(sale_date,'%Y/%m') as SaleDate,
       count(sale_date)
from sales_upper
group by ProductName,SaleDate;

# 123.The Most Recent Orders for Each Product
# Write an SQL query to find the most recent order(s) of each product.
select product_name,r.product_id,order_id,order_date
from (
    select product_name,ord.product_id,order_id,order_date,
           dense_rank() over (partition by ord.product_id order by order_date desc ) as rnk from orders_rec as ord
               left join products_rec as pr
                   on ord.product_id = pr.product_id
    order by ord.product_id,order_date desc
    )as r
where r.rnk =1