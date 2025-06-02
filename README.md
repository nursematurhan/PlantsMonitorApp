# 🌿 Plant Monitor App

A smart Flutter + Firebase + Arduino-based application to monitor real-time soil moisture of indoor plants. Ideal for plant enthusiasts who want to ensure optimal watering conditions. Built using Flutter for UI, Firebase for data handling, and NodeMCU (ESP8266) for sensor connectivity.

---

## 📱 Features

- 🔍 **Plant Selection** – Choose from a curated list of indoor flowering plants.
- 📡 **Real-time Monitoring** – Get live soil moisture values from Firebase Realtime Database.
- ⚠️ **Moisture Alerts** – Visual alerts when moisture is out of safe range.
- 🔎 **Search Bar** – Quickly find a plant by its name.
- 🖼️ **Image Support** – Plants with image and moisture data from Firestore.

<p align="center">
    <img src="https://github.com/user-attachments/assets/00c4c4fe-8cd0-4732-9a9d-9e98c7507eee" alt="Plant List Page" width="22%" />
     &nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/07bcb58e-20fd-4ce3-a846-c2d8a37b2aa2" alt="Monitor Page" width="22%" />
  &nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/673fc820-9931-40ef-934a-8d9818c7e666" alt="Plant List Page" width="22%" />
 

</p>

---

## 🧰 Tech Stack

### 📱 Mobile (Flutter)

- Flutter
- Dart
- Firebase Core
- Firebase Realtime Database
- Firebase Firestore
- Material UI 3

### 🌐 Backend (Firebase)

- Realtime Database – for sensor data
- Firestore – for plant list and moisture range
- Firebase Auth (optional for future)

### 🤖 IoT (Arduino)

- **NodeMCU (ESP8266)** – Wi-Fi enabled microcontroller
- **Soil Moisture Sensor (FC-28)** – Measures soil humidity
- **DHT11 Sensor** – Reads temperature and humidity (optional)
- **Breadboard + Jumper Wires**
- **Power Source (e.g., USB or 5V supply)**

---

### 🔌 Arduino Sensor Firmware

See the full source code used to read temperature, humidity, and soil moisture and push to Firebase:

👉 [`arduino/plant_monitor.ino`](./arduino/plant_monitor.ino)

---
