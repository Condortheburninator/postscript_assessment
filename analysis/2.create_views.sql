

-- BUILD LIST A

    -- SUMMARIZE SMS_PLATFORM_A_SUBSCRIBER_LIST ;

    CREATE OR REPLACE VIEW SUBSCRIBER_LIST_A

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
            SMS_PLATFORM_A_SUBSCRIBER_LIST

    WHERE
            1 = 1

    ;

    -- SUMMARIZE SUBSCRIBER_LIST_A ;
    -- SELECT * FROM SUBSCRIBER_LIST_A ORDER BY DATE_UNSUBSCRIBED DESC LIMIT 100 ;

-- BUILD LIST B

    -- SUMMARIZE SMS_PLATFORM_B_SUBSCRIBER_LIST ;

    CREATE OR REPLACE VIEW SUBSCRIBER_LIST_B

    AS

    SELECT
             "Phone number"                                 AS PHONE_NUMBER
            ,"SMS Subscription Status"                      AS SMS_SUBSCRIPTION_STATUS
            ,TRY_CAST( "Opt-in Timestamp" AS TIMESTAMPTZ )  AS OPT_IN_TIMESTAMP
            ,"Opt-in Source"                                AS OPT_IN_SOURCE
            ,"Additional Detail"                            AS ADDITIONAL_DETAIL
            ,"SMS Consent Timestamp"                        AS SMS_CONSENT_TIMESTAMP

    FROM
            SMS_PLATFORM_B_SUBSCRIBER_LIST

    WHERE
            1 = 1

    ;

    -- SUMMARIZE SUBSCRIBER_LIST_B ;
