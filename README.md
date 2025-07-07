# 🛒 ElectroCommerce Flutter App

This project is a final e-commerce application built using **Flutter**. It supports essential e-commerce features including:

- User Registration & Login (with API Integration)
- Product Listing (via API)
- Category Filtering
- Cart Management (with persistent SharedPreferences)
- Order History
- Profile Page with local image and saved data

---

## 📚 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [App Structure](#app-structure)
- [Getting Started](#getting-started)
- [Developer](#developer)
- [Notes](#notes)
- [Acknowledgments](#acknowledgments)

---

## 📌 Overview

ElectroCommerce is a lightweight and functional e-commerce Flutter app designed as a final project for the ITI Flutter Course. It combines clean UI/UX design with persistent state handling and real-time API integration.

---

## 🚀 Features

- **Authentication:**  
  - User Registration & Login (مع تكامل API)
- **Product Catalog:**  
  - Product Listing (عبر API)
  - Category Filtering
- **Cart System:**  
  - Cart Management (حفظ تلقائي في SharedPreferences)
  - Offline-safe cart persistence
- **Order Management:**  
  - View and track order history
- **Profile:**  
  - Profile page (تعديل صورة المستخدم المحلية وحفظ البيانات)
- **UI/UX:**  
  - Modern, responsive UI with BlueAccent theme
  - Placeholder images for missing API images

---

## 🖼️ Screenshots

<div align="center">

|   |   |   |
|---|---|---|
| <img src="screenshots/1.jpg" width="200"/> | <img src="screenshots/2.jpg" width="200"/> | <img src="screenshots/3.jpg" width="200"/> |
| <img src="screenshots/4.jpg" width="200"/> | <img src="screenshots/5.jpg" width="200"/> | <img src="screenshots/6.jpg" width="200"/> |

</div>

<div align="center">
  <img src="screenshots/7.jpg" width="200"/>
</div>

---

## 🎬 App Preview

<div align="center">
  <img src="record.gif" width="300" alt="App Preview"/>
</div>

---

## 🧱 App Structure

```bash
lib/
├── screens/      # UI Screens (Login, Register, Home, Cart, Orders)
├── data/         # Shared preferences and global data
├── models/       # Models for Products & Cart Items
├── services/     # API integrations (Products, Categories)
```

---

## 🧑‍💻 Developer

**Ahmed Mohamed Gaafer**  
[LinkedIn](https://www.linkedin.com/in/ahmedgaafer/) | [GitHub](https://github.com/ahmedgaafer1)

---

## 📝 Notes

- Offline-safe cart and order persistence using SharedPreferences
- Placeholder images handle missing API images
- Main color theme: `BlueAccent`

---

## 🙏 Acknowledgments

> This project is part of the ITI Final Flutter Course Assignment under the supervision of **Eng. Ibrahim**
