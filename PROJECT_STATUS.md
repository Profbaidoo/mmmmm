# 🇬🇭 NEBWorld GROUP — Enterprise Platform Progress & Navigation Directory

> **Ghanaian Telecom, Mobile Money, Utility Bill Payments & Agent POS Platform**  
> **Status:** Phases 1–12 Completed & Verified &bull; **Test Suite:** 157/157 Passing (100%) &bull; **Currency:** GHS (Ghana Cedi)

---

## 🚀 How to Launch the Application Locally

To run the local server at any time:

```powershell
.venv\Scripts\python run.py
```

The application will be accessible at: **[http://127.0.0.1:5000](http://127.0.0.1:5000)**

---

## 🔑 Demo Access Credentials

| Role | Email / Identifier | Password | Dashboard Link |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `admin@nebworld.com` | `AdminSecure@2026!` | [http://127.0.0.1:5000/admin/dashboard](http://127.0.0.1:5000/admin/dashboard) |
| **Agent (POS)** | `agent@nebworld.com` | `AgentSecure@2026!` | [http://127.0.0.1:5000/agent/dashboard](http://127.0.0.1:5000/agent/dashboard) |
| **Customer** | `customer@nebworld.com` | `CustomerSecure@2026!` | [http://127.0.0.1:5000/customer/dashboard](http://127.0.0.1:5000/customer/dashboard) |

---

## 🌐 Feature Navigation & Live URL Directory

### 1. Mobile Money Gateway (Phase 12 — Completed)
- **MoMo Hub**: [http://127.0.0.1:5000/momo/](http://127.0.0.1:5000/momo/) — Unified portal for MTN MoMo, Telecel Cash, and AT Money, with live subscriber KYC lookup.
- **Send Mobile Money (Transfer)**: [http://127.0.0.1:5000/momo/transfer](http://127.0.0.1:5000/momo/transfer) — Transfers with automatic Ghana E-Levy compliance (1% above GHS 100/day threshold).
- **Top-Up Wallet (Cash-In)**: [http://127.0.0.1:5000/momo/deposit](http://127.0.0.1:5000/momo/deposit) — USSD Push prompt collection from phone to credit wallet float (E-Levy exempt).
- **Withdraw (Cash-Out)**: [http://127.0.0.1:5000/momo/withdraw](http://127.0.0.1:5000/momo/withdraw) — Payout from account wallet directly to mobile money.
- **Admin Gateway Console**: [http://127.0.0.1:5000/admin/gateways](http://127.0.0.1:5000/admin/gateways) — Node health, Live/Sandbox switcher, and webhook endpoints.

### 2. Utility & Institutional Bill Payments (Phase 11 — Completed)
- **Bill Payment Catalog**: [http://127.0.0.1:5000/bills/](http://127.0.0.1:5000/bills/) — ECG Electricity, GWCL Water, DStv, GOtv, StarTimes, MTN Fibre, WAEC/BECE.
- **ECG STS Recharge**: [http://127.0.0.1:5000/bills/pay/ECG_PREPAID](http://127.0.0.1:5000/bills/pay/ECG_PREPAID) — Meter verification and 20-digit STS token generation.
- **Admin Biller Management**: [http://127.0.0.1:5000/admin/billers](http://127.0.0.1:5000/admin/billers) — Configure utility billers, fee structures, and categories.

### 3. Telecom Airtime & Data Bundles (Phases 9 & 10 — Completed)
- **Airtime Purchase**: [http://127.0.0.1:5000/airtime/](http://127.0.0.1:5000/airtime/) — Instant top-up across MTN, Telecel, and AirtelTigo with network auto-detection.
- **Data Bundle Marketplace**: [http://127.0.0.1:5000/data/marketplace](http://127.0.0.1:5000/data/marketplace) — Non-expiry bundles, daily, weekly, and monthly packages.

### 4. Operations, Portals & Reconciler (Phases 1–8 — Completed)
- **Agent POS Terminal**: [http://127.0.0.1:5000/agent/dashboard](http://127.0.0.1:5000/agent/dashboard) — Sales terminal, float management, commission tracking.
- **Customer Portal**: [http://127.0.0.1:5000/customer/dashboard](http://127.0.0.1:5000/customer/dashboard) — Personal wallet balance, transactions, payment history.
- **Admin Executive Console**: [http://127.0.0.1:5000/admin/dashboard](http://127.0.0.1:5000/admin/dashboard) — Platform KPIs, agent management, wallet float oversight.
- **Admin Wallet Reconciler**: [http://127.0.0.1:5000/admin/reconcile](http://127.0.0.1:5000/admin/reconcile) — Mathematical double-entry ledger balance auditor.

---

## 📈 20-Phase Implementation Roadmap

| Phase | Module | Status |
| :--- | :--- | :---: |
| **Phase 1** | Enterprise System Architecture & DB Foundations | ✅ Verified |
| **Phase 2** | User Authentication, RBAC & Security | ✅ Verified |
| **Phase 3** | Multi-Wallet System & Double-Entry Ledger | ✅ Verified |
| **Phase 4** | Agent Management & Onboarding Flow | ✅ Verified |
| **Phase 5** | Customer Management & Self-Service Portal | ✅ Verified |
| **Phase 6** | Commission Structure & Multi-Tier Distribution | ✅ Verified |
| **Phase 7** | Transaction Processing Core & Idempotency | ✅ Verified |
| **Phase 8** | Agent POS Dashboard & Operations Terminal | ✅ Verified |
| **Phase 9** | Airtime Top-Up Integration (MTN, Telecel, AT) | ✅ Verified |
| **Phase 10** | Internet Data Bundle Marketplace | ✅ Verified |
| **Phase 11** | Utility & Institutional Bill Payments (ECG, GWCL, DStv) | ✅ Verified |
| **Phase 12** | Mobile Money (MTN MoMo API & Telecel Cash Gateway) | ✅ Verified |
| **Phase 13** | **SMS & WhatsApp Notification Engine (Hubtel / Arkesel / Twilio)** | ⏳ **NEXT** |
| **Phase 14** | USSD Offline Engine (*920# Architecture) | ⏸️ Queued |
| **Phase 15** | Agent POS Hardware & Bluetooth Thermal Receipt Printing | ⏸️ Queued |
| **Phase 16** | Automated Reconciliation & Float Balance Manager | ⏸️ Queued |
| **Phase 17** | Fraud Detection, Limits Engine & AML Compliance | ⏸️ Queued |
| **Phase 18** | Analytics, Reporting & Business Intelligence Export | ⏸️ Queued |
| **Phase 19** | Public Developer API, Webhooks & Partner Integration | ⏸️ Queued |
| **Phase 20** | Production Hardening, Performance Tuning & Deployment | ⏸️ Queued |

---

## 🧪 Regression Testing Summary
- **Total Test Cases**: 157
- **Passing**: 157 / 157 (100%)
- **Failures**: 0
- **Regressions**: 0

### 🛡️ Authentication & Authorization Features (Phase 2 Enhanced)
- **User Identification**: Multi-channel identity resolution (Email, Phone, Identity UUID, Customer/Agent Codes) with public verification badge.
- **Two-Factor Authentication (2FA)**: RFC 6238 TOTP with Base32 secret generation, SVG QR codes, and login interception.
- **Salt & Pepper Hashing**: 128-bit per-user random cryptographic salt + application secret pepper with PBKDF2-HMAC-SHA256 (100,000 iterations).
- **Row-Level Authorization (RLA)**: Fine-grained record access control via `RowAuthService` and `@row_authorized` decorator preventing IDOR vulnerabilities.
- **Auth Backup & Recovery**: Emergency single-use recovery codes + Authenticated AES (Fernet) backup snapshots with SHA-256 HMAC integrity checks and CLI/Web restoration.
