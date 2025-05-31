# 📚 Tabulka pojmů - SQL projekt

**Slovník klíčových pojmů a zkratek použitých v projektu**

---

## 🔤 **SQL POJMY**

| Pojem | Vysvětlení | Použití v projektu |
|-------|------------|-------------------|
| **SELECT** | Příkaz pro výběr dat z tabulky | Základní příkaz pro všechny dotazy |
| **FROM** | Určuje zdrojovou tabulku | `FROM czechia_payroll` |
| **WHERE** | Podmínka pro filtrování řádků | `WHERE value_type_code = 5958` |
| **GROUP BY** | Seskupování řádků podle hodnot | `GROUP BY payroll_year, industry_branch_code` |
| **ORDER BY** | Řazení výsledků | `ORDER BY year, industry_branch_code` |
| **JOIN** / **INNER JOIN** | Spojení tabulek - jen řádky s shodou v obou | Spojování mezd s cenami |
| **LEFT JOIN** | Zachová všechny řádky z levé tabulky | Pro meziroční srovnání (self-join) |
| **Self-join** | Spojení tabulky se sebou samou | `current_year.year = prev_year.year + 1` |
| **CREATE TABLE** | Vytvoření nové tabulky | `CREATE TABLE temp_payroll_yearly` |
| **DROP TABLE** | Smazání tabulky | `DROP TABLE IF EXISTS temp_...` |
| **AS** | Alias - přejmenování sloupce/tabulky | `AVG(value) AS avg_payroll` |
| **DISTINCT** | Výběr unikátních hodnot bez duplikátů | `SELECT DISTINCT payroll_year` |
| **LIMIT** | Omezení počtu výsledných řádků | `LIMIT 10` - jen prvních 10 řádků |
| **CASE WHEN** | Podmíněná logika ("když... pak...") | Extrakce roku z data: `CASE WHEN date_from >= '2006-01-01'...` |
| **EXTRACT()** | Vytažení části z data | `EXTRACT(YEAR FROM date_from)` |
| **IS NOT NULL** | Kontrola, zda hodnota není prázdná | `WHERE prev_year.avg_payroll IS NOT NULL` |

---

## 📊 **AGREGAČNÍ FUNKCE**

| Funkce | Účel | Příklad použití |
|--------|------|----------------|
| **AVG()** | Průměr | `AVG(value)` - průměrná mzda |
| **COUNT()** | Počet řádků | `COUNT(*)` - kolik máme záznamů |
| **MIN()** | Minimální hodnota | `MIN(year)` - nejstarší rok |
| **MAX()** | Maximální hodnota | `MAX(year)` - nejnovější rok |

---

## 🏛️ **DATABÁZOVÉ OBJEKTY**

| Objekt | Vysvětlení | Příklady v projektu |
|--------|------------|-------------------|
| **Tabulka** | Místo uložení dat (řádky + sloupce) | `czechia_payroll`, `czechia_price` |
| **Sloupec** | Vertikální část tabulky | `payroll_year`, `value`, `category_code` |
| **Řádek** | Horizontální část tabulky - jeden záznam | Jedna mzda za čtvrtletí v jednom odvětví |
| **Primární klíč** | Unikátní identifikátor řádku | `id` sloupce v tabulkách |
| **Cizí klíč** | Odkaz na primární klíč jiné tabulky | `industry_branch_code` → `czechia_payroll_industry_branch.code` |
| **Číselník** | Tabulka s kódy a jejich názvy | `czechia_payroll_value_type` |
| **Alias** | Zkrácený název tabulky | `cp` místo `czechia_payroll` |

---

## 💼 **EKONOMICKÉ POJMY**

| Pojem | Vysvětlení | Souvislost s projektem |
|-------|------------|----------------------|
| **HDP** | Hrubý domácí produkt - celková hodnota výroby | Výzkumná otázka 5 |
| **GINI koeficient** | Míra nerovnosti příjmů (0-100) | Sekundární tabulka evropských zemí |
| **Kupní síla** | Kolik si můžeme koupit za peníze | Výpočet jednotek potravin za mzdu |
| **Meziroční růst** | Změna mezi stejnými obdobími různých let | Srovnání 2007 vs 2006, atd. |
| **Inflace** | Růst cenové hladiny | Růst cen potravin |
| **Deflace** | Pokles cenové hladiny | Zlevnění cukru a rajčat |
| **Reálná mzda** | Mzda upravená o inflaci | Kolik si skutečně můžeme koupit |
| **Nominální mzda** | Mzda v běžných cenách | Mzdy v našem projektu |
| **Volatilita** | Míra výkyvů hodnot | Těžba má vysokou volatilitu |
| **Korelace** | Míra vztahu mezi dvěma veličinami | HDP vs. mzdy |

---

## 🏭 **KÓDY ODVĚTVÍ**

