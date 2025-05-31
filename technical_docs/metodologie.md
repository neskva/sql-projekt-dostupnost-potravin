# 📐 Metodologie SQL projektu

**Projekt:** Analýza dostupnosti základních potravin v České republice  
**Autor:** Filip Hedvik  
**Období:** 2006-2018  
**Databáze:** PostgreSQL

---

## 🎯 **Cíle projektu**

### **Primární cíl:**
Analyzovat dostupnost základních potravin široké veřejnosti na základě průměrných příjmů v České republice za období 2006-2018.

### **Sekundární cíle:**
- Vyhodnotit vývoj mezd napříč ekonomickými odvětvími
- Identifikovat trendy v cenách základních potravin
- Porovnat kupní sílu na začátku a konci sledovaného období
- Analyzovat vztah mezi ekonomickým růstem (HDP) a vývojem mezd/cen

---

## 📊 **Datové zdroje**

### **Primární data:**
| Tabulka | Zdroj | Období | Frekvence | Popis |
|---------|-------|--------|-----------|-------|
| **czechia_payroll** | Portál otevřených dat ČR | 2000-2021 | Čtvrtletní | Mzdy podle odvětví |
| **czechia_price** | Portál otevřených dat ČR | 2006-2018 | Týdenní | Ceny vybraných potravin |
| **countries** | Veřejné zdroje | - | Statické | Geografické a demografické údaje |
| **economies** | Veřejné zdroje | Různé | Roční | Ekonomické ukazatele (HDP, GINI) |

### **Podpůrné číselníky:**
- `czechia_payroll_value_type` - Typy mzdových hodnot
- `czechia_payroll_calculation` - Typy kalkulací (fyzické vs. přepočtené)
- `czechia_payroll_industry_branch` - Názvy odvětví
- `czechia_price_category` - Kategorie a jednotky potravin

---

## ⏰ **Časové vymezení**

### **Dostupná data:**
- **Mzdy:** 2000-2021 (22 let)
- **Ceny:** 2006-2018 (13 let)

### **Společné období analýzy:**
**2006-2018 (13 let)** - průsečík obou datových sad

### **Zdůvodnění výběru:**
- **Maximální využití dat** - nejdelší možné společné období
- **Ekonomická relevance** - zahrnuje předkrizové, krizové i oživující období
- **Statistická robustnost** - dostatečný počet pozorování pro trendy

---

## 🔍 **Klíčová rozhodnutí**

### **1. Typ mzdových dat**

**Rozhodnutí:** `value_type_code = 5958` (Průměrná hrubá mzda na zaměstnance)

**Zdůvodnění:**
- **Nejreprezentativnější** ukazatel kupní síly
- **Dostupnost** napříč všemi odvětvími a roky
- **Srovnatelnost** s oficiálními statistikami

**Alternativy odmítnuté:**
- `value_type_code = 316` (Počet zaměstnanců) - nehodí se pro kupní sílu

### **2. Typ kalkulace mezd**

**Rozhodnutí:** `calculation_code = 100` (Fyzické mzdy)

**Zdůvodnění:**
- **Skutečné příjmy** lidí včetně částečných úvazků
- **Reálná kupní síla** vs. teoretické přepočty na plný úvazek
- **Konzistence** s cílem analýzy dostupnosti

**Alternativy odmítnuté:**
- `calculation_code = 200` (Přepočtené) - nereálné pro kupní sílu

### **3. Časová agregace**

**Rozhodnutí:** Převod na roční průměry

**Zdůvodnění:**
- **Eliminace sezónnosti** (vánoční odměny, letní zelenina)
- **Srovnatelnost** s ročními HDP daty
- **Stabilnější trendy** vs. volatilní měsíční/čtvrtletní data

**Metoda agregace:**
- **Mzdy:** `AVG(value)` ze všech čtvrtletí daného roku
- **Ceny:** `AVG(value)` ze všech týdnů a krajů daného roku

### **4. Geografická agregace**

**Rozhodnutí:** Celonárodní průměry

