# Handmade Shop Database

Baza danych zaprojektowana dla małego przedsiębiorstwa zajmującego się sprzedażą produktów handmade.
Projekt umożliwia zarządzanie klientami, zamówieniami, produktami, materiałami produkcyjnymi oraz płatnościami.

## Główne funkcjonalności
- zarządzanie klientami
- obsługa zamówień
- kontrola płatności
- zarządzanie materiałami wykorzystywanymi do produkcji
- monitorowanie stanów magazynowych
- analiza wartości zamówień

## Technologie
- PostgreSQL
- SQL
- PL/pgSQL
- ERD (draw.io)

## Struktura projektu
```
handmade-shop-database
|
├─ 01_schema.sql                      # struktura bazy danych (tabele, klucze)
├─ 02_functions.sql                   # funkcje SQL
├─ 03_triggers.sql                    # wyzwalacze
├─ 04_views.sql                       # widoki
├─ 05_cursors.sql                     # przykłady użycia kursora
├─ 06_example_queries.sql             # przykładowe zapytania
├─ 07_example_transactions.sql        # przykładowe transakcje
├─ 08_sample_data.sql                 # przykładowe dane
├─ ERD.drawio.svg                     # diagram bazy danych
├─ ERD.drawio                         # diagram bazy danych
└─ README.md
```

## Model danych
Baza danych składa się z tabeli przedstawiających:
- klientów
- pracowników
- zamówienia
- produkty
- materiały
- płatności
- produkty w zamówieniach
- materiały używane do zrobienia produktów

### Ograniczenia
Mają na celu zapewnienie poprawności, spójności oraz wiarygodności przechowywanych danych.
- PRIMARY KEY
- FOREIGN KEY
- UNIQUE
- NOT NULL
- CHECK

### Widoki (Views)
Umożliwiają uproszczony dostęp do wybranych danych.
- widok_klient_podstawowy
- widok_dostawcy
- widok_pracownik_podstawowy
- widok_zamowienia_status
- widok_material_magazyn

### Funkcje
Realizują logike biznesową.
- oblicznie wartości zamówienia
- liczenie produktów w zamówieniu
- sprawdzanie czy zamówienie zostało opłacone
- oblicznie liczby zamówień klienta
- sprawdzanie dostępności materiału w magazynie
- obliczanie średniej wartości zamówień klienta

### Wyzwalacze
Automatycznie ustawia datę zamówienia przy dodaniu nowego rekordu do tabeli zamówienie.

### Transakacje
- zmiana statusu zamówienia i rejestracja płatności
- składanie zamówienia

### Kursory
Przykład kursora do przetwarzania rekordów zamówień w operacjach wykonywanych iteracyjnie
- ustawienie statusu 'Wyslane' dla wszystkich zamówień wysłanych dzisiaj

## Możliwe rozszerzenia projektu 
- system ról i uprawnień użytkowników
- archiwizacja zakończonych zamówień
- automatyczne kopie zapasowe
- dodatkowe raporty sprzedażowe
