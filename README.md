# V.A.R.U.N.A. (Versatile Aquatic Reclamation & Autonomous Skimming Node)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MCU: ESP32 DevKit V1](https://img.shields.io/badge/MCU-ESP32--DevKit--V1-blue.svg)](https://www.espressif.com/)
[![Competition: AICTE Vishwakarma Awards](https://img.shields.io/badge/Competition-AICTE%20Vishwakarma%20Awards%202026--27-green.svg)](https://www.aicte-india.org/)
[![Budget Ceiling: ₹10,250](https://img.shields.io/badge/Budget%20Ceiling-%E2%82%B910%2C250-orange.svg)]()

> **Autonomous, Low-Cost, Solar-Assisted Surface Skimmer & Water Quality Monitoring Vessel.**  
> Developed for the **AICTE Chhatra Vishwakarma Awards (Supported by Maker Bhavan Foundation)**.

---

## 📌 Executive Summary

V.A.R.U.N.A. is a shallow-draft, twin-pontoon mechatronic surface skimmer engineered to intercept and remove floating solid municipal waste (plastics, wrappers, leaf litter) from lakes, stagnant urban drains, and shallow river banks. Operating at a total continuous power budget of **42.2W** and built within a strict **₹10,250 MVP cost ceiling**, V.A.R.U.N.A. serves as a continuous, preventive maintenance alternative to heavy earthmoving machinery (JCBs) and expensive imported commercial cleaning drones.

---

## 🛠 Engineering Target Specifications

| Parameter | Target Specification | Hardware / Protocol Implementation |
| :--- | :--- | :--- |
| **Vessel Envelope** | 120 × 65 × 55 cm | 2020 T-slot anodized aluminum frame + PVC hull |
| **Mass & Payload** | 8.2 kg (Dry) / 8.0 kg (Payload) | 35L removable mesh crate on sliding rails |
| **Buoyancy & Draft** | 36.2 L reserve volume / 15.5 cm draft | Twin sealed PVC pipes (Metacentric Height GM > 0.18 m) |
| **Propulsion & Drive** | 360° zero-turn differential steering | 2× 12V geared RS-775 motors + 2× BTS7960 43A H-bridges |
| **Intake Mechanism** | 32 cm V-mouth guide | 45 RPM grab-roller + 30 RPM SS mesh cleated conveyor |
| **Runtime & Power** | 102 – 148 mins continuous runtime | 12.8V 6Ah LiFePO4 (20A BMS) + 20W overhead solar arch |
| **Control & Vision** | 180 m Line-of-Sight Wi-Fi UI | ESP32-CAM (720p FPV) + ESP32 DevKit V1 (3.3V UART bus) |

---

## 📐 System Architecture & Communication Flow

V.A.R.U.N.A. utilizes a **Dual-MCU split-processing model** over a 3.3V UART serial bus. Isolating Wi-Fi video streaming (ESP32-CAM) from real-time motor control loops (ESP32 DevKit V1) prevents control latency spikes during remote navigation.
