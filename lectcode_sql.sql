# 1.���������
select * from Person left join Address on Person.PersonId = Address.AddressId;

# 2.ѡ��ڶ��ߵ�н��
# ����1,����,Ȼ��ɸѡ
select id,Salary from (
    select id,Salary,dense_rank() over (order by Salary desc ) as rnk from Employee)as r
where r.rnk = 2;
# ����2
# ����(����),Ȼ��limitƫ��(����ֻ������salary�������ظ�ֵ�����)
select id,Salary from employee order by Salary desc limit 2 offset 1;

# 3.ѡ���N�ߵ�н��
select id,Salary from (
    select id,Salary,dense_rank() over (order by Salary desc ) as rnk from Employee)as r
where r.rnk = 3;

# 4 �ɼ�����(��ͬ�ɼ�����,�Ҳ���ϵ��)
# ˼·,���ں���
# �������򴰿ں���
# .row_number() ������ԣ�������������Ϊ��ѯ������ÿһ�м�¼����һ����ţ����������Ҳ����ظ�
# dense_rank()  ������ԣ������������������ͬһ����ʱ���������ǵڶ����� ������1,2,2,3
# rank() ������ԣ� ��Ծ�������������ͬһ����ʱ���������ǵ�������,����1,2,2,4
select score,dense_rank() over (order by score desc ) as 'rank' from rank_scores;

# 5.��������(����3��)
# ������row_number()��id��������,(Ϊ�˷�ֹid�ֶγ��ֶϵ�)
# ʹ��partition by num��num���飨Ҳ����num��ͬ����Ϊһ�飩��Ȼ������order by����ͬ��num�������id��������
select num,count(*) from (
    select
       id,
       num,
       row_number() over (order by Id) - row_number() over (partition by Num order by id)
           as orde from logs)
    as r
group by num, orde
having count(*) > 1;

# 6�Ի�ȡ���볬�����Ǿ����Ա����������
# ˼·,����ĿҪ��,��ְ������������(managerid=id)��������Ա����>�Ҳྭ���ʵ�,��Ϊ���������ļ�¼,ѡ�����е�employee�ֶμ���
select employee from (
select if(ea.salary>ea2.salary,ea.name,null) as employee  from employee_above as ea
left join employee_above as ea2
on ea.managerid = ea2.id
                  )as r
where r.employee is not null;

# 7 �����ظ�����
select email from find_email
having count(Email)>1;

# 8 �Ӳ������Ŀͻ�
select name from customer_none
where id not in (select customer_id from orders_none);

# 9 �����Ź�����ߵ�Ա��
# ˼·,���ڶ�����������employees ��department���ű�,ȡ��Ҫ���ֶ�,Ȼ���salary�ô��ں�������(��departmen���ŷ���),
# �����ɸѡ��rnk=1,����ߵĲ��ּ���
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

# 10,����ǰ��нˮ
# ˼·,����ͬ��,ֻ��Ҫ���ɸѡ������rnk<=3����
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

# 11.ɾ���ظ�����
delete p1 from pemail as p1,pemail as p2
where p1.Email = p2.Email and p1.id > p2.id;
select * from pemail;

# 12 �������¶�
# �������ں�����Ӧ��
select wt1.id as id from weather as wt1,weather as wt2
where to_days(wt1.recorddate) - to_days(wt2.recorddate) = 1 and wt1.temperature>wt2.temperature;

# 13.�ǽ�ֹ�û���ȡ����(�г̺��û�)
# ˼·,���ҵ��������û�,���˵�����صļ�¼
select request_at,ifnull(round(sum(if(status<>'completed',1,0))/count(*),2),0) as rate
from trips
where client_id not in (select user_id from users where banned is true)
      and request_at between '2013/10/01' and '2013/10/03'
group by request_at;

# 14.��Ϸ�淨����1
# дһ�� SQL ��ѯ����ȡÿλ��� ��һ�ε�½ƽ̨�����ڡ�
# ˼·,ʹ�ô��ں���,��player_id����,event_date����,ȡrnk=1����
select
       player_id,
       event_date
from (
     select player_id,
            event_date,
            rank() over (partition by player_id order by event_date) as rnk
     from activity)as s
where s.rnk = 1;

# 15.��Ϸ�淨����2
# ���дһ�� SQL ��ѯ������ÿһ������״ε�½���豸����
select
       player_id,
       event_date
from (
     select player_id, event_date
            event_date,
            rank() over (partition by player_id order by event_date) as rnk
     from activity)as s
where s.rnk = 1;

# 16 ��Ϸ�淨����3
# ��дһ�� SQL ��ѯ��ͬʱ����ÿ����Һ����ڣ��Լ���ҵ�ĿǰΪֹ���˶�����Ϸ��
select  player_id,sum(games_played) over (partition by player_id order by event_date) games_played_so_far
from activity;

# 17 ��Ϸ�淨����4
# �������յ�½���û��ڴ���Ҳ��½����������Ϸ
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

# ����ϲ�
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

# 18.��Ա������λ��
# ����1. ���ô��ں���,��salary���з�������(����˳��Ҫ��),�������rnk1 = rnk2,�������Ǹ÷������λ��,
# ����ż�������,��abs(rnk1 - rnk2) = 1,��������������λ��
select id,Company,Salary from (
    select id, company, salary,
           row_number() over (partition by Company order by Salary) as id1,
           row_number() over (partition by Company order by Salary desc) as id2
    from employee_median
    order by Company
    ) as r
where r.id1 = r.id2 or abs(cast(id1 as signed )-cast(id2 as signed)) = 1;

# 19 ��ѯ����Ա��>=5 �ľ�������
# ˼·,������manageridͳ��Ա����,havingɸѡ������5�� managerid,�����ø�IDΪ����ɸѡ������
select name from employee_manager
where id in (
    select managerid from employee_manager
    group by  managerid
    having count(*) >=5
    );

# 20 �������ֵ�Ƶ�ʲ�ѯ��λ��
# ˼·1 ���������м��λ��
select avg(number) as medium from(
    select
       number,
       sum(frequency) over(order by number) as rnk,
       sum(frequency) over(order by number desc) as drnk,
       sum(frequency) over() as cnt
       from numbers)as r
where rnk>=cnt/2 and drnk>=cnt/2;

# ˼·2.
# '��λ����Ƶ��һ���ǻ���ڵ������ϰ벿��Ƶ���ܺ����°벿��Ƶ���ܺ�֮�Ȼ�������λ��Ƶ������avgһ�¾Ϳ��Եõ���λ����'
select avg(n.number) median
from numbers as n
where n.frequency >= abs((select sum(frequency) from numbers where number<=n.number) -
                         (select sum(frequency) from numbers where number>=n.number));
# ˼·3,ֱ����pandas����

# 21 ��ѡ��,ѡ�ٻ�ʤ
# ˼·,���Ȱ���ѡ���˵�Ʊ���ͳ��,ɸ����Ʊ�����˵�id,�ڰ���idɸѡ������,
# ���ǵ����˵�Ʊ��ͬ�����,�����ô��ں�����ct�Ÿ���,����㰴rnk=1��ȡid,������ͬ
select name from candidate where id in (
    select candidateid as ct from vote
    group by candidateid
    order by count(*) desc limit 1
    );

