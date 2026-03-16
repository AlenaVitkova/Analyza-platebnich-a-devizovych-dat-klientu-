## Úvod projektu

Tento projekt se zaměřuje na analýzu dat o klientech, účtech, zahraničních 
platbách a devizových obchodech fiktivní finanční instituce. Data byla uložena 
v relační databázi PostgreSQL (Neon), transformována pomocí SQL pohledů a vizualizována v Power BI.

Projekt zahrnuje čtyři hlavní fáze:
- kontrolu kvality dat pomocí SQL
- tvorbu Python skriptu pro validaci dat
- sestavení hvězdicového datového modelu
- vizualizaci výsledků v Power BI

Výstupy mohou sloužit jako podklad pro monitoring transakcí, AML reporting 
nebo další compliance analýzy.

## Závěr projektu

### Kontrola kvality dat (Python + SQL)

Během kontroly dat pomocí SQL dotazů a Python skriptu byly v tabulkách 
`payments` a `fx_trades` identifikovány záznamy s chybějícími hodnotami 
(NULL), nulovými nebo zápornými částkami. Tyto záznamy by měly být před 
dalším zpracováním opraveny nebo vyloučeny z analýzy.

### Power BI

Při analýze v PBI bylo zjištěno, že část klientů má neúplný KYC status 
(`incomplete`), přesto provedli zahraniční platby i devizové obchody. 
Potřeba prozkoumat a řešit.

### Výstupy projektu

Report v Power BI obsahuje 2 listy - Zahraniční platby a Devizové obchody.
Poskytuje přehled o:
- objemu a struktuře zahraničních plateb podle měn a zemí
- devizových obchodech podle měnových párů a jejich vývoji v čase
- výsledky je možno filtrovat pomocí filtrů 
