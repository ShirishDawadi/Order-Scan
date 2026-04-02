# Order + Barcode App

A simple mobile app simulating **B2B order placement** and **barcode scanning**, built in Flutter. This app demonstrates core app logic, customer-type pricing, and barcode validation.

---

## Features

### Part 1 — Order App
- View product list with:
  - Product Name
  - Price
  - Minimum Order Quantity (MOQ)
- Place an order:
  - Select product
  - Enter quantity
  - Validate MOQ (cannot order below MOQ)
  - Show total price dynamically
- Customer type logic:
  - **Dealer** → lower price
  - **Retail** → standard price

### Part 2 — Barcode Scanner
- Scan barcode using device camera
- Display product name (dummy mapping)
- Show validity status:
  - Valid (barcode ends with even number)
  - Invalid (barcode ends with odd number)

### Part 3 — API Integration
- Product list fetched from a dummy API
- Demonstrates API integration workflow

---

## Getting Started

### Prerequisites
- Flutter 3.x
- Dart 3.x
- Android Studio / VS Code

### Install Dependencies
```bash
flutter pub get
