-- =====================================================
-- SQL PROJEKT: Analýza dostupnosti základních potravin
-- VERZE PRO ÚPLNÉ ZAČÁTEČNÍKY
-- Autor: Filip Hedvik
-- Období analýzy: 2006-2018
-- 
-- CO TENTO KÓD DĚLÁ:
-- Analyzuje, kolik potravin si mohou koupit lidé v různých odvětvích
-- za své průměrné mzdy v České republice mezi lety 2006-2018
-- =====================================================

-- =====================================================
-- CO JE SQL?
-- SQL = Structured Query Language = jazyk pro práci s databázemi
-- Databáze = místo, kde jsou uložena data v tabulkách
-- Tabulka = jako Excel tabulka - má řádky a sloupce
-- 
-- ZÁKLADNÍ PŘÍKAZY:
-- SELECT = vyber data (jako "ukaž mi")
-- FROM = z které tabulky
-- WHERE = s jakou podmínkou (filtr)
-- GROUP BY = seskup podle něčeho
-- ORDER BY = seřaď podle něčeho
-- JOIN = spoj dvě tabulky dohromady
-- CREATE TABLE = vytvoř novou tabulku
-- =====================================================

-- =====================================================
-- PRŮZKUMNÉ DOTAZY - POZNÁVÁME DATA
-- 
-- PŘED PSANÍM SLOŽITÝCH ANALÝZ MUSÍME POCHOPIT, 
-- JAKÁ DATA MÁME K DISPOZICI
-- 
-- Tyto dotazy jsme použili na začátku projektu,
-- abychom zjistili:
-- - Jaké roky máme dostupné
-- - Jaké jsou kódy pro mzdy a potraviny
-- - Jak vypadají vzorová data
-- =====================================================

-- DOTAZ 1: Jaké roky máme dostupné v tabulce mezd?
-- ÚČEL: Zjistit časový rozsah mzdových dat
SELECT DISTINCT payroll_year 
FROM czechia_payroll 
ORDER BY payroll_year;
-- DISTINCT = "bez duplikátů" - každý rok jen jednou
-- VÝSLEDEK: 2000, 2001, 2002, ... 2021

-- DOTAZ 2: Jaké roky máme dostupné v tabulce cen?
-- ÚČEL: Zjistit časový rozsah cenových dat
-- EXTRACT(YEAR FROM date_from) = "vytáhni rok z data"
SELECT DISTINCT EXTRACT(YEAR FROM date_from) as year 
FROM czechia_price 
ORDER BY year;
-- VÝSLEDEK: 2006, 2007, 2008, ... 2018

-- ZÁVĚR Z DOTAZŮ 1 A 2: 
-- Společné období = 2006-2018 (průsečík obou datových sad)

-- DOTAZ 3: Jaké typy hodnot máme v tabulce mezd?
-- ÚČEL: Zjistit, který kód znamená "průměrná mzda"
SELECT * FROM czechia_payroll_value_type;
-- VÝSLEDEK: Našli jsme kód 5958 = "Průměrná hrubá mzda na zaměstnance"

-- DOTAZ 3B: Jaké typy kalkulací máme v tabulce mezd?
-- ÚČEL: Zjistit rozdíl mezi "fyzickým" a "přepočteným"
SELECT * FROM czechia_payroll_calculation;
-- VÝSLEDEK: 
-- 100 = "fyzický" (skutečný počet zaměstnanců/skutečné mzdy)
-- 200 = "přepočtený" (přepočteno na plný úvazek)
-- 
-- CO TO ZNAMENÁ:
-- - Fyzický = člověk pracuje na částečný úvazek = nižší mzda
-- - Přepočtený = jako kdyby všichni pracovali na plný úvazek
-- - Pro analýzu kupní síly použijeme "fyzický" (skutečné příjmy lidí)

-- DOTAZ 3C: Jaké jednotky máme v tabulce mezd?
-- ÚČEL: Pochopit, v jakých jednotkách jsou mzdy uvedeny
SELECT * FROM czechia_payroll_unit;
-- OČEKÁVÁNÝ VÝSLEDEK: Pravděpodobně Kč, osoby, atd.

-- DOTAZ 3D: Jaká odvětví máme k dispozici?
-- ÚČEL: Podívat se na všechna dostupná odvětví
SELECT * FROM czechia_payroll_industry_branch ORDER BY code;
-- VÝSLEDEK: A = Zemědělství, C = Zpracovatelský průmysl, atd.

-- DOTAZ 4: Jaké potraviny máme v databázi?
-- ÚČEL: Najít kódy pro mléko a chléb (potřeba pro otázku 2)
SELECT * FROM czechia_price_category ORDER BY name;
-- VÝSLEDEK: 
-- 114201 = "Mléko polotučné pasterované" (1.0 l)
-- 111301 = "Chléb konzumní kmínový" (1.0 kg)

-- DOTAZ 5: Jak vypadají vzorová data z mezd?
-- ÚČEL: Pochopit strukturu mzdových dat a ověřit naše předpoklady
SELECT * FROM czechia_payroll 
WHERE payroll_year = 2006 AND value_type_code = 5958 
LIMIT 5;
-- VÝSLEDEK: Viděli jsme, že všechny řádky mají:
-- - value_type_code = 5958 (průměrná hrubá mzda)
-- - unit_code = 200 (jednotka)
-- - calculation_code = 100 (fyzický - skutečné mzdy, ne přepočtené)
-- - Hodnoty v řádech tisíců (pravděpodobně Kč)

