

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
            1. a small amount of records need to be removed - see results below :point_down:

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

:question: How many subscribers from SMS Platform A can be uploaded to Postscript? Break down the subscriber counts by original opt-in sources. Use the following table template:

Before answering the prompt we need to solve for the hints/assumptions listed in the document.

need to complete the following:
- [x] only include phone numbers with 8 or 9 digits (leading 1)
- [x] convert all 8 digit numbers to have a leading one for consistency
- [x] remove dupes
- [x] remove list import from consideration
- [x] identify the original `OPT_IN_SOURCE` if "Collected on SMS Platform B" shows up on list a
- [x] only include statuses of "Subscribed"

:information_source: refer to query in analysis/5.answers_task1.sql for the detailed query

results below :point_down:

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
:question: How many subscribers from the SMS Platform A export cannot be uploaded to Postscript? Create a table similar to the above and explain why these subscribers cannot be maintained.

:information_source: refer to query in analysis/5.answers_task1.sql for the detailed query

|        OPT_IN_SOURCE        | SUBSCRIBER_COUNT |
|-----------------------------|------------------|
| Collected on SMS Platform B | 29807            |
| List Import                 | 70080            |

1. 'Collected on SMS Platform B' - these records were supposed to be found in list b but returned nothing, therefore we can't determine their opt-in source and they need to be removed (29,807)
1. when joining to list b, a number of phone numbers returned 'list import' as the opt in source. given the assumptions in the document, list import is not a valid reason to port these subscribers over  (70,080)

### Task 2

:question: After you’ve completed the analysis and uploaded the list based on the criteria above, the customer is concerned that they’re missing a bunch of subscribers. We learn that SMS Provider A failed to override the “unsubscribed” status on the list export if subscribers re-opted in (after opting out/unsubscribing) at a later date. How many subscribers have an opt-in date/timestamp that is AFTER the opt-out timestamp?


steps:
1. upcycled the query from task 1-1 and swapped the `STATUS = 'Unsubscribed'`
1. joined list b to list a since list b is the only table with the opt-in timestamp
1. filtered the results to `OPT_IN_TIMESTAMP > DATE_UNSUBSCRIBED`

:information_source: refer to query in analysis/6.answers_task2.sql for the detailed query

there are 97 subscribers that have an opt-in date/timestamp that is AFTER the opt-out timestamp

results :point_down:

