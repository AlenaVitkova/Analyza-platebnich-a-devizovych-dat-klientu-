-- DIMENZE: Klienti
CREATE VIEW dim_clients AS
SELECT
    client_id,
    client_name,
    client_type,
    country_code,
    onboarding_date,
    kyc_status
FROM clients;

-- DIMENZE: Účty
CREATE VIEW dim_accounts AS
SELECT
    account_id,
    account_number,
    account_open_date,
    account_status,
    currency,
    client_id
FROM accounts;

-- DIMENZE: Země
CREATE VIEW dim_countries AS
SELECT
    country_code,
    country_name,
    risk_level,
    eu_member
FROM countries;

-- FACT: Platby (hlavní měřitelné události)
CREATE VIEW fact_payments AS
SELECT
    p.payment_id,
    p.payment_date,
    p.amount,
    p.currency,
    p.direction,
    p.payment_type,
    p.payment_status,
    p.account_id,
    p.counterparty_country,
    a.client_id,          
    c.country_code AS client_country  
FROM payments p
JOIN accounts a ON p.account_id = a.account_id
JOIN clients c ON a.client_id = c.client_id;

-- FACT: FX obchody
CREATE VIEW fact_fx_trades AS
SELECT
    fx_trade_id,
    trade_date,
    client_id,
    currency_from,
    currency_to,
    amount_from,
    amount_to,
    exchange_rate,
    trade_status
FROM fx_trades;