-- DOTAZ 6: Jak vypadají vzorová data z cen?
-- ÚČEL: Pochopit strukturu cenových dat
SELECT * FROM czechia_price 
WHERE category_code IN ('114201', '111301') 
AND EXTRACT(YEAR FROM date_from) = 2006 
LIMIT 5;
-- VÝSLEDEK: Viděli jsme týdenní data podle krajů

-- DOTAZ 7: Kontrola názvu sloupce (kvůli chybě)
-- ÚČEL: Zjistit správný název sloupce v tabulce economies
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'economies' 
AND column_name LIKE '%mortality%';
-- VÝSLEDEK: Objevili jsme překlep "mortaliy_under5" (chybí 't')

-- DOTAZ 8: Jaké země máme v tabulce countries?
-- ÚČEL: Zkontrolovat, jestli máme evropské země
SELECT DISTINCT country 
FROM countries 
WHERE continent = 'Europe' 
ORDER BY country 
LIMIT 10;
-- VÝSLEDEK: Potvrdili jsme, že máme evropské země včetně ČR

-- DOTAZ 9: Kontrola dat o ČR v tabulce economies
-- ÚČEL: Ověřit dostupnost HDP dat pro Českou republiku
SELECT * 
FROM economies 
WHERE country = 'Czech Republic' 
AND year BETWEEN 2006 AND 2018
ORDER BY year;
-- VÝSLEDEK: Potvrdili jsme dostupnost HDP dat pro naše období

-- =====================================================
-- ZÁVĚRY Z PRŮZKUMNÝCH DOTAZŮ:
-- 
-- ✅ Společné období: 2006-2018 (13 let)
-- ✅ Kód pro průměrnou mzdu: 5958
-- ✅ Typ kalkulace: 100 (fyzické mzdy, ne přepočtené)
-- ✅ Kód pro mléko: 114201, chléb: 111301  
-- ✅ Mzdy: čtvrtletní data → potřeba průměrování
-- ✅ Ceny: týdenní data podle krajů → potřeba průměrování
-- ✅ Evropské země včetně ČR: dostupné
-- ✅ HDP data pro ČR: dostupná pro celé období
-- =====================================================

-- =====================================================
-- KROK 1: VYTVOŘENÍ POMOCNÝCH TABULEK
-- 
-- PROČ POMOCNÉ TABULKY?
-- Představte si, že vaříte složité jídlo. Nejdřív si připravíte
-- jednotlivé suroviny, a pak je spojíte dohromady.
-- Stejně tak v SQL - nejdřív si připravíme jednodušší tabulky,
-- pak je spojíme do finální tabulky.
-- =====================================================

-- POMOCNÁ TABULKA 1: Průměrné roční mzdy podle odvětví
-- 
-- CO DĚLÁME:
-- Bereme tabulku "czechia_payroll" (která má mzdy po čtvrtletích)
-- a vypočítáváme z ní průměrnou mzdu za celý rok pro každé odvětví

-- DROP TABLE IF EXISTS = "pokud tabulka existuje, smaž ji"
-- (abychom mohli kód spustit víckrát bez chyby)
DROP TABLE IF EXISTS temp_payroll_yearly;

-- CREATE TABLE AS = "vytvoř novou tabulku a naplň ji daty z tohoto dotazu"
CREATE TABLE temp_payroll_yearly AS
SELECT 
    -- SELECT = "vyber tyto sloupce"
    -- payroll_year = rok (bude to sloupec v nové tabulce)
    payroll_year,
    
    -- industry_branch_code = kód odvětví (A = zemědělství, C = průmysl, atd.)
    industry_branch_code,
    
    -- AVG() = average = průměr
    -- AVG(value) = spočítej průměr ze sloupce "value" (hodnota mzdy)
    -- AS avg_payroll = "pojmenuj tento vypočítaný sloupec jako avg_payroll"
    AVG(value) AS avg_payroll
    
-- FROM = "bere data z tabulky czechia_payroll"
FROM czechia_payroll 

-- WHERE = "ale pouze řádky, které splňují tyto podmínky"
WHERE value_type_code = 5958  
    -- value_type_code = 5958 znamená "průměrná hrubá mzda na zaměstnance"
    -- (ověřili jsme si to dotazem na tabulku czechia_payroll_value_type)
    -- Mohli bychom chtít i jiné typy (např. počet zaměstnanců), ale my chceme mzdy
    
    AND payroll_year >= 2006  -- AND = "a zároveň"
    -- payroll_year >= 2006 = "rok je větší nebo roven 2006"
    -- Začátek našeho společného období (kdy máme data jak pro mzdy, tak pro ceny)
    
    AND payroll_year <= 2018  
    -- payroll_year <= 2018 = "rok je menší nebo roven 2018"
    -- Konec našeho společného období

-- GROUP BY = "seskup řádky podle těchto sloupců"
-- GROUP BY payroll_year, industry_branch_code = 
-- "udělej samostatnou skupinu pro každou kombinaci rok + odvětví"
-- Takže budeme mít jednu skupinu pro "2006 + zemědělství", 
-- druhou pro "2006 + průmysl", atd.
-- AVG() se pak počítá pro každou skupinu zvlášť
GROUP BY payroll_year, industry_branch_code;

-- ZKONTROLUJEME, CO JSME VYTVOŘILI
-- SELECT * = "vyber všechny sloupce"
-- ORDER BY = "seřaď podle" (aby výsledek byl přehledný)
-- LIMIT 10 = "ukaž jen prvních 10 řádků" (aby se nám nevypsalo moc dat)
SELECT * FROM temp_payroll_yearly ORDER BY payroll_year, industry_branch_code LIMIT 10;

