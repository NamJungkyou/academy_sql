--1. employees 테이블에서 job_id 를 중복 배제하여 조회 하고
--   job_title 같이 출력
--19건
SELECT DISTINCT e.job_id
              , j.job_title
  FROM employees e JOIN jobs j
    ON e.job_id = j.job_id
;
/*
JOB_ID, JOB_TITLE
--------------------------------------
AD_ASST	Administration Assistant
SA_REP	Sales Representative
IT_PROG	Programmer
MK_MAN	Marketing Manager
AC_MGR	Accounting Manager
FI_MGR	Finance Manager
AC_ACCOUNT	Public Accountant
PU_MAN	Purchasing Manager
SH_CLERK	Shipping Clerk
FI_ACCOUNT	Accountant
AD_PRES	President
SA_MAN	Sales Manager
MK_REP	Marketing Representative
AD_VP	Administration Vice President
PU_CLERK	Purchasing Clerk
ST_MAN	Stock Manager
ST_CLERK	Stock Clerk
HR_REP	Human Resources Representative
PR_REP	Public Relations Representative
*/

--2. employees 테이블에서 사번, 라스트네임, 급여, 커미션 팩터,
--   급여x커미션팩터(null 처리) 조회
--   커미션 컬럼에 대해 null 값이면 0으로 처리하도록 함
--107건
SELECT e.employee_id 사번
     , e.last_name 라스트네임
     , e.salary 급여
     , nvl(e.commission_pct, 0) as "커미션 팩터"
     , e.salary * nvl(e.commission_pct, 0) as "급여x커미션팩터"
  FROM employees e
;
/*
사번, 라스트네임, 급여, 커미션 팩터, 급여x커미션팩터
----------------------------------------------------------------
100	King	24000	0	0
101	Kochhar	17000	0	0
.
.
.

149	Zlotkey	10500	0.2	2100
150	Tucker	10000	0.3	3000
151	Bernstein	9500	0.25	2375
152	Hall	9000	0.25	2250
153	Olsen	8000	0.2	1600
154	Cambrault	7500	0.2	1500
155	Tuvault	7000	0.15	1050
156	King	10000	0.35	3500
157	Sully	9500	0.35	3325
158	McEwen	9000	0.35	3150
.
.
.
204	Baer	10000	0	0
205	Higgins	12008	0	0
206	Gietz	8300	0	0
*/

--3. employees 테이블에서 사번, 라스트네임, 급여, 커미션 팩터(null 값 처리) 조회
--   단, 2007년 이 후 입사자에 대하여 조회, 고용년도 순 오름차순 정렬
--30건
SELECT e.employee_id 사번
     , e.last_name 라스트네임
     , e.salary 급여
     , nvl(e.commission_pct, 0) as "커미션 팩터"
  FROM employees e
 WHERE e.hire_date > to_date('07/01/01','YY/MM/DD')
 ORDER BY e.hire_date
;
/*
사번, 라스트네임, 급여, 커미션 팩터
------------------------------------
127	Landry	2400	0
107	Lorentz	4200	0
187	Cabrio	3000	0
171	Smith	7400	0.15
195	Jones	2800	0
163	Greene	9500	0.15
172	Bates	7300	0.15
132	Olson	2100	0
104	Ernst	6000	0
178	Grant	7000	0.15
198	OConnell	2600	0
182	Sullivan	2500	0
119	Colmenares	2500	0
148	Cambrault	11000	0.3
124	Mourgos	5800	0
155	Tuvault	7000	0.15
113	Popp	6900	0
135	Gee	2400	0
191	Perkins	2500	0
179	Johnson	6200	0.1
199	Grant	2600	0
164	Marvins	7200	0.1
149	Zlotkey	10500	0.2
183	Geoni	2800	0
136	Philtanker	2200	0
165	Lee	6800	0.1
128	Markle	2200	0
166	Ande	6400	0.1
167	Banda	6200	0.1
173	Kumar	6100	0.1
*/

--4. Finance 부서에 소속된 직원의 목록 조회
--조인으로 해결
SELECT e.employee_id
     , e.first_name
     , e.last_name
     , e.department_id
  FROM employees e JOIN departments d
    ON e.department_id = d.department_id
 WHERE d.department_name = 'Finance'
;
/*
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID
----------------------------------------------------
108	Nancy	Greenberg	100
109	Daniel	Faviet	100
110	John	Chen	100
111	Ismael	Sciarra	100
112	Jose Manuel	Urman	100
113	Luis	Popp	100
*/

--서브쿼리로 해결
SELECT e.employee_id
     , e.first_name
     , e.last_name
     , e.department_id
  FROM employees e
 WHERE e.department_id = (SELECT d.department_id
                            FROM departments d
                           WHERE d.department_name = 'Finance')
;
/*
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID
----------------------------------------------------
108	Nancy	Greenberg	100
109	Daniel	Faviet	100
110	John	Chen	100
111	Ismael	Sciarra	100
112	Jose Manuel	Urman	100
113	Luis	Popp	100
*/
--6건
 
--5. Steven King 의 직속 부하직원의 모든 정보를 조회
--14건
-- 조인 이용
SELECT e1.EMPLOYEE_ID 
     , e1.FIRST_NAME 
     , e1.LAST_NAME 
     , e1.EMAIL 
     , e1.PHONE_NUMBER 
     , e1.HIRE_DATE 
     , e1.JOB_ID 
     , e1.SALARY 
     , e1.COMMISSION_PCT 
     , e1.MANAGER_ID 
     , e1.DEPARTMENT_ID
  FROM employees e1 JOIN employees e2
    ON e1.manager_id = e2.employee_id
 WHERE e2.first_name = 'Steven'
   AND e2.last_name = 'King'
