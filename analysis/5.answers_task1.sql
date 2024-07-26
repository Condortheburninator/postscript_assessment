

---
-- task 1
    -- How many subscribers from SMS Platform A can be uploaded to Postscript? Break down the subscriber counts by original opt-in sources.

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
            -- ,*

    FROM
            SILVER.SUBSCRIBER_LIST_A

    WHERE
            1 = 1
            AND OPT_IN_SOURCE !=  'List import'
            AND STATUS        =   'Subscribed'
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
             PHONE_NUMBER
            ,OPT_IN_SOURCE
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
            ,OPT_IN_SOURCE

    FROM
            SILVER.SUBSCRIBER_LIST_B

),

COMBINED AS (

    SELECT
             A.OPT_IN_SOURCE            AS OPT_IN_SOURCE_A
            ,B.OPT_IN_SOURCE            AS OPT_IN_SOURCE_B
            ,COUNT( A.PHONE_NUMBER )    AS PHONE_COUNT

    FROM
            TASK_1_A_CLEANED            AS A

            LEFT JOIN TASK_1_B  AS B
                ON  A.PHONE_NUMBER  = B.PHONE_NUMBER
                -- AND A.OPT_IN_SOURCE = B.OPT_IN_SOURCE
                AND A.OPT_IN_SOURCE = 'Collected on SMS Platform B'

    GROUP BY
            ALL

    -- ORDER BY
    --          A.OPT_IN_SOURCE
    --         ,B.OPT_IN_SOURCE

)

SELECT
        --  OPT_IN_SOURCE_A
        -- ,OPT_IN_SOURCE_B
         CASE
            WHEN OPT_IN_SOURCE_B IS NOT NULL
            THEN OPT_IN_SOURCE_B
            ELSE OPT_IN_SOURCE_A
         END                AS OPT_IN_SOURCE
        ,SUM(PHONE_COUNT)   AS SUBSCRIBER_COUNT

FROM
        COMBINED

WHERE
        1 = 1
        -- AND(
        --     OPT_IN_SOURCE_A     != 'Collected on SMS Platform B'
        --     OR OPT_IN_SOURCE_B  != 'List Import'
        -- )

        -- task 2
        -- AND (
            AND (
                OPT_IN_SOURCE_A         = 'Collected on SMS Platform B'
                AND OPT_IN_SOURCE_B     = 'List Import'
            )
            OR (
                OPT_IN_SOURCE_A     = 'Collected on SMS Platform B'
                AND OPT_IN_SOURCE_B IS NULL
            )
        -- )

GROUP BY
        ALL

ORDER BY
        OPT_IN_SOURCE

-- LIMIT
--         1000

;
