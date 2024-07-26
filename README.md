

```
______ _____ _____ _____ _____ _____ ______ ___________ _____
| ___ \  _  /  ___|_   _/  ___/  __ \| ___ \_   _| ___ \_   _|
| |_/ / | | \ `--.  | | \ `--.| /  \/| |_/ / | | | |_/ / | |
|  __/| | | |`--. \ | |  `--. \ |    |    /  | | |  __/  | |
| |   \ \_/ /\__/ / | | /\__/ / \__/\| |\ \ _| |_| |     | |
\_|    \___/\____/  \_/ \____/ \____/\_| \_|\___/\_|     \_/

```

`CONNER FERGUSON TAKE HOME ASSESSMENT`

---

## :books: Table of Contents

- [Approach](#-approach)
- [Data Quality](#mag_right-data-quality-loading-data--data-cleanup)
- [EDA](#hiking_boot-eda)
- [Assumption Review](#jigsaw-hintsassumptions-review-from-pdf)
- [Answers](#white_check_mark-answers)
- [Next Steps](#next_track_button-next-steps)
- [Bibliography](#book-bibliography)


## 🎯 Approach
1. load data into duckdb
    1. use [medallion architecture](https://www.databricks.com/glossary/medallion-architecture)
1. data quality checks
1. EDA
1. answer questions from assessment
1. profit :dollar: :dollar: :dollar: !!!



## :mag_right: Data Quality (Loading Data) & Data Cleanup

1. :white_check_mark: `SMS Platform B Subscriber List.csv` - no glaring issues
    1. was able to use the following simple code to upload it :point_down:

    `CREATE TABLE SMS_PLATFORM_B_SUBSCRIBER_LIST AS SELECT * FROM 'data/SMS Platform B Subscriber List.csv';`

1. :x: `SMS Platform A Subscriber List.csv` - lots of issues
    1. after some investigation two things are going on:
        1. `NULL` values are inputted as a dash ( `-` ) --> kept this as a `VARCHAR` and will solve for it later in a `VIEW` with `TRY_CAST`
        1. 1 row is causing problems :point_down: --> removed this row

         |       |          |                             |              |                  |            |   |
         | ----- | -------- | --------------------------- | ------------ | ---------------- | ---------- | - |
         | SANTA | Checkout | Collected on SMS Platform B | Unsubscribed | 2023-07-06 11:53 | Subscribed | - |

1. duckdb had issues inferring some of the data types (mostly timestamps & timestamps with timezones)
    1. wanted to clean all of this up and create views or tables so I wouldn't have to deal with this later on
    1. ex. varchar to timestamptz
        1.  `2019-04-08 13:00:00 PDT` --> `2019-04-08 13:00:00-04`



## :hiking_boot: EDA

1. list a

|    column_name    | column_type |       min        |             max             | approx_unique |        avg         |        std        |    q25    |    q50    |    q75    | count  | null_percentage |
|-------------------|-------------|------------------|-----------------------------|--------------:|--------------------|-------------------|-----------|-----------|-----------|-------:|----------------:|
| Phone number      | BIGINT      | 11111111         | 498191152175206             | 685077        | 1009853966.5912259 | 604829825759.1072 | 134651272 | 160484117 | 181121891 | 678473 | 0.00            |
| Opt-in Source     | VARCHAR     | Checkout         | Tools keywords              | 10            |                    |                   |           |           |           | 678473 | 0.00            |
| Date added        | VARCHAR     | 2022-02-03 06:08 | 2024-03-19 17:21            | 358079        |                    |                   |           |           |           | 678473 | 0.00            |
| Status            | VARCHAR     | Subscribed       | Unsubscribed                | 2             |                    |                   |           |           |           | 678473 | 0.00            |
| Date unsubscribed | VARCHAR     | -                | 2024-03-18T22:28:45.466000Z | 13446         |                    |                   |           |           |           | 678473 | 0.00            |

1. list b

|       column_name       | column_type |           min           |           max           | approx_unique |        avg         |        std         |    q25    |    q50    |    q75    | count  | null_percentage |
|-------------------------|-------------|-------------------------|-------------------------|--------------:|--------------------|--------------------|-----------|-----------|-----------|-------:|----------------:|
| Phone Number            | BIGINT      | 20587393                | 198999810               | 836832        | 158220062.09586287 | 24073108.084134195 | 134475959 | 159793070 | 180509509 | 815540 | 0.00            |
| SMS Subscription Status | VARCHAR     | SUBSCRIBED              | SUBSCRIBED              | 1             |                    |                    |           |           |           | 815540 | 0.00            |
| Opt-in Timestamp        | VARCHAR     | 2019-04-08 17:00:00 PDT | 2024-04-25 10:37:24 PDT | 644797        |                    |                    |           |           |           | 815540 | 0.00            |
| Opt-in Source           | VARCHAR     | Checkout                | TEXT                    | 6             |                    |                    |           |           |           | 815540 | 0.00            |
| Additional Detail       | VARCHAR     | 8310QTM31               | yes                     | 79            |                    |                    |           |           |           | 815540 | 26.89           |
| SMS Consent Timestamp   | TIMESTAMP   | 2019-04-08 17:00:00     | 2024-04-25 10:37:24     | 639069        |                    |                    |           |           |           | 815540 | 0.00            |

## :jigsaw: Hints/Assumptions Review (from pdf)
1. digits removal - either be 8 digits long or 9 with a leading 1
    1. list a
        1. most of the records are either 8 or 9 digits
            1. see results below :point_down:
            1. a small amount of records need to be removed

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
        1. no issues here

            | PHONE_NUMBER | PHONE_COUNT |     PER_OF_TOTAL     |
            |-------------:|------------:|---------------------:|
            | 8            | 17          | 0.002084508423866395 |
            | 9            | 815523      | 99.99791549157612    |

        1. check to see if the 9 digit numbers start with 1 --> no issues

            | LEADING_DIGIT | PHONE_COUNT | PER_OF_TOTAL |
            |---------------|------------:|-------------:|
            | 1             | 815523      | 100.0        |

1. remove list import as an opt-in source
    1. list a
        1. list import accounts for >10% of the records
        1. collect on sms platform b accounts for a huge portion, we'll need to grab the `OPT_IN_SOURCE` from that table

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

    1. list b
        1. list import accounts for >21% of the records in list b

        | OPT_IN_SOURCE  | PHONE_COUNT |     PER_OF_TOTAL     |
        |----------------|------------:|---------------------:|
        | Mobile Pop-up  | 22197       | 2.7217549108566104   |
        | Checkout       | 25120       | 3.08016774161905     |
        | TEXT           | 93          | 0.011403487259974986 |
        | QR Code        | 173         | 0.02121293866640508  |
        | List Import    | 171826      | 21.06898496701572    |
        | Desktop Pop-up | 596131      | 73.09647595458225    |

1. filter to `STATUS = 'Subscribed'`
    1. list a

        |    STATUS    | STATUS_COUNT |
        |--------------|-------------:|
        | Unsubscribed | 13485        |
        | Subscribed   | 664985       |

    1. list b

        | SMS_SUBSCRIPTION_STATUS | STATUS_COUNT |
        |-------------------------|-------------:|
        | SUBSCRIBED              | 815540       |


---

## :white_check_mark: Answers

### Task 1-1

How many subscribers from SMS Platform A can be uploaded to Postscript? Break down the subscriber counts by original opt-in sources. Use the following table template:

- need to complete the following:
    - only include phone numbers with 8 or 9 digits (leading 1)
    - convert all 8 digit numbers to have a leading one for consistency
    - remove dupes
    - remove list import from consideration
    - identify the original `OPT_IN_SOURCE` if "Collected on SMS Platform B" shows up on list a
    - only include statuses of "Subscribed"

:information_source: refer to query in analysis/5.answers_task1.sql for the detailed query

|       OPT_IN_SOURCE       | SUBSCRIBER_COUNT |
|---------------------------|------------------|
| Checkout                  | 58695            |
| Desktop Pop-up            | 402851           |
| Join keywords             | 7                |
| Mobile Pop-up             | 4411             |
| QR Code                   | 18               |
| QR code                   | 251              |
| Social opt-in             | 3263             |
| Subscribe keyword         | 7467             |
| Subscription form         | 5788             |
| Summertime Website Pop-up | 1146             |
| TEXT                      | 6                |
| Tools keywords            | 47               |

### Task 1-2
How many subscribers from the SMS Platform A export cannot be uploaded to Postscript? Create a table similar to the above and explain why these subscribers cannot be maintained.

:information_source: refer to query in analysis/5.answers_task1.sql for the detailed query

|        OPT_IN_SOURCE        | SUBSCRIBER_COUNT |
|-----------------------------|------------------|
| Collected on SMS Platform B | 29807            |
| List Import                 | 70080            |

1. 'Collected on SMS Platform B' - these records were supposed to be found in list b but returned nothing, therefore we can't determine their opt-in source and they need to be removed (29,807)
1. when joining to list b, a number of phone numbers returned 'list import' as the opt in source. given the assumptions in the document, list import is not a valid enough reason to port these subscribers over  (70,080)

### Task 2

After you’ve completed the analysis and uploaded the list based on the criteria above, the customer is concerned that they’re missing a bunch of subscribers. We learn that SMS Provider A failed to override the “unsubscribed” status on the list export if subscribers re-opted in (after opting out/unsubscribing) at a later date. How many subscribers have an opt-in date/timestamp that is AFTER the opt-out timestamp?



---

## :next_track_button: Next Steps
- [ ] implement business logic in gold layer (medallion set-up)
- [ ] build out transformation pipeline and lineage in dbt

---

## :book: Bibliography

- [ascii generator](https://patorjk.com/software/taag/#p=display&f=Doom&t=RAMP)
- [duckdb data types guide](https://duckdb.org/docs/sql/data_types/overview.html)
- [duckdb csv INSERT guide](https://duckdb.org/docs/data/csv/overview.html)
- [medallion architecture](https://www.databricks.com/glossary/medallion-architecture)

---