;
/*
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
------------------------------------------------------------------------------------------------------------------------------
101	Neena	Kochhar	NKOCHHAR	515.123.4568	05/09/21	AD_VP	17000		100	90
102	Lex	De Haan	LDEHAAN	515.123.4569	01/01/13	AD_VP	17000		100	90
114	Den	Raphaely	DRAPHEAL	515.127.4561	02/12/07	PU_MAN	11000		100	30
120	Matthew	Weiss	MWEISS	650.123.1234	04/07/18	ST_MAN	8000		100	50
121	Adam	Fripp	AFRIPP	650.123.2234	05/04/10	ST_MAN	8200		100	50
122	Payam	Kaufling	PKAUFLIN	650.123.3234	03/05/01	ST_MAN	7900		100	50
123	Shanta	Vollman	SVOLLMAN	650.123.4234	05/10/10	ST_MAN	6500		100	50
124	Kevin	Mourgos	KMOURGOS	650.123.5234	07/11/16	ST_MAN	5800		100	50
145	John	Russell	JRUSSEL	011.44.1344.429268	04/10/01	SA_MAN	14000	0.4	100	80
146	Karen	Partners	KPARTNER	011.44.1344.467268	05/01/05	SA_MAN	13500	0.3	100	80
147	Alberto	Errazuriz	AERRAZUR	011.44.1344.429278	05/03/10	SA_MAN	12000	0.3	100	80
148	Gerald	Cambrault	GCAMBRAU	011.44.1344.619268	07/10/15	SA_MAN	11000	0.3	100	80
149	Eleni	Zlotkey	EZLOTKEY	011.44.1344.429018	08/01/29	SA_MAN	10500	0.2	100	80
201	Michael	Hartstein	MHARTSTE	515.123.5555	04/02/17	MK_MAN	13000		100	20
*/
-- 서브쿼리 이용
SELECT e.EMPLOYEE_ID 
     , e.FIRST_NAME 
     , e.LAST_NAME 
     , e.EMAIL 
     , e.PHONE_NUMBER 
     , e.HIRE_DATE 
     , e.JOB_ID 
     , e.SALARY 
     , e.COMMISSION_PCT 
     , e.MANAGER_ID 
     , e.DEPARTMENT_ID 
  FROM employees e
 WHERE e.manager_id = (SELECT e.employee_id
                         FROM employees e
                        WHERE e.first_name = 'Steven'
                          AND e.last_name = 'King')
;
/*
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
------------------------------------------------------------------------------------------------------------------------------
101	Neena	Kochhar	NKOCHHAR	515.123.4568	05/09/21	AD_VP	17000		100	90
102	Lex	De Haan	LDEHAAN	515.123.4569	01/01/13	AD_VP	17000		100	90
114	Den	Raphaely	DRAPHEAL	515.127.4561	02/12/07	PU_MAN	11000		100	30
120	Matthew	Weiss	MWEISS	650.123.1234	04/07/18	ST_MAN	8000		100	50
121	Adam	Fripp	AFRIPP	650.123.2234	05/04/10	ST_MAN	8200		100	50
122	Payam	Kaufling	PKAUFLIN	650.123.3234	03/05/01	ST_MAN	7900		100	50
123	Shanta	Vollman	SVOLLMAN	650.123.4234	05/10/10	ST_MAN	6500		100	50
124	Kevin	Mourgos	KMOURGOS	650.123.5234	07/11/16	ST_MAN	5800		100	50
145	John	Russell	JRUSSEL	011.44.1344.429268	04/10/01	SA_MAN	14000	0.4	100	80
146	Karen	Partners	KPARTNER	011.44.1344.467268	05/01/05	SA_MAN	13500	0.3	100	80
147	Alberto	Errazuriz	AERRAZUR	011.44.1344.429278	05/03/10	SA_MAN	12000	0.3	100	80
148	Gerald	Cambrault	GCAMBRAU	011.44.1344.619268	07/10/15	SA_MAN	11000	0.3	100	80
149	Eleni	Zlotkey	EZLOTKEY	011.44.1344.429018	08/01/29	SA_MAN	10500	0.2	100	80
201	Michael	Hartstein	MHARTSTE	515.123.5555	04/02/17	MK_MAN	13000		100	20
*/

--6. Steven King의 직속 부하직원 중에서 Commission_pct 값이 null이 아닌 직원 목록
--5건
SELECT e1.EMPLOYEE_ID 
     , e1.FIRST_NAME 
     , e1.LAST_NAME 
     , e1.EMAIL 
     , e1.PHONE_NUMBER 
     , e1.HIRE_DATE 
     , e1.JOB_ID 
     , e1.SALARY 
     , e1.COMMISSION_PCT 
     , e1.MANAGER_ID 
     , e1.DEPARTMENT_ID
  FROM employees e1 JOIN employees e2
    ON e1.manager_id = e2.employee_id
 WHERE e2.first_name = 'Steven'
   AND e2.last_name = 'King'
   AND e1.commission_pct IS NOT NULL
;
/*
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
------------------------------------------------------------------------------------------------------------------------------
145	John	Russell	JRUSSEL	011.44.1344.429268	04/10/01	SA_MAN	14000	0.4	100	80
146	Karen	Partners	KPARTNER	011.44.1344.467268	05/01/05	SA_MAN	13500	0.3	100	80
147	Alberto	Errazuriz	AERRAZUR	011.44.1344.429278	05/03/10	SA_MAN	12000	0.3	100	80
148	Gerald	Cambrault	GCAMBRAU	011.44.1344.619268	07/10/15	SA_MAN	11000	0.3	100	80
149	Eleni	Zlotkey	EZLOTKEY	011.44.1344.429018	08/01/29	SA_MAN	10500	0.2	100	80
*/

