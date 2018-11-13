select distinct s1.StuId 
from tblScore s1, tblScore s2
where s1.StuId=s2.StuId and s1.CourseId='001' and s2.CourseId='002' and s1.Score>s2.score;

select StuId, avg(Score)
from tblScore
group by StuId
having avg(Score) > 60;

select s.StuId, s.StuName,count(sc.CourseId)  , sum(sc.Score) 
from tblStudent s, tblScore sc
where s.StuId=sc.StuId
group by s.StuId;

select count(teaId)
from tblTeacher
where TeaName like '李%';

select distinct StuId, StuName 
from tblStudent 
where StuId not in (select distinct s.StuId 
from tblStudent s, tblTeacher t, tblCourse c, tblScore sc
where s.StuId = sc.StuId and c.CourseId=sc.CourseId and c.TeaId=t.TeaId and  t.TeaName='叶平');

select distinct s1.StuId, s1.StuName 
from tblStudent s1, tblStudent s2, tblScore sc
where sc.CourseId='001' and s1.StuId= sc.StuId and s1.StuId
in (select s1.StuId 
from tblStudent s1, tblScore sc
where sc.CourseId='002' and s1.StuId= sc.StuId);

select course.StuId, course.StuName
from 
(select s.StuId, s.StuName, count(c.CourseId) num
from tblStudent s, tblCourse c, tblScore sc, tblTeacher t
where sc.StuId = s.StuId and c.CourseId = sc.CourseId  and   c.TeaId=t.TeaId and t.TeaName = '叶平'
group by s.StuId) course
where course.num = 
(select count(c.CourseId) total from tblCourse c, tblTeacher t where t.TeaId = c.TeaId and t.TeaName = '叶平')  
or  course.num >
(select count(c.CourseId) total from tblCourse c, tblTeacher t where t.TeaId = c.TeaId and t.TeaName = '叶平');

select distinct s.StuId, s.StuName 
from tblStudent s, tblScore sc1, tblScore sc2 
where s.StuId = sc1.StuId and sc1.StuId = sc2.StuId and sc1.CourseId = '001' and sc2.CourseId = '002' and sc2.Score < sc1.Score;

select s.StuId, s.StuName, sum(sc.Score) total_score
from tblStudent s, tblScore sc 
where s.StuId = sc.StuId 
group by s.StuId
having total_score < 60;  

select distinct s.StuId, s.StuName
from tblStudent s, 
(select count(c.CourseId) num from tblCourse c group by c.CourseId) course, 
(select sc.StuId, sc.CourseId, count(sc.CourseId) num from tblScore sc group by sc.StuId) person_course 
where course.num != person_course.num and s.StuId = person_course.StuId;

select distinct s.StuId, s.StuName
from tblStudent s, tblScore sc
where s.StuId = sc.StuId and sc.CourseId in 
(select sc.CourseId from tblScore sc where sc.StuId = '1001');

select distinct s.StuId, s.StuName
from tblStudent s, tblScore sc
where not exists (select sc.CourseId from tblScore sc where sc.StuId = '1001')
not  in (select sc.CourseId from tblScore sc where sc.StuId = s.StuId) and s.StuId = sc.StuId;

update tblScore sc1 set sc1.Score = 
(select avg(sc.Score) from tblScore sc where sc1.StuId = sc.StuId) 
where exists
(select sc.StuId from  tblCourse c, tblTeacher t
where t.TeaName = '叶平' and t.TeaId = c.TeaName  and sc1.CourseId = c.CourseId);

select distinct s.StuId, s.StuName
from tblStudent s, tblScore sc
where not exists (select sc.CourseId from tblScore sc where sc.StuId = '1002')
not in (select sc.CourseId from tblScore sc where sc.StuId = s.StuId) and s.StuId = sc.StuId;

delete from tblScore  
where exists 
(select c.CourseId from tblCourse c, tblTeacher t where t.TeaId = c.TeaId and t.TeaName = '叶平')

select avg(sc.Score) from tblScore sc where sc.CourseId = '002'

select s1.StuId,
(select sc.Score from tblScore sc, tblCourse c, tblStudent s where c.CourseName = '数据库' and c.CourseId = sc.CourseId and s.StuId = sc.StuId and s.StuId = s1.StuId) as db,
(select sc.Score from tblScore sc, tblCourse c, tblStudent s where c.CourseName = '企业管理' and c.CourseId = sc.CourseId and s.StuId = sc.StuId and s.StuId = s1.StuId) as manegement,
(select sc.Score from tblScore sc, tblCourse c, tblStudent s where c.CourseName = '英语' and c.CourseId = sc.CourseId and s.StuId = sc.StuId and s.StuId = s1.StuId) as english,
avg(sc.Score) avg_score
from tblStudent s1, tblScore sc 
where s1.StuId = sc.StuId
group by s1.StuId
order by avg_score desc;

