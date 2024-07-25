

```
______ _____ _____ _____ _____ _____ ______ ___________ _____
| ___ \  _  /  ___|_   _/  ___/  __ \| ___ \_   _| ___ \_   _|
| |_/ / | | \ `--.  | | \ `--.| /  \/| |_/ / | | | |_/ / | |
|  __/| | | |`--. \ | |  `--. \ |    |    /  | | |  __/  | |
| |   \ \_/ /\__/ / | | /\__/ / \__/\| |\ \ _| |_| |     | |
\_|    \___/\____/  \_/ \____/ \____/\_| \_|\___/\_|     \_/

```

`CONNER FERGUSON TAKE HOME ASSESSMENT`

- [Approach](#-approach)
- [EDA & Data Quality](#mag_right-eda--data-quality)
- [Answer](#white_check_mark-answer)
- [Next Steps](#next_track_button-next-steps)
- [Bibliography](#book-bibliography)
- [Appendix](#appendix)


---

## 🎯 Approach
1. load data into duckdb
1. data quality checks
1. EDA
1. answer questions from assessment
1. profit :dollar: :dollar: :dollar: !!!


---

## :mag_right: Data Quality (Loading Data) & Data Cleanup

### Data Quality
1. no issues with loading the platform b list
    1. was able to use the following simple code to upload it `CREATE TABLE SMS_PLATFORM_B_SUBSCRIBER_LIST AS SELECT * FROM 'data/SMS Platform B Subscriber List.csv';`
1. however, lots of issues with platform a list
    1. after some investigation two things are going on:
        1. `NULL` values are inputted as as a dash  --> kept this as a `VARCHAR` and will solve for it later in a `VIEW`
        1. 1 row is causing problems :point_down: --> removed this row

         |       |          |                             |              |                  |            |   |
         | ----- | -------- | --------------------------- | ------------ | ---------------- | ---------- | - |
         | SANTA | Checkout | Collected on SMS Platform B | Unsubscribed | 2023-07-06 11:53 | Subscribed | - |
1. duckdb had issues inferring some of the data types (mostly timestamps & timestamps with timezones)
    1. wanted to clean all of this up and `CREATE VIEWS` so I wouldn't have to deal with this later on
    1. ex. varchar to timestamptz
        1.  `2019-04-08 13:00:00 PDT` --> `2019-04-08 13:00:00-04`


### EDA

1.




---

## :white_check_mark: Answer



---

## :next_track_button: Next Steps


---

## :book: Bibliography

- [ascii generator](https://patorjk.com/software/taag/#p=display&f=Doom&t=RAMP)
- [duckdb data types guide](https://duckdb.org/docs/sql/data_types/overview.html)
- [duckdb csv INSERT guide](https://duckdb.org/docs/data/csv/overview.html)

---