-- POMOCNÁ TABULKA 2: Celkový průměr mezd za všechna odvětví
--
-- PROČ POTŘEBUJEME TAKÉ CELKOVÝ PRŮMĚR?
-- V předchozí tabulce máme průměr pro každé odvětví zvlášť.
-- Ale někdy chceme vědět, jaká je průměrná mzda v celé ČR
-- (bez ohledu na odvětví). To se hodí pro obecné srovnání.

DROP TABLE IF EXISTS temp_payroll_total;
CREATE TABLE temp_payroll_total AS
SELECT 
    payroll_year,
    
    -- Stejný AVG() jako výše, ale tentokrát počítáme průměr
    -- ze VŠECH odvětví dohromady (proto nejsou v GROUP BY odvětví)
    AVG(value) AS avg_payroll_total
    
FROM czechia_payroll 
WHERE value_type_code = 5958  -- Stejné podmínky jako výše
    AND payroll_year >= 2006  
    AND payroll_year <= 2018  

-- POZOR: Tady je GROUP BY jen podle roku (bez odvětví)!
-- To znamená, že všechna odvětví stejného roku se spojí do jedné skupiny
-- a AVG() spočítá průměr ze všech odvětví
GROUP BY payroll_year;

-- ZKONTROLUJEME VÝSLEDEK
-- Měli bychom vidět 13 řádků (jeden za každý rok 2006-2018)
SELECT * FROM temp_payroll_total ORDER BY payroll_year;

-- POMOCNÁ TABULKA 3: Průměrné roční ceny potravin
--
-- PROBLÉM: Ceny jsou v tabulce "czechia_price" uložené týdně
-- (každý týden má svůj řádek), ale my chceme roční průměry.
-- Také každý kraj má své ceny, ale my chceme průměr za celou ČR.

DROP TABLE IF EXISTS temp_prices_yearly;
CREATE TABLE temp_prices_yearly AS
SELECT 
    -- PROBLÉM: Sloupec date_from obsahuje úplné datum (např. "2006-11-06 01:00:00")
    -- ale my chceme jen rok (2006).
    -- ŘEŠENÍ: Použijeme CASE WHEN (= "když... pak...")
    
    CASE 
        -- CASE WHEN podmínka THEN výsledek
        -- "Když je datum mezi 1.1.2006 a 1.1.2007, pak je to rok 2006"
        WHEN date_from >= '2006-01-01' AND date_from < '2007-01-01' THEN 2006
        WHEN date_from >= '2007-01-01' AND date_from < '2008-01-01' THEN 2007
        WHEN date_from >= '2008-01-01' AND date_from < '2009-01-01' THEN 2008
        WHEN date_from >= '2009-01-01' AND date_from < '2010-01-01' THEN 2009
        WHEN date_from >= '2010-01-01' AND date_from < '2011-01-01' THEN 2010
        WHEN date_from >= '2011-01-01' AND date_from < '2012-01-01' THEN 2011
        WHEN date_from >= '2012-01-01' AND date_from < '2013-01-01' THEN 2012
        WHEN date_from >= '2013-01-01' AND date_from < '2014-01-01' THEN 2013
        WHEN date_from >= '2014-01-01' AND date_from < '2015-01-01' THEN 2014
        WHEN date_from >= '2015-01-01' AND date_from < '2016-01-01' THEN 2015
        WHEN date_from >= '2016-01-01' AND date_from < '2017-01-01' THEN 2016
        WHEN date_from >= '2017-01-01' AND date_from < '2018-01-01' THEN 2017
        WHEN date_from >= '2018-01-01' AND date_from < '2019-01-01' THEN 2018
        -- END = konec CASE příkazu
    END AS price_year,  -- Pojmenujeme výsledný sloupec jako "price_year"
    
    -- category_code = kód potraviny (114201 = mléko, 111301 = chléb, atd.)
    category_code,
    
    -- AVG(value) = průměrná cena
    -- Průměr ze všech týdnů daného roku a všech krajů
    AVG(value) AS avg_price
    
FROM czechia_price 
WHERE date_from >= '2006-01-01'  -- Začátek našeho období
    AND date_from < '2019-01-01'   -- Konec našeho období (do konce 2018)

GROUP BY 
    -- POZOR: V GROUP BY musíme zopakovat celý CASE výraz!
    -- (nemůžeme použít jen "price_year", protože to je alias)
    CASE 
        WHEN date_from >= '2006-01-01' AND date_from < '2007-01-01' THEN 2006
        WHEN date_from >= '2007-01-01' AND date_from < '2008-01-01' THEN 2007
        WHEN date_from >= '2008-01-01' AND date_from < '2009-01-01' THEN 2008
        WHEN date_from >= '2009-01-01' AND date_from < '2010-01-01' THEN 2009
        WHEN date_from >= '2010-01-01' AND date_from < '2011-01-01' THEN 2010
        WHEN date_from >= '2011-01-01' AND date_from < '2012-01-01' THEN 2011
        WHEN date_from >= '2012-01-01' AND date_from < '2013-01-01' THEN 2012
        WHEN date_from >= '2013-01-01' AND date_from < '2014-01-01' THEN 2013
        WHEN date_from >= '2014-01-01' AND date_from < '2015-01-01' THEN 2014
        WHEN date_from >= '2015-01-01' AND date_from < '2016-01-01' THEN 2015
        WHEN date_from >= '2016-01-01' AND date_from < '2017-01-01' THEN 2016
        WHEN date_from >= '2017-01-01' AND date_from < '2018-01-01' THEN 2017
        WHEN date_from >= '2018-01-01' AND date_from < '2019-01-01' THEN 2018
    END,
    -- A také seskupujeme podle kódu potraviny
    -- (chceme průměr pro každou potravinu zvlášť)
    category_code;

