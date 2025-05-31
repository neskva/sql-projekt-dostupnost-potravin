# 📊 Projekt z SQL: Analýza dostupnosti základních potravin

**Autor:** Filip Hedvik  
**Databáze:** PostgreSQL  
**Období analýzy:** 2006-2018  

---

## 📋 Popis projektu

Tento projekt analyzuje **dostupnost základních potravin** široké veřejnosti na základě průměrných příjmů v České republice. Cílem je poskytnout robustní datové podklady pro analýzu životní úrovně občanů za období 2006-2018.

### 🎯 Hlavní cíle:
- Porovnat dostupnost potravin na základě průměrných příjmů
- Analyzovat vývoj mezd napříč odvětvími
- Identifikovat trendy v cenách základních potravin
- Vyhodnotit vliv ekonomických faktorů na kupní sílu

---

## 📂 Struktura repozitáře

```
├── README.md                    # Hlavní dokumentace
├── sql_script.sql              # Kompletní SQL kód projektu
├── data_analysis/              # Analýzy výsledků
│   ├── otazka1_analyza.md     # Růst mezd podle odvětví
│   ├── otazka2_analyza.md     # Dostupnost mléka a chleba
│   ├── otazka3_analyza.md     # Nejpomalejší zdražování
│   ├── otazka4_analyza.md     # Ceny vs. mzdy po letech
│   └── otazka5_analyza.md     # Vliv HDP na mzdy a ceny
├── technical_docs/             # Technická dokumentace
│   ├── tabulka_pojmu.md       # Slovník pojmů
│   └── metodologie.md         # Popis metod a rozhodnutí
└── results/                   # Výsledky analýz
    └── summary.md            # Shrnutí všech zjištění
```

---

## 🎯 Výzkumné otázky

### 1. **Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**
- **Odpověď:** ✅ **Mzdy rostou ve VŠECH odvětvích** (19/19 odvětví s pozitivním růstem)
- **Nejrychlejší růst:** Zdravotnictví (+76.9%), Zemědělství (+73.0%)
- **Nejpomalejší růst:** Peněžnictví (+36.3%) - stále pozitivní

### 2. **Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období?**
- **Mléko:** 1,432 l (2006) → 1,639 l (2018) = **+14.5%** 🥛
- **Chléb:** 1,282 kg (2006) → 1,340 kg (2018) = **+4.5%** 🍞
- **Závěr:** Kupní síla pro obě základní potraviny se zlepšila

### 3. **Která kategorie potravin zdražuje nejpomaleji?**
- **Překvapení:** 🍯 **Cukr se zlevnil** o 27.5%! (21,73 → 15,75 Kč/kg)
- **Druhé místo:** 🍅 **Rajčata se zlevnila** o 23.1%! (57,83 → 44,49 Kč/kg)
- **Třetí místo:** 🍌 **Banány** jen +7.4% (nejstabilnější ceny)

### 4. **Existuje rok s velkým rozdílem mezi růstem cen potravin a mezd (>10%)?**
- **Odpověď:** ❌ **NE** - žádný rok nepřekročil limit 10%
- **Největší rozdíl:** 6.59% v roce 2013
- **Závěr:** Stabilní a vyvážený trh práce a potravin

### 5. **Má výška HDP vliv na změny ve mzdách a cenách potravin?**
- **Odpověď:** ✅ **Částečně ANO** - korelace v 3 z 11 let (27%)
- **Roky s korelací:** 2007, 2017, 2018
- **Závěr:** Vliv existuje především v obdobích ekonomické stability

---

## 📊 Klíčová zjištění

### 🏆 Pozitivní trendy:
- **100% odvětví** vykazuje růst mezd za sledované období
- **Kupní síla roste** - lidé si mohou dovolit více základních potravin
- **2 potraviny se zlevnily** (cukr, rajčata) při růstu mezd o 58%
- **Žádný dramatický šok** - rozdíl ceny vs. mzdy nikdy nepřekročil 10%
- **Ekonomická stabilita** - rychlá adaptace na krize

### 📈 Statistické shrnutí:
- **Průměrný růst mezd:** 58% za období 2006-2018
- **Nejstabilnější odvětví:** Doprava, zdravotnictví, zpracovatelský průmysl
- **Nejvíce volatilní:** Těžba, energetika, peněžnictví
- **Nejdostupnější potraviny:** Základní komodity (cukr, rajčata, banány)

---

## 🛠️ Technické informace

### Použité technologie:
- **Databáze:** PostgreSQL
- **Jazyk:** SQL (základní příkazy bez pokročilých funkcí)
- **Přístup:** Vytváření pomocných tabulek místo CTE

### Datové zdroje:
- **czechia_payroll** - Mzdy v různých odvětvích (čtvrtletní data)
- **czechia_price** - Ceny vybraných potravin (týdenní data)
- **countries** + **economies** - Ekonomické údaje evropských zemí