# 22.Ա������(�鿴Ա������<2000�ļ�¼)
# ˼·,������,Ȼ��ɸѡbonus<2000�ļ�¼,ע������Ϊ�յ�,Ҫ���һ��is null������
select name,bonus from employee_bonus
left join bonus b on employee_bonus.empid = b.empid
where bonus <2000 or bonus is null ;

# 23 �鿴�ش�����ߵļ�¼
# ������ش���,Ȼ����ΪǶ�ײ�ѯ�ҵ�question_id,�������ҵ�������ߵ��Ǹ�
select
    question_id
from
     (select question_id,
             ifnull(round(sum(if(action='answer',1,0))/sum(if(action='show',1,0))*100,2),0) as answer_rate
     from survey_log
     group by question_id) as r1
group by question_id
having max(answer_rate);

# 24 ��ѯԱ�����ۼ�нˮ
# ��������ۼ�(�����������һ����)
# ˼·,���ں���+where����ɸѡ
select id,month,sum(salary) over (partition by id order by month) as salary from employee_cumulative
where month <> (select max(month) from employee_cumulative)
order by id, month desc;

# 25 ͳ�Ƹ�רҵѧ������
# ˼·,Ϊ�˱�֤���п�Ŀ����ʾ,�����ÿγ̱�������ѧ��ѡ�α�
select dept_name, count(student_id) as ct from department
left join student_d sd on department.dept_id = sd.dept_id
group by dept_name;

# 26 Ѱ���û��Ƽ���
# ����һ������б��б��б�ŵ��Ƽ��˵ı�Ŷ�����2
# ע��referee_id<>2�ǻ��ų���Ϊ�յĲ���,����Ҫ�����ó�����дһ��is null������
select name from referee
where referee_id <> 2 or referee_id is null;

# 27.2016���Ͷ��
# дһ����ѯ��䣬�� 2016 �� ��(TIV_2016) ���гɹ�Ͷ�ʵĽ������������� 2 λС����
# ˼·,���ҵ�������ϵ�id,�����
# ����
    # 1. ���� 2015 ���Ͷ���� (TIV_2015) ���ٸ�һ������Ͷ������ 2015 ���Ͷ������ͬ
    # 2. �����ڳ��еľ�γ���Ƕ�һ�޶��ġ�
# 1,Ͷ������ͬ
# ע,����������֮����ڽ���,���Բ���ֱ��ͨ��Ƕ�׸㶨,��������Ƿֿ�д��������,���ȡ����(���ﾭγ�ȵ�����ȡ��,�����������)
select pid from insurance where pid not in (
    select pid  from insurance
    group by tiv_2015
    having count(*) = 1
    );
# 2,��γ����ͬ
select i1.pid from insurance as i1,insurance as i2
where i1.lat = i2.lat and i1.lon = i2.lon and i1.pid <> i2.pid;

# 3.����ȡ�
select sum(tiv_2016) from insurance
where pid not in (
    select i1.pid from insurance as i1,insurance as i2
    where i1.lat = i2.lat and i1.lon = i2.lon and i1.pid <> i2.pid
    ) and pid in(select pid from insurance where pid not in (
    select pid  from insurance
    group by tiv_2015
    having count(*) = 1
));
# ���ں���
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

# 28.�������Ŀͻ�
# .�ڱ� orders ���ҵ����������ͻ���Ӧ�� customer_number
# ע ��������������ֵ����,˼·1,����ͳ��������,���ȡlimit 1
# ���ͬʱ������ͬ����ֵ,����ʹ��Ƕ��
# (ֱ��ȡ�������ֵ�Ƚ��鷳,����ȡ�ɸ�����ֱֵ���ô��ں�������rank,���ս�������,���ֻ��Ҫrnk=1����
select customer_number from orders_max
group by customer_number
order by count(*) desc limit 1;

select customer_number from (
    select customer_number,dense_rank() over (order by count(*) desc)as rnk
    from orders_max
    group by customer_number
    )as r
where r.rnk = 1;

# 29.���
# ����where �� and,or�����ʹ��
select name,population,area from world
WHERE area > 3000000 OR population > 25000000;

# 30.�г����г��������5��ѧ���ĿΡ�
# ����group by �� having�����ʹ��
select class from class_studnet
group by class
having count(*) >=5;

# 31.�������� I ������ͨ����
# ˼·,ʵ�ʾ�����request_accepted���еļ���(���ظ�����)��friend_request(���ظ�)�����ı�ֵ
select
       ifnull(round(count(distinct requester_id,accepter_id)/count(distinct sender_id,send_to_id),2),0) as accept_rate
from friend_request,request_accepted;

# ������μ��� ÿ�µ�����ͨ����,
# ˼·:���·ֿ������������ʹ����,Ȼ��ϲ������
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

# ���ռ��������,�൱�ڼ��㵱��ͨ���������� (���ﰴ�����ռ���)
select l1.request_date, ifnull(round(accepted_num/request_num,2)*100,0)  as 'rate(%)'
from
     (select request_date , count(distinct sender_id,send_to_id) request_num
     from friend_request group by request_date) as l1
left join  (
    select accpet_date , count(distinct requester_id,accepter_id) accepted_num
    from request_accepted group by accpet_date )as r1
on l1.request_date = r1.accpet_date;

# 32.�����ݵ�������
# ���дһ����ѯ��䣬�ҳ��������ĸ߷��ڡ��߷���ʱ�������������м�¼�е�������������100
# ˼·,��Ŀ˵��id����������������,Ϊ���Է���һ,������������������������(������������)
# �������貢δ˵���Ǵ�������,���Ǵ�������,�������������Ҫ���ǽ�ȥ,���Ǵ��м������߼���
select s1.* from stadium as s1,stadium as s2 ,stadium as s3
# ����������
where ((datediff(s1.visit_date,s2.visit_date)=1 and datediff(s1.visit_date,s3.visit_date) = 2)
# ���м���������
or( datediff(s2.visit_date,s1.visit_date)=1 and datediff(s3.visit_date,s2.visit_date) = 1)
# ����������
or (datediff(s3.visit_date,s2.visit_date)=1 and datediff(s2.visit_date,s1.visit_date) = 1))
and s1.people>=100 and s2.people>=100 and s3.people>=100
order by s1.visit_date;

# 33.�������� II ��˭�����ĺ��ѣ�union all��
# дһ����ѯ��䣬���˭ӵ�����ĺ��Ѻ���ӵ�еĺ�����Ŀ��
# ˼·,��Ϊ�ñ�ʵ���Ͼ����Ѿ�������ѵĹر�,����һ��������ܾ���һ������,���԰������ֶκϲ�����,Ȼ������Ϳ��������������id
select
id,count(*) as num
from (
    select requester_id as id from request_accpeted_most
    union all
    select accepter_id as id from request_accpeted_most
    )as r
group by id
order by num desc limit 1;

# ���ǵ��������ֵΪ����˵Ŀ�����,���Ͻű����Խ�һ���Ż�(���ô��ں���,�Լ���������,���ȡ��һ����)

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

# 34.����������λ
# ˼·,cinema ��������,�ж���������1��idǰ�����1;2,�����״̬Ӧ����һ�µ�,����Ϊ0��Ϊ1
select distinct c1.seat_id from cinema as c1,cinema as c2
where abs(c1.seat_id - c2.seat_id)= 1
and c1.free = c2.free
order by  c1.seat_id;

