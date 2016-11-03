Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
For example, given the above Scores table, your query should generate the following report (order by highest score):

+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+

# Write your MySQL query statement below
#####################SQL SERVER########################
SELECT Score, DENSE_RANK () OVER (PARTITION BY Id ORDER BY Score DESC) AS Rank
	FROM Scores
	GROUP BY Id;

#####################MY SQL########################
With Variables: 841 ms

First one uses two variables, one for the current rank and one for the previous score.

SELECT
  Score,
  @rank := @rank + (@prev <> (@prev := Score)) Rank
FROM
  Scores,
  (SELECT @rank := 0, @prev := -1) init
ORDER BY Score desc
#####################MY SQL########################
Always Count: 1322 ms
This one counts, for each score, the number of distinct greater or equal scores.

SELECT
  Score,
  (SELECT count(distinct Score) FROM Scores WHERE Score >= s.Score) Rank
FROM Scores s
ORDER BY Score desc
#####################MY SQL########################
Always Count, Pre-uniqued: 795 ms

Same as the previous one, but faster because I have a subquery that "uniquifies" the scores first. Not entirely sure why it's faster, I'm guessing MySQL makes tmp a temporary table and uses it for every outer Score.

SELECT
  Score,
  (SELECT count(*) FROM (SELECT distinct Score s FROM Scores) tmp WHERE s >= Score) Rank
FROM Scores
ORDER BY Score desc
#####################MY SQL########################
Filter/count Scores^2: 1414 ms

Inspired by the attempt in wangkan2001's answer. Finally Id is good for something :-)

SELECT s.Score, count(distinct t.score) Rank
FROM Scores s JOIN Scores t ON s.Score <= t.score
GROUP BY s.Id
ORDER BY s.Score desc
#####################MY SQL########################
select Score,Rank from 
(
SELECT Score,
       CASE
           WHEN @dummy <=> Score THEN @Rank := @Rank 
           ELSE @Rank := @Rank +1
	END AS Rank,@dummy := Score as dummy
FROM
  (SELECT @Rank := 0,@dummy := NULL) r,
     Scores
ORDER BY Score DESC
) AS C
#####################MY SQL########################
SELECT Scores.Score AS Score, IFNULL(q3.Rank, 0)+1 AS Rank
    FROM Scores
    LEFT JOIN 
         (SELECT q1.Score AS Score, COUNT(*) AS Rank
            FROM (SELECT DISTINCT Scores.Score AS Score
                    FROM Scores
                    ORDER BY Score DESC) AS q1
            JOIN
                 (SELECT DISTINCT Scores.Score AS Score
                    FROM Scores
                    ORDER BY Score DESC) AS q2
            ON q1.Score < q2.Score
            GROUP BY Score
            ORDER BY Score DESC) AS q3
    ON q3.Score = Scores.Score
    ORDER BY Score DESC
#####################MY SQL########################   
SELECT T2.Score Score, (SELECT COUNT(*) + 1 FROM (SELECT T1.Score FROM Scores T1 GROUP BY Score ORDER BY Score DESC) TEMP WHERE T2.Score < TEMP.Score) Rank FROM Scores T2 ORDER BY Score DESC;