| Kód | Název odvětví | Charakteristika |
|-----|---------------|----------------|
| **A** | Zemědělství, lesnictví, rybářství | Primární sektor |
| **B** | Těžba a dobývání | Volatilní, závislé na komoditách |
| **C** | Zpracovatelský průmysl | Stabilní růst |
| **D** | Výroba a rozvod elektřiny | Vysoké mzdy, volatilní |
| **F** | Stavebnictví | Cyklické |
| **G** | Velkoobchod a maloobchod | Služby |
| **H** | Doprava a skladování | Nejstabilnější růst |
| **I** | Ubytování, stravování | Nižší mzdy |
| **J** | Informační a komunikační činnosti | Nejvyšší mzdy |
| **K** | Peněžnictví a pojišťovnictví | Vysoké mzdy, nízký růst |
| **O** | Veřejná správa a obrana | Veřejný sektor |
| **P** | Vzdělávání | Veřejný sektor |
| **Q** | Zdravotní a sociální péče | Nejrychlejší růst mezd |

---

## 🥬 **KÓDY POTRAVIN**

| Kód | Název potraviny | Jednotka | Poznámka |
|-----|----------------|----------|----------|
| **111301** | Chléb konzumní kmínový | kg | Základní potravina pro analýzu |
| **114201** | Mléko polotučné pasterované | l | Základní potravina pro analýzu |
| **118101** | Cukr krystalový | kg | Největší zlevnění (-27.5%) |
| **117101** | Rajská jablka červená kulatá | kg | Druhé největší zlevnění (-23.1%) |
| **115101** | Máslo | kg | Největší zdražení (+98.4%) |
| **116103** | Banány žluté | kg | Nejstabilnější ceny (+7.4%) |

---

## 🔢 **TYPY HODNOT A KALKULACÍ**

| Kód | Typ | Vysvětlení |
|-----|-----|------------|
| **5958** | Průměrná hrubá mzda na zaměstnance | Klíčová hodnota pro naši analýzu |
| **316** | Průměrný počet zaměstnaných osob | Nepoužíváme |
| **100** | Fyzický | Skutečné mzdy (včetně částečných úvazků) |
| **200** | Přepočtený | Přepočteno na plné úvazky |

---

## 📈 **ANALYTICKÉ POJMY**

| Pojem | Vysvětlení | Použití |
|-------|------------|---------|
| **Procentuální růst** | `((nová - stará) / stará) × 100` | Růst mezd a cen |
| **Procentní bod** | Rozdíl mezi procenty | Rozdíl růstu cen a mezd |
| **Medián** | Prostřední hodnota | Statistické srovnání |
| **Průměr** | `Součet / počet` | Základní agregace |
| **Minimum/Maximum** | Nejnižší/nejvyšší hodnota | Růstová analýza |
| **Absolutní změna** | Rozdíl v původních jednotkách | +207 litrů mléka |
| **Relativní změna** | Rozdíl v procentech | +14.5% pro mléko |

---

## 💻 **TECHNICKÉ POJMY**

| Pojem | Vysvětlení | Souvislost |
|-------|------------|------------|
| **Subselect** | Vnořený dotaz | Dotaz uvnitř jiného dotazu (otázka 5) |
| **Kartézský součin** | Každý řádek s každým | JOIN výsledek - každá mzda s každou potravinou |
| **Agregace** | Seskupení a výpočet | GROUP BY + agregační funkce |
| **Filtrování** | Výběr podle podmínek | WHERE klauzule |
| **Primární tabulka** | Hlavní výsledek projektu | `t_filip_hedvik_project_SQL_primary_final` |
| **Sekundární tabulka** | Dodatečné ekonomické údaje | `t_filip_hedvik_project_SQL_secondary_final` |
| **Pomocná tabulka** | Dočasná tabulka pro výpočty | `temp_payroll_yearly`, `temp_prices_yearly` |

---

## 🌍 **GEOGRAFICKÉ POJMY**

| Pojem | Vysvětlení | Použití |
|-------|------------|---------|
| **ČR/Česká republika** | Hlavní země analýzy | Všechny hlavní analýzy |
| **Evropa** | Kontinent pro srovnání | Sekundární tabulka |
| **Kraj** | Regionální jednotka ČR | Ceny agregované přes kraje |
| **CZ010, CZ020...** | Kódy krajů | Regionální data v cenách |

---

## ⏰ **ČASOVÉ POJMY**

| Pojem | Vysvětlení | Rozsah v projektu |
|-------|------------|------------------|
| **Společné období** | Průsečík dostupných dat | 2006-2018 |
| **Čtvrtletí** | 3 měsíce | Mzdová data |
| **Týden** | 7 dní | Cenová data |
| **Rok** | 12 měsíců | Finální agregace |
| **Meziroční srovnání** | Rok oproti předchozímu roku | 2007 vs 2006, atd. |

---

## 🎯 **VÝZKUMNÉ POJMY**

| Pojem | Vysvětlení | Otázka |
|-------|------------|--------|
| **Nejpomalejší zdražování** | Nejnižší procentuální růst cen | Otázka 3 |
| **Kritický rozdíl 10%** | Limit pro výrazný rozdíl ceny vs mzdy | Otázka 4 |
| **Korelace HDP** | Vztah mezi růstem HDP a mezd/cen | Otázka 5 |
| **Kupní síla základních potravin** | Kolik mléka/chleba za průměrnou mzdu | Otázka 2 |
| **Růst across all sectors** | Pozitivní trend ve všech odvětvích | Otázka 1 |