# 35.������б� salesperson �У�û����˾ 'RED' �����κζ���������Ա��
# ˼·,�ҵ�'RED'��˾��com_id,ɸѡ�����۲�Ʒ��sale_id,�������Щsale_idȡ����ɸѡ������Ա
select * from salesperson
where sales_id not in (
    select sales_id from orders_sales where com_id in (
        select com_id from company where name ='RED'));

# 36,���ڵ�
# ˼·,p_id Ϊ�յļ�λ���ڵ�,�����id��p_id��,(�ų�Ϊnull��)��Ϊinner�ڵ�,��������Ϊleaf�ڵ�
# ����if���÷�
select id,if(isnull(p_id),'root',if(id in (select p_id from tree),'inner','leaf')) as 'type' from tree;

#37.�ж�������
# �����ι�������,��������֮��<=������
# ����case when��Ӧ��
select x,y,z,
       if(x+y<=z or x+z<=y or y+z<=x ,'yes','no') as triangle
from triangle;

# 38.ƽ���ϵ��������
# ����mysql��������ú���ʹ��
select min(round(sqrt(power(p1.x-p2.x,2)+power(p1.y-p2.y,2)),2)) as distance from point_2d as p1,point_2d as p2
where p1.x <> p2.x and p1.y <> p2.y;

# 39.ֱ���ϵ��������
select min(abs(p1.x-p2.x)) as shortest_distance from point as p1, point as p2
where p1.x <> p2.x;

# 40.������ע��
# ��дһ�� sql ��ѯ��䣬��ÿһ����ע�ߣ���ѯ��ע���Ĺ�ע�ߵ���Ŀ
# ˼·,���Ǽ����ڹ�ע���б�����ı���ע�ߵĹ�ע������
select followee as follower ,count(*) as ct from follow
where followee in (select follower from follow)
group by followee
order by ct;

# 41.ƽ�����ʣ������빫˾�Ƚ�
# ˼·����1.����ƽ��ֵ��.2����Ʒ��ֵ��,3.�����������,
# 1.����ƽ��ֵ��
select
       left(pay_date,7) as pay_month,
       department_id,
       avg(amount) as avg_a
from salary_avg as sa, employee_avg as ea
where sa.employee_id = ea.employee_id
group by pay_month,department_id;

# 2.salary&employee�ϲ���ķ�����ͱ�
select left(pay_date,7) as pay_month,avg(amount) from salary_avg
group by pay_month;

# ����ϲ�
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

# ���ں���
select distinct pay_month, department_id,
       case when dep_avg > total_avg then 'higher'
            when dep_avg = total_avg then 'same'
            else 'lower' end as comparison
from
(
  # ƽ�����Ź���, ��˾ƽ������
    select department_id,
           avg(amount) over(partition by department_id, date_format(pay_date, '%Y-%m')) dep_avg,
           date_format(pay_date, '%Y/%m') pay_month,
           avg(amount) over(partition by date_format(pay_date, '%Y/%m')) total_avg
    from salary_avg s left join employee_avg
    using(employee_id)
) t;

# 42.ѧ��������Ϣ���棨row_number��
# .дһ����ѯ���ʵ�ֶԴ��ޣ�continent���е� ͸�ӱ�
select
       max(case when continent='America' then name end) as 'America',
       max(case when continent='Asia' then name end) as 'Asia',
       max(case when continent='Europe' then name end) as 'Europe'
from
(
    select row_number() over(partition by continent order by name) as id, name, continent
    from student_geo)t group by id;

# ����2
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

# 43.ֻ����һ�ε��������
# ˼·,Ƕ�ײ�ѯ,�����ҵ����ִ���Ϊһ����ֵ,Ȼ��ȡ�������Ĳ���
select
       max(num) as num
from (
    select num from my_number
    group by num
    having count(*) = 1)as s;

# 44.��Ȥ�ĵ�Ӱ
# �ҳ�����ӰƬ����Ϊ�� boring (������) �Ĳ��� id Ϊ���� ��ӰƬ������밴�ȼ� rating ����
select * from movies
where id%2 <> 0 and description <>'boring'
order by rating desc;

# 45.����λ
# ˼·,�޸�ID�ֶ�,���idΪż��,���Ӧ-1,�����������=MAX(id)�򱣳ֲ���,��������id��Ӧ+1,
# ����ͬ��������,����ٰ���id���򼴿�.
select
    case
        when Id%2=0 then id -1
        when Id%2<>0 and Id = (select max(Id) from seat) THEN Id
        ELSE Id+1
    end as id,
    Student
from seat
order by id;

# 46.��������
# .ֻʹ��һ�����£�Update����䣬����û���м����ʱ��(������Ů)
select * from swap_salary;
update swap_salary set sex = if(sex='f','m','f');
select * from swap_salary;

# 47.�������в�Ʒ�Ŀͻ�
# �� Customer ���в�ѯ������ Product �������в�Ʒ�Ŀͻ��� id��
# ˼·,�������в�Ʒ��ζ��Customer�а����û�id����Ļ�,count(distinct product_key) =
select customer_id from customer_all
group by customer_id
having count(distinct product_key) = (select count(distinct product_key) from Product_all);

# 19,��Ա����>�侭������ļ�¼
# ˼·,���������,��manageid����id,�б����ߵ�salary,ȡ�����������Ĺ�Ա����
select e.name as employee from employees_earning as e
left join employees_earning as m
on e.managerid = m.id
where e.salary > m.salary;

# 48.�������������ε���Ա�͵���
# дһ��SQL��ѯ����ȡ�������������ε���Ա�͵��ݵ� id �� (actor_id, director_id)
# ˼·,��actor_id, director_id����Ϊchar����,Ȼ�����ı��ϲ�,��Ϊ������
# ����,concat�ı��ϲ�,cast�ֶ���������ת��
select actor_id,director_id
from ActorDirector
group by actor_id, director_id
having count(concat(cast(actor_id as CHAR),cast(director_id as char))) >=3;

# 49.��Ʒ���۷��� I
# ��ѯ����ȡ��Ʒ�� Product �����е� ��Ʒ���� product name �Լ� �ò�Ʒ�� Sales �������Ӧ�� ������� year �� �۸� price��
select product_name,year,price
from sales_year as s
    left join product_year py
        on py.product_id = s.product_id;

# 50.��Ʒ���۷��� II
# ��дһ�� SQL ��ѯ������Ʒ id product_id ��ͳ��ÿ����Ʒ������������
select product_id,sum(quantity) from sales_year
group by product_id;

# 51.��Ʒ���۷��� III��group by ���壩
# ��дһ�� SQL ��ѯ��ѡ��ÿ�����۲�Ʒ�� ��һ�� �� ��Ʒ id����ݡ����� �� �۸�
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

# 52.��ĿԱ�� I
# ��ѯÿһ����Ŀ��Ա����ƽ���������ޣ���ȷ��С�������λ��
select project_id,round(avg(experience_year),2) as avg_years from project_workyear
left join employee_workyear ew on ew.employee_id = project_workyear.employee_id
group by project_id;

# 53.��ĿԱ��II
# ��дһ��SQL��ѯ���������й�Ա������Ŀ��
select
       project_id
from (
    select project_id,rank() over (order by count(*) desc) as rnk from project_workyear
    left join employee_workyear ew on ew.employee_id = project_workyear.employee_id
    group by project_id)as s
