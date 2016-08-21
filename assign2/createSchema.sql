drop table if exists workers;
create table workers(
	id integer primary key,
	first_name varchar(100),
	last_name varchar(100)
);

drop table if exists work_orders;
create table work_orders(
	id integer primary key,
	worker_id integer,
	work_details varchar(100),
	creation_date Date,
	status varchar(20),
	status_update_date Date
);