### Společné období analýzy:
- **Mzdy dostupné:** 2000-2021
- **Ceny dostupné:** 2006-2018
- **Analyzované období:** 2006-2018 (průsečík dat)

---

## 📋 Metodologie

### Klíčová rozhodnutí:

1. **Typ mzdy:** `value_type_code = 5958` (Průměrná hrubá mzda)
2. **Typ kalkulace:** `calculation_code = 100` (Fyzické mzdy, ne přepočtené)
3. **Agregace:** Roční průměry z čtvrtletních/týdenních dat
4. **Potraviny pro otázku 2:** Mléko (114201) a chléb (111301)
5. **Kritický limit:** 10% rozdíl pro otázku 4
6. **HDP korelace:** >3% růst HDP + >3% růst mezd = možná souvislost

### Výstupní tabulky:
- **`t_filip_hedvik_project_SQL_primary_final`** - Hlavní analýza (mzdy + ceny + kupní síla)
- **`t_filip_hedvik_project_SQL_secondary_final`** - Evropské země (HDP, GINI, populace)

---

## 🚀 Jak spustit projekt

### Předpoklady:
- PostgreSQL databáze
- Naplněné zdrojové tabulky dle zadání
- Oprávnění k CREATE TABLE

### Spuštění:
1. **Otevřete** `sql_script.sql`
2. **Spusťte po částech:**
   - Nejdříve průzkumné dotazy (volitelné)
   - Pak vytvoření pomocných tabulek
   - Nakonec finální tabulky a analýzy
3. **Výsledky** najdete v nově vytvořených tabulkách

### Testování:
```sql
-- Kontrola počtu záznamů
SELECT COUNT(*) FROM t_filip_hedvik_project_SQL_primary_final;

-- Ukázka dat
SELECT * FROM t_filip_hedvik_project_SQL_primary_final LIMIT 5;
```

---

## 📈 Výsledky pro prezentaci

### Citovatelné statistiky:
- *"Mzdy rostou ve všech odvětvích - žádné nezaznamenalo pokles"*
- *"Za průměrnou mzdu si Češi koupí o 15% více mléka než před 12 lety"*
- *"Senzace: Cukr a rajčata se zlevnily o čtvrtinu"*
- *"Český trh prokázal stabilitu - ani v krizi nepřekročil kritický limit"*

### Pro tiskové oddělení:
- **Pozitivní trendy** napříč všemi ukazateli
- **Konkrétní číselné údaje** připravené k citování
- **Stabilita ekonomiky** potvrzená analýzou
- **Zlepšující se životní úroveň** prokázána daty

---

## 📚 Dokumentace

### Podrobné analýzy:
- [Analýza růstu mezd](data_analysis/otazka1_analyza.md)
- [Dostupnost základních potravin](data_analysis/otazka2_analyza.md)
- [Cenové trendy potravin](data_analysis/otazka3_analyza.md)
- [Stabilita trhu práce](data_analysis/otazka4_analyza.md)
- [Ekonomické korelace](data_analysis/otazka5_analyza.md)

### Technická dokumentace:
- [Slovník pojmů](technical_docs/tabulka_pojmu.md)
- [Metodologie a rozhodnutí](technical_docs/metodologie.md)

---

## ⚠️ Omezení a poznámky

### Metodologická omezení:
- **Hrubé mzdy** - analýza před zdaněním
- **Nominální hodnoty** - neupraveno o celkovou inflaci
- **Agregované hodnoty** - regionální rozdíly nejsou zahrnuty
- **Vybrané potraviny** - nereprezentuje celý spotřební košík

### Technická omezení:
- **MIN/MAX problém** v růstové analýze (nemusí být z krajních roků)
- **Kartézský součin** vytváří velké tabulky
- **Pomocné tabulky** zabírají místo v databázi

### Interpretační poznámky:
- **Korelace ≠ kauzalita** u HDP analýzy
- **Sezónní vlivy** minimalizovány, ale ne zcela eliminovány
- **Externí faktory** (globální trhy) ovlivňují výsledky

---

## 🎉 Závěr

Tento projekt přináší **komplexní pohled na vývoj životní úrovně** v České republice za období 2006-2018. Všechny analyzované ukazatele poukazují na **pozitivní trendy**:

- ✅ Růst mezd ve všech odvětvích
- ✅ Zlepšení kupní síly pro základní potraviny  
- ✅ Stabilitu trhu práce i během krizí
- ✅ Efektivní ekonomické řízení

Výsledky poskytují **solidní základ** pro další analýzy a rozhodování v oblasti sociální a ekonomické politiky.

---

## 📞 Kontakt

**Autor:** Filip Hedvik  
**Projekt:** SQL Analýza dostupnosti potravin  
**Rok:** 2024  

---

*Tento projekt byl vytvořen jako součást studia databázových systémů a SQL analýzy.*
