# Day 8 — Python Unit Testing with Pytest

## 📖 Overview
Today’s focus: **Python Unit Testing with Pytest**.  
We’ll explore how to write and run unit tests with `pytest` to ensure code quality and catch bugs early.

---

## 🎯 Learning Goals
- Install and configure **pytest**.  
- Write simple test functions and use assertions.  
- Group tests into test files and classes.  
- Use fixtures to set up and tear down test data.  
- Run tests with markers and get detailed reports.  

---

## 🛠️ Lab Setup & Tasks

```text
1. Install pytest
   pip install pytest

2. Write basic tests
   python -m pytest tests/test_math_basic.py

3. Use fixtures
   python -m pytest tests/test_with_fixtures.py

4. Run with markers
   pytest -m "slow"

5. Generate detailed reports
   pytest -v
   pytest --junitxml=report.xml
```

---

## 💡 Challenge
- Extend the math tests to include **edge cases** (division by zero, negative numbers, large inputs).  
- Add a custom marker `@pytest.mark.integration` and run only those tests.  
- Create a fixture that sets up a temporary file and cleans it up after tests.  

---



## 📌 Commit
Once complete, commit your progress:
```bash
git add day08-pytest-unit-testing
git commit -m "day08: Python unit testing with pytest — basics, fixtures, markers"
git push
```