--7. 각 job 별 최대급여를 구하여 출력 job_id, job_title, job별 최대급여 조회
--19건
SELECT e.job_id
     , j.job_title
     , MAX(e.salary) 최대급여
  FROM employees e JOIN jobs j
    ON e.job_id = j.job_id
 GROUP BY e.job_id, j.job_title
;
/*
JOB_ID, JOB_TITLE, 최대급여
----------------------------------------------------
AD_ASST	Administration Assistant	4400
IT_PROG	Programmer	9000
MK_MAN	Marketing Manager	13000
SA_REP	Sales Representative	11500
AC_MGR	Accounting Manager	12008
AC_ACCOUNT	Public Accountant	8300
FI_MGR	Finance Manager	12008
PU_MAN	Purchasing Manager	11000
SH_CLERK	Shipping Clerk	4200
FI_ACCOUNT	Accountant	9000
AD_PRES	President	24000
MK_REP	Marketing Representative	6000
SA_MAN	Sales Manager	14000
AD_VP	Administration Vice President	17000
PU_CLERK	Purchasing Clerk	3100
ST_CLERK	Stock Clerk	3600
ST_MAN	Stock Manager	8200
HR_REP	Human Resources Representative	6500
PR_REP	Public Relations Representative	10000
*/
 
--8. 각 Job 별 최대급여를 받는 사람의 정보를 출력,
--  급여가 높은 순서로 출력
----서브쿼리 이용
SELECT e.JOB_ID 
     , e.EMPLOYEE_ID 
     , e.FIRST_NAME 
     , e.LAST_NAME 
     , e.SALARY 
     , e.EMAIL 
     , e.PHONE_NUMBER 
     , e.HIRE_DATE 
     , e.COMMISSION_PCT 
     , e.MANAGER_ID 
     , e.DEPARTMENT_ID 
  FROM employees e
 WHERE (e.job_id, e.salary) IN (SELECT e.job_id
                                     , MAX(e.salary)
                                  FROM employees e
                                 GROUP BY e.job_id)
 ORDER BY e.salary DESC
;
/*
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
------------------------------------------------------------------------------------------------------------------------------
AD_PRES	100	Steven	King	24000	SKING	515.123.4567	03/06/17			90
AD_VP	101	Neena	Kochhar	17000	NKOCHHAR	515.123.4568	05/09/21		100	90
AD_VP	102	Lex	De Haan	17000	LDEHAAN	515.123.4569	01/01/13		100	90
SA_MAN	145	John	Russell	14000	JRUSSEL	011.44.1344.429268	04/10/01	0.4	100	80
MK_MAN	201	Michael	Hartstein	13000	MHARTSTE	515.123.5555	04/02/17		100	20
FI_MGR	108	Nancy	Greenberg	12008	NGREENBE	515.124.4569	02/08/17		101	100
AC_MGR	205	Shelley	Higgins	12008	SHIGGINS	515.123.8080	02/06/07		101	110
SA_REP	168	Lisa	Ozer	11500	LOZER	011.44.1343.929268	05/03/11	0.25	148	80
PU_MAN	114	Den	Raphaely	11000	DRAPHEAL	515.127.4561	02/12/07		100	30
PR_REP	204	Hermann	Baer	10000	HBAER	515.123.8888	02/06/07		101	70
IT_PROG	103	Alexander	Hunold	9000	AHUNOLD	590.423.4567	06/01/03		102	60
FI_ACCOUNT	109	Daniel	Faviet	9000	DFAVIET	515.124.4169	02/08/16		108	100
AC_ACCOUNT	206	William	Gietz	8300	WGIETZ	515.123.8181	02/06/07		205	110
ST_MAN	121	Adam	Fripp	8200	AFRIPP	650.123.2234	05/04/10		100	50
HR_REP	203	Susan	Mavris	6500	SMAVRIS	515.123.7777	02/06/07		101	40
MK_REP	202	Pat	Fay	6000	PFAY	603.123.6666	05/08/17		201	20
AD_ASST	200	Jennifer	Whalen	4400	JWHALEN	515.123.4444	03/09/17		101	10
SH_CLERK	184	Nandita	Sarchand	4200	NSARCHAN	650.509.1876	04/01/27		121	50
ST_CLERK	137	Renske	Ladwig	3600	RLADWIG	650.121.1234	03/07/14		123	50
PU_CLERK	115	Alexander	Khoo	3100	AKHOO	515.127.4562	03/05/18		114	30
*/
----join 이용
SELECT e1.JOB_ID 
     , e1.EMPLOYEE_ID 
     , e1.FIRST_NAME 
     , e1.LAST_NAME 
     , e1.SALARY 
     , e1.EMAIL 
     , e1.PHONE_NUMBER 
     , e1.HIRE_DATE 
     , e1.COMMISSION_PCT 
     , e1.MANAGER_ID 
     , e1.DEPARTMENT_ID 
  FROM employees e1 JOIN (SELECT e.job_id
                               , MAX(e.salary) salary
                            FROM employees e
                           GROUP BY e.job_id) e2
    ON e1.job_id = e2.job_id
 WHERE e1.salary = e2.salary