where s.rnk = 1;

# 54.��ĿԱ�� III
# ������ÿһ����Ŀ�о�����ḻ�Ĺ�Ա��˭��(ͬ���Ĳ��г���)
# Ϊ�˷��㿴�����,���Ը�������
update employee_workyear set experience_year = 3 where name='John';

select project_id,employee_id from(
             select project_id,ew.employee_id,rank() over (partition by project_id order by experience_year desc ) as rnk
from project_workyear as p left join employee_workyear ew on ew.employee_id = p.employee_id
                 )as r
where r.rnk =1 ;

# 55.���۷��� I
# ��дһ��SQL��ѯ����ѯ�����۶���ߵ������ߣ�����в��еģ��Ͷ�չʾ����
SELECT seller_id FROM
(
    select seller_id,rank() over (ORDER BY SUM(price) desc) as rnk from salesmax
    GROUP BY seller_id
    )as s
where s.rnk = 1;

# 56.���۷��� II
# ��дһ�� SQL ��ѯ����ѯ������ S8 �ֻ�ȴû�й��� iPhone ����ҡ�ע������ S8 �� iPhone �� Product ���еĲ�Ʒ
# ˼·:�ֿ���ѯ,Ȼ��ȡ����,�ӹ���s8�Ŀͻ������ҵ�û��iPhone�ļ���
select buyer_id from (
    select buyer_id from salesmax left join product_salemax ps on salesmax.product_id = ps.product_id
    WHERE product_name = 'S8') as s1
where buyer_id in (select buyer_id from salesmax left join product_salemax ps on salesmax.product_id = ps.product_id
WHERE product_name <> 'iPhone');

# 57.���۷���III
# ��дһ��SQL��ѯ������2019�괺�����۳��Ĳ�Ʒ��������2019-01-01��2019-03-31������֮����۵���Ʒ��
# ע����Ŀ,Ҫ��ֻ�ڴ�������,���������ʱ�䷢�۵���Ҫȥ��,����Ҫʹ��groupby����,�ҵ���ٷ��ۺ����緢�۶��ڴ����ļ�¼
select ps.product_id,product_name from salesmax
left join product_salemax ps on salesmax.product_id = ps.product_id
group by ps.product_id, product_name
having(max(sale_date) between '2019-01-01' and '2019-03-01' )
   and(min(sale_date)  between '2019-01-01' and '2019-03-01');

# 58.��Ϸ�淨���� V
# ��дһ�� SQL ��ѯ������ÿ����װ���ڡ����찲װ��Ϸ����������͵�һ��ı���ʱ��
# ��ĳ������ X �ĵ� 1 �챣��ʱ�䶨��Ϊ��װ����Ϊ X ����ҵ������������� X ֮���һ�����µ�¼�����԰�װ����Ϊ X ����ҵ�����
# ���յ�½
select
event_date as first_load_date ,count(distinct player_id) as frist_date_num
from (
    select player_id,event_date,
           rank() over (partition by player_id order by event_date) as rnk
    from activity) as r
where r.rnk = 1
group by event_date ;

# 59.С���鼮
# ɸѡ����ȥһ���ж������� ����10�� �� �鼮
# ������ �ϼܣ�available from����� ����һ���� ���鼮������ ��������� 2019-06-23 ��
# ˼·,�����޷����������<10���鼮��¼���鼮�嵥����,��Ϊ<10�ų����ļ�¼���鼮�嵥����ʱ(left join)���Ϊ�յĲ����޷�˵��ʱ��Ϊ>10����
# û�ж�����¼,������õİ취�ǽ�����ֱ�ӹ���,Ȼ������ɸ���������ϵļ�¼
select distinct b.book_id,b.name from books as b
left join orders_book ob on b.book_id = ob.book_id
where available_from < '2019-06-23' - interval 1 month
group by b.book_id,year(dispatch_date)
having sum(quantity) < 10 or sum(quantity) is null;

# 60.ÿ�����û�ͳ��
# SQL ��ѯ�ӽ�������� 90 ���ڣ�ÿ�����ڸ������״ε�¼���û�������������� 2019-06-30.
# ˼·,�ȼ����״ε�½,Ȼ���ٿ���½����;������ɸѡ90���ڵļ�¼,��Ϊ��������ܴ���ͬʱ��3.30��֮ǰ��֮�ڶ���½�ļ�¼
# �����Ļ�,�����ļ�����Ҳ�Ὣ��������״ε�½��,ͬ���岻��,����Ӧ����ͳ���״ε�½,�ڿ���½����.
select activity_date,
       count(*)
from (
    select activity_date,user_id,
           rank() over (partition by user_id order by activity_date) as rnk from traffic
    where activity ='login')as r
where r.rnk = 1 and (activity_date between '2019-06-30' - interval 90 day  and '2019-06-30')
group by activity_date;

# �ȼ����½���ڵĽ��(X)
select
       activity_date,user_id,
       rank() over (partition by user_id order by activity_date) as rnk
from traffic
where activity_date between '2019-06-30' - interval 90 day  and '2019-06-30';

# 61.ÿλѧ������߳ɼ�
#��ѯÿλѧ����õ���߳ɼ���������Ӧ�Ŀ�Ŀ������Ŀ�ɼ����У�ȡ course_id ��С��һ�š���ѯ����谴 student_id �����������
# ˼·,���촰�ں�������,��һ������student_id����,Ȼ�󰴳ɼ���������,�ҵ�����ѧ���÷���ߵļ�¼,Ȼ��ȡ��min(course_id)�Ĳ���
select student_id,min(course_id),grade from (
              select
                     student_id,course_id,grade,
                     rank() over (partition by student_id order by grade desc ) as rnk
              from enrollments
                )as r
where r.rnk = 1
group by student_id
order by student_id;

# 62.����ļ�¼
# ��ѯÿ�� �������ɣ�report reason��������ı������������������ 2019-07-05��
# ˼·,�������ں�����ʹ��,
select extra,count(distinct user_id) from actions_report
where action_date = '2019/7/5'-interval 1 day and extra is not null
group by extra;

# 63.��ѯ��Ծҵ��
# ����ѯ���л�Ծ��ҵ��
# ���һ��ҵ���ĳ���¼����͵ķ����������ڴ��¼�����������ҵ���е�ƽ������������
# ���Ҹ�ҵ�������������������¼����ͣ���ô��ҵ��Ϳɱ������ǻ�Ծҵ��
# ˼·,�������������ֵ��r��,�����activity_report��r��������,
# ����business_id���з������,����having��������>=2����
select business_id from activity_report as ar
left join (select event_type,avg(occurences) as avg_o from activity_report
group by event_type) as r
on ar.event_type = r.event_type
where ar.occurences > r.avg_o
group by business_id
having count(ar.event_type) >=2;

# 64.�û�����ƽ̨ *
# ����ÿ���ʹ���ֻ����û����� ʹ��������û��� ͬʱ ʹ������˺��ֻ��˵��û���������֧�����
# ˼·,��������,����ǽ�ʹ��ĳһ��ͻ��˵Ļ�,��ô�������ں��û�����ͳ������platformӦ�ü���=1,���ݸ���������
# �������sum(amount) ��count(user_id),���������Ļ�,��ȱʡû�м�¼ֵ�Ĳ���,
# ����Ҫ����һ��temp��(����������е�spend_date��platfrom��Ϣ)Ȼ���֮ǰ�����������(left join)
# ����ֵΪnull�Ĳ���Ϊ0����

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