**Zdůvodnění:**
- **Cíl projektu** - celostátní dostupnost
- **Jednostnost analýzy** - bez regionálních komplikací
- **Datová dostupnost** - ne všechny regiony mají kompletní data

**Metoda:**
- **Ceny:** Průměr přes všechny kraje (`region_code`)
- **Mzdy:** Již agregované na národní úrovni

### **5. Výběr potravin pro detailní analýzu**

**Rozhodnutí:** Mléko (`114201`) a chléb (`111301`)

**Zdůvodnění:**
- **Základní potraviny** - denní spotřeba
- **Reprezentativnost** - různé kategorie (mléčné vs. pekařské)
- **Dostupnost dat** - kompletní časové řady
- **Jednotky** - srozumitelné (litry, kilogramy)

---

## 🧮 **Analytické metody**

### **1. Růstová analýza (Otázka 1)**

**Metoda:** Porovnání MIN vs. MAX hodnot + meziroční změny

**Vzorce:**
```sql
-- Celkový růst
total_growth = ((MAX(mzda) - MIN(mzda)) / MIN(mzda)) × 100

-- Meziroční růst
year_growth = ((mzda_t - mzda_t-1) / mzda_t-1) × 100
```

**Limitace:** MIN/MAX nemusí být z krajních let

### **2. Kupní síla (Otázka 2)**

**Metoda:** Poměr průměrné mzdy k průměrné ceně

**Vzorec:**
```sql
kupni_sila = avg_payroll_total / avg_food_price
```

**Interpretace:** Počet jednotek potraviny za měsíční mzdu

### **3. Cenová analýza (Otázka 3)**

**Metoda:** Procentuální změna cen za celé období

**Vzorec:**
```sql
price_change = ((cena_2018 - cena_2006) / cena_2006) × 100
```

**Řazení:** Od nejnižší po nejvyšší změnu

### **4. Stability test (Otázka 4)**

**Metoda:** Meziroční rozdíl růstu cen vs. mezd

**Vzorec:**
```sql
difference = food_price_growth - payroll_growth
```

**Kritérium:** Rozdíl > 10 procentních bodů = nestabilita

### **5. Korelační analýza (Otázka 5)**

**Metoda:** Kvalitativní hodnocení synchronního růstu

**Kritéria:**
- HDP růst > 3% AND mzdy růst > 3% = možná korelace
- HDP růst < 0% AND mzdy růst < 2% = možná korelace (negativní)

---

## 🛠️ **Technické řešení**

### **Architektura kódu:**

**1. Průzkumné dotazy:**
- Zjištění dostupných let
- Ověření kódů a struktur
- Validace dat

**2. Pomocné tabulky:**
```sql
temp_payroll_yearly      -- Roční mzdy podle odvětví
temp_payroll_total       -- Celkové roční mzdy
temp_prices_yearly       -- Roční ceny potravin
```

**3. Finální tabulky:**
```sql
t_filip_hedvik_project_SQL_primary_final    -- Hlavní analýza
t_filip_hedvik_project_SQL_secondary_final  -- Evropská data
```

### **SQL techniky použité:**

**Základní příkazy:**
- `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`
- `JOIN`, `LEFT JOIN` (self-join pro meziroční srovnání)
- `CREATE TABLE`, `DROP TABLE`

**Funkce:**
- `AVG()`, `MIN()`, `MAX()`, `COUNT()`
- `CASE WHEN`, `EXTRACT()`, `IS NOT NULL`

**Pokročilé techniky:**
- **Self-join** místo window funkcí
- **Subselect** pro složité dotazy
- **Aliasy** pro čitelnost

---

## ⚠️ **Limitace a rizika**

### **Metodologické limitace:**

**1. Hrubé vs. čisté mzdy:**
- **Analýza:** Hrubé mzdy před zdaněním
- **Dopad:** Reálná kupní síla může být nižší
- **Zdůvodnění:** Dostupnost dat a mezinárodní srovnatelnost

**2. Nominální vs. reálné hodnoty:**
- **Analýza:** Nominální hodnoty bez adjustace na inflaci
- **Dopad:** Nezohledňuje celkovou cenovou hladinu
- **Kompenzace:** Analyzujeme relativní poměry (mzda/cena)

