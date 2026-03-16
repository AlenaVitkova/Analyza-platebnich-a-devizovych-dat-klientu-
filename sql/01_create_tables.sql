CREATE TABLE countries (
    country_code TEXT PRIMARY KEY,
    country_name TEXT,
    risk_level TEXT,
    eu_member TEXT
);

CREATE TABLE clients (
    client_id INTEGER PRIMARY KEY,
    client_name TEXT,
    country_code TEXT REFERENCES countries(country_code),
    client_type TEXT,
    onboarding_date DATE,
    kyc_status TEXT
);

CREATE TABLE accounts (
    account_id INTEGER PRIMARY KEY,
    account_number TEXT,
    account_open_date DATE,
    account_status TEXT,
    currency TEXT,
    client_id INTEGER REFERENCES clients(client_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    account_id INTEGER REFERENCES accounts(account_id),
    payment_date DATE,
    amount NUMERIC,
    currency TEXT,
    direction TEXT,
    counterparty_country TEXT REFERENCES countries(country_code),
    payment_type TEXT,
    payment_status TEXT
);

CREATE TABLE fx_trades (
    fx_trade_id INTEGER PRIMARY KEY,
    client_id INTEGER REFERENCES clients(client_id),
    trade_date DATE,
    currency_from TEXT,
    currency_to TEXT,
    amount_from NUMERIC,
    exchange_rate NUMERIC,
    amount_to NUMERIC,
    trade_status TEXT
);