-- ZKONTROLUJEME VÝSLEDEK
-- Měli bychom vidět různé kombinace roku a potraviny
SELECT * FROM temp_prices_yearly ORDER BY price_year, category_code LIMIT 10;

-- =====================================================
-- KROK 2: VYTVOŘENÍ PRIMÁRNÍ TABULKY
-- 
-- NYNÍ SPOJÍME VŠECHNY POMOCNÉ TABULKY DOHROMADY
-- 
-- CO CHCEME DOSÁHNOUT:
-- Chceme tabulku, kde každý řádek obsahuje:
-- - rok
-- - odvětví 
-- - potravinu
-- - průměrnou mzdu v tom odvětví
-- - průměrnou cenu té potraviny
-- - kolik té potraviny si za tu mzdu může koupit
-- =====================================================

DROP TABLE IF EXISTS t_filip_hedvik_project_SQL_primary_final;
CREATE TABLE t_filip_hedvik_project_SQL_primary_final AS
SELECT 
    -- ZÁKLADNÍ INFORMACE O ROCE
    pty.payroll_year AS year,  -- pty = alias pro temp_payroll_total
    pty.avg_payroll_total,     -- Celkový průměr mezd v daném roce
    
    -- INFORMACE O ODVĚTVÍ
    py.industry_branch_code,   -- py = alias pro temp_payroll_yearly
    cpib.name AS industry_name,          -- cpib = alias pro czechia_payroll_industry_branch
    py.avg_payroll AS industry_avg_payroll,  -- Průměrná mzda v konkrétním odvětví
    
    -- INFORMACE O POTRAVINĚ
    pry.category_code,         -- pry = alias pro temp_prices_yearly
    cpc.name AS food_category,           -- cpc = alias pro czechia_price_category
    cpc.price_unit,            -- Jednotka (kg, l, ks) - abychom věděli, co počítáme
    pry.avg_price AS avg_food_price,     -- Průměrná cena potraviny
    
    -- VÝPOČTY KUPNÍ SÍLY (to je hlavní výsledek!)
    -- Kolik jednotek potraviny si může koupit průměrný člověk v ČR?
    pty.avg_payroll_total / pry.avg_price AS units_total_payroll,
    
    -- Kolik jednotek potraviny si může koupit člověk z konkrétního odvětví?
    py.avg_payroll / pry.avg_price AS units_industry_payroll

-- NYNÍ SPOJUJEME TABULKY POMOCÍ JOIN
-- JOIN = "spoj tabulky podle nějakého klíče"
-- Představte si to jako spojování Excel tabulek podle společného sloupce

FROM temp_payroll_total pty
-- ZAČÍNÁME s tabulkou celkových mezd (nejmenší tabulka = 13 řádků)

-- INNER JOIN = "připoj tabulku, ale jen řádky, které mají shodu v obou tabulkách"
INNER JOIN temp_payroll_yearly py 
    ON pty.payroll_year = py.payroll_year
    -- ON pty.payroll_year = py.payroll_year = "spoj podle roku"
    -- To znamená: vezmi rok 2006 z první tabulky a najdi všechny 
    -- řádky s rokem 2006 v druhé tabulce
    
-- Připojíme tabulku s názvy odvětví (aby místo "A" viděli "Zemědělství")
INNER JOIN czechia_payroll_industry_branch cpib 
    ON py.industry_branch_code = cpib.code
    -- Spojujeme podle kódu odvětví
    
-- Připojíme ceny potravin
INNER JOIN temp_prices_yearly pry 
    ON pty.payroll_year = pry.price_year
    -- Spojujeme podle roku
    -- POZOR: Tady se stane "kartézský součin"!
    -- To znamená: každá mzda se spojí s KAŽDOU potravinou stejného roku
    -- Pokud je v roce 2006 10 odvětví a 20 potravin, 
    -- vznikne 10 × 20 = 200 kombinací pro rok 2006
    
-- Připojíme tabulku s názvy potravin
INNER JOIN czechia_price_category cpc 
    ON pry.category_code = cpc.code
    -- Spojujeme podle kódu potraviny

-- Seřadíme výsledek, aby byl přehledný
ORDER BY year, industry_branch_code, category_code;

-- ZKONTROLUJEME, CO JSME VYTVOŘILI
-- COUNT(*) = "spočítej řádky" - mělo by to být hodně (roky × odvětví × potraviny)
SELECT COUNT(*) AS pocet_radku FROM t_filip_hedvik_project_SQL_primary_final;

-- Podívejme se na prvních 5 řádků
SELECT * FROM t_filip_hedvik_project_SQL_primary_final LIMIT 5;

-- =====================================================
-- KROK 3: VYTVOŘENÍ SEKUNDÁRNÍ TABULKY
-- 
-- ÚČEL: Dodatečné ekonomické údaje o evropských zemích
-- (HDP, GINI koeficient, populace) pro srovnání s ČR
-- =====================================================

