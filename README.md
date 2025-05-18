# Visits Tracker App

A Flutter application for tracking sales rep visits using a clean and scalable architecture. 
This version focuses on basic screen navigation with `go_router`, ready for future feature expansion.

---

## 🚀 Overview

This Flutter app demonstrates:

- Declarative routing using `go_router`
- API integration with Supabase (PostgREST over PostgreSQL)
- A structured foundation based on Clean Architecture (Data, Domain, Presentation)
- Testable, modular, and scalable codebase

---

## 📸 Screenshots

> Add your screenshots here (optional). Example:

##  Key Architectural Choices

## Clean Architecture
Organized into layers:
- data 
  Contains models and Supabase API integration (via `dio`) for fetching/storing visit data.

- domain
  Contains core business logic — entities and, eventually, use cases.

- presentation
  Contains UI components (screens/widgets), state management, and navigation (`router/` folder).


## Getting Started

```bash
git clone https://github.com/Dmwinzi/visit_tracker
cd visits-tracker
flutter pub get
flutter run
