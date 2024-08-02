create table orders
(
    id     SERIAL primary key,
    status varchar(15)
);

create table payment_transactions
(
    id     SERIAL primary key,
    order_id integer references orders(id),
    status varchar(15)
);

insert into orders (status) values ('Pending');

insert into payment_transactions(order_id, status) 
VALUES 
    (1, 'Failed'), (1, 'Paid');

insert into payment_transactions(order_id, status)
VALUES (1, 'Paid');



select * from pg_stat_replication;

select * from orders;