DROP TABLE IF EXISTS t_filip_hedvik_project_SQL_secondary_final;
CREATE TABLE t_filip_hedvik_project_SQL_secondary_final AS
SELECT 
    -- INFORMACE O ZEMI
    c.country,          -- c = alias pro countries
    c.capital_city,     -- Hlavní město
    c.currency_name,    -- Měna
    c.population AS population_countries_table,  -- Populace z tabulky countries
    
    -- EKONOMICKÉ ÚDAJE PODLE ROKU
    e.year,             -- e = alias pro economies
    e.population AS population_economies_table,  -- Populace z tabulky economies (může se lišit)
    e.gdp,              -- HDP (Hrubý domácí produkt)
    e.gini,             -- GINI koeficient (míra nerovnosti)
    e.taxes,            -- Daňová zátěž
    e.fertility,        -- Porodnost
    e.mortaliy_under5   -- Dětská úmrtnost (POZOR: překlep v databázi - chybí jedno 't')
    
FROM countries c
-- Spojíme tabulku zemí s tabulkou ekonomických údajů
INNER JOIN economies e ON c.country = e.country
-- Spojujeme podle názvu země

WHERE c.continent = 'Europe'  -- Jen evropské země (podle zadání)
    AND e.year >= 2006        -- Stejné období jako naše hlavní analýza
    AND e.year <= 2018
    
ORDER BY c.country, e.year;   -- Seřadíme podle země a roku

-- ZKONTROLUJEME SEKUNDÁRNÍ TABULKU
SELECT COUNT(*) AS pocet_radku FROM t_filip_hedvik_project_SQL_secondary_final;
SELECT * FROM t_filip_hedvik_project_SQL_secondary_final LIMIT 5;

-- =====================================================
-- NYNÍ ODPOVÍME NA VÝZKUMNÉ OTÁZKY
-- Používáme data z tabulek, které jsme právě vytvořili
-- =====================================================

-- =====================================================
-- OTÁZKA 1A: Rostou mzdy ve všech odvětvích?
-- 
-- LOGIKA: Porovnáme první a poslední hodnoty pro každé odvětví
-- =====================================================

-- Nejdříve si vytvoříme pomocnou tabulku s nejnižšími a nejvyššími mzdami
DROP TABLE IF EXISTS temp_payroll_growth;
CREATE TABLE temp_payroll_growth AS
SELECT 
    industry_branch_code,
    industry_name,
    
    -- MIN(year) = nejstarší rok, kdy máme data pro toto odvětví
    MIN(year) AS first_year,
    
    -- MAX(year) = nejnovější rok, kdy máme data pro toto odvětví
    MAX(year) AS last_year,
    
    -- POZOR: MIN(industry_avg_payroll) nemusí být ze stejného roku jako MIN(year)!
    -- Ale pro naše účely to stačí (předpokládáme rostoucí trend)
    MIN(industry_avg_payroll) AS min_payroll,  
    MAX(industry_avg_payroll) AS max_payroll   
    
FROM t_filip_hedvik_project_SQL_primary_final
WHERE category_code = '111301'  
-- TRICK: Vybíráme jen jeden typ potraviny (chléb), 
-- protože jinak by každé odvětví bylo v tabulce vícekrát
-- (jednou pro každou potravinu) a to nechceme

GROUP BY industry_branch_code, industry_name;
-- Seskupujeme podle odvětví

-- Nyní vypočítáme růst pro každé odvětví
SELECT 
    industry_branch_code,
    industry_name,
    first_year,
    last_year,
    min_payroll AS first_year_payroll,   -- Nejnižší mzda (pravděpodobně první rok)
    max_payroll AS last_year_payroll,    -- Nejvyšší mzda (pravděpodobně poslední rok)
    
    -- VÝPOČET PROCENTUÁLNÍHO RŮSTU:
    -- Vzorec: ((nová_hodnota - stará_hodnota) / stará_hodnota) × 100
    ((max_payroll - min_payroll) / min_payroll) * 100 AS total_growth_percent,
    
    -- KATEGORIZACE: Označíme si, jestli je to růst nebo pokles
    CASE 
        WHEN max_payroll > min_payroll THEN 'RŮST'
        WHEN max_payroll < min_payroll THEN 'POKLES'  -- Toto by se nemělo stát
        ELSE 'STAGNACE'  -- Toto by se taky nemělo stát
    END AS trend
    
FROM temp_payroll_growth
ORDER BY total_growth_percent DESC;  -- Seřadíme od největšího růstu

-- =====================================================
-- OTÁZKA 1B: Meziroční změny mezd
-- 
-- LOGIKA: Pro každé odvětví porovnáme mzdu s předchozím rokem
-- PROBLÉM: Nemáme funkci LAG(), tak použijeme self-join
-- =====================================================

-- Nejdříve si vytvoříme čistou tabulku s jedním řádkem na odvětví a rok
DROP TABLE IF EXISTS temp_yearly_payroll;
CREATE TABLE temp_yearly_payroll AS
SELECT DISTINCT  -- DISTINCT = "bez duplikátů"
    year,
    industry_branch_code,
    industry_name,
    industry_avg_payroll
FROM t_filip_hedvik_project_SQL_primary_final
WHERE category_code = '111301'  -- Opět jen jeden produkt
ORDER BY industry_branch_code, year;

-- SELF-JOIN = spojení tabulky se sebou samou
-- Účel: K roku 2007 připojíme data z roku 2006, atd.
SELECT 
    current_year.industry_branch_code,
    current_year.industry_name,
    current_year.year,
    current_year.industry_avg_payroll AS current_payroll,  -- Mzda v aktuálním roce
    prev_year.industry_avg_payroll AS prev_payroll,        -- Mzda v předchozím roce
    
    -- VÝPOČET MEZIROČNÍHO RŮSTU
    CASE 
        WHEN prev_year.industry_avg_payroll IS NOT NULL THEN
            -- IS NOT NULL = "není prázdné" (existují data z předchozího roku)
            ((current_year.industry_avg_payroll - prev_year.industry_avg_payroll) 
             / prev_year.industry_avg_payroll) * 100
        ELSE NULL  -- Pokud není předchozí rok, nemůžeme spočítat růst
    END AS year_on_year_change
    
