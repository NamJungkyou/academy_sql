-- 남정규lab03


-- 실습 15)
SELECT e.empno 사원번호
     , e.ename 이름
     , e.sal 급여
     , decode(e.job, 'CLERK', to_char(300, '$9,999')
                 , 'SALESMAN', to_char(450,'$9,999')
                 , 'MANAGER', to_char(600, '$9,999')
                 , 'ANALYST', to_char(800, '$9,999')
                 , 'PRESIDENT', to_char(1000, '$9,999')
            ) as "자기 계발비"
  FROM emp e
;
-- 실습 16)