# 65.����ļ�¼ II
# �ڱ�����Ϊ�������������У����Ƴ������ӵ�ÿ��ƽ��ռ�ȣ��������뵽С����� 2 λ��
# ˼·,���ȹ���ad_action��removal��,�����extram='spam'�����������ڷ���ͳ��������������ɾ����,����,Ȼ�����������ƽ��ֵ
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

# 66.��ѯ��30���Ծ�û���
#��ѯ������ 2019-07-27������2019-07-27������ 30���ÿ�ջ�Ծ�û���������ֻҪ��һ�����¼����Ϊ��Ծ�û���
# mysql��between������Եֵ(��Ϊ������)
select activity_date,count(distinct user_id) from activity_users
where activity_date between '2019/07/27'-interval 30 day  and '2019/07/27'
group by activity_date;

# 67.��ȥ30����û�� II
# ���ҽ���2019��7��27�գ�������30����ÿ���û���ƽ���Ự��
# һ�������Ļػ�����open~end
# ˼·,һ�������ػ�Ӧ����һ���û�id��Ӧһ���ػ�id�������״̬,���԰���user_id,session_id�������(activity_type)=3,
# ���ÿ���û�id�����ʵ�������ػ��ĻỰid��,����ڶԼ��������,�����û������ֵ
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

# 68.������� I
#  ��ѯ���ҳ�����������Լ����µ����ߣ�������� id ��������

select distinct v1.author_id as id from mydb.views as v1, mydb.views as v2
where v1.author_id = v2.viewer_id
order by id;

# 69.������� II
# ��ѯ���ҳ���ͬһ���Ķ�������ƪ���µ��ˣ�������� id ��������
select viewer_id as id from mydb.views
group by viewer_id
having COUNT(distinct article_id) >= 2;

# 70.�г����� I
# ��ѯÿ���û���ע�����ں��� 2019 ����Ϊ��ҵĶ�������
# ����whereɸѡ��λ��,�Լ�null�Ĵ���
select u.user_id as buyer_id ,join_date,count(order_id) as ord_in_2019 from user_registers as u
left join (select * from orders_info where year(order_date) = 2019) as r
on u.user_id = r.buyer_id
group by r.buyer_id, join_date;


# 71.�г����� II
# ������ 2019-08-16 ʱȫ����Ʒ�ļ۸񣬼������в�Ʒ���޸�ǰ�ļ۸��� 10��2
# ˼·,����ɸѡ��<2019-8-16�ļ�¼,������datediff(product_id,2019-8-16)�ͷ���ȡ��Сֵ����
# ͬʱ,��Ϊ�ñ��б�������޸ĺ������,���������������û�б��޸�,�򲻻�����ڸñ���,������Ҫ����һ��temp��������product_id,Ȼ��left join
# Ϊ�յĲ�����10���

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

# 72.ָ�����ڵĲ�Ʒ�۸� *
# ��ѯȷ��ÿһ���û�������˳�������ĵڶ�����Ʒ��Ʒ���Ƿ���������ϲ����Ʒ�ơ����һ���û���������������Ʒ����ѯ�Ľ���� no
# �����ű��������,�ô��ں����õ�ÿ�����ҵڶ��������Ĳ�Ʒid��Ʒ��,����user_favorite��õ��û���ϲ����Ʒ�Ʊ�,ʹ��
# where rnk =2 �õ�ÿ�����ҵڶ��������Ĳ�Ʒ��Ϣ����ϲ����Ʒ����Ϣ,���������ͬ,����
# Ϊ��֤�õ�����������Ϣ(�����Ƿ���۲�Ʒ,������Ҫ��user_favorite�������ұ�,
select user_id as seller_id,
       if(user_id in (select seller_id from (select seller_id,order_date,item_brand,favorite_brand,
       rank() over (partition by seller_id order by order_date) as rnk from order_favorite
           left join item i on order_favorite.item_id = i.item_id
           left join user_favorite uf on uf.user_id = order_favorite.seller_id)as r
       where r.rnk = 2 and item_brand = favorite_brand),'yes','no')as 2nd_item_fav_brand
from user_favorite;

# 73.��ʱʳ������ I
# .��ѯ����ȡ��ʱ������ռ�ı����� ������λС��
# ��ע,count�ڵ�if(����,���1,���2)��Ҫ���ó�1,0,��ΪcountҲ�����0������,�������ó�Null,
# ����count��if��Ƕ��ʹ��
select round(COUNT(if(order_date=cumtoer_per_deliver_date,1,null))/count(delivery_id)*100,2) as immediate_percentage
from delivery;

# 74.��ʱʳ������ II
# ��ѯ����ȡ��ʱ�����������û����״ζ����еı�����������λС����
# ����ͬ��������,��������Ҫ���ô��ں���ɸѡ�����е���������,Ȼ��������count+if�������ʱ����
select round(COUNT(if(order_date=cumtoer_per_deliver_date,1,null))/count(delivery_id)*100,2) as immediate_percentage
from (select order_date,cumtoer_per_deliver_date,delivery_id,customer_id,
       rank() over (partition by customer_id order by order_date)as rnk from delivery) as r
where r.rnk = 1;

# 75.���¸�ʽ�����ű�
# дһ�� SQL ��ѯ�����¸�ʽ����ʹ���µı�����һ������ id �к�һЩ��Ӧ ÿ���� �����루revenue����
# ��ת��
# ˼·,���취,��sumif�Ǳ���ÿ���ֶ�
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


# 76.ÿ�½��� I��date_format��
# ��дһ�� sql ��ѯ������ÿ���º�ÿ������/�����������������ܽ�����׼�������������ܽ�
# �������ں���date_format,�Լ�sum+if,count+if��ʹ��
select date_format(trans_date,'%Y-%m') as mon ,
       country,
       sum(amount) as total_amount ,
       sum(if(state='approved',amount,0)) as approved_total,
       count(id) as ct,
       count(if(state='approved',1,null)) as approved_ct from transactions
group by mon,country;

# 77.��������ʤ��
# ��ѯ������ÿ���еĻ�ʤ�ߡ����ƽ�֣�player_id ��С ��ѡ�ֻ�ʤ��
# ˼·,���Ƚ�playes��matches������,ʹ��if��case when�ҵ���ʤ�ߺ͵÷�,
# Ȼ����,���ô��ں�����group_id����,���÷�����,�ҳ�
# �ҳ�ͷ��
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

# 78.���һ���ܽ�����ݵ��ˣ��ۼ�/����/���ں�����
# ���������һ���ܽ�������Ҳ������������Ƶ� person_name ����Ŀȷ�������е�һλ���˿��Խ������ ��
# ����sum+over���ۼ����,Ȼ���ҵ�<=1000�ļ�¼,���������ҵ���ӽ�1000�ļ�¼����
select person_name from
(select person_name,sum(weight) over(order by turn) as sum_weight from queue)as r
where r.sum_weight <= 1000
order by sum_weight desc limit 1;

# 79.ÿ�½���II��union all��*
# ��ÿ���º�ÿ������/����������׼���׵����������ܽ��˵������������ܽ��
# �ֳ�������ͳ��,һ������approved����,һ�������˵�����,������month�ϲ�
# ����,��ôɾ������.
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



