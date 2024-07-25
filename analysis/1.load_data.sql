

-- CREATE SCHEMAS

    CREATE SCHEMA IF NOT EXISTS BRONZE ;
    CREATE SCHEMA IF NOT EXISTS SILVER ;
    CREATE SCHEMA IF NOT EXISTS GOLD   ;


-- CREATE TABLES

    CREATE OR REPLACE TABLE BRONZE.SMS_PLATFORM_A_SUBSCRIBER_LIST

    AS

    SELECT * FROM read_csv(

        'data/SMS Platform A Subscriber List.csv'
        ,delim          = ','
        ,header         = TRUE
        ,null_padding   = TRUE
        -- ,all_varchar    = TRUE
        ,ignore_errors  = TRUE

    );


    CREATE OR REPLACE TABLE BRONZE.SMS_PLATFORM_B_SUBSCRIBER_LIST

    AS

    SELECT * FROM 'data/SMS Platform B Subscriber List.csv'

    ;


-- SHOW ALL TABLES ;