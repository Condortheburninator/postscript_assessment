

-- BUILD LIST A

    CREATE OR REPLACE TABLE SILVER.SUBSCRIBER_LIST_A

    AS

    SELECT
             "Phone number"                                 AS PHONE_NUMBER
            ,"Opt-in Source"                                AS OPT_IN_SOURCE
            ,TRY_CAST   (
                STRPTIME(
                     "Date added"
                    ,'%Y-%m-%d %H:%M'
                )           AS TIMESTAMP
             )                                              AS DATE_ADDED
            ,"Status"                                       AS 'STATUS'
            ,TRY_CAST("Date unsubscribed" AS TIMESTAMPTZ)   AS DATE_UNSUBSCRIBED

    FROM
            BRONZE.SMS_PLATFORM_A_SUBSCRIBER_LIST

    WHERE
            1 = 1
            -- AND "Opt-in Source" !=  'List import'
            -- AND "Status"        =   'Subscribed'
            -- AND (
            --     LEN( CAST ( "Phone number" AS VARCHAR ) ) = 8
            --     OR (
            --         LEN( CAST ( "Phone number" AS VARCHAR ) ) = 9
            --         AND LEFT( CAST ( "Phone number" AS VARCHAR ), 1 ) = 1
            --     )
            -- )

    ;

-- BUILD LIST B


    CREATE OR REPLACE TABLE SILVER.SUBSCRIBER_LIST_B

    AS

    SELECT
             "Phone number"                                 AS PHONE_NUMBER
            ,"SMS Subscription Status"                      AS SMS_SUBSCRIPTION_STATUS
            ,TRY_CAST( "Opt-in Timestamp" AS TIMESTAMPTZ )  AS OPT_IN_TIMESTAMP
            ,"Opt-in Source"                                AS OPT_IN_SOURCE
            ,"Additional Detail"                            AS ADDITIONAL_DETAIL
            ,"SMS Consent Timestamp"                        AS SMS_CONSENT_TIMESTAMP

    FROM
            BRONZE.SMS_PLATFORM_B_SUBSCRIBER_LIST

    WHERE
            1 = 1

    ;


SHOW ALL TABLES ;