📘 ABAP RAP – Travel Management Application
🚀 Overview

This repository contains my hands-on implementation of SAP ABAP RAP (RESTful Application Programming Model) using a Travel Management Application use case.

The application is designed using RAP Business Object principles where:

Travel is the Root View Entity

Booking is a Child Entity (Composition)

Booking Supplement has an Association to Booking

This project demonstrates how RAP entities are modeled and connected using CDS views, behavior definitions, and service exposure.

It serves both as a learning project and a portfolio showcase of modern ABAP development.

🧩 Business Object Design
📌 Entity Relationship
Travel (Root)
  |
  └── Booking (Composition Child)
           |
           └── Booking Supplement (Association)

🔹 Explanation

Travel
Root business object representing a travel request.

Booking
Composition child of Travel.
Lifecycle is dependent on Travel.

Booking Supplement
Associated entity linked to Booking.
Used to store additional services or extras.

This structure follows RAP best practices:

✔ Composition for tightly coupled entities
✔ Association for loosely coupled data
✔ Single Root Business Object

🎯 Objective

Implement RAP Managed Scenario

Design Root & Child entities

Practice composition vs association

Build CDS View Entities

Implement Behavior Definitions

Expose services via Service Definition & Binding

🧠 Key Concepts Covered

CDS View Entities

Root & Child Business Objects

Composition vs Association

Behavior Definitions & Implementations

Managed RAP Scenario

Service Definition

Service Binding

CRUD Operations

ABAP Classes
```
📁 Project Structure
ABAP_RAP/
│
├── src/
│   ├── CDS Views
│   ├── Behavior Definitions
│   ├── Behavior Implementations
│   ├── Service Definitions
│   └── ABAP Classes
│
└── README.md
```
🛠 Tools Used

SAP ADT (Eclipse)

ABAP on S/4HANA

RAP Framework

GitHub

📌 How to Run

Clone repository

Import objects into SAP ADT

Activate CDS Views

Activate Behavior Definitions

Activate Service Definition

Publish Service Binding

Test via browser / Fiori preview

🧪 What I Learned

RAP Business Object modeling

Composition vs Association usage

Managed RAP implementation

End-to-end service exposure

Modern ABAP development patterns

📈 Future Enhancements

Add validations & determinations

Authorization checks

Draft handling

Fiori Elements UI

Improved error handling

👨‍💻 About Me

SAP ABAP Developer with experience in:

ABAP + HCM

ABAP on HANA

RAP

Azure Data Engineering (ADF, Databricks, SQL)

This repository reflects my journey toward modern SAP development.

📜 License

Eclipse Public License 2.0

⭐ Feel free to star the repository if you find it useful!