;
/*
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
------------------------------------------------------------------------------------------------------------------------------
IT_PROG	103	Alexander	Hunold	9000	AHUNOLD	590.423.4567	06/01/03		102	60
AC_MGR	205	Shelley	Higgins	12008	SHIGGINS	515.123.8080	02/06/07		101	110
AC_ACCOUNT	206	William	Gietz	8300	WGIETZ	515.123.8181	02/06/07		205	110
ST_MAN	121	Adam	Fripp	8200	AFRIPP	650.123.2234	05/04/10		100	50
PU_MAN	114	Den	Raphaely	11000	DRAPHEAL	515.127.4561	02/12/07		100	30
AD_ASST	200	Jennifer	Whalen	4400	JWHALEN	515.123.4444	03/09/17		101	10
AD_VP	101	Neena	Kochhar	17000	NKOCHHAR	515.123.4568	05/09/21		100	90
AD_VP	102	Lex	De Haan	17000	LDEHAAN	515.123.4569	01/01/13		100	90
SH_CLERK	184	Nandita	Sarchand	4200	NSARCHAN	650.509.1876	04/01/27		121	50
FI_ACCOUNT	109	Daniel	Faviet	9000	DFAVIET	515.124.4169	02/08/16		108	100
FI_MGR	108	Nancy	Greenberg	12008	NGREENBE	515.124.4569	02/08/17		101	100
PU_CLERK	115	Alexander	Khoo	3100	AKHOO	515.127.4562	03/05/18		114	30
SA_MAN	145	John	Russell	14000	JRUSSEL	011.44.1344.429268	04/10/01	0.4	100	80
MK_MAN	201	Michael	Hartstein	13000	MHARTSTE	515.123.5555	04/02/17		100	20
PR_REP	204	Hermann	Baer	10000	HBAER	515.123.8888	02/06/07		101	70
AD_PRES	100	Steven	King	24000	SKING	515.123.4567	03/06/17			90
SA_REP	168	Lisa	Ozer	11500	LOZER	011.44.1343.929268	05/03/11	0.25	148	80
MK_REP	202	Pat	Fay	6000	PFAY	603.123.6666	05/08/17		201	20
ST_CLERK	137	Renske	Ladwig	3600	RLADWIG	650.121.1234	03/07/14		123	50
HR_REP	203	Susan	Mavris	6500	SMAVRIS	515.123.7777	02/06/07		101	40*/
--20건

--9. 7번 출력시 job_id 대신 Job_name, manager_id 대신 Manager의 last_name, department_id 대신 department_name 으로 출력
--20건
SELECT e1.JOB_ID "Job_name"
     , e1.EMPLOYEE_ID 
     , e1.FIRST_NAME 
     , e1.LAST_NAME 
     , e1.SALARY 
     , e1.EMAIL 
     , e1.PHONE_NUMBER 
     , e1.HIRE_DATE 
     , e1.COMMISSION_PCT 
     , e2.LAST_NAME "MANAGER_LAST_NAME"
     , d.DEPARTMENT_NAME 
  FROM employees e1 LEFT OUTER JOIN employees e2
    ON e1.manager_id = e2.employee_id JOIN departments d
    ON e1.department_id = d.department_id
 WHERE (e1.job_id, e1.salary) IN (SELECT e.job_id
                                     , MAX(e.salary)
                                  FROM employees e
                                 GROUP BY e.job_id)
 ORDER BY e1.salary DESC
;
/*
Job_name, EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, EMAIL, PHONE_NUMBER, HIRE_DATE, COMMISSION_PCT, MANAGER_LAST_NAME, DEPARTMENT_NAME
------------------------------------------------------------------------------------------------------------------------------------------
AD_PRES	100	Steven	King	24000	SKING	515.123.4567	03/06/17			Executive
AD_VP	101	Neena	Kochhar	17000	NKOCHHAR	515.123.4568	05/09/21		King	Executive
AD_VP	102	Lex	De Haan	17000	LDEHAAN	515.123.4569	01/01/13		King	Executive
SA_MAN	145	John	Russell	14000	JRUSSEL	011.44.1344.429268	04/10/01	0.4	King	Sales
MK_MAN	201	Michael	Hartstein	13000	MHARTSTE	515.123.5555	04/02/17		King	Marketing
FI_MGR	108	Nancy	Greenberg	12008	NGREENBE	515.124.4569	02/08/17		Kochhar	Finance
AC_MGR	205	Shelley	Higgins	12008	SHIGGINS	515.123.8080	02/06/07		Kochhar	Accounting
SA_REP	168	Lisa	Ozer	11500	LOZER	011.44.1343.929268	05/03/11	0.25	Cambrault	Sales
PU_MAN	114	Den	Raphaely	11000	DRAPHEAL	515.127.4561	02/12/07		King	Purchasing
PR_REP	204	Hermann	Baer	10000	HBAER	515.123.8888	02/06/07		Kochhar	Public Relations
IT_PROG	103	Alexander	Hunold	9000	AHUNOLD	590.423.4567	06/01/03		De Haan	IT
FI_ACCOUNT	109	Daniel	Faviet	9000	DFAVIET	515.124.4169	02/08/16		Greenberg	Finance
AC_ACCOUNT	206	William	Gietz	8300	WGIETZ	515.123.8181	02/06/07		Higgins	Accounting
ST_MAN	121	Adam	Fripp	8200	AFRIPP	650.123.2234	05/04/10		King	Shipping
HR_REP	203	Susan	Mavris	6500	SMAVRIS	515.123.7777	02/06/07		Kochhar	Human Resources
MK_REP	202	Pat	Fay	6000	PFAY	603.123.6666	05/08/17		Hartstein	Marketing
AD_ASST	200	Jennifer	Whalen	4400	JWHALEN	515.123.4444	03/09/17		Kochhar	Administration
SH_CLERK	184	Nandita	Sarchand	4200	NSARCHAN	650.509.1876	04/01/27		Fripp	Shipping
ST_CLERK	137	Renske	Ladwig	3600	RLADWIG	650.121.1234	03/07/14		Vollman	Shipping
PU_CLERK	115	Alexander	Khoo	3100	AKHOO	515.127.4562	03/05/18		Raphaely	Purchasing
*/

