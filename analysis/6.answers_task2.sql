

/**

After you’ve completed the analysis and uploaded the list based on the criteria above,
the customer is concerned that they’re missing a bunch of subscribers.

We learn that SMS Provider A failed to override the “unsubscribed” status on the
list export if subscribers re-opted in (after opting out-unsubscribing) at a later date.
How many subscribers have an opt-in date-timestamp that is AFTER the opt-out timestamp?

**/

-- SUMMARIZE SILVER.SUBSCRIBER_LIST_A ;
-- SUMMARIZE SILVER.SUBSCRIBER_LIST_B ;

WITH

TASK_1_A AS (

    SELECT
             CASE
                WHEN LEN( CAST( PHONE_NUMBER AS VARCHAR ) ) = 8
                THEN CAST( CONCAT( 1, CAST( PHONE_NUMBER AS VARCHAR ) ) AS INT )
                ELSE PHONE_NUMBER
             END                AS PHONE_NUMBER
            ,OPT_IN_SOURCE
            ,DATE_ADDED
            ,STATUS
            ,DATE_UNSUBSCRIBED
            -- ,*

    FROM
            SILVER.SUBSCRIBER_LIST_A

    WHERE
            1 = 1
            AND OPT_IN_SOURCE !=  'List import'
            AND STATUS        =   'Unsubscribed'
            AND (
                LEN( CAST ( PHONE_NUMBER AS VARCHAR ) ) = 8
                OR (
                    LEN( CAST ( PHONE_NUMBER AS VARCHAR ) ) = 9
                    AND LEFT( CAST ( PHONE_NUMBER AS VARCHAR ), 1 ) = 1
                )
            )
            AND PHONE_NUMBER IS NOT NULL

),

TASK_1_A_CLEANED AS (

    SELECT
             *
            ,ROW_NUMBER()
             OVER(
                PARTITION BY    PHONE_NUMBER
                ORDER BY        DATE_ADDED DESC
             )                  AS RN

    FROM
            TASK_1_A

    WHERE
            1 = 1

    QUALIFY
            RN = 1
),

TASK_1_B AS (

    SELECT
             CASE
                WHEN LEN( CAST( PHONE_NUMBER AS VARCHAR ) ) = 8
                THEN CAST( CONCAT( 1, CAST( PHONE_NUMBER AS VARCHAR ) ) AS INT )
                ELSE PHONE_NUMBER
             END                AS PHONE_NUMBER
            ,SMS_SUBSCRIPTION_STATUS
            ,OPT_IN_TIMESTAMP
            ,OPT_IN_SOURCE
            ,ADDITIONAL_DETAIL
            ,SMS_CONSENT_TIMESTAMP

    FROM
            SILVER.SUBSCRIBER_LIST_B

    WHERE
            1 = 1

),

COMBINED AS (

    SELECT
             A.PHONE_NUMBER
            ,A.STATUS
            ,A.OPT_IN_SOURCE    AS OPT_IN_SOURCE_A
            ,B.OPT_IN_TIMESTAMP
            ,A.DATE_UNSUBSCRIBED
            ,B.OPT_IN_SOURCE    AS OPT_IN_SOURCE_B
            --  EXCLUDE( RN )
            -- ,DATEDIFF( 'DAY', B.OPT_IN_TIMESTAMP, A.DATE_ADDED )

    FROM
            TASK_1_A_CLEANED        AS A

            LEFT JOIN TASK_1_B      AS B
                ON  A.PHONE_NUMBER  = B.PHONE_NUMBER
                -- AND A.OPT_IN_SOURCE = B.OPT_IN_SOURCE
                AND A.OPT_IN_SOURCE = 'Collected on SMS Platform B'
                AND B.OPT_IN_SOURCE != 'List Import'

    WHERE
            1 = 1
            AND B.OPT_IN_TIMESTAMP > A.DATE_UNSUBSCRIBED

    ORDER BY
            B.OPT_IN_SOURCE
            ,A.PHONE_NUMBER

)

SELECT
        *
        -- COUNT(PHONE_NUMBER)


FROM
        COMBINED

;