

-- CREATE TABLE SMS_PLATFORM_A_SUBSCRIBER_LIST AS SELECT * FROM 'data/SMS_Platform_A_Subscriber_List.csv' null_padding = TRUE;

SELECT * FROM read_csv(

    'data/SMS_Platform_A_Subscriber_List.csv'
    ,delim          = ','
    ,header         = TRUE
    ,null_padding   = TRUE
    ,columns = {
        -- 'FlightDate': 'DATE',
        -- 'UniqueCarrier': 'VARCHAR',
        -- 'OriginCityName': 'VARCHAR',
        -- 'DestCityName': 'VARCHAR'
    }
);

-- CREATE TABLE SMS_PLATFORM_B_SUBSCRIBER_LIST AS SELECT * FROM 'data/SMS_Platform_B_Subscriber_List.csv';