--10. 전체 직원의 급여 평균을 구하여 출력
SELECT AVG(e.salary) 급여평균
  FROM employees e
;
/*
급여평균
-------------------------------------------
6461.831775700934579439252336448598130841
*/
--11. 전체 직원의 급여 평균보다 높은 급여를 받는 사람의 목록 출력. 급여 오름차순 정렬
--51건
SELECT e.EMPLOYEE_ID 
     , e.FIRST_NAME 
     , e.LAST_NAME 
     , e.EMAIL 
     , e.PHONE_NUMBER 
     , e.HIRE_DATE 
     , e.JOB_ID 
     , e.SALARY 
     , e.COMMISSION_PCT 
     , e.MANAGER_ID 
     , e.DEPARTMENT_ID  
  FROM employees e
 WHERE e.salary > (SELECT AVG(e.salary)
                     FROM employees e)
 ORDER BY e.salary
;
/*
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISIION_PCT, MANAGER_ID, DEPARTMNET_ID
-------------------------------------------------------------------------------------------------------------------------------
203	Susan	Mavris	SMAVRIS	515.123.7777	02/06/07	HR_REP	6500		101	40
123	Shanta	Vollman	SVOLLMAN	650.123.4234	05/10/10	ST_MAN	6500		100	50
165	David	Lee	DLEE	011.44.1346.529268	08/02/23	SA_REP	6800	0.1	147	80
113	Luis	Popp	LPOPP	515.124.4567	07/12/07	FI_ACCOUNT	6900		108	100
155	Oliver	Tuvault	OTUVAULT	011.44.1344.486508	07/11/23	SA_REP	7000	0.15	145	80
.
.
.
146	Karen	Partners	KPARTNER	011.44.1344.467268	05/01/05	SA_MAN	13500	0.3	100	80
145	John	Russell	JRUSSEL	011.44.1344.429268	04/10/01	SA_MAN	14000	0.4	100	80
102	Lex	De Haan	LDEHAAN	515.123.4569	01/01/13	AD_VP	17000		100	90
101	Neena	Kochhar	NKOCHHAR	515.123.4568	05/09/21	AD_VP	17000		100	90
100	Steven	King	SKING	515.123.4567	03/06/17	AD_PRES	24000			90
*/

--12. 각 부서별 평균 급여를 구하여 출력
--12건
SELECT e.department_id
     , AVG(e.salary) "부서별 평균급여"
  FROM employees e
 GROUP BY e.department_id
;
/*
DEPARTMENT_ID, 부서별 평균 급여
------------------------------------------------
100	8601.333333333333333333333333333333333333
30	4150
	7000
90	19333.3333333333333333333333333333333333
20	9500
70	10000
110	10154
50	3475.555555555555555555555555555555555556
80	8955.882352941176470588235294117647058824
40	6500
60	5760
10	4400
*/

--13. 12번의 결과에 department_name 같이 출력
--12건
SELECT e.department_id
     , d.department_name
     , AVG(e.salary) "부서별 평균급여"
  FROM employees e LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id
 GROUP BY e.department_id, d.department_name
;
/*
DEPARTMENT_ID, DEPARTMENT_NAME, 부서별 평균급여
-------------------------------------------------------------
100	Finance	8601.333333333333333333333333333333333333
		7000
50	Shipping	3475.555555555555555555555555555555555556
70	Public Relations	10000
30	Purchasing	4150
90	Executive	19333.3333333333333333333333333333333333
10	Administration	4400
110	Accounting	10154
40	Human Resources	6500
20	Marketing	9500
60	IT	5760
80	Sales	8955.882352941176470588235294117647058824
*/

--14. employees 테이블이 각 job_id 별 인원수와 job_title을 같이 출력하고 job_id 오름차순 정렬
-- 19건
SELECT e.job_id
     , j.job_title
     , COUNT(e.job_id) 인원수
  FROM employees e JOIN jobs j
    ON e.job_id = j.job_id
 GROUP BY e.job_id, j.job_title
 ORDER BY e.job_id
;
/*JOB_ID, JOB_TITLE, 인원수
--------------------------------------
AC_ACCOUNT	Public Accountant	1
AC_MGR	Accounting Manager	1
AD_ASST	Administration Assistant	1
AD_PRES	President	1
AD_VP	Administration Vice President	2
FI_ACCOUNT	Accountant	5
FI_MGR	Finance Manager	1
HR_REP	Human Resources Representative	1
IT_PROG	Programmer	5
MK_MAN	Marketing Manager	1
MK_REP	Marketing Representative	1
PR_REP	Public Relations Representative	1
PU_CLERK	Purchasing Clerk	5
PU_MAN	Purchasing Manager	1
SA_MAN	Sales Manager	5
SA_REP	Sales Representative	30
SH_CLERK	Shipping Clerk	20
ST_CLERK	Stock Clerk	20
ST_MAN	Stock Manager	5
*/
--15. employees 테이블의 job_id별 최저급여,
--   최대급여를 job_title과 함께 출력 job_id 알파벳순 오름차순 정렬
-- 19건
SELECT e.job_id
     , j.job_title
     , min(e.salary) 최저급여
     , max(e.salary) 최대급여
  FROM employees e JOIN jobs j
    ON e.job_id = j.job_id
 GROUP BY e.job_id, j.job_title
 ORDER BY e.job_id
