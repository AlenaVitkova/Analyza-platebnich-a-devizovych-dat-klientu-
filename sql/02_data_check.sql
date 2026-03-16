-- První kontrola dat po importu

-- 1.Počet řádků v tabulkách
SELECT
    (SELECT COUNT(*) FROM accounts) AS pocet_uctu, -- 75
    (SELECT COUNT(*) FROM clients) AS pocet_klientu, -- 50
    (SELECT COUNT(*) FROM countries) AS pocet_zemi, -- 10
    (SELECT COUNT(*) FROM fx_trades) AS pocet_fx_obchodu, -- 16
    (SELECT COUNT(*) FROM payments) AS pocet_plateb -- 50


-- 2.Počet různých zemí -- 6
SELECT 
    COUNT(DISTINCT country_code) AS pocet_zemi 
FROM clients;

-- 3. Přehled zemí klientů
SELECT DISTINCT 
    country_code
FROM clients
ORDER BY country_code;

-- 4. Nejmenší a největší platby
SELECT
    MIN(amount) AS nejmensi_castka,  -- 1200
    MAX(amount) AS nejvetsi_castka,  -- 250000
    AVG(amount) AS prumerna_castka   -- 24520
FROM payments
WHERE amount>0;

-- 5.Počet plateb podle měny
SELECT
    currency,
    COUNT(*) AS pocet_plateb
    FROM payments
GROUP BY currency
ORDER BY pocet_plateb DESC;

-- 6. Objem plateb podle dne
SELECT
    payment_date,
    SUM(amount) AS objem_plateb
FROM payments
GROUP BY payment_date
ORDER BY payment_date;

-- 7.Jaký je objem plateb podle měn?
SELECT
    currency,
    COUNT(*) AS pocet_plateb,
    SUM(amount) AS celkovy_objem_plateb
FROM payments
GROUP BY currency
ORDER BY celkovy_objem_plateb DESC;

-- Kontrola kvality dat

--Tabulka payments
-- 1.Vyskytují se NULL hodnoty? - 1 hodnota
SELECT *
FROM payments
WHERE amount IS NULL
   OR currency IS NULL
   OR payment_date IS NULL
   OR payment_status IS NULL;

-- 2.Vyskytují se 0 nebo záporné hodnoty? - 1 hodnota
SELECT *
FROM payments
WHERE amount <= 0;

-- 3.Duplikuje se někde payment.ID? - Ne
SELECT
    payment_id,
    COUNT(*) AS pocet
FROM payments
GROUP BY payment_id
HAVING COUNT(*) > 1;

--Tabulka fx_trades
-- 1.Vyskytují se NULL hodnoty? - 1 hodnota
SELECT *
FROM fx_trades
WHERE client_id IS NULL
   OR amount_from IS NULL
   OR amount_to IS NULL
   OR exchange_rate IS NULL
   OR currency_from IS NULL
   OR currency_to IS NULL
   OR trade_date IS NULL;

-- 2.Vyskytují se 0 nebo záporné hodnoty? - 0
SELECT *
FROM fx_trades
WHERE amount_from <= 0
   OR amount_to <= 0
   OR exchange_rate <= 0;

--3.Směna stejné měny? - 0
SELECT *
FROM fx_trades
WHERE currency_from = currency_to;

--Tabulka clients

-- 1.Nulové hodnoty? - 0
SELECT *
FROM clients
WHERE client_name IS NULL
   OR country_code IS NULL
   OR kyc_status IS NULL;

--Tabulka accounts

-- 1.Nulové hodnoty? - 0
SELECT *
FROM accounts
WHERE client_ID IS NULL
   OR currency IS NULL;

-- Kontrola, zda je platba bez existujícího účtu
SELECT p.*
FROM payments p
LEFT JOIN accounts a
    ON p.account_id = a.account_id
WHERE a.account_id IS NULL;

-- Kolik plateb a jakou celkovou částku udělal klient? Nutnost spojit tabulky payments -> accounts -> clients
-- INNER JOIN - vypíše pouze klienty, kteří mají účet a alespoň 1 platbu
SELECT
  c.client_name,
  COUNT(p.payment_id) AS pocet_plateb,
  SUM(p.amount) AS celkova_castka
FROM clients c
JOIN accounts a
    ON c.client_id = a.client_id
JOIN payments p
    ON a.account_id = p.account_id
GROUP BY c.client_name
ORDER BY celkova_castka DESC;


-- Kontrola, zda převod měn sedí
SELECT fx_trade_id, 
  amount_from, 
  exchange_rate, 
  amount_to,
  ROUND(amount_from / exchange_rate, 2) AS pocitany_prevod,
  ROUND(amount_from / exchange_rate, 2) - amount_to AS rozdil
FROM fx_trades
