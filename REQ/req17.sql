/* 17-------------- Les 10 clients les plus vieux ayant plus de 50 ans */

SELECT nom, age(current_timestamp, date_naiss) FROM Client
WHERE age(current_timestamp, date_naiss) >= '30 years'
ORDER BY (age(current_timestamp, date_naiss)) DESC
LIMIT 10;