;
/*
JOB_ID, JOB_TITLE, 쵲저급여, 최대급여
------------------------------------------------------
AC_ACCOUNT	Public Accountant	8300	8300
AC_MGR	Accounting Manager	12008	12008
AD_ASST	Administration Assistant	4400	4400
AD_PRES	President	24000	24000
AD_VP	Administration Vice President	17000	17000
FI_ACCOUNT	Accountant	6900	9000
FI_MGR	Finance Manager	12008	12008
HR_REP	Human Resources Representative	6500	6500
IT_PROG	Programmer	4200	9000
MK_MAN	Marketing Manager	13000	13000
MK_REP	Marketing Representative	6000	6000
PR_REP	Public Relations Representative	10000	10000
PU_CLERK	Purchasing Clerk	2500	3100
PU_MAN	Purchasing Manager	11000	11000
SA_MAN	Sales Manager	10500	14000
SA_REP	Sales Representative	6100	11500
SH_CLERK	Shipping Clerk	2500	4200
ST_CLERK	Stock Clerk	2100	3600
ST_MAN	Stock Manager	5800	8200
*/

--16. Employees 테이블에서 인원수가 가장 많은 job_id를 구하고
--   해당 job_id 의 job_title 과 그 때 직원의 인원수를 같이 출력
SELECT e.job_id
     , j.job_title
     , COUNT(*) 인원수
  FROM employees e JOIN jobs j
    ON e.job_id = j.job_id
 GROUP BY e.job_id, j.job_title
HAVING COUNT(*) = (SELECT max(a.인원수)
                     FROM (SELECT e.job_id
                                , COUNT(*) 인원수
                             FROM employees e 
                            GROUP BY e.job_id) a)
;
/*
JOB_ID, JOB_TITLE, 인원수
-----------------------------------
SA_REP	Sales Representative	30
*/
SELECT a.job_id
     , a.job_title
     , a.인원수
  FROM (SELECT e.job_id
             , j.job_title
             , COUNT(*) 인원수
          FROM employees e JOIN jobs j
            ON e.job_id = j.job_id
 GROUP BY e.job_id, j.job_title
 ORDER BY 인원수 DESC) a
 WHERE ROWNUM = 1
;
/*
JOB_ID, JOB_TITLE, 인원수
-----------------------------------
SA_REP	Sales Representative	30
*/

--17.사번,last_name, 급여, 직책이름(job_title), 부서명(department_name), 부서매니저이름
--  부서 위치 도시(city), 나라(country_name), 지역(region_name) 을 출력
----------- 부서가 배정되지 않은 인원 고려 ------
-- 107건
SELECT e.employee_id 사번
     , e.last_name as "last_name"
     , e.salary 급여
     , j.job_title 직책이름
     , d.DEPARTMENT_NAME 부서명
     , dm.name 부서매니저이름
     , ln.city "부서 위치 도시"
     , ln.COUNTRY_NAME 나라
     , ln.REGION_NAME 지역 
  FROM employees e LEFT OUTER JOIN departments d
    ON e.DEPARTMENT_ID = d.DEPARTMENT_ID JOIN jobs j
    ON e.job_id = j.job_id LEFT OUTER JOIN (SELECT e.first_name || ' ' || e.last_name as name
                                                 , d.DEPARTMENT_ID
                                              FROM employees e JOIN departments d
                                                ON e.EMPLOYEE_ID = d.MANAGER_ID) dm
    ON e.DEPARTMENT_ID = dm.DEPARTMENT_ID LEFT OUTER JOIN (SELECT d.DEPARTMENT_ID
                                                                , l.CITY
                                                                , c.COUNTRY_NAME
                                                                , r.REGION_NAME
                                                             FROM departments d JOIN locations l
                                                               ON d.LOCATION_ID = l.LOCATION_ID JOIN countries c
                                                               ON l.COUNTRY_ID = c.COUNTRY_ID JOIN regions r
                                                               ON c.REGION_ID = r.REGION_ID) ln
    ON e.DEPARTMENT_ID = ln.DEPARTMENT_ID
;
/*
사번, last_name, 급여, 직책이름, 부서명, 부서매니저이름, 부서 위치 도시, 나라, 지역
--------------------------------------------------------------------------------------------------------------------------------------------------
200	Whalen	4400	Administration Assistant	Administration	Jennifer Whalen	Seattle	United States of America	Americas
202	Fay	6000	Marketing Representative	Marketing	Michael Hartstein	Toronto	Canada	Americas
201	Hartstein	13000	Marketing Manager	Marketing	Michael Hartstein	Toronto	Canada	Americas
114	Raphaely	11000	Purchasing Manager	Purchasing	Den Raphaely	Seattle	United States of America	Americas
119	Colmenares	2500	Purchasing Clerk	Purchasing	Den Raphaely	Seattle	United States of America	Americas
118	Himuro	2600	Purchasing Clerk	Purchasing	Den Raphaely	Seattle	United States of America	Americas
.
.
.
.

109	Faviet	9000	Accountant	Finance	Nancy Greenberg	Seattle	United States of America	Americas
110	Chen	8200	Accountant	Finance	Nancy Greenberg	Seattle	United States of America	Americas
205	Higgins	12008	Accounting Manager	Accounting	Shelley Higgins	Seattle	United States of America	Americas
206	Gietz	8300	Public Accountant	Accounting	Shelley Higgins	Seattle	United States of America	Americas
178	Grant	7000	Sales Representative					
*/

--18.부서 아이디, 부서명, 부서에 속한 인원숫자를 출력
-- 27건
SELECT d.department_id "부서 아이디"
     , d.department_name 부서명
     , COUNT(e.department_id) 인원수
  FROM employees e RIGHT OUTER JOIN departments d
    ON e.department_id = d.department_id
 GROUP BY d.department_id, d.department_name
