CREATE DATABASE tdfdb;

use tdfdb


################################ - status $$$
CREATE Table status  
(
    status_id int auto_increment PRIMARY KEY,
    name char(15) not null
);

insert into status (name) 
values 
('Active'),
('Inactive'),
('Open'),
('Closed'),
('Blocked');

################################ - status



################################ - countries $$$

CREATE Table countries 
(
    country_id int auto_increment PRIMARY KEY,
    name char(35) not null unique,
    isd_code int not null unique
);

insert into countries
(name, isd_code) values
('Bharat', 91), ('USA', 1), ('China', 86), ('Russia', 7);

################################ - countries



################################ - occupations $$$
CREATE Table occupations 
(
    occupation_id int auto_increment PRIMARY KEY,
    name char(35) not null unique
);

insert into occupations
(name) values
('Student'), ('Working Professional'), ('Startup Owner'), ('Freelancer');

insert into occupations
(name) VALUE ('Trainer');

################################ - occupations



################################ - badges $$$

CREATE Table badges 
(
    badge_id int auto_increment PRIMARY KEY,
    name char(15) not null unique
);

insert into badges
(name) values
('Silver'),('Gold'),('Platinum');

################################ - badges




################################ - topics  $$$
CREATE Table topics
(
    topic_id int auto_increment PRIMARY KEY,
    name char(25) not null,
    all_posts int not null DEFAULT 0,
    open_posts int not null DEFAULT 0,
    active_users int not null DEFAULT 0
);

insert into topics
(name) values
('Java Script'),
('JavaSE'),
('JavaEE'),
('Spring'),
('SpringBoot'),
('Micro Services'),
('Python'),
('Django'),
('Go Lang'),
('Ruby');

alter table topics add column last_post datetime after open_posts; 
################################ - topics

################################ - Users $$$
CREATE Table users 
(
    user_id int auto_increment PRIMARY KEY,
    name char(45) not null,
    email char(255) not null unique,
    password char(255) not null,
    pic char(255),
    phone char(10) not null unique,
    interest char(255),
    employer char(60),
    experience int,
    job_profile char(25),
    occupation_id int,
    technologies_used char(100),
    questions_posted int not null DEFAULT 0,
    responses int not null DEFAULT 0,
    country_id int not null,
    messages_blocked int not null DEFAULT 0,
    otp char(6),
    star_rank int not null DEFAULT 0,
    badge_id int,
    status_id int not null DEFAULT 2,
    constraint fk_users_occupations foreign key (occupation_id) references occupations (occupation_id),
    constraint fk_users_countries foreign key (country_id) references countries (country_id),
    constraint fk_users_badges foreign key (badge_id) references badges (badge_id),
    constraint fk_users_status foreign key (status_id) references status (status_id)
);

insert into users (name, email, password, phone, country_id) value (?,?,?,?,?);
update users set status_id=1,otp='' where email=? and otp=?;

select user_id,u.name,password,pic,phone,interest,employer,experience,job_profile,occupation_id,
technologies_used,questions_posted,responses,c.country_id,c.name,messages_blocked,star_rank,badge_id,
s.status_id,s.name from users as u inner join countries as c inner join status as s where email=? 
and u.country_id=c.country_id and u.status_id=s.status_id; 

update users set password=? where email=?;

alter table users add column user_type_id int not null default 3,
add constraint fk_users_utypes foreign key (user_type_id) 
references user_types (user_type_id);

########################### - Users
-------------------------------



########################### - moderators $$$
CREATE Table moderators
(
    moderator_id int auto_increment PRIMARY KEY,
    topic_id int not null,
    user_id int not null,
    joined_on datetime not null,
    status_id int not null,
    constraint fk_moderators_topics foreign key (topic_id) references topics (topic_id),
    constraint fk_moderators_users foreign key (user_id) references users (user_id),
    constraint fk_moderators_status foreign key (status_id) references status (status_id)
);

########################### - moderators




########################### - posts $$$
CREATE Table posts 
(
    post_id int auto_increment PRIMARY KEY,
    user_id int not null,
    posted_on datetime not null,
    post varchar(2000) not null,
    likes int not null DEFAULT 0,
    dislikes int not null DEFAULT 0,
    spams int not null DEFAULT 0,
    shares int not null DEFAULT 0,
    post_type bool not null,
    status_id int not null,
    constraint fk_posts_users foreign key (user_id) references users (user_id),
    constraint fk_posts_status foreign key (status_id) references status (status_id)
);


alter table posts change column status_id status_id int not null default 3;

insert into posts (user_id, posted_on, post, post_type) value (?,?,?,?);
########################### - posts



########################### - questions $$$

CREATE Table questions
(
    question_id int auto_increment PRIMARY KEY,
    topic_id int not null,
    title char(100) not null,
    post_id int not null,
    replies int not null DEFAULT 0,
    constraint fk_questions_topics foreign key (topic_id) references topics (topic_id),
    constraint fk_questions_posts foreign key (post_id) references posts (post_id) 
);

insert into questions (topic_id, title, post_id) value (?,?,?);

select * from questions where question_id=?
########################### - questions




########################### - replies $$$
CREATE Table replies
(
    reply_id int auto_increment PRIMARY KEY,
    question_id int not null,
    post_id int not null,
    constraint fk_replies_questions foreign key (question_id) references questions (question_id),
    constraint fk_replies_posts foreign key (post_id) references posts (post_id) 
);

########################### - replies 




########################### - wishlist $$$ 
CREATE Table wishlist 
(
    wishlist_id int auto_increment PRIMARY KEY,
    post_id int not null,
    user_id int not null,
    status_id int not null DEFAULT 1,
    constraint fk_wishlist_posts foreign key (post_id) references posts (post_id),
    constraint fk_wishlist_users foreign key (user_id) references users (user_id),
    constraint fk_wishlist_status foreign key (status_id) references status (status_id)
);

########################### - wishlist




########################### - messages $$$ 

CREATE Table messages
(
    message_id int auto_increment PRIMARY KEY,
    from_user_id int not null,
    to_user_id int not null,
    message varchar(1000) not null,
    posted_on datetime not null,
    constraint fk_messages_users1 foreign key (from_user_id) references users (user_id),
    constraint fk_messages_users2 foreign key (to_user_id) references users (user_id)
);

alter table messages add column status_id int not null,
add constraint fk_messages_status foreign key (status_id) 
references status (status_id);

########################### - messages 



########################### - messages $$$

create table user_types 
(
    user_type_id int auto_increment primary key,
    name char(15) not null unique
);

insert into user_types (name) values ('Admin'), ('Moderator'), ('General User');

########################### - messages 