# 80.��ѯ�����������ռ��
# ����С�� 3 �Ĳ�ѯ���ռȫ����ѯ����İٷֱȡ�
# ����sql����,count+if
select query_name,
       round(avg((rating/position)),2) as quality,
       round(count(if(rating<3,1,null))/count(*)*100,2) as poor_query_percentage
from queries
group by query_name;

# 81.��ѯ��ӻ���
# ��ѯÿ���ӵ� team_id��team_name �� num_points��
# ������� num_points ����������������ӻ�����ͬ����ô�����Ӱ� team_id  ��������/
# ˼·,����ʤ��ƽ�������ͳ�����ֱ�(ʤ��һ��,ƽ����Ϊ˫������һ��,���Ե���Ϊһ�ű�()

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

# 82.����ϵͳ״̬���������ڣ�date_sub + over��
# ��ѯ 2019-01-01 �� 2019-12-31 �ڼ���������ͬ״̬ period_state ����ֹ���ڣ�start_date �� end_date����
# ���������ʧ���ˣ�����ʧ��״̬����ֹ���ڣ��������ɹ��ˣ����ǳɹ�״̬����ֹ����

# �ȼ��������״̬�µ���������
# Ȼ���շ����cls(ͳ����������)�ֶη����������,ȡ���ڵ���ֵ(�ǵ�havingɸѡ��ֻ��1��ļ�¼)
select type as period_state,min(date) as start_date,max(date) as end_date from
(select date,type,datediff(date,'2018/01/01')- rank() over (partition by type order by date) as cls from
(select fail_date as date,'failure' as type from failed
union all
select success_date as date,'succeed'as type from succeeded) as l)as l2
group by type,cls
having count(*) > 1;

# 83.ÿ�����ӵ�������
# ��д SQL ����Բ���ÿ�����ӵ���������
# ˼·,�����ҵ����е�����,Ȼ��͹����ÿ������id�������������
select distinct s.sub_id as post_id,ifnull(ct,0) as number_of_comments
from submissions as s
left join (
    select parent_id as sub_id ,count(distinct sub_id) as ct from submissions
    where parent_id is not null
    group by parent_id)as r
on s.sub_id = r.sub_id
where parent_id is null;

# 84.ƽ���ۼ�
# SQL��ѯ�Բ���ÿ�ֲ�Ʒ��ƽ���ۼ�
# ˼·,��������,Ȼ�󿨶���ʱ��,�����ʹ��ͳ�ƺ���
select u.product_id,round(sum(price*units)/sum(units),2) as average_price from unitssold as u
left join prices_avg pa on u.product_id = pa.product_id
where purchase_date between start_date and end_date
group by u.product_id;

# 85.ҳ���Ƽ���union��
# дһ��SQL��user_id = 1 ���û����Ƽ���������ϲ����ҳ�档��Ҫ�Ƽ����û��Ѿ�ϲ����ҳ��
# ˼·,��ɸѡ��user_id= 1���û�������id,��ͨ������id�ҵ�����ϲ����page_id�ٺ�user_id=1ϲ����idȡ�
# ע,��Ϊfriendship����ÿһ�ж�����һ�����ѹ�ϵ,����Ҫ���ǵ�user_1,user_2 =1�����,ͬʱ,������ĿҪ��,��Ҫ��user_id=1����ϲ��
# ��page_id�޳���ȥ

select distinct page_id as recommended_page from likes
where uer_id in (select * from
    (
    select if(user1_id=1,user2_id,if(user2_id=1,user1_id,NULL)) as id from friendship
    )as l1
    where l1.id is not null) and page_id not in (select distinct page_id from likes where uer_id = 1)
order by recommended_page;

# 86.��˾CEO�㱨������������
# SQL ��ѯ������ֱ�ӻ�����˾ CEO �㱨������ְ���� employee_id ��
# ˼·,�ּ���㱨��CEO��employee_idȻ��union all
# ������Ƕ�ײ�ѯ


select employee_id from (
#     1����
    select employee_id from employees_report where manage_id = 1 and employee_id <> 1
union all
#     2����
    select employee_id from employees_report
    where manage_id in (select employee_id
    from employees_report where manage_id = 1 and employee_id <> 1)
union all
# 3����
    select employee_id from employees_report
    where manage_id in (select employee_id from employees_report
    where manage_id in (select employee_id
    from employees_report where manage_id = 1 and employee_id <> 1))
) as r;


# 87.ѧ���ǲμӸ��Ʋ��ԵĴ���
# ��ѯ��ÿ��ѧ���μ�ÿһ�ſ�Ŀ���ԵĴ���������� student_id �� subject_name ����
# ����ѿ�����
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

# 88.�ҵ���������Ŀ�ʼ�ͽ������֣�dense_rank����������
# ��ѯ�õ� Logs ���е���������Ŀ�ʼ���ֺͽ������֡�
# ˼·,�������ô��ں��������������������,Ȼ���մ��ں���,����Ӷ��ҳ�����������ֵ,��Ϊ������������Ŀ�ʼ,����ֵ
select min(log_id) as start_id,max(log_id) as end_id
from(select log_id,log_id - rank() over (order by log_id) as rnk from logs_a
)as r
group by rnk;

# 89.��ͬ���ҵ���������
# �ҵ�����ÿ�������� 2019 �� 11 �µ��������͡�
# ����if��SQLͳ�ƺ�����ʹ��,���Ȱ���Ҫ�������country_id����������,Ȼ���countries����,��Ӧ��������
select c.country_name,l.weather_type from (
    select country_id,
           if(avg(weather_state)>=25,'Hot',if(avg(weather_state)>15,'Warm','Cold')) as  weather_type
    from weather_c
    where month(day) = 11
    group by country_id) as l
left join countries as c
on l.country_id = c.country_id;

# 90.���Ŷ�����
# ���ÿ��Ա�������Ŷӵ���������
# ˼·,���ȹ����ÿ���Ŷӵ�����temp��,Ȼ��͹�Ա���������
select et.employee_id,ct as team_size from employee_total as et
left join (
    select team_id,count(*) as ct from employee_total group by team_id)as r
on et.team_id = r.team_id;

# 91.��ͬ�Ա�ÿ�շ����ܼƣ��ۼ�/����/���ں�����
# ��ѯÿ���Ա���ÿһ����ܷ֣������Ա�����ڶԲ�ѯ�������
# ����sum+���ں���ʵ�ַ����ۼ����
select gender,day,sum(score_points) over (partition by gender order by day) as total from score_bysex;

# 92.�͹�Ӫҵ��仯������over���ں�����
# дһ�� SQL ��ѯ������ 7 �죨ĳ���� + ������ǰ�� 6 �죩Ϊһ��ʱ��εĹ˿�����ƽ��ֵ
# ����1,����ѿ�����,Ȼ������,ɸ�����ڷ���Ҫ��0<=(date1-date2)<7������,����ټ��������ֶ�
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

# ���ں���
# LAG(<expression>[,offset[, default_value]]) OVER (
#     PARTITION BY expr,...
#     ORDER BY expr [ASC|DESC],...
# )
# LAG()��������expression��ǰ��֮ǰ���е�ֵ����ֵΪoffset ������������е�������
# rows between ...  and ... ��˼�ǣ���XXX֮ǰ��XXX֮������м�¼
select visited_on,ant,
       lag(visited_on,6) over (order by visited_on) lg,
       sum(ant) over (order by visited_on rows between 6 preceding and current row ) as amount
