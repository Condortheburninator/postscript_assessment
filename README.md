

```
______ _____ _____ _____ _____ _____ ______ ___________ _____
| ___ \  _  /  ___|_   _/  ___/  __ \| ___ \_   _| ___ \_   _|
| |_/ / | | \ `--.  | | \ `--.| /  \/| |_/ / | | | |_/ / | |
|  __/| | | |`--. \ | |  `--. \ |    |    /  | | |  __/  | |
| |   \ \_/ /\__/ / | | /\__/ / \__/\| |\ \ _| |_| |     | |
\_|    \___/\____/  \_/ \____/ \____/\_| \_|\___/\_|     \_/

```

`CONNER FERGUSON APPLICATION ASSESSMENT`

- [Approach](#-approach)
- [EDA & Data Quality](#mag_right-eda--data-quality)
- [Answer](#white_check_mark-answer)
- [Next Steps](#next_track_button-next-steps)
- [Bibliography](#book-bibliography)
- [Appendix](#appendix)


---

## 🎯 Approach
1. load data into duckdb
1. EDA
1. data quality checks
1. answer questions from assessment
1. profit :dollar: :dollar: :dollar: !!!


---

## :mag_right: EDA & Data Quality

### Data Quality
1. no issues with loading the platform b list
was able to use the following syntax to upload it
`CREATE TABLE SMS_PLATFORM_B_SUBSCRIBER_LIST AS SELECT * FROM 'data/SMS Platform B Subscriber List.csv';`
1. however, lots of issues with platform a list
    1. after some investigation two things are going on:
        1. `NULL` values are inputted as as a dash
        1. 1 row is causing problems

         |       |          |                             |              |                  |            |   |
         | ----- | -------- | --------------------------- | ------------ | ---------------- | ---------- | - |
         | SANTA | Checkout | Collected on SMS Platform B | Unsubscribed | 2023-07-06 11:53 | Subscribed | - |


### EDA

1.




---

## :white_check_mark: Answer



---

## :next_track_button: Next Steps


---

## :book: Bibliography

- [ascii generator](https://patorjk.com/software/taag/#p=display&f=Doom&t=RAMP)
- [duckdb csv INSERT guide](https://duckdb.org/docs/data/csv/overview.html)

---
