The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, Max has the highest salary in the IT department and Henry has the highest salary in the Sales department.

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+

# Write your MySQL query statement below

SELECT dep.Name as Department, emp.Name as Employee, emp.Salary 
from Department dep, Employee emp 
where emp.DepartmentId=dep.Id 
and emp.Salary=(Select max(Salary) from Employee e2 where e2.DepartmentId=dep.Id)

# Write your MySQL query statement below
select p.dName as Department, em.Name as Employee, em.Salary
from Employee em,
(
select d.Id as dId, d.Name as dName, max(e.Salary) as maxSalary
from Employee e, Department d
where e.DepartmentId = d.Id
group by e.DepartmentId
) p
where em.DepartmentId = p.dId and em.Salary = p.maxSalary
