
create database jobportal3;
use jobportal3;
create table users(id int auto_increment primary key,name varchar(100),email varchar(100) UNIQUE, password varchar(100),role varchar(20),summary text,skills text,education text,certificates text,mobile varchar(20),resume varchar(255),photo varchar(255));
create table jobs(id int auto_increment primary key,title varchar(100),description text, company varchar(100), salary varchar(50), experience varchar(20), created_at DATETIME DEFAULT CURRENT_TIMESTAMP);
create table applications(id int auto_increment primary key,job_id int,applicant varchar(100));

CREATE TABLE IF NOT EXISTS notifications (
  id int auto_increment primary key,
  to_user varchar(100),
  message text,
  type varchar(20),
  sent_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  is_read BOOLEAN DEFAULT false
);

ALTER TABLE users ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active';

insert into users(name,email,password,role) values('Admin','admin@gmail.com','admin','admin');

