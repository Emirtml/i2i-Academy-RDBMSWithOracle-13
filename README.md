#i2i-Academy-RDBMSWithOracle-13
# Book Management & Automated Data Parsing System

A robust backend application developed using **Spring Boot** and **Oracle Database 21c**. The system is designed to handle high-performance relational data management, automated auditing through database triggers, and server-side data parsing for both XML and JSON payloads via advanced PL/SQL packages.

---

## 🚀 Features

* **Database Migration Management:** Automated schema creation and version control utilizing **Flyway**.
* **Automated Auditing:** Real-time logging of database transactions into dedicated audit tables via row-level **triggers**.
* **High-Performance PL/SQL Parsing:** Server-side processing of large data blocks (**CLOB**) using modern Oracle `XMLTABLE` and `JSON_TABLE` structures.
* **RESTful API Architecture:** Robust endpoints built with Spring Boot to accept data payloads and execute transactional database procedures seamlessly.

---

## 🛠️ Tech Stack

* **Backend Framework:** Java 21, Spring Boot 4.1.0
* **Database:** Oracle Database 21c Express Edition (Dockerized)
* **ORM & Migration:** Spring Data JPA, Hibernate, Flyway Migration
* **Build Tool:** Maven
* **Testing Client:** Postman

---

## 📊 Database Schema & Architecture

The database architecture consists of a fully normalized relational structure designed to avoid redundancy, alongside an tracking layout for audit logs.

### 1. Relational Tables
* **`AUTHORS`**: Stores independent author records (Primary Key: `id`, Name: `name`).
* **`PUBLISHERS`**: Stores publishing house details (Primary Key: `id`, Name: `name`).
* **`BOOKS`**: Core entity mapped to both authors and publishers through foreign keys (`author_id`, `publisher_id`).

### 2. Auditing Table
* **`AUDIT_LOGS`**: Captures historical transactional data including the operation type, timestamp, targeted table name, row ID, and the database user who executed the query.

---

## 🗂️ Database Migrations (Flyway Layout)

The database schema evolves through versioned SQL scripts located under `src/main/resources/db/migration/`:

### `V1__Create_Tables.sql`
Initializes the structural layout of the application by generating the sequences and tables for `AUTHORS`, `PUBLISHERS`, and `BOOKS`.

### `V2__Create_Audit_Log_And_Trigger.sql`
Generates the `AUDIT_LOGS` table and implements an advanced row-level **database trigger** (`trg_books_audit`). This trigger intercepts every successful `INSERT` operation on the `BOOKS` table and automatically documents the transaction details.

### `V3__Create_Book_Management_Package.sql`
Deploys a comprehensive **PL/SQL Package** (`pkg_book_management`) containing relational lookup logic and two high-performance parsing procedures:
* `process_books_xml`: Parses a raw XML document string and extracts book properties.
* `process_books_json`: Processes a raw JSON block structure to isolate entity objects.

---

## 🔌 API Endpoints & Payloads

The application exposes structured **POST** endpoints for bulk data registration.

### 1. Process XML Data
* **URL:** `POST /api/books/xml`
* **Content-Type:** `application/xml`
* **Sample Payload:**

```xml
<books>
    <book>
        <title>Nutuk</title>
        <author>Mustafa Kemal Ataturk</author>
        <publisher>Iskultur Yayinlari</publisher>
    </book>
    <book>
        <title>Savas ve Baris</title>
        <author>Lev Tolstoy</author>
        <publisher>Iskultur Yayinlari</publisher>
    </book>
</books>