select c.CourseId, max(sc.Score) max_core, min(sc.Score) min_score
from tblCourse c, tblScore sc
where c.CourseId = sc.CourseId
group by c.CourseId;

select management as management_avg, MaxCourse as MaxCourse_avg, UML as UML_avg, DB as DB_avg,
manage_pass/manage_all as manage_pass_per, max_pass/max_all as max_pass_per, uml_pass/uml_all as uml_pass_per,
 db_pass/db_all as db_pass_per
from (select avg(sc.Score)management
from tblScore sc, tblCourse c
where c.CourseId = '001' and c.CourseId = sc.CourseId 
group by sc.CourseId) management,
(select avg(sc.Score) MaxCourse
from tblScore sc, tblCourse c 
where c.CourseId = '002' and c.CourseId = sc.CourseId 
group by sc.CourseId) MaxCourse,
(select avg(sc.Score) UML
from tblScore sc, tblCourse c 
where c.CourseId = '003' and c.CourseId = sc.CourseId 
group by sc.CourseId) UML,
(select avg(sc.Score)  DB
from tblScore sc, tblCourse c 
where c.CourseId = '004' and c.CourseId = sc.CourseId 
group by sc.CourseId) DB,
(select count(sc.Score) manage_all
from tblScore sc, tblCourse c
where sc.CourseId = c.CourseId and c.CourseId = '001' 
group by sc.CourseId) manage_all,
(select count(sc.Score) max_all
from tblScore sc, tblCourse c
where sc.CourseId = c.CourseId and c.CourseId = '002' 
group by sc.CourseId) max_all,
(select count(sc.Score) uml_all
from tblScore sc, tblCourse c
where sc.CourseId = c.CourseId and c.CourseId = '003'
group by sc.CourseId) uml_all,
(select count(sc.Score) db_all
from tblScore sc, tblCourse c
where sc.CourseId = c.CourseId and c.CourseId = '004' 
group by sc.CourseId) db_all,
(select count(sc.Score) manage_pass
from tblScore sc, tblCourse c
where sc.CourseId = c.CourseId and c.CourseId = '001' and sc.Score >= 60
group by sc.CourseId) manage_pass,
(select count(sc.Score) max_pass
from tblScore sc, tblCourse c
where sc.CourseId = c.CourseId and c.CourseId = '002' and sc.Score >= 60
group by sc.CourseId) max_pass,
(select count(sc.Score) uml_pass
from tblScore sc, tblCourse c
where sc.CourseId = c.CourseId and c.CourseId = '003' and sc.Score >= 60
group by sc.CourseId) uml_pass,
(select count(sc.Score) db_pass
from tblScore sc, tblCourse c
where sc.CourseId = c.CourseId and c.CourseId = '004' and sc.Score >= 60
group by sc.CourseId) db_pass

select c.CourseId, c.CourseName, c.TeaId, avg(sc.Score) as score
from tblCourse c, tblScore sc 
where sc.CourseId = c.CourseId
group by c.CourseId, c.TeaId
order by score desc;

select s1.StuId, s1.StuName,
(select sc.Score from tblScore sc, tblCourse c, tblStudent s where c.CourseName = '数据库' and c.CourseId = sc.CourseId and s.StuId = sc.StuId and s.StuId = s1.StuId) as db,
(select sc.Score from tblScore sc, tblCourse c, tblStudent s where c.CourseName = '企业管理' and c.CourseId = sc.CourseId and s.StuId = sc.StuId and s.StuId = s1.StuId) as manegement,
(select sc.Score from tblScore sc, tblCourse c, tblStudent s where c.CourseName = '英语' and c.CourseId = sc.CourseId and s.StuId = sc.StuId and s.StuId = s1.StuId) as english,
avg(sc.Score) avg_score
from tblStudent s1, tblScore sc 
where s1.StuId = sc.StuId
group by s1.StuId
order by avg_score desc
limit 3 , 6;

select score.StuId,  score.avg_score,@rownum := @rownum + 1 AS rownum
from (select  sc.StuId, avg(sc.Score) avg_score from tblScore sc
group by StuId
order by avg_score desc) score, (select @rownum:=0) q;

