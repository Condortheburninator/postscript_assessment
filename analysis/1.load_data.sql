

CREATE TABLE SMS_PLATFORM_A_SUBSCRIBER_LIST

AS

    SELECT * FROM read_csv(

        'data/SMS Platform A Subscriber List.csv'
        ,delim          = ','
        ,header         = TRUE
        ,null_padding   = TRUE
        -- ,all_varchar    = TRUE
        ,ignore_errors  = TRUE
        ,columns = {

            'Phone Number'          : BIGINT
            ,'Opt-in Source'        : VARCHAR
            ,'Date added'           : TIMESTAMP
            ,'Status'               : VARCHAR
            ,'Date unsubscribed'    : VARCHAR
        }

    );


-- CREATE TABLE SMS_PLATFORM_B_SUBSCRIBER_LIST AS SELECT * FROM 'data/SMS Platform B Subscriber List.csv';