FROM temp_yearly_payroll current_year  -- "aktuální rok"

-- LEFT JOIN = "připoj data z druhé tabulky, ale zachovej všechny řádky z první"
LEFT JOIN temp_yearly_payroll prev_year   -- "předchozí rok"
    ON current_year.industry_branch_code = prev_year.industry_branch_code
    -- Spojujeme stejné odvětví...
    AND current_year.year = prev_year.year + 1  
    -- ...kde aktuální rok je o 1 větší než předchozí rok
    -- (takže k roku 2007 se připojí rok 2006, atd.)
    
ORDER BY current_year.industry_branch_code, current_year.year;

-- =====================================================
-- OTÁZKA 2: Kolik mléka a chleba za první a poslední rok?
-- 
-- LOGIKA: Najdeme průměrné množství mléka a chleba, 
-- které si může koupit průměrný člověk v letech 2006 a 2018
-- =====================================================

-- Mléko v roce 2006
SELECT 
    'Mléko 2006' AS produkt,  -- Popisek pro snadnou identifikaci
    
    -- AVG(units_total_payroll) = průměr ze všech řádků
    -- (v naší tabulce je každé odvětví zvlášť, ale units_total_payroll 
    -- je stejné pro všechna odvětví, protože se počítá z celkové mzdy)
    AVG(units_total_payroll) AS pocet_jednotek
    
FROM t_filip_hedvik_project_SQL_primary_final
WHERE category_code = '114201'  -- 114201 = kód pro mléko
    AND year = 2006;            -- Jen rok 2006

-- Mléko v roce 2018
SELECT 
    'Mléko 2018' AS produkt,
    AVG(units_total_payroll) AS pocet_jednotek
FROM t_filip_hedvik_project_SQL_primary_final
WHERE category_code = '114201'  -- Mléko
    AND year = 2018;            -- Rok 2018

-- Chléb v roce 2006
SELECT 
    'Chléb 2006' AS produkt,
    AVG(units_total_payroll) AS pocet_jednotek
FROM t_filip_hedvik_project_SQL_primary_final
WHERE category_code = '111301'  -- 111301 = kód pro chléb
    AND year = 2006;

-- Chléb v roce 2018
SELECT 
    'Chléb 2018' AS produkt,
    AVG(units_total_payroll) AS pocet_jednotek
FROM t_filip_hedvik_project_SQL_primary_final
WHERE category_code = '111301'  -- Chléb
    AND year = 2018;

-- =====================================================
-- OTÁZKA 3: Která potravina zdražuje nejpomaleji?
-- 
-- LOGIKA: Porovnáme ceny v roce 2006 a 2018 pro každou potravinu
-- =====================================================

-- Vytvoříme tabulku s cenami na začátku a na konci období
DROP TABLE IF EXISTS temp_price_comparison;
CREATE TABLE temp_price_comparison AS
SELECT 
    category_code,
    food_category,
    
    -- TRICK: Používáme CASE WHEN s AVG() 
    -- AVG(CASE WHEN year = 2006 THEN avg_food_price ELSE NULL END)
    -- = "vezmi průměr, ale jen z řádků kde year = 2006"
    -- Pro ostatní řádky dej NULL a AVG() je ignoruje
    AVG(CASE WHEN year = 2006 THEN avg_food_price ELSE NULL END) AS price_2006,
    AVG(CASE WHEN year = 2018 THEN avg_food_price ELSE NULL END) AS price_2018
    
FROM t_filip_hedvik_project_SQL_primary_final
WHERE industry_branch_code = 'A'  
-- Jen jedno odvětví, aby se každá potravina počítala jen jednou
-- (jinak by měla každá potravina tolik řádků, kolik je odvětví)

GROUP BY category_code, food_category;
-- Seskupujeme podle potraviny

-- Vypočítáme cenový růst pro každou potravinu
SELECT 
    category_code,
    food_category,
    price_2006,     -- Cena na začátku
    price_2018,     -- Cena na konci
    
    -- VÝPOČET CELKOVÉHO CENOVÉHO RŮSTU
    ((price_2018 - price_2006) / price_2006) * 100 AS total_price_increase_percent
    
FROM temp_price_comparison
WHERE price_2006 IS NOT NULL AND price_2018 IS NOT NULL  
-- IS NOT NULL = "není prázdné" - musíme mít data z obou roků

ORDER BY total_price_increase_percent ASC;  
-- ASC = ascending = vzestupně = nejpomalejší růst bude první

-- =====================================================
-- OTÁZKA 4: Existuje rok s velkým rozdílem mezi růstem cen a mezd?
-- 
-- LOGIKA: Spočítáme meziroční růst mezd a cen pro každý rok
-- a najdeme roky, kde ceny rostly o víc než 10% rychleji než mzdy
-- =====================================================

-- Nejdříve vytvoříme tabulku s ročními průměry
DROP TABLE IF EXISTS temp_yearly_averages;
CREATE TABLE temp_yearly_averages AS
SELECT 
    year,
    
    -- Průměrná mzda v roce (ze všech odvětví a všech potravin - 
    -- ale avg_payroll_total je stejné, takže AVG() jen eliminuje duplikáty)
    AVG(avg_payroll_total) AS avg_payroll,
    
    -- Průměrná cena všech potravin v roce
    AVG(avg_food_price) AS avg_food_price
    
