# SQL Injection (SQLi) Interactive Laboratory

![sqli](https://github.com/user-attachments/assets/72e32033-b9fb-4128-8043-f31f3c45ab71)


## ⚠️ Legal & Ethical Disclaimer
**FOR EDUCATIONAL PURPOSES ONLY.**  
Attempting to perform SQL injection on systems you do not own or have explicit permission to test is illegal and unethical. This application is intentionally designed with critical security vulnerabilities to be used strictly in a controlled lab environment.

---

## 📌 Project Overview
This laboratory is a full-stack web application designed to demonstrate the mechanics, impact, and prevention of **SQL Injection (SQLi)**. Built with **Flask** and **PostgreSQL**, it provides a realistic environment to practice modern web exploitation and defense.

### Learning Objectives
1.  Understand how unsanitized input manipulates backend SQL logic.
2.  Practice **Authentication Bypass** to gain administrative access.
3.  Perform **Union-Based** attacks to exfiltrate hidden database records.
4.  Execute **Blind SQLi** using time-based delays (`pg_sleep`).
5.  Learn to mitigate vulnerabilities using **Parameterized Queries**.

---

## 🛠️ Quick Start (Docker Setup)

The easiest way to launch the lab is using Docker, which automatically configures the web server and the PostgreSQL database.

### 1. Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running.

### 2. Launch the Environment
Open your terminal in the project root and run:
```bash
docker-compose up --build
```

### 3. Access the Lab
Once the containers are running, open your browser to:
- **URL:** `http://localhost:5000`

---

## 📂 Project Structure
- `app.py`: Flask routing and session management.
- `database.py`: Vulnerable SQL execution logic.
- `init_db.sql`: Database schema and seed data (runs automatically).
- `templates/`: HTML interface built with Bootstrap 5.
- `static/images/`: Contains your `sqli_diagram.svg` and lab screenshots.

---

## 🧪 SQLi Walkthrough Guide

### Phase 1: Authentication Bypass (The "Entry" Hack)
**Goal:** Log in as the administrator without a password.
1.  Navigate to the **Login** page.
2.  In the **Username** field, enter: `administrator' --`
3.  Leave the password blank and click **Login**.
4.  **Result:** You are redirected to the **Admin Dashboard**.
5.  **Why?** The `--` comments out the password check in the query:
    `SELECT * FROM users WHERE user = 'administrator' --' AND pass = '...'`

<img width="1438" height="805" alt="image" src="https://github.com/user-attachments/assets/767a3995-4834-4e26-921d-d04074d9097f" />


---

### Phase 2: Logic Manipulation (Hidden Data)
**Goal:** View products that are not yet released to the public.
1.  Go to the **Products** page.
2.  Search for: `' OR 1=1 --`
3.  **Observation:** A product named **"Hidden Prototype"** appears.
4.  **Why?** The original query has `WHERE released = TRUE`. By injecting `OR 1=1`, we make the condition always true, and the `--` removes the "released" restriction.

---

### Phase 3: In-Band Union Attack (Data Exfiltration)
**Goal:** Dump all usernames and passwords from the `users` table into the product list.
1.  In the **Product Search** bar, enter the following (careful with column counts):
    ```sql
    ' UNION SELECT username, password, NULL, NULL FROM users --
    ```
2.  **Result:** The product grid now displays the user database contents.
3.  **Note:** We use `NULL` or placeholder strings to ensure our injected query matches the **4 columns** expected by the original query.

<img width="1323" height="971" alt="image" src="https://github.com/user-attachments/assets/18e9c7b9-fe55-450e-8222-a582c517d013" />



---

### Phase 4: Blind SQLi (Time-Based)
**Goal:** Confirm a vulnerability exists when no data is displayed on the screen.
1.  Navigate to **Blind SQLi** (User Verification).
2.  Enter ID: `1; SELECT pg_sleep(5) --`
3.  **Observation:** The page will hang/spin for exactly 5 seconds before loading.
4.  **Why?** Even if the UI doesn't show database errors, the server's **response time** proves the SQL command was executed.

---

## 🛡️ The Fix: Parameterized Queries
The lab isn't complete until you see the fix. In `database.py`, we move from dangerous string formatting to secure placeholders.

**❌ Vulnerable (Insecure):**
```python
query = f"SELECT * FROM users WHERE username = '{username}'"
cur.execute(query)
```

**✅ Parameterized (Secure):**
```python
query = "SELECT * FROM users WHERE username = %s"
cur.execute(query, (username,))
```
*The database driver ensures the `%s` input is treated strictly as data, making it impossible for the attacker to "break out" of the string.*

---

## 📖 Presentation Resources
- **Diagram:** View the `sqli_diagram.svg` in the home section for a visual breakdown of the "Breakout" logic.
- **Cheat Sheet:** Use the [PortSwigger SQLi Cheat Sheet](https://portswigger.net/web-security/sql-injection/cheat-sheet) for advanced payloads (PostgreSQL specific).

---

## 🚀 Contributing & Customization
This laboratory is designed to be modular and extensible. Learning security is a community effort, and you are encouraged to **fork this repository** to add your own features or challenges.

**Ideas for expansion:**
*   **New Injection Types:** Add scenarios for *Second-Order SQLi* or *Out-of-band (OAST)* attacks.
*   **WAF Simulation:** Implement a simple regex-based filter and challenge users to bypass it using encoding or case-switching.
*   **Database Variety:** Add support or Docker profiles for **MySQL** or **MariaDB** to show syntax differences.
*   **Automation:** Create a folder for `sqlmap` scripts to show how automated tools interact with these vulnerabilities.

If you create a cool new injection scenario, feel free to submit a **Pull Request**!

---

> *"The code you used today is just the baseline. If you want to dive deeper, fork the project and try to build a 'Secure Mode' toggle that switches between the vulnerable code and the parameterized code. It’s the best way to practice both attacking and defending."*
---

**Created for [ Network Security & Cryptography Lab / GVPCE (A) ]**  
*Lead Presenter: Bagadi Bharat*