;
/*
부서 아이디, 부서명, 인원수
----------------------------------------------
100	Finance	6
140	Control And Credit	0
50	Shipping	45
70	Public Relations	1
250	Retail Sales	0
120	Treasury	0
220	NOC	0
230	IT Helpdesk	0
240	Government Sales	0
30	Purchasing	6
90	Executive	3
200	Operations	0
10	Administration	1
110	Accounting	2
130	Corporate Tax	0
170	Manufacturing	0
180	Construction	0
190	Contracting	0
40	Human Resources	1
20	Marketing	2
60	IT	5
80	Sales	34
160	Benefits	0
210	IT Support	0
150	Shareholder Services	0
260	Recruiting	0
270	Payroll	0
*/


--19.인원이 가장 많은 상위 다섯 부서아이디, 부서명, 인원수 목록 출력
-- 5건
SELECT a."부서 아이디"
     , a.부서명
     , a.인원수
  FROM (SELECT d.department_id "부서 아이디"
             , d.department_name 부서명
             , COUNT(*) 인원수
          FROM employees e RIGHT OUTER JOIN departments d
            ON e.department_id = d.department_id
         GROUP BY d.department_id, d.department_name
         ORDER BY 인원수 DESC) a
 WHERE ROWNUM <= 5
;
/*
부서 아이디, 부서명, 인원수
------------------------------
50	Shipping	45
80	Sales   	34
100	Finance 	6
30	Purchasing	6
60	IT	        5
*/         

--20. 부서별, 직책별 평균 급여를 구하여라.
--   부서이름, 직책이름, 평균급여 소수점 둘째자리에서 반올림으로 구하여라.
-- 19건
SELECT d.department_name 부서이름
     , ROUND(AVG(e.salary), 1) "부서별 평균급여"
  FROM employees e JOIN departments d
    ON e.department_id = d.department_id
 GROUP BY d.department_name
;

SELECT j.job_title 직책이름
     , ROUND(AVG(e.salary), 1) "직책별 평균급여"
  FROM employees e JOIN jobs j
    ON e.job_id = j.job_id    
 GROUP BY j.job_title
;

SELECT d.department_name 부서이름
     , j.job_title 직책이름
     , ROUND(AVG(e.salary), 1) "부서,직책별 평균급여"
  FROM employees e JOIN jobs j
    ON e.job_id = j.job_id JOIN departments d
    ON e.department_id = d.department_id
 GROUP BY j.job_title, d.department_name
;
/*
부서이름, 직책이름, 부서,직책별 평균급여
----------------------------------------------
Marketing	Marketing Representative	6000
Shipping	Shipping Clerk	3215
Shipping	Stock Manager	7280
Shipping	Stock Clerk	2785
Administration	Administration Assistant	4400
Marketing	Marketing Manager	13000
Purchasing	Purchasing Manager	11000
Sales	Sales Representative	8396.6
Sales	Sales Manager	12200
Executive	Administration Vice President	17000
Executive	President	24000
Finance	Finance Manager	12008
Accounting	Public Accountant	8300
Public Relations	Public Relations Representative	10000
Finance	Accountant	7920
Accounting	Accounting Manager	12008
Purchasing	Purchasing Clerk	2780
Human Resources	Human Resources Representative	6500
IT	Programmer	5760
*/

--21.각 부서의 정보를 부서매니저 이름과 함께 출력(부서는 모두 출력되어야 함)
-- 27건
SELECT d.DEPARTMENT_ID 부서아이디
     , d.DEPARTMENT_NAME 부서명
     , d.LOCATION_ID 위치아이디
     , d.MANAGER_ID 매니저아이디
     , e.FIRST_NAME || ' ' || e.LAST_NAME 부서매니저이름
  FROM departments d LEFT OUTER JOIN employees e
    ON d.MANAGER_ID = e.EMPLOYEE_ID
;
/*
부서아이디, 부서명, 위치아이디, 매니저아이디, 부서매니저이름
--------------------------------------------------
90	Executive	1700	100	Steven King
60	IT	1400	103	Alexander Hunold
100	Finance	1700	108	Nancy Greenberg
30	Purchasing	1700	114	Den Raphaely
50	Shipping	1500	121	Adam Fripp
80	Sales	2500	145	John Russell
10	Administration	1700	200	Jennifer Whalen
20	Marketing	1800	201	Michael Hartstein
40	Human Resources	2400	203	Susan Mavris
70	Public Relations	2700	204	Hermann Baer
110	Accounting	1700	205	Shelley Higgins
270	Payroll	1700		 
260	Recruiting	1700		 
250	Retail Sales	1700		 
240	Government Sales	1700		 
230	IT Helpdesk	1700		 
220	NOC	1700		 
210	IT Support	1700		 
200	Operations	1700		 
190	Contracting	1700		 
180	Construction	1700		 
170	Manufacturing	1700		 
160	Benefits	1700		 
150	Shareholder Services	1700		 
140	Control And Credit	1700		 
130	Corporate Tax	1700		 
120	Treasury	1700		 
*/

--22. 부서가 가장 많은 도시이름을 출력
SELECT a.도시이름
  FROM (SELECT l.city 도시이름
             , COUNT(*) 부서수
          FROM departments d JOIN locations l
            ON d.LOCATION_ID = l.location_id
         GROUP BY l.city
         ORDER BY 부서수 DESC) a
 WHERE ROWNUM = 1
;
/*
도시이름
---------
Seattle
*/

SELECT l.city 도시이름
  FROM departments d JOIN locations l
    ON d.LOCATION_ID = l.LOCATION_ID
 GROUP BY l.city
