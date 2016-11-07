# leetcode_sql
Write a SQL query to get the nth highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the nth highest salary where n = 2 is 200.
If there is no nth highest salary, then the query should return null.
##########################################################
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  set N = N-1;
  RETURN (
      select distinct Salary
      from Employee
      order by Salary desc
      limit N, 1
  );
END
##########################################################
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      select Salary
      from
      (
          select Salary, (@rank := @rank + 1) as rank
          from
          (
              select distinct Salary
              from Employee
              order by Salary desc
          ) A, (select @rank := 0) as Init
      ) as t
      where rank = N
  );
END
##########################################################
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN 
  RETURN (
  SELECT e1.Salary
FROM (SELECT DISTINCT Salary FROM Employee)e1
WHERE (
  SELECT COUNT(Salary) FROM (SELECT DISTINCT Salary FROM Employee)e2 WHERE e1.Salary<e2.Salary
  )=N-1
LIMIT 1
  );
END
