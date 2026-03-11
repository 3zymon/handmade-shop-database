# Handmade Shop Database

Baza danych zaprojetowana dla małego przzedsiębiorstwa zajmującego się sprzedażą produktów handmade.
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
handmade-shop-database
|
├─ schema.sql            
├─ functions.sql
├─ triggers.sql
├─ views.sql
├─ cursors.sql
├─ example_queries.sql
├─ example_transactions.sql
├─ sample_data.sql
├─ ERD.drawio.svg
├─ ERD.drawio
└─ README.md

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
Zapewniają one spójność i poprawność danych.
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
- obliczanie średniej wartości zamówień klienta

### Wyzwalacze
Automatycznei ustawia datę zamówienia przy dodaniu nowego rekordu do tabeli zamówienie.

### Transakacje
- zmiana statusu zamówienia
- rejestracja płatności
- składanie zamówienia

### Kursory
Przykład do wykorzystania kursora do przetwarzania rekordów zamówień w operacjach wykonywanych iteracyjnie.

## Możliwe rozszerzenia projektu 
- system ról i uprawnień użytkowników
- archiwizacja zakończonych zamówień
- automatyczne kopie zapasowe
- dodatkowe raporty sprzedażowe