HAVING COUNT(*) = (SELECT max(a.부서수)
                     FROM (SELECT d.location_id
                                , COUNT(*) 부서수
                             FROM departments d
                            GROUP BY d.location_id) a)
;
/*
도시이름
---------
Seattle
*/

--23. 부서가 없는 도시 목록 출력
-- 16건
--조인사용
SELECT l.city 도시이름
  FROM departments d RIGHT OUTER JOIN locations l
    ON d.LOCATION_ID = l.location_id
 WHERE d.department_id IS NULL
;
/*
도시이름
-------
Beijing
Bern
Tokyo
Sydney
Utrecht
South Brunswick
Bombay
Geneva
Sao Paulo
Venice
Whitehorse
Singapore
Hiroshima
Stretford
Roma
Mexico City
*/

--집합연산 사용
SELECT l.city 도시이름
  FROM departments d RIGHT OUTER JOIN locations l
    ON d.LOCATION_ID = l.location_id
MINUS
SELECT l.city 도시이름
  FROM departments d JOIN locations l
    ON d.LOCATION_ID = l.location_id
;
/*
도시이름
--------
Beijing
Bern
Bombay
Geneva
Hiroshima
Mexico City
Roma
Sao Paulo
Singapore
South Brunswick
Stretford
Sydney
Tokyo
Utrecht
Venice
Whitehorse
*/
--서브쿼리 사용
SELECT l.city 도시이름
  FROM locations l
 WHERE l.LOCATION_ID NOT IN (SELECT d.location_id
                               FROM departments d
                              GROUP BY d.location_id)
;
 /*
 도시이름
 ----------
 Beijing
Bern
Tokyo
Sydney
Utrecht
South Brunswick
Bombay
Geneva
Sao Paulo
Venice
Whitehorse
Singapore
Hiroshima
Stretford
Roma
Mexico City
 */ 
 
--24.평균 급여가 가장 높은 부서명을 출력
SELECT d.department_name 부서명
  FROM departments d JOIN (SELECT e.department_id
                                , ROUND(AVG(e.salary))평균급여
                             FROM employees e
                            GROUP BY e.department_id
                            ORDER BY 평균급여  DESC) e
    on d.department_id = e.department_id
 WHERE ROWNUM =1 
;
/*
부서명
---------
Executive
*/

--25. Finance 부서의 평균 급여보다 높은 급여를 받는 직원의 목록 출력
-- 28건
SELECT e.employee_id 직원아이디
     , e.first_name
     , e.last_name
  FROM employees e
 WHERE e.salary > (SELECT AVG(e.salary)
                     FROM employees e
                    WHERE e.department_id = (SELECT d.department_id
                                               FROM departments d
                                              WHERE department_name = 'Finance'))
;
/*
직원아이디, FIRST_NAME, LAST_NAME
--------------------------------
100	Steven	King
101	Neena	Kochhar
102	Lex	De Haan
103	Alexander	Hunold
108	Nancy	Greenberg
109	Daniel	Faviet
114	Den	Raphaely
145	John	Russell
146	Karen	Partners
147	Alberto	Errazuriz
148	Gerald	Cambrault
149	Eleni	Zlotkey
150	Peter	Tucker
151	David	Bernstein
152	Peter	Hall
156	Janette	King
157	Patrick	Sully
158	Allan	McEwen
162	Clara	Vishney
163	Danielle	Greene
168	Lisa	Ozer
169	Harrison	Bloom
170	Tayler	Fox
174	Ellen	Abel
175	Alyssa	Hutton
201	Michael	Hartstein
204	Hermann	Baer
205	Shelley	Higgins
*/

-- 26. 각 부서별 인원수를 출력하되, 인원이 없는 부서는 0으로 나와야 하며
--     부서는 정식 명칭으로 출력하고 인원이 많은 순서로 정렬.
-- 27건
SELECT d.DEPARTMENT_NAME 부서명
     , COUNT(e.DEPARTMENT_ID) 인원수
  FROM employees e RIGHT OUTER JOIN departments d
    ON e.department_id = d.department_id
 GROUP BY d.DEPARTMENT_NAME
 ORDER BY 인원수 DESC
;
/*
부서명, 인원수
---------------
Shipping	45
Sales	34
Finance	6
Purchasing	6
IT	5
Executive	3
Marketing	2
Accounting	2
Public Relations	1
Administration	1
Human Resources	1
Control And Credit	0
Shareholder Services	0
IT Helpdesk	0
Operations	0
Payroll	0
Recruiting	0
Retail Sales	0
NOC	0
Contracting	0
Corporate Tax	0
Benefits	0
Government Sales	0
Construction	0
Manufacturing	0
IT Support	0
Treasury	0
*/

--27. 지역별 등록된 나라의 갯수 출력(지역이름, 등록된 나라의 갯수)
-- 4건
SELECT r.REGION_NAME 지역이름
     , COUNT(*) "나라 수"
  FROM countries c JOIN regions r
    ON c.REGION_ID = r.REGION_ID
 GROUP BY r.REGION_NAME
;
/*
나라 수
------------------------------
Middle East and Africa	6
Europe	8
Asia	6
Americas	5
*/

--28. 가장 많은 나라가 등록된 지역명 출력
-- 1건
SELECT 지역이름
  FROM (SELECT r.REGION_NAME 지역이름
             , COUNT(*) "나라 수"
          FROM countries c JOIN regions r
            ON c.REGION_ID = r.REGION_ID
         GROUP BY r.REGION_NAME
         ORDER BY "나라 수" DESC) a
 WHERE ROWNUM = 1
;
/*
지역이름
--------
Europe
*/