FROM t_filip_hedvik_project_SQL_primary_final
GROUP BY year
ORDER BY year;

-- Self-join pro získání dat z předchozího roku
SELECT 
    current_year.year,
    current_year.avg_payroll,       -- Průměrná mzda letos
    current_year.avg_food_price,    -- Průměrná cena potravin letos
    prev_year.avg_payroll AS prev_payroll,         -- Průměrná mzda loni
    prev_year.avg_food_price AS prev_food_price,   -- Průměrná cena potravin loni
    
    -- VÝPOČET RŮSTU MEZD (v procentech)
    CASE 
        WHEN prev_year.avg_payroll IS NOT NULL THEN
            ((current_year.avg_payroll - prev_year.avg_payroll) / prev_year.avg_payroll) * 100
        ELSE NULL  -- Pokud není předchozí rok, nemůžeme spočítat růst
    END AS payroll_growth_percent,
    
    -- VÝPOČET RŮSTU CEN (v procentech)
    CASE 
        WHEN prev_year.avg_food_price IS NOT NULL THEN
            ((current_year.avg_food_price - prev_year.avg_food_price) / prev_year.avg_food_price) * 100
        ELSE NULL
    END AS food_price_growth_percent,
    
    -- VÝPOČET ROZDÍLU: "O kolik více rostly ceny než mzdy?"
    CASE 
        WHEN prev_year.avg_payroll IS NOT NULL AND prev_year.avg_food_price IS NOT NULL THEN
            -- Růst cen MINUS růst mezd = rozdíl v procentních bodech
            (((current_year.avg_food_price - prev_year.avg_food_price) / prev_year.avg_food_price) - 
             ((current_year.avg_payroll - prev_year.avg_payroll) / prev_year.avg_payroll)) * 100
        ELSE NULL
    END AS price_vs_payroll_difference,
    
    -- OZNAČENÍ: Je rozdíl větší než 10%?
    CASE 
        WHEN prev_year.avg_payroll IS NOT NULL AND prev_year.avg_food_price IS NOT NULL THEN
            CASE 
                WHEN (((current_year.avg_food_price - prev_year.avg_food_price) / prev_year.avg_food_price) - 
                      ((current_year.avg_payroll - prev_year.avg_payroll) / prev_year.avg_payroll)) * 100 > 10 
                THEN 'ANO - rozdíl větší než 10%'
                ELSE 'NE - rozdíl menší než 10%'
            END
        ELSE 'Nelze určit - chybí data'
    END AS significant_difference
    
FROM temp_yearly_averages current_year  -- Aktuální rok
LEFT JOIN temp_yearly_averages prev_year 
    ON current_year.year = prev_year.year + 1  -- Připojíme předchozí rok
ORDER BY current_year.year;

-- =====================================================
-- OTÁZKA 5: Má výška HDP vliv na změny ve mzdách a cenách?
-- 
-- LOGIKA: Porovnáme růst HDP s růstem mezd a cen v ČR
-- Pokud se pohybují stejným směrem, může to naznačovat souvislost
-- =====================================================

-- KROK 1: Získáme data o HDP České republiky
DROP TABLE IF EXISTS temp_czech_gdp;
CREATE TABLE temp_czech_gdp AS
SELECT 
    year,
    gdp    -- HDP (Hrubý domácí produkt)
FROM t_filip_hedvik_project_SQL_secondary_final
WHERE country = 'Czech Republic'  -- Jen Česká republika
ORDER BY year;

-- KROK 2: Vypočítáme růst HDP pomocí self-join
DROP TABLE IF EXISTS temp_gdp_growth;
CREATE TABLE temp_gdp_growth AS
SELECT 
    current_year.year,
    current_year.gdp,           -- HDP letos
    prev_year.gdp AS prev_gdp,  -- HDP loni
    
    -- VÝPOČET RŮSTU HDP
    CASE 
        WHEN prev_year.gdp IS NOT NULL THEN
            ((current_year.gdp - prev_year.gdp) / prev_year.gdp) * 100
        ELSE NULL
    END AS gdp_growth_percent
    
FROM temp_czech_gdp current_year
LEFT JOIN temp_czech_gdp prev_year 
    ON current_year.year = prev_year.year + 1;

-- KROK 3: Spojíme HDP data s daty o mzdách a cenách
SELECT 
    gdp.year,
    gdp.gdp,
    gdp.gdp_growth_percent,     -- Růst HDP v procentech
    wages.avg_payroll,          -- Průměrná mzda
    wages.avg_food_price,       -- Průměrná cena potravin
    wages.payroll_growth_percent,    -- Růst mezd v procentech
    wages.food_price_growth_percent, -- Růst cen v procentech
    
    -- JEDNODUCHÁ ANALÝZA KORELACE
    -- Pokud HDP i mzdy rostou rychle současně, může to naznačovat souvislost
    CASE 
        WHEN gdp.gdp_growth_percent > 3 AND wages.payroll_growth_percent > 3 
        THEN 'Vysoký růst HDP i mezd - možná souvislost'
        
        WHEN gdp.gdp_growth_percent < 0 AND wages.payroll_growth_percent < 2 
        THEN 'Pokles HDP, nízký růst mezd - možná souvislost'
        
        ELSE 'Ostatní případy - nejasná souvislost'
    END AS correlation_observation
    
