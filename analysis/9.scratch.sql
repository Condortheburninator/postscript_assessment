

SELECT
         A.OPT_IN_SOURCE
        ,B.OPT_IN_SOURCE
        ,COUNT(*)

FROM
        SUBSCRIBER_LIST_A           AS A

        LEFT JOIN SUBSCRIBER_LIST_B AS B
            ON  A.PHONE_NUMBER  = B.PHONE_NUMBER
            AND A.OPT_IN_SOURCE = 'Collected on SMS Platform B'

-- LIMIT
        -- 1000
GROUP BY
        ALL

ORDER BY
        1, 2
;