**3. Agregace přes regiony:**
- **Metoda:** Celonárodní průměry
- **Ztráta:** Regionální rozdíly v cenách i mzdách
- **Zdůvodnění:** Komplexnost a cíl projektu

**4. Omezený potravinový košík:**
- **Analýza:** Pouze vybrané potraviny
- **Riziko:** Nereprezentuje celkové životní náklady
- **Mitigation:** Zaměření na základní potraviny

### **Technické limitace:**

**1. MIN/MAX problém:**
- **Problém:** MIN(mzda) nemusí být z MIN(rok)
- **Dopad:** Nepřesný výpočet růstu
- **Zdůvodnění:** Jednodušší implementace vs. přesnost

**2. Různé frekvence dat:**
- **Mzdy:** Čtvrtletní → roční průměr
- **Ceny:** Týdenní → roční průměr
- **Riziko:** Ztráta volatility a sezónních efektů

**3. Kartézský součin:**
- **Metoda:** Každá mzda × každá potravina
- **Následek:** Velké tabulky, duplikace informací
- **Výhoda:** Flexibilita pro různé analýzy

---

## 📐 **Validace výsledků**

### **Kontroly kvality dat:**

**1. Kompletnost:**
```sql
-- Kontrola chybějících let
SELECT COUNT(DISTINCT year) FROM final_table;
-- Expected: 13 let (2006-2018)
```

**2. Konzistence:**
```sql
-- Kontrola duplikátů
SELECT year, industry_branch_code, category_code, COUNT(*)
FROM final_table
GROUP BY year, industry_branch_code, category_code
HAVING COUNT(*) > 1;
-- Expected: Žádné duplicity
```

**3. Logické kontroly:**
```sql
-- Kontrola pozitivních hodnot
SELECT COUNT(*) FROM final_table 
WHERE avg_payroll <= 0 OR avg_food_price <= 0;
-- Expected: 0 negativních hodnot
```

### **Cross-validace:**
- **Porovnání** s oficiálními statistikami ČSÚ
- **Kontrola trendů** s makroekonomickými daty
- **Ověření extrémních hodnot** (máslo +98%, cukr -27%)

---

## 📊 **Interpretační rámec**

### **Statistická významnost:**
- **Minimální období:** 13 let pro identifikaci trendů
- **Minimální změna:** ±5% pro významný rozdíl
- **Kritické prahy:** 10% pro destabilizaci trhu

### **Ekonomické kontexty:**
- **2008-2009:** Globální finanční krize
- **2011-2013:** Evropská dluhová krize + fiskální konsolidace
- **2014-2018:** Ekonomické oživení + nízké úrokové sazby

### **Benchmarking:**
- **Mezinárodní srovnání:** ČR vs. evropský průměr
- **Historické srovnání:** Předkrizové vs. pokrizové období
- **Sektorové srovnání:** Veřejný vs. soukromý sektor

---

## 🎯 **Závěry metodologie**

### **Síly přístupu:**
- ✅ **Kompletní období** - pokrývá různé ekonomické cykly
- ✅ **Robustní data** - oficiální zdroje s pravidelnou aktualizací
- ✅ **Jasná interpretace** - kupní síla jako srozumitelná metrika
- ✅ **Technická průhlednost** - základní SQL bez černých skříní

### **Oblasti zlepšení:**
- 🔄 **Regionální rozměr** - analýza podle krajů
- 🔄 **Širší potravinový košík** - reprezentativnější výběr
- 🔄 **Reálné hodnoty** - adjustace na celkovou inflaci
- 🔄 **Prediktivní model** - forecast budoucího vývoje

### **Praktická použitelnost:**
- 📊 **Pro politiky** - podklad pro sociální a ekonomické politiky
- 📈 **Pro analytiky** - metodický základ pro rozšířené analýzy
- 📰 **Pro média** - citovatelné statistiky o životní úrovni
- 🎓 **Pro vzdělávání** - praktická demonstrace SQL analýzy

---

*Tato metodologie poskytuje transparentní rámec pro replikaci a rozšíření analýzy.*
