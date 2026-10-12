# NEBWorld GROUP — Mobile Financial Services & Fintech Platform (Ghana)

[![Python 3.14+](https://img.shields.io/badge/python-3.14%2B-blue.svg)](https://www.python.org/)
[![Framework Flask](https://img.shields.io/badge/framework-Flask%203.1-black.svg)](https://flask.palletsprojects.com/)
[![Currency GHS](https://img.shields.io/badge/currency-GHS%20%28Ghana%20Cedi%29-yellow.svg)]()
[![Environment SANDBOX](https://img.shields.io/badge/mode-SANDBOX%20%2F%20TEST-orange.svg)]()

A commercial-grade, secure, multi-tier Mobile Money, Airtime distribution, Data Bundle marketplace, and Bill Payment business management system designed specifically for the Ghanaian telecommunications and payment landscape.

---

## 📌 Project Overview
* **System Name:** NEBWorld GROUP
* **Target Jurisdiction:** Ghana
* **Operating Currency:** Ghana Cedi (GHS)
* **Supported Telecom Networks:** MTN Ghana, Telecel Ghana (formerly Vodafone), AT (AirtelTigo)
* **Core Offerings:** Airtime Top-ups, Volume Data Bundles, Mobile Money Float Management, Utility Bill Collections, Agent Commissions & Float Ledger

---

## 🏗 Phase 1 Architecture & Status

**Phase 1: Project Architecture & Flask Setup** is complete.

### Key Architectural Implementations:
1. **Application Factory Pattern (`create_app`)**: Clean modular startup supporting `DevelopmentConfig`, `TestingConfig`, and `ProductionConfig`.
2. **Fintech Sandbox & Production Isolation**: Prominent UI and API-level sandbox warnings preventing accidental movement of real funds.
3. **HTTP & Session Security**:
   - `Content-Security-Policy` (CSP)
   - `X-Frame-Options: SAMEORIGIN` (Clickjacking prevention)
   - `X-Content-Type-Options: nosniff` (MIME sniffing prevention)
   - `X-XSS-Protection: 1; mode=block`
   - `Referrer-Policy: strict-origin-when-cross-origin`
   - `Permissions-Policy: camera=(), microphone=(), geolocation=()`
   - Strict HTTP-only cookies with configurable secure flags
4. **Error Handling Without Information Disclosure**:
   - Custom templates and REST JSON responses for `400`, `401`, `403`, `404`, `429`, `500`, and `503`.
   - Never exposes internal stack traces or database queries to users in production.
5. **Ghanaian Telecom Utilities**:
   - Automatic normalization of Ghanaian MSISDNs (`024XXXXXXX`, `233XXXXXXXXX`, `+233...`).
   - Dynamic network detection (MTN, Telecel, AirtelTigo).
   - Ghana Cedi (`GHS`) precision formatting filters.
   - Cryptographically random, non-sequential reference generator (`NW-YYYYMMDD-XXXXXX`).
6. **Mobile-First Responsive Interface**:
   - Sticky bottom navigation bar for mobile touch screens (`< 768px`).
   - 48px+ tap targets compliant with modern accessibility standards.
   - Quick action service cards with branded Ghana telecom badges.

---

## 📂 Project Structure

```text
My business/
├── .env                  # Local environment configuration
├── .env.example          # Environment configuration template
├── .gitignore            # Git exclusion rules
├── pytest.ini            # Pytest execution settings
├── requirements.txt      # Pinned Python package dependencies
├── run.py                # Server entry point & CLI commands
├── README.md             # Project documentation
│
├── app/
│   ├── __init__.py       # Application Factory (create_app), security headers, error handlers
│   ├── config.py         # Config hierarchy (BaseConfig, Dev, Test, Prod)
│   ├── extensions.py     # SQLAlchemy, Migrate, LoginManager, CSRFProtect, Limiter
│   │
│   ├── blueprints/
│   │   ├── main/         # Web portal (index, about, contact, health)
│   │   ├── api/          # REST API gateway (/api/v1/health, /api/v1/info)
│   │   ├── auth/         # Authentication blueprint skeleton (Phase 3)
│   │   ├── customer/     # Customer dashboard blueprint skeleton (Phase 4)
│   │   ├── agent/        # Agent terminal blueprint skeleton (Phase 5)
│   │   └── admin/        # Business owner console skeleton (Phase 6)
│   │
│   ├── models/
│   │   ├── __init__.py   # Models exporter
│   │   └── base.py       # Abstract BaseModel with UUID keys and audit timestamps
│   │
│   ├── services/         # Telecom APIs, payment abstraction & ledger services
│   │   └── __init__.py
│   │
│   ├── utils/
│   │   ├── __init__.py
│   │   └── helpers.py    # GHS currency, Ghana phone validator, network detector, reference generator
│   │
│   ├── static/
│   │   ├── css/
│   │   │   └── style.css # Mobile-first styling & Ghanaian telecom brand palette
│   │   ├── js/
│   │   │   └── main.js   # Client-side phone sanitation, GHS formatting & toast alerts
│   │   └── img/          # Static image assets
│   │
│   └── templates/
│       ├── base.html     # Master responsive layout with sandbox banner & bottom nav
│       ├── main/
│       │   ├── index.html   # Landing page with large service cards
│       │   ├── about.html   # Corporate and security architecture
│       │   └── contact.html # Support hotline and transaction query guidelines
│       └── errors/
│           ├── 400.html
│           ├── 401.html
│           ├── 403.html
│           ├── 404.html
│           ├── 429.html
│           ├── 500.html
│           └── 503.html
│
└── tests/
    ├── conftest.py          # Pytest fixtures (app, client, runner)
    ├── test_api.py          # REST API endpoint tests
    ├── test_config.py       # Configuration verification tests
    ├── test_errors.py       # Error handling & security header tests
    ├── test_factory.py      # Application factory & blueprint tests
    ├── test_main_routes.py  # Web pages & health check tests
    └── test_utils.py        # Currency, phone sanitation & reference tests
```

---

## 🚀 Quickstart & Installation

### 1. Prerequisites
* Python 3.10+ (Tested on Python 3.14.2)
* MySQL 8.0+ (Required for Production; SQLite fallback available for Phase 1 local development)

### 2. Environment Setup
```powershell
# In PowerShell / Terminal:
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 3. Configure Environment Variables
Copy `.env.example` to `.env`:
```powershell
cp .env.example .env
```
Ensure `ENVIRONMENT_MODE=SANDBOX` is active for non-production environments.

### 4. Initialize Local Database
```powershell
flask --app run.py init-db
```

### 5. Inspect Configuration Settings (Safe View)
```powershell
flask --app run.py check-config
```

### 6. Run the Application
```powershell
python run.py
# Or via Flask CLI:
flask --app run.py run --port 5000
```
Open your browser at: [http://127.0.0.1:5000](http://127.0.0.1:5000)

---

## 🧪 Testing

Run the automated test suite:
```powershell
.\.venv\Scripts\python.exe -m pytest -v
```

All 19 automated tests cover:
* Application factory initialization
* Blueprint registrations
* Environment configurations & production guardrails
* Public landing, about, contact, and system health checks
* REST API health and platform info routes
* Security HTTP response headers
* Custom error handlers (HTML for browsers vs JSON for API clients)
* Ghanaian phone number normalization & network classification
* Cryptographic reference token generation
* Ghana Cedi (GHS) precision formatting