| PHONE_NUMBER |    STATUS    |       OPT_IN_SOURCE_A       |    OPT_IN_TIMESTAMP    |     DATE_UNSUBSCRIBED      | OPT_IN_SOURCE_B |
|-------------:|--------------|-----------------------------|------------------------|----------------------------|-----------------|
| 136094671    | Unsubscribed | Collected on SMS Platform B | 2023-06-02 06:18:32-04 | 2022-07-24 12:47:44-04     | Checkout        |
| 150438278    | Unsubscribed | Collected on SMS Platform B | 2023-03-22 07:04:54-04 | 2022-08-09 12:49:54-04     | Checkout        |
| 156159117    | Unsubscribed | Collected on SMS Platform B | 2023-04-28 10:36:42-04 | 2022-10-01 13:04:24-04     | Checkout        |
| 180465296    | Unsubscribed | Collected on SMS Platform B | 2023-07-16 09:06:14-04 | 2022-08-23 14:07:24-04     | Checkout        |
| 183245957    | Unsubscribed | Collected on SMS Platform B | 2023-03-11 17:45:26-05 | 2023-01-07 00:51:37-05     | Checkout        |
| 120554049    | Unsubscribed | Collected on SMS Platform B | 2023-02-02 16:25:16-05 | 2023-01-26 13:21:24-05     | Desktop Pop-up  |
| 122528724    | Unsubscribed | Collected on SMS Platform B | 2024-02-07 19:50:30-05 | 2022-04-16 12:42:45-04     | Desktop Pop-up  |
| 122834363    | Unsubscribed | Collected on SMS Platform B | 2023-10-03 07:53:50-04 | 2022-09-06 14:05:13-04     | Desktop Pop-up  |
| 124054785    | Unsubscribed | Collected on SMS Platform B | 2023-08-25 03:10:26-04 | 2022-07-05 13:48:49-04     | Desktop Pop-up  |
| 125230828    | Unsubscribed | Collected on SMS Platform B | 2023-08-01 14:35:02-04 | 2023-07-01 13:07:57-04     | Desktop Pop-up  |
| 125480052    | Unsubscribed | Collected on SMS Platform B | 2023-10-17 03:24:09-04 | 2023-04-02 18:56:06-04     | Desktop Pop-up  |
| 125622636    | Unsubscribed | Collected on SMS Platform B | 2023-04-09 03:51:20-04 | 2022-07-20 14:09:36-04     | Desktop Pop-up  |
| 125641731    | Unsubscribed | Collected on SMS Platform B | 2023-01-15 03:03:03-05 | 2022-08-20 12:39:18-04     | Desktop Pop-up  |
| 125652052    | Unsubscribed | Collected on SMS Platform B | 2023-12-17 17:15:37-05 | 2022-04-03 00:47:33-04     | Desktop Pop-up  |
| 126762592    | Unsubscribed | Collected on SMS Platform B | 2023-12-30 09:51:23-05 | 2022-11-28 14:54:24-05     | Desktop Pop-up  |
| 130227200    | Unsubscribed | Collected on SMS Platform B | 2023-08-24 11:39:30-04 | 2022-10-10 13:29:53-04     | Desktop Pop-up  |
| 130937144    | Unsubscribed | Collected on SMS Platform B | 2022-12-18 16:12:59-05 | 2022-08-15 12:54:24-04     | Desktop Pop-up  |
| 131056797    | Unsubscribed | Collected on SMS Platform B | 2022-11-21 19:47:48-05 | 2022-09-05 01:14:04-04     | Desktop Pop-up  |
| 131455604    | Unsubscribed | Collected on SMS Platform B | 2023-12-17 11:49:34-05 | 2023-01-20 11:10:58-05     | Desktop Pop-up  |
| 133741280    | Unsubscribed | Collected on SMS Platform B | 2023-10-31 20:43:16-04 | 2023-04-08 12:59:13-04     | Desktop Pop-up  |
| 134730745    | Unsubscribed | Collected on SMS Platform B | 2023-05-09 13:16:23-04 | 2022-10-18 14:27:01-04     | Desktop Pop-up  |
| 134775605    | Unsubscribed | Collected on SMS Platform B | 2022-12-26 18:19:21-05 | 2022-10-11 12:38:29-04     | Desktop Pop-up  |
| 134790837    | Unsubscribed | Collected on SMS Platform B | 2023-04-15 16:46:23-04 | 2022-09-30 12:59:06-04     | Desktop Pop-up  |
| 140483817    | Unsubscribed | Collected on SMS Platform B | 2023-03-24 06:22:11-04 | 2022-05-07 14:16:08-04     | Desktop Pop-up  |
| 140484018    | Unsubscribed | Collected on SMS Platform B | 2023-08-10 04:37:52-04 | 2023-06-19 13:42:17-04     | Desktop Pop-up  |
| 140739852    | Unsubscribed | Collected on SMS Platform B | 2022-08-21 01:01:52-04 | 2022-03-25 13:13:40-04     | Desktop Pop-up  |
| 140797315    | Unsubscribed | Collected on SMS Platform B | 2022-03-12 17:07:52-05 | 2020-09-10 05:38:04-04     | Desktop Pop-up  |
| 141042244    | Unsubscribed | Collected on SMS Platform B | 2023-06-05 17:06:37-04 | 2022-11-15 07:41:16-05     | Desktop Pop-up  |
| 141578601    | Unsubscribed | Collected on SMS Platform B | 2022-08-03 13:41:01-04 | 2022-06-02 21:27:13-04     | Desktop Pop-up  |
| 144341884    | Unsubscribed | Collected on SMS Platform B | 2023-02-03 16:03:42-05 | 2022-09-07 14:15:14-04     | Desktop Pop-up  |
| 144395380    | Unsubscribed | Collected on SMS Platform B | 2023-11-26 00:18:10-05 | 2023-03-06 12:40:09-05     | Desktop Pop-up  |
| 146988204    | Unsubscribed | Collected on SMS Platform B | 2023-02-05 00:46:39-05 | 2022-05-15 12:33:20-04     | Desktop Pop-up  |
| 147921226    | Unsubscribed | Collected on SMS Platform B | 2023-11-05 20:46:51-05 | 2023-09-22 12:19:24-04     | Desktop Pop-up  |
| 150299613    | Unsubscribed | Collected on SMS Platform B | 2022-12-26 03:51:57-05 | 2022-12-12 12:50:07-05     | Desktop Pop-up  |
| 150828484    | Unsubscribed | Collected on SMS Platform B | 2023-11-23 21:14:06-05 | 2022-02-10 13:07:54-05     | Desktop Pop-up  |
| 150841440    | Unsubscribed | Collected on SMS Platform B | 2023-12-02 15:13:04-05 | 2022-11-16 14:32:09-05     | Desktop Pop-up  |
| 150873681    | Unsubscribed | Collected on SMS Platform B | 2023-04-26 03:06:03-04 | 2023-01-16 22:11:11-05     | Desktop Pop-up  |
| 151653471    | Unsubscribed | Collected on SMS Platform B | 2022-09-25 04:26:46-04 | 2022-04-07 12:41:39-04     | Desktop Pop-up  |
| 151658711    | Unsubscribed | Collected on SMS Platform B | 2021-12-19 21:13:31-05 | 2020-09-09 07:51:29-04     | Desktop Pop-up  |
| 153122974    | Unsubscribed | Collected on SMS Platform B | 2023-08-17 06:37:53-04 | 2022-06-25 13:39:07-04     | Desktop Pop-up  |
| 158541491    | Unsubscribed | Collected on SMS Platform B | 2022-11-29 12:08:16-05 | 2022-03-02 18:14:50-05     | Desktop Pop-up  |
| 158682289    | Unsubscribed | Collected on SMS Platform B | 2023-11-26 09:14:01-05 | 2022-09-01 12:40:34-04     | Desktop Pop-up  |
| 160723546    | Unsubscribed | Collected on SMS Platform B | 2023-03-09 05:42:23-05 | 2022-08-28 12:40:46-04     | Desktop Pop-up  |
| 160950132    | Unsubscribed | Collected on SMS Platform B | 2023-08-05 10:13:37-04 | 2023-07-01 12:52:10-04     | Desktop Pop-up  |
| 161056384    | Unsubscribed | Collected on SMS Platform B | 2023-05-02 19:40:22-04 | 2023-01-25 12:49:22-05     | Desktop Pop-up  |
| 161420764    | Unsubscribed | Collected on SMS Platform B | 2024-01-09 09:02:28-05 | 2020-09-10 18:14:58-04     | Desktop Pop-up  |
| 161489303    | Unsubscribed | Collected on SMS Platform B | 2024-01-02 20:09:30-05 | 2022-08-30 03:18:29-04     | Desktop Pop-up  |
| 161587800    | Unsubscribed | Collected on SMS Platform B | 2024-01-04 22:46:54-05 | 2022-10-15 12:42:38-04     | Desktop Pop-up  |
| 161879136    | Unsubscribed | Collected on SMS Platform B | 2022-08-08 19:44:28-04 | 2020-09-10 06:13:17-04     | Desktop Pop-up  |
| 164625120    | Unsubscribed | Collected on SMS Platform B | 2023-07-01 07:08:12-04 | 2022-12-19 23:00:00-05     | Desktop Pop-up  |
| 166163459    | Unsubscribed | Collected on SMS Platform B | 2024-02-24 14:43:28-05 | 2023-09-29 12:46:07-04     | Desktop Pop-up  |
| 166277268    | Unsubscribed | Collected on SMS Platform B | 2024-01-25 11:56:07-05 | 2023-01-26 12:44:47-05     | Desktop Pop-up  |
| 170142938    | Unsubscribed | Collected on SMS Platform B | 2024-02-27 17:17:48-05 | 2023-03-23 15:46:08-04     | Desktop Pop-up  |
| 170659012    | Unsubscribed | Collected on SMS Platform B | 2023-09-07 10:06:30-04 | 2023-04-11 20:04:36-04     | Desktop Pop-up  |
| 171655344    | Unsubscribed | Collected on SMS Platform B | 2021-11-12 18:58:44-05 | 2020-09-09 19:29:54-04     | Desktop Pop-up  |
| 171861284    | Unsubscribed | Collected on SMS Platform B | 2023-12-22 22:10:17-05 | 2023-11-28 12:33:29.402-05 | Desktop Pop-up  |
| 173256973    | Unsubscribed | Collected on SMS Platform B | 2022-12-14 11:18:47-05 | 2022-07-29 12:44:46-04     | Desktop Pop-up  |
| 173261429    | Unsubscribed | Collected on SMS Platform B | 2023-10-09 09:27:18-04 | 2022-10-19 13:00:33-04     | Desktop Pop-up  |
| 173446912    | Unsubscribed | Collected on SMS Platform B | 2023-08-17 17:11:29-04 | 2022-10-01 12:43:08-04     | Desktop Pop-up  |
| 175770510    | Unsubscribed | Collected on SMS Platform B | 2023-12-01 20:37:14-05 | 2023-08-21 18:35:45-04     | Desktop Pop-up  |
| 175779368    | Unsubscribed | Collected on SMS Platform B | 2024-02-18 06:55:50-05 | 2023-08-28 22:43:50-04     | Desktop Pop-up  |
| 177224031    | Unsubscribed | Collected on SMS Platform B | 2023-02-17 19:17:52-05 | 2022-10-22 13:10:53-04     | Desktop Pop-up  |
| 177294028    | Unsubscribed | Collected on SMS Platform B | 2023-10-16 14:10:20-04 | 2023-09-07 13:53:42-04     | Desktop Pop-up  |
| 177365670    | Unsubscribed | Collected on SMS Platform B | 2023-10-08 02:13:08-04 | 2022-06-23 12:39:06-04     | Desktop Pop-up  |
| 177398336    | Unsubscribed | Collected on SMS Platform B | 2023-10-16 07:37:44-04 | 2022-03-12 15:14:07-05     | Desktop Pop-up  |
| 178146093    | Unsubscribed | Collected on SMS Platform B | 2022-03-01 14:36:30-05 | 2020-09-09 22:28:15-04     | Desktop Pop-up  |
| 178631872    | Unsubscribed | Collected on SMS Platform B | 2023-11-28 19:51:14-05 | 2022-11-21 12:20:09-05     | Desktop Pop-up  |
| 178667517    | Unsubscribed | Collected on SMS Platform B | 2023-04-02 12:47:14-04 | 2022-11-25 19:34:11-05     | Desktop Pop-up  |
| 180382529    | Unsubscribed | Collected on SMS Platform B | 2023-09-14 12:41:16-04 | 2022-03-02 18:47:56-05     | Desktop Pop-up  |
| 180492042    | Unsubscribed | Collected on SMS Platform B | 2023-04-21 01:20:03-04 | 2023-01-08 06:39:37-05     | Desktop Pop-up  |
| 180545358    | Unsubscribed | Collected on SMS Platform B | 2024-02-11 21:19:22-05 | 2022-11-02 12:35:49-04     | Desktop Pop-up  |
| 184351032    | Unsubscribed | Collected on SMS Platform B | 2023-08-05 12:13:56-04 | 2022-05-03 12:35:47-04     | Desktop Pop-up  |
| 185051948    | Unsubscribed | Collected on SMS Platform B | 2023-05-06 03:22:57-04 | 2022-07-26 12:38:32-04     | Desktop Pop-up  |
| 185052986    | Unsubscribed | Collected on SMS Platform B | 2023-12-08 23:50:11-05 | 2023-10-05 08:49:17-04     | Desktop Pop-up  |
| 185628841    | Unsubscribed | Collected on SMS Platform B | 2024-01-20 03:13:10-05 | 2022-05-16 14:50:47-04     | Desktop Pop-up  |
| 185653562    | Unsubscribed | Collected on SMS Platform B | 2024-02-02 12:17:47-05 | 2022-04-10 12:41:13-04     | Desktop Pop-up  |
| 186093443    | Unsubscribed | Collected on SMS Platform B | 2022-12-30 21:49:25-05 | 2022-05-16 17:24:11-04     | Desktop Pop-up  |
| 186426073    | Unsubscribed | Collected on SMS Platform B | 2023-11-24 09:14:42-05 | 2022-08-13 13:07:23-04     | Desktop Pop-up  |
| 186525453    | Unsubscribed | Collected on SMS Platform B | 2023-09-08 05:21:16-04 | 2022-12-07 13:21:09-05     | Desktop Pop-up  |
| 187021009    | Unsubscribed | Collected on SMS Platform B | 2022-09-25 20:38:46-04 | 2022-09-12 12:49:23-04     | Desktop Pop-up  |
| 190126418    | Unsubscribed | Collected on SMS Platform B | 2022-10-18 03:51:18-04 | 2022-06-06 12:41:11-04     | Desktop Pop-up  |
| 190842278    | Unsubscribed | Collected on SMS Platform B | 2022-12-12 10:53:41-05 | 2022-05-27 12:57:03-04     | Desktop Pop-up  |
| 191054499    | Unsubscribed | Collected on SMS Platform B | 2022-12-30 10:26:51-05 | 2022-05-10 12:57:44-04     | Desktop Pop-up  |
| 191262181    | Unsubscribed | Collected on SMS Platform B | 2023-12-19 08:15:44-05 | 2023-05-06 12:09:38-04     | Desktop Pop-up  |
| 191449798    | Unsubscribed | Collected on SMS Platform B | 2023-08-21 12:49:09-04 | 2022-05-02 12:33:05-04     | Desktop Pop-up  |
| 191638582    | Unsubscribed | Collected on SMS Platform B | 2023-11-07 16:48:32-05 | 2022-07-04 12:46:12-04     | Desktop Pop-up  |
| 191793852    | Unsubscribed | Collected on SMS Platform B | 2023-03-17 15:16:32-04 | 2022-11-27 21:23:30-05     | Desktop Pop-up  |
| 193751627    | Unsubscribed | Collected on SMS Platform B | 2023-10-13 10:44:48-04 | 2022-11-26 20:31:31-05     | Desktop Pop-up  |
| 194930113    | Unsubscribed | Collected on SMS Platform B | 2023-04-01 18:28:30-04 | 2022-08-18 12:47:45-04     | Desktop Pop-up  |
| 195155623    | Unsubscribed | Collected on SMS Platform B | 2023-12-15 16:13:02-05 | 2022-05-12 12:53:47-04     | Desktop Pop-up  |
| 195455907    | Unsubscribed | Collected on SMS Platform B | 2023-11-21 03:50:59-05 | 2020-09-10 20:06:48-04     | Desktop Pop-up  |
| 195486058    | Unsubscribed | Collected on SMS Platform B | 2024-03-05 19:43:38-05 | 2020-09-09 17:45:55-04     | Desktop Pop-up  |
| 197177286    | Unsubscribed | Collected on SMS Platform B | 2023-02-16 02:38:36-05 | 2022-08-23 12:55:16-04     | Desktop Pop-up  |
| 198042397    | Unsubscribed | Collected on SMS Platform B | 2023-12-04 15:39:30-05 | 2022-06-06 13:08:42-04     | Desktop Pop-up  |
| 198964012    | Unsubscribed | Collected on SMS Platform B | 2023-04-20 04:52:22-04 | 2022-08-18 12:42:20-04     | Desktop Pop-up  |
| 180429596    | Unsubscribed | Collected on SMS Platform B | 2023-06-17 10:11:51-04 | 2022-05-03 12:53:46-04     | Mobile Pop-up   |
| 172439696    | Unsubscribed | Collected on SMS Platform B | 2021-11-26 10:40:07-05 | 2020-09-10 05:19:50-04     | QR Code         |

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