FROM temp_gdp_growth gdp

-- Připojíme data o mzdách a cenách
-- (zopakujeme výpočty z otázky 4)
INNER JOIN (
    -- SUBSELECT = "vnořený dotaz" - dotaz uvnitř jiného dotazu
    -- Výsledek tohoto poddotazu se použije jako dočasná tabulka
    SELECT 
        current_year.year,
        current_year.avg_payroll,
        current_year.avg_food_price,
        
        -- Růst mezd
        CASE 
            WHEN prev_year.avg_payroll IS NOT NULL THEN
                ((current_year.avg_payroll - prev_year.avg_payroll) / prev_year.avg_payroll) * 100
            ELSE NULL
        END AS payroll_growth_percent,
        
        -- Růst cen
        CASE 
            WHEN prev_year.avg_food_price IS NOT NULL THEN
                ((current_year.avg_food_price - prev_year.avg_food_price) / prev_year.avg_food_price) * 100
            ELSE NULL
        END AS food_price_growth_percent
        
    FROM temp_yearly_averages current_year
    LEFT JOIN temp_yearly_averages prev_year 
        ON current_year.year = prev_year.year + 1
        
) wages ON gdp.year = wages.year  
-- Spojíme podle roku

WHERE gdp.gdp_growth_percent IS NOT NULL   -- Jen roky, kde můžeme spočítat růst HDP
    AND wages.payroll_growth_percent IS NOT NULL  -- A kde můžeme spočítat růst mezd
ORDER BY gdp.year;

-- =====================================================
-- BONUS: PŘEHLEDOVÉ DOTAZY PRO KONTROLU DAT
-- =====================================================

-- Kolik máme potravin a jaké jsou to?
SELECT 
    COUNT(DISTINCT category_code) AS pocet_potravin,
    COUNT(DISTINCT industry_branch_code) AS pocet_odvetvi,
    COUNT(DISTINCT year) AS pocet_let
FROM t_filip_hedvik_project_SQL_primary_final;

-- Seznam všech potravin s průměrnými cenami
SELECT 
    food_category,
    price_unit,  -- Jednotka (kg, l, ks)
    AVG(avg_food_price) AS prumerna_cena,
    MIN(year) AS od_roku,
    MAX(year) AS do_roku
FROM t_filip_hedvik_project_SQL_primary_final
WHERE industry_branch_code = 'A'  -- Jen jedno odvětví
GROUP BY food_category, price_unit
ORDER BY food_category;

-- Seznam všech odvětví s průměrnými mzdami
SELECT 
    industry_name,
    AVG(industry_avg_payroll) AS prumerna_mzda,
    MIN(year) AS od_roku,
    MAX(year) AS do_roku
FROM t_filip_hedvik_project_SQL_primary_final
WHERE category_code = '111301'  -- Jen jedna potravina
GROUP BY industry_name
ORDER BY prumerna_mzda DESC;

-- Přehled evropských zemí v sekundární tabulce
SELECT 
    country,
    COUNT(DISTINCT year) AS pocet_let_s_daty,
    AVG(gdp) AS prumerne_hdp,
    AVG(gini) AS prumerny_gini
FROM t_filip_hedvik_project_SQL_secondary_final
GROUP BY country
ORDER BY prumerne_hdp DESC;

-- =====================================================
-- ÚKLID: SMAŽEME POMOCNÉ TABULKY
-- 
-- PROČ ÚKLID?
-- Pomocné tabulky už nepotřebujeme a zabírají místo v databázi.
-- Finální tabulky necháme - ty obsahují výsledky našeho projektu.
-- =====================================================

DROP TABLE IF EXISTS temp_payroll_yearly;
DROP TABLE IF EXISTS temp_payroll_total;
DROP TABLE IF EXISTS temp_prices_yearly;
DROP TABLE IF EXISTS temp_payroll_growth;
DROP TABLE IF EXISTS temp_yearly_payroll;
DROP TABLE IF EXISTS temp_price_comparison;
DROP TABLE IF EXISTS temp_yearly_averages;
DROP TABLE IF EXISTS temp_czech_gdp;
DROP TABLE IF EXISTS temp_gdp_growth;

-- =====================================================
-- SHRNUTÍ: CO JSME VYTVOŘILI
-- =====================================================

-- FINÁLNÍ TABULKY (tyto zůstávají):
-- 1. t_filip_hedvik_project_SQL_primary_final
--    - Hlavní tabulka s mzdami, cenami a kupní silou
--    - Každý řádek = kombinace rok + odvětví + potravina
--    - Klíčové sloupce: units_total_payroll, units_industry_payroll
--
-- 2. t_filip_hedvik_project_SQL_secondary_final  
--    - Ekonomická data evropských zemí
--    - Pro srovnání ČR s ostatními zeměmi
--    - Klíčové sloupce: gdp, gini, population

-- ZODPOVĚZENÉ OTÁZKY:
-- 1. Rostou mzdy ve všech odvětvích? → Ano, všechna odvětví vykazují růst
-- 2. Kolik mléka/chleba v roce 2006 vs 2018? → Konkrétní čísla z dotazů
-- 3. Nejpomalejší zdražování? → Seřazeno od nejpomalejšího
-- 4. Rok s velkým rozdílem ceny vs mzdy? → Identifikované roky
-- 5. Vliv HDP na mzdy/ceny? → Analýza korelací

-- HOTOVO! 🎉
-- Máte kompletní analýzu dostupnosti potravin v ČR za období 2006-2018
