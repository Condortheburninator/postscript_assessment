

-- list a

    -- check the length of the phone numbers

        WITH

        PHONE_COUNTS AS (

            SELECT
                     LEN( CAST( PHONE_NUMBER AS VARCHAR ) ) AS PHONE_NUMBER
                    --  PHONE_NUMBER
                    ,COUNT( DISTINCT PHONE_NUMBER )         AS PHONE_COUNT

            FROM
                    SILVER.SUBSCRIBER_LIST_A

            WHERE
                    1 = 1

            GROUP BY
                    ALL

            ORDER BY
                    PHONE_NUMBER

        )

        SELECT
                 *
                ,PHONE_COUNT / SUM( PHONE_COUNT ) OVER () * 100 AS 'PER_OF_TOTAL'

        FROM
                PHONE_COUNTS

        ;

    -- for phone numbers with 9 digits, make sure they start with 1

        WITH

        PHONE_COUNTS AS (

            SELECT
                    --  PHONE_NUMBER
                     LEFT(CAST( PHONE_NUMBER AS VARCHAR ) , 1)  AS LEADING_DIGIT
                    ,COUNT( DISTINCT PHONE_NUMBER )             AS PHONE_COUNT

            FROM
                    SILVER.SUBSCRIBER_LIST_A

            WHERE
                    1 = 1
                    AND LEN(CAST( PHONE_NUMBER AS VARCHAR )) = 9
                    -- AND LEFT(CAST( PHONE_NUMBER AS VARCHAR ) , 1) != 1

            GROUP BY
                    ALL

        )

        SELECT
                *
                ,PHONE_COUNT / SUM( PHONE_COUNT ) OVER() * 100  AS PER_OF_TOTAL

        FROM
                PHONE_COUNTS

        WHERE
                1 = 1

        ORDER BY
                LEADING_DIGIT
        ;

    -- opt-in source

        WITH

        SOURCE AS (

        SELECT
                 OPT_IN_SOURCE
                ,COUNT(DISTINCT PHONE_NUMBER)   AS PHONE_COUNT

        FROM
                SILVER.SUBSCRIBER_LIST_A

        GROUP BY
                ALL

        )

        SELECT
                *
                ,PHONE_COUNT / SUM( PHONE_COUNT ) OVER () * 100    AS PER_OF_TOTAL

        FROM
                SOURCE

        ;

    -- phone numbers are subscribed

        SELECT
                 STATUS
                ,COUNT( DISTINCT PHONE_NUMBER   )   AS STATUS_COUNT

        FROM
                SILVER.SUBSCRIBER_LIST_A

        WHERE
                1 = 1

        GROUP BY
                ALL

        ;

-- list b
    -- check the length of phone numbers

        WITH

        PHONE_COUNTS AS (

            SELECT
                     LEN( CAST( PHONE_NUMBER AS VARCHAR ) ) AS PHONE_NUMBER
                    --  PHONE_NUMBER
                    ,COUNT( DISTINCT PHONE_NUMBER )         AS PHONE_COUNT

            FROM
                    SILVER.SUBSCRIBER_LIST_B

            WHERE
                    1 = 1
                    AND PHONE_NUMBER IS NOT NULL

            GROUP BY
                    ALL

            ORDER BY
                    PHONE_NUMBER

        )

        SELECT
                 *
                ,PHONE_COUNT / SUM( PHONE_COUNT ) OVER () * 100 AS 'PER_OF_TOTAL'

        FROM
                PHONE_COUNTS

        ;

    -- for phone numbers with 9 digits, make sure they start with 1

        WITH

        PHONE_COUNTS AS (

            SELECT
                    --  PHONE_NUMBER
                     LEFT(CAST( PHONE_NUMBER AS VARCHAR ) , 1)  AS LEADING_DIGIT
                    ,COUNT( DISTINCT PHONE_NUMBER )             AS PHONE_COUNT

            FROM
                    SILVER.SUBSCRIBER_LIST_B

            WHERE
                    1 = 1
                    AND LEN(CAST( PHONE_NUMBER AS VARCHAR )) = 9
                    -- AND LEFT(CAST( PHONE_NUMBER AS VARCHAR ) , 1) != 1

            GROUP BY
                    ALL

        )

        SELECT
                *
                ,PHONE_COUNT / SUM( PHONE_COUNT ) OVER() * 100  AS PER_OF_TOTAL

        FROM
                PHONE_COUNTS

        WHERE
                1 = 1

        ORDER BY
                LEADING_DIGIT
        ;

    -- opt-in source

        WITH

        SOURCE AS (

        SELECT
                 OPT_IN_SOURCE
                ,COUNT(DISTINCT PHONE_NUMBER)   AS PHONE_COUNT

        FROM
                SILVER.SUBSCRIBER_LIST_B

        GROUP BY
                ALL

        )

        SELECT
                *
                ,PHONE_COUNT / SUM( PHONE_COUNT ) OVER () * 100    AS PER_OF_TOTAL

        FROM
                SOURCE

        ;


    -- phone numbers are subscribed

        SELECT
                 SMS_SUBSCRIPTION_STATUS
                ,COUNT( DISTINCT PHONE_NUMBER   )   AS STATUS_COUNT

        FROM
                SILVER.SUBSCRIBER_LIST_B

        WHERE
                1 = 1

        GROUP BY
                ALL

        ;
