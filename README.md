

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
- [Data Quality](#mag_right-data-quality-loading-data--data-cleanup)
- [EDA](#hiking_boot-eda--hintsassumptions-review-from-pdf)
- [Answer](#white_check_mark-answer)
- [Next Steps](#next_track_button-next-steps)
- [Bibliography](#book-bibliography)

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
1. :white_check_mark: `SMS Platform B Subscriber List.csv` - no glaring issues
    1. was able to use the following simple code to upload it :point_down:

    `CREATE TABLE SMS_PLATFORM_B_SUBSCRIBER_LIST AS SELECT * FROM 'data/SMS Platform B Subscriber List.csv';`

1. :x: `SMS Platform A Subscriber List.csv` - lots of issues
    1. after some investigation two things are going on:
        1. `NULL` values are inputted as as a dash  --> kept this as a `VARCHAR` and will solve for it later in a `VIEW` with `TRY_CAST`
        1. 1 row is causing problems :point_down: --> removed this row

         |       |          |                             |              |                  |            |   |
         | ----- | -------- | --------------------------- | ------------ | ---------------- | ---------- | - |
         | SANTA | Checkout | Collected on SMS Platform B | Unsubscribed | 2023-07-06 11:53 | Subscribed | - |
1. duckdb had issues inferring some of the data types (mostly timestamps & timestamps with timezones)
    1. wanted to clean all of this up and `CREATE VIEWS` so I wouldn't have to deal with this later on
    1. ex. varchar to timestamptz
        1.  `2019-04-08 13:00:00 PDT` --> `2019-04-08 13:00:00-04`

---

## :hiking_boot: EDA & Hints/Assumptions Review (from pdf)
1. digits removal - either be 8 digits long or 9 with a leading 1
    1. list a
        1. most of the records are either 8 or 9 digits
            1. see results below :point_down: a small amount of records need to be removed

            | PHONE_NUMBER | PHONE_COUNT |      PER_OF_TOTAL      |
            |-------------:|------------:|-----------------------:|
            | 8            | 135         | 0.01989771102627972    |
            | 9            | 671172      | 98.92434448096452      |
            | 10           | 6296        | 0.9279702860848674     |
            | 11           | 863         | 0.12719796011614368    |
            | 12           | 3           | 0.0004421713561395493  |
            | 15           | 1           | 0.00014739045204651644 |

        1. however, let's make sure that all the 9 digit numbers start with 1
            1. again, a small amount of records need to be removed

            | LEADING_DIGIT | PHONE_COUNT |     PER_OF_TOTAL     |
            |---------------|------------:|---------------------:|
            | 1             | 666003      | 99.22985464232715    |
            | 2             | 258         | 0.038440220986572744 |
            | 3             | 1673        | 0.24926546399432634  |
            | 4             | 1221        | 0.1819205807155245   |
            | 5             | 206         | 0.030692579547418542 |
            | 6             | 1620        | 0.24136882945057303  |
            | 7             | 41          | 0.006108717288563885 |
            | 8             | 73          | 0.010876496635735698 |
            | 9             | 77          | 0.011472469054132175 |

    1. list b
1. remove list import as an opt-in source
    1. list a
        1. list import accounts for >10% of the records
        1. collect on sms platform b accounts for a huge portion

        |        OPT_IN_SOURCE        | PHONE_COUNT |     PER_OF_TOTAL     |
        |-----------------------------|------------:|---------------------:|
        | Checkout                    | 67563       | 9.958141111618788    |
        | Summertime Website Pop-up   | 1156        | 0.170383362565773    |
        | QR code                     | 251         | 0.036995003463675624 |
        | List import                 | 68882       | 10.152549117868144   |
        | Collected on SMS Platform B | 523318      | 77.13207658407887    |
        | Subscribe keyword           | 7467        | 1.1005645054313382   |
        | Join keywords               | 7           | 0.001031733164325615 |
        | Tools keywords              | 47          | 0.006927351246186273 |
        | Social opt-in               | 3668        | 0.5406281781066222   |
        | Subscription form           | 6111        | 0.9007030524562618   |


1. filter to `STATUS = 'Subscribed'`

list a
- [ ] has 8 digits or 9 starting with 1
- [ ] remove list import as an opt-in source
 - [ ]
- [ ] filter to subscribed status


---

## :white_check_mark: Answer



---

## :next_track_button: Next Steps
- [ ] build out transformation pipeline and lineage in dbt

---

## :book: Bibliography

- [ascii generator](https://patorjk.com/software/taag/#p=display&f=Doom&t=RAMP)
- [duckdb data types guide](https://duckdb.org/docs/sql/data_types/overview.html)
- [duckdb csv INSERT guide](https://duckdb.org/docs/data/csv/overview.html)

---
