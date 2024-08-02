
## Links

Debezium
Confluent: 

## Docs
Debezium example: https://github.com/debezium/debezium-examples

https://medium.com/@nikhil.nagarajappa/dockerizing-the-debezium-postgres-connector-918a71aa37bd

## Copy configuration files
COPY connect-debezium-postgresql.properties kafka/config/connect-debezium-postgresql.properties

## Commands

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

## Create a stream


CREATE STREAM orders (id VARCHAR, status VARCHAR)
WITH (KAFKA_TOPIC='postgres.public.payment_transactions',VALUE_FORMAT='JSON');


CREATE STREAM orders (
    payload STRUCT<
        after STRUCT<
            id INTEGER,
            status VARCHAR
        >
    >
)
WITH (
    KAFKA_TOPIC='postgres.public.orders',
    VALUE_FORMAT='JSON'
);



CREATE STREAM payment_transactions (
    payload STRUCT<
        after STRUCT<
            id INTEGER,
            order_id INTEGER,
            status VARCHAR
        >
    >
)
WITH (
    KAFKA_TOPIC='postgres.public.payment_transactions',
    VALUE_FORMAT='JSON'
);



## join streams 

select pt.PAYLOAD -> AFTER -> ORDER_ID, pt.PAYLOAD-> AFTER -> STATUS from
PAYMENT_TRANSACTIONS pt JOIN  ORDERS o within 2 days  ON o.PAYLOAD -> AFTER ->ID = pt.PAYLOAD -> AFTER -> ORDER_ID  EMIT CHANGES;


working join

select pt.PAYLOAD -> AFTER -> ORDER_ID, pt.PAYLOAD-> AFTER -> STATUS from
PAYMENT_TRANSACTIONS pt left JOIN  ORDERS o WITHIN (0 SECONDS, 7 DAYS)  ON o.PAYLOAD -> AFTER ->ID = pt.PAYLOAD -> AFTER -> ORDER_ID EMIT CHANGES;



select pt.PAYLOAD -> AFTER -> ORDER_ID, LATEST_BY_OFFSET(pt.PAYLOAD-> AFTER -> STATUS) from
PAYMENT_TRANSACTIONS pt left JOIN  ORDERS o WITHIN (0 SECONDS, 7 DAYS)  
ON o.PAYLOAD -> AFTER ->ID = pt.PAYLOAD -> AFTER -> ORDER_ID 
group by pt.PAYLOAD -> AFTER -> ORDER_ID  EMIT CHANGES;

create a stream from the above join

CREATE STREAM shipped_orders AS xxx


https://medium.com/@dursunkoc/realtime-streaming-etl-using-apache-kafka-kafka-connect-debezium-and-ksqldb-8e7c13d71a5f
https://stackoverflow.com/questions/57061599/kafka-debezium-mysql-connector-based-topic-for-ksql-streams-and-tables-all-col


