-- Clean column names
ALTER TABLE week1 RENAME COLUMN TransactionCode TO transaction_code;
ALTER TABLE week1 RENAME COLUMN Value TO value;
ALTER TABLE week1 RENAME COLUMN CustomerCode TO customer_code;
ALTER TABLE week1 RENAME COLUMN `OnlineorIn-Person` TO online_or_in_person;
ALTER TABLE week1 RENAME COLUMN TransactionDate TO transaction_date;

-- Filter by "DSB" Transactions
SELECT transaction_code,
	value,
	customer_code,
	online_or_in_person,
	transaction_date
FROM week1
WHERE transaction_code LIKE "DSB%";

-- Find online transactions
SELECT online_or_in_person
FROM week1
WHERE online_or_in_person == 1;

-- Find in-person transactions
SELECT online_or_in_person
FROM week1
WHERE online_or_in_person == 2;

-- Update OnlineorIn-Person column 
-- Replace 1 with "Online" and 2 with "In-Person"
UPDATE week1
SET online_or_in_person = "Online"
WHERE online_or_in_person == 1;

UPDATE week1
SET online_or_in_person = "In-Person"
WHERE online_or_in_person == 2;

-- Find 1st quarter Transaction Dates
--
SELECT transaction_date
FROM week1
WHERE transaction_date GLOB "*/0[1-3]/2023*";

-- Change the date to be the quarter
ALTER TABLE week1 ADD COLUMN quarter INT;

UPDATE week1
SET quarter = 1
WHERE transaction_date GLOB "*/0[1-3]/*";

UPDATE week1
SET quarter = 2
WHERE transaction_date GLOB "*/0[4-6]/*";

UPDATE week1
SET quarter = 3
WHERE transaction_date GLOB "*/0[7-9]/*";

UPDATE week1
SET quarter = 4
WHERE transaction_date GLOB "*/1[0-2]/*";

-- Remove unnecessary columns
SELECT transaction_code,
	value,
	online_or_in_person,
	quarter
FROM week1
WHERE transaction_code LIKE "DSB%";

-- Sum the transaction values for each quarter and for 
--  each Type of Transaction (Online or In-Person)
DROP VIEW IF EXISTS [week1view];
CREATE VIEW [week1view] AS
SELECT transaction_code, 
	CAST(SUM(value) as INT) value, 
	CAST(online_or_in_person as TEXT) online_or_in_person, 
	quarter
FROM (SELECT transaction_code,
	value,
	online_or_in_person,
	quarter
	FROM week1
	WHERE transaction_code LIKE "DSB%"
	) sub
GROUP BY online_or_in_person, quarter;

-- Pivot the quarterly targets so we have a row for each 
--  Type of Transaction and each Quarter
--
-- Use targets_cleaned in the meantime

-- CLean targets_cleaned column names
ALTER TABLE targets_cleaned RENAME COLUMN QuarterlyTargets TO quarterly_targets;
ALTER TABLE targets_cleaned RENAME COLUMN `OnlineorIn-Person` TO online_or_in_person;
ALTER TABLE targets_cleaned RENAME COLUMN Quarter TO quarter;

-- Join the two datasets together
SELECT w1.quarter,
	w1.value,
	w1.online_or_in_person,
	tc.quarterly_targets
FROM week1view w1
JOIN targets_cleaned tc
	ON w1.quarter = tc.quarter
	AND w1.online_or_in_person = tc.online_or_in_person
GROUP BY w1.quarter, w1.online_or_in_person;

-- Calculate the Variance to Target for each row
SELECT online_or_in_person,
	quarter,
	value,
	quarterly_targets,
	(value - quarterly_targets) variance_to_target
FROM (SELECT w1.quarter,
	w1.value,
	w1.online_or_in_person,
	tc.quarterly_targets
	FROM week1view w1
	JOIN targets_cleaned tc
		ON w1.quarter = tc.quarter
		AND w1.online_or_in_person = tc.online_or_in_person
	GROUP BY w1.quarter, w1.online_or_in_person
	) sub;
