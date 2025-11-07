# Robotframeworkconcept

This repository contains sample Robot Framework suites. The `tests/register.robot` suite automates the registration form available at [https://demo.automationtesting.in/Register.html](https://demo.automationtesting.in/Register.html).

## Running the registration test

Run the suite directly with the bundled Robot Framework installation:

```bash
robot tests/register.robot
```

Because the execution environment cannot reach external web pages or install browser automation dependencies, the suite keeps an in-memory representation of the demo registration form using native Robot Framework keywords. The test follows the same steps as the live site—capturing personal details, choosing languages, skills, and a birth date, and submitting the form—while remaining fully runnable offline.
