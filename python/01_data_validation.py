import pandas as pd

# Načtení dat
payments = pd.read_csv("fact_payments.csv")
fx_trades = pd.read_csv("fact_fx_trades.csv")
clients = pd.read_csv("dim_clients.csv")
accounts = pd.read_csv("dim_accounts.csv")

issues = []

# ── PAYMENTS ──────────────────────────────────────────
# NULL hodnoty
null_payments = payments[
    payments["amount"].isnull() |
    payments["currency"].isnull() |
    payments["payment_date"].isnull() |
    payments["payment_status"].isnull()
]
if not null_payments.empty:
    issues.append(f"PAYMENTS: {len(null_payments)} záznamů s NULL hodnotou")

# Záporné nebo nulové částky
invalid_amount = payments[payments["amount"] <= 0]
if not invalid_amount.empty:
    issues.append(f"PAYMENTS: {len(invalid_amount)} záznamů se zápornou nebo nulovou částkou")

# Duplicitní payment_id
duplicates = payments[payments.duplicated(subset="payment_id")]
if not duplicates.empty:
    issues.append(f"PAYMENTS: {len(duplicates)} duplicitních payment_id")

for issue in issues:
    print(issue)