from (
select visited_on,sum(amount) ant from customer_by7day
group by visited_on order by visited_on) as t1;

# 93.���Ч��
# ��ѯÿһ������ ctr
# ����count+if,�Լ�SQLͳ�ƺ���
select ad_id,
       ifnull(round(count(if(action='Clicked',1,null))/count(if(action<>'Ignored',1,null))*100,2),0) as ctr
from ads
group by ad_id;

# 94.�г�ָ��ʱ��������е��µ���Ʒ
# ��ȡ�� 2020 �� 2 �·��µ������������� 100 �Ĳ�Ʒ�����ֺ���Ŀ��
# ����������
select py.product_name,ut
from (select product_id,sum(unit) as ut from orders_y
where month(order_date) = 02
group by product_id
having ut >=100) as r
left join products_y as py
on  r.product_id = py.product_id;

# 95.ÿ�η��ʵĽ��״���
#  ��ѯ���ٿͻ����������е�û�н����κν��ף����ٿͻ����������н�����һ�ν��׵ȵ�
select transactions_count,ifnull(visit_ct,0) as ct from(select 0 transactions_count
union all
# ��Ϊ��������max�϶����ᳬ�����ױ������,����ֱ�Ӱ��ñ���������������(��Ϊȱʧ��0��,������ҪUnion��)
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

# 96.��Ӱ����
# �������۵�Ӱ���������û������������ƽ�֣������ֵ����С���û�����
# ���ȹ����ÿ���û��ĵ�Ӱ������,Ȼ����û������,ɸѡ��ӦƸ����,(��Ϊ���ܴ�����ͬ�����,���Դ��ں���)
# ���ȡid��С�ļ���
select um.name from (
select user_id,rank() over (order by count(movie_id) desc) as rnk from movie_rating
group by user_id
order by user_id
)as l
left join user_movies as um
on l.user_id = um.user_id
where l.rnk =1
having min(l.user_id);
# 96.��Ӱ����plus
# ������ 2020 �� 2 �� ƽ��������� �ĵ�Ӱ���ơ��������ƽ�֣������ֵ����С�ĵ�Ӱ���ơ�
# ����ͬ��
select ma.movie_title from(
select movie_id,rank() over (order by avg(rating) desc) as rnk from Movie_Rating
where date_format(create_at,'%Y-%m') = '2020-02'
group by movie_id
)as l
left join movies_a as ma
on l.movie_id = ma.movie_id
where l.rnk =1
having min(l.movie_id);

# 97.Ժϵ��Ч��ѧ��
# ��ѯ��Щ����Ժϵ�����ڵ�ѧ���� id ������
select id, name from student_info
where department_id not in (select deparments_info.id from deparments_info);

# 98.������ߣ�any������
# SQL ��ѯ��Щ��û����࣬Ҳû�����ٲ����ߵĻ������
# ˼·,�ҵ��������ٵ�,Ȼ��pass������(���ں�����������,����,���򶼲�����һ,��Ϊ����ֵ),
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

# 99.�˿͵Ŀ�����ϵ������
# Ϊÿ�ŷ�Ʊ invoice_id ��дһ��SQL��ѯ�Բ����������ݣ�
# customer_name���뷢Ʊ��صĹ˿����ơ�
# price����Ʊ�ļ۸�
# contacts_cnt���ù˿͵���ϵ��������
# trusted_contacts_cnt��������ϵ�˵����������Ǹù˿͵���ϵ�������̵�˿͵���ϵ������������������ϵ�˵ĵ����ʼ������ڿͻ����У���
# ����ѯ�Ľ������ invoice_id ����
# �ֳ�������,��һ����Ϊ��Ʊ��Ϣ,(invoice_id,customer_name,price)
# �ڶ�����Ϊ��ϵ������
# ��������Ϊ������ϵ������
# ������������
select invoice_id,customer_name,price,ifnull(contacts_cnt,0),ifnull(trusted_contacts_cnt,0)
from(
    select invoice_id,customer_name,price,user_id from invoices as i left join customers_info as ci
        on i.user_id = ci.customer_id) as s1
left join (select user_id,count(*) as contacts_cnt  from Contacts group by user_id) as s2
    on s1.user_id = s2.user_id
left join (select user_id,count(*) as trusted_contacts_cnt from contacts,customers_info
where contacts.contact_email = customers_info.email group by user_id)as s3
    on s2.user_id=s3.user_id;

# 100.��ȡ����ڶ��εĻ��over���ں�����
# дһ��SQL��ѯչʾÿһλ�û�����ڶ��εĻ
# ˼·,��������,��һ����,������Ŀ>=2��,���տ�ʼʱ��ͽ���ʱ��ֱ������ڶ�ɸѡ����,Ȼ���ٰ�ֻ��һ�εĲ��ָ�Union����
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

# 101.ʹ��Ψһ��ʶ���滻Ա��ID
# չʾÿλ�û��� Ψһ��ʶ�루unique ID �������ĳλԱ��û��Ψһ��ʶ�룬ʹ�� null ��伴�ɡ�
# �����������
select unique_id,name from employees_unique as eu left join employeeuni as e
on eu.id = e.id
order by unique_id;

# 102.������г������ܶ�
# ��ѯÿ����Ʒÿ��������۶������ product_id, product_name �Լ� report_year ����Ϣ��
# ˼·,�ֳ������������
# ���翼��2018������ݵ�,�����ʵʱ��>='2018/01/01'�������ʼʱ��,����'2018/01/01'����
# �������ʱ��<='2018/12/31'��,�򰴽���ʱ�����,����'2018/12/31'����
# ����2019,2020��ͬ��,�������union����

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

# 103.��Ʊ���ʱ�����
# дһ��SQL��ѯ������ÿ֧��Ʊ���ʱ����档
#����SUM+IF �������
select
       stock_name,
       sum(if(operation='Sell',price,0)) - sum(if(operation='Buy',price,0)) as capital_gain_loss
from stocks
group by stock_name;

# 104.�����˲�ƷA�Ͳ�ƷBȴû�й����ƷC�Ĺ˿�
# ��ѯ�����湺���˲�Ʒ A �Ͳ�Ʒ B ȴû�й����Ʒ C �Ĺ˿͵� ID ��
# ������ customer_id �� customer_name �������ǽ����ڴ˽��Ϊ�����Ƽ���Ʒ C ��
# Ƕ�ײ�ѯ �ҵ�������A���û�id,������Щ�û�idɸѡ������B���û�,������Щ�û������ҵ�û�й���C��
# ������AB���������ABC,ʣ�µľ���AB(��C)
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

# 105.������ǰ��������
# дһ��SQL,����ÿ���û������о���.
select name,ifnull(sum(distance),0) as dist from users_dist as ud
left join rides_dist as rd
on ud.id = rd.user_id
group by name
order by dist desc ,name;

# 106.���ҳɼ��������ε�ѧ��
# �ҳ������в����ж��������ε�ѧ�� (student_id, student_name)��
# ˼·,ԭ���Ǵ���ֱ���ҵ����гɼ����ε�ѧ��,���Ǻ������ִ���ֱ�������ŵ�ѧ��,���Ի���˼·,�ҵ���߷�,��ͷֵ�ѧ��id,
# �����вμӿ��Ե�ѧ��id���ų����ⲿ��ѧ��,Ȼ���ٺ�ѧ�������,����

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

# 107.����ֵ��ѯ
# �ҵ� Queries ����ÿһ�β�ѯ�ľ���ֵ.
select qn.*,ifnull(npv,0)
from queries_npv as qn left join npv n
on qn.year = n.year and qn.id = n.id;

# 108.�����Ự��״ͼ
# Write an SQL query to report the (bin, total) in any order.
# ˼·,�ֶ���������������ļ�¼,Ȼ��union�ϲ�
select '[0-5>' as bin,count(if(duration/60 >=0 and duration/60<5 ,1,null)) as total from sessions
union
select '[5-10>' as bin,count(if(duration/60 >=5 and duration/60<10 ,1,null)) as total from sessions
union
select '[10-15>' as bin,count(if(duration/60 >=10 and duration/60< 15 ,1,null)) as total from sessions
union
select '15 or more' as bin,count(if(duration/60 >=15,1,null)) as total from sessions;

# 109.���㲼�����ʽ��ֵ��case when then else end��
# Write an SQL query to evaluate the boolean expressions in Expressions table.
# ����case when��Ƕ��ʹ��
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


# 110.ƻ���ͽ���
# ����ÿһ�� ƻ�� �� ���� ���۵���Ŀ�Ĳ���.
# ����sum+if�������
select
       sale_date,
       sum(if(fruit='apples',sold_num,0))-sum(if(fruit='oranges',sold_num,0)) as diff from fruits_sales
group by sale_date;

# 111.��Ծ�û�������dense_rank����������
# 108.Write an SQL query to find the id and the name of active users.
# ������β�ѯ��������,(ʹ�ô��ں�����id���з���,����������)Ȼ��ʹ��date�������,���������������,���ֵ��Ӧ���,
# Ȼ����id��diff_date����ͳ��,�õ���������ʱ��ĳ���,ȡ>=5�ļ���
select
       r.id,ac.name
from (select id,login_date,
       datediff(login_date,'2020/1/1')-rank() over (partition by id order by login_date) as cday
from logins) as r left join accounts as ac
on r.id = ac.id
group by id, cday
having count(*) >= 5;

# 112.�������
#  �����ɱ���������������γɵ����п��ܵľ���.
select p1.id,p2.id,abs((p2.y_value-p1.y_value)*(p2.x_value-p1.x_value)) as area  from points as p1,points as p2
where  p1.id < p2.id and p1.x_value<>p2.x_value and p1.y_value<>p2.y_value
order by area desc,p1.id,p2.id;

# 113.����˰����
# ��������˾Ա����߹��ʲ��� 1000 ��˰��Ϊ 0%
# ��������˾Ա����߹����� 1000 �� 10000 ֮�䣬˰��Ϊ 24%
# ��������˾Ա����߹��ʴ��� 10000 ��˰��Ϊ 49%
# ������˳�򷵻ؽ����˰���ʽ��ȡ��
# ˼·,��������˾��߹��ʵ�temp��,Ȼ���ԭ��������,���ʹ��if�ж�

select st.company_id,employee_id,employee_name,
       if(m_salary<=1000,salary,if(m_salary<=10000,salary*0.76,salary*0.51)) as salary
from salaries_tax as st
left join (
    select company_id ,max(salary) as m_salary from salaries_tax
group by company_id)as r
on st.company_id = r.company_id;

# 114.����ÿ������������dayname���ڼ���
# dayname ��������Ӣ�����ڼ���dayofweek���صڼ��죬������1
# date_format + %w�����췵�� 0��%W������Ӣ�����ڼ�
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

# 115.�����ڷ������۲�Ʒ
# group_concat()
# group by ������ͬһ�������е�ֵ��������������һ���ַ��������
# �﷨��group_concat( [distinct] Ҫ���ӵ��ֶ� [order by �����ֶ� asc/desc ] [separator '�ָ���'] )
# distinct����ȥ�أ�order by�Ӿ� ����separator��һ���ַ���ֵ��ȱʡΪһ������
select sell_date,
       count(distinct product) as num_sold ,
       group_concat(distinct product) as products from activities_c
group by sell_date;

# 116.Friendly Movies Streamed Last Month
# Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.
select distinct title from tvprogram
left join content c on tvprogram.content_id = c.content_id
where content_type='movies' and Kids_content='Y' and  date_format(program_date,'%Y-%m')='2020-06';

# 117.���Է���Ͷ�ʵĹ���
# �ù�˾��ҪͶ�ʵĹ�����: �ù���ƽ��ͨ��ʱ��Ҫ�ϸ�ش���ȫ��ƽ��ͨ��ʱ��.
# дһ�� SQL, �ҵ����иù�˾����Ͷ�ʵĹ���.
# ����������,��1Ϊ�������ҵ�ƽ��ͨ��ʱ��,��2Ϊ���й��ҵ�ƽ��ͨ��ʱ��(��������,��Ҫ��celler_id ��cellee_id�����ֶκϲ�,ͳ��duration,Ȼ����
# �ֿ�������������ع��ҵ�duration

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
# ����6,7�µ������Ѷ�>=100�ļ�¼,��date_formate,�Լ�sum��ֵ,����customer_f�����,�ҵ��û�������,
# ������=2(��Ϊ6,7�¶����ڼ�¼�Ļ�,����=2)
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

# 119.Find Users With Valid E-Mails��������ʽ��
# ^ ��ʾ��ͷ
# + ƥ��һ������,��������
# [] ��ʾ�����������һ��
# \\ ����ת�������ַ�
# a{m,n} ƥ��m��n��a����಻дΪ0���Ҳ಻дΪ����
# $ ��ʾ��ʲôΪ��β
# regexp + pattern ʹ��������ʽƥ��

select * from users_regex
where mail regexp '^[a-zA-Z]+[0-9a-zA-Z\.\\-]*@leetcode.com$';


# 120.Patients With a Condition��like��
# Write an SQL query to report the patient_id, patient_name all conditions of patients
# who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix

# mysql ͨ���
# %���ٷֺţ���_���»��ߣ�����ͨ�����%��ʾ�κ��ַ������������(������0��)��_��ʾ�����ַ�
select * from patients
where conditions like '%DIAB1%';

# 121.The Most Recent Three Orders��dense_rank + over���ں�����
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

# 122.Fix Product Name Format��trimȥ�ո�+upper/lower��Сд��
# MYSQL���ı�����
# ��дupper\ucase,Сдlower\lcase
# trimȥ���ո�ltrim��rtrimֻȥ���������Ҳ�ո�
select
    product_name,sale_date,count(*)
from (select
       lcase(trim(product_name)) as product_name,
       date_format(sale_date,'%Y/%m') as sale_date
from sales_upper
)as r
group by product_name, sale_date;

# ֱ�ӻ��ܵĻ�,��Ϊ���ƴ��ڳ�ͻ,����MYSQL��Ĭ��Ϊ��ԭ�����ֶ���,�����������ԭ�ȵ�,����
select
       lcase(trim(product_name)) as product_name,
       date_format(sale_date,'%Y/%m') as sale_date,
       count(*)
from sales_upper
group by product_name,sale_date;

# Ҫô���������ֶ�(Ҫô��Ƕ�ײ�ѯ)
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