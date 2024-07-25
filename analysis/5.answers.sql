

---
-- task 1
    -- How many subscribers from SMS Platform A can be uploaded to Postscript? Break down the subscriber counts by original opt-in sources. Use the following table template:

SELECT
        -- *
        OPT_IN_SOURCE
        ,COUNT( DISTINCT PHONE_NUMBER )

FROM
        SUBSCRIBER_LIST_A

WHERE
        1 = 1

GROUP BY
        ALL

;

SELECT
        --  LEN( CAST ( PHONE_NUMBER AS VARCHAR ) )
        -- ,COUNT( DISTINCT PHONE_NUMBER)
        -- PHONE_NUMBER
          PHONE_NUMBER
         ,COUNT( PHONE_NUMBER)

FROM
        SUBSCRIBER_LIST_A

GROUP BY
        ALL

HAVING
        COUNT( PHONE_NUMBER ) != 1

;


SUMMARIZE SUBSCRIBER_LIST_A ;

SELECT
        -- COUNT( DISTINCT PHONE_NUMBER)
         PHONE_NUMBER
        ,CASE
            WHEN LEN( CAST( PHONE_NUMBER AS VARCHAR ) ) = 8
            THEN CAST( CONCAT( 1, CAST( PHONE_NUMBER AS VARCHAR ) ) AS INT )
            ELSE PHONE_NUMBER
         END

FROM
        SUBSCRIBER_LIST_A

WHERE
        1 = 1
        AND LEN( CAST( PHONE_NUMBER AS VARCHAR ) ) = 8

LIMIT
        100
;
