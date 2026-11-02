# 🚚 Delivery Tracker App

A modern, multi-screen mobile delivery tracking application built with **Flutter** and **Riverpod**, designed with a polished Material 3 interface inspired by top-tier logistics and food delivery platforms.

---

## ✨ Features

- **Reactive State Management**: Powered by Riverpod (`StateNotifier`) for predictable, immutable state updates across the lifecycle of an order.
- **Multi-Screen Mobile Architecture**: Seamless navigation shell featuring Home, Live Tracking, and Profile tabs built using Flutter's Material 3 components.
- **Live Order Simulation**: Interactive status stepper (`Placed` $\rightarrow$ `Preparing` $\rightarrow$ `On the Way` $\rightarrow$ `Delivered`) with dynamic ETA and driver contact cards.
- **Responsive Layout**: Optimized for both mobile phones and tablet viewports.

---

## 📱 Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Flutter Riverpod (`flutter_riverpod`)
- **UI/UX**: Material 3 Design System, Custom Container Cards, and IndexedStack navigation shell.

---

## 📂 Project Structure

```text
delivery_tracker/
├── lib/
│   ├── main.dart             # Root application and theme setup
│   ├── delivery_provider.dart  # Data models, enums, and Riverpod StateNotifier
│   └── screens/
│       ├── main_shell.dart   # Bottom navigation shell
│       ├── home_screen.dart  # Dashboard with active orders
│       ├── delivery_screen.dart # Live status tracker & order summary
│       └── profile_screen.dart  # User account & delivery settings
└── pubspec.yaml              # Project dependencies & assets