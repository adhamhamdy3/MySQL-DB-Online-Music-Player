create table users (
	id int auto_increment,
    name varchar(50),
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    password varchar(20) not null,
    date_created datetime,
    profile_pic blob,
    primary key(id)
);

create table artists (
	id int auto_increment,
    name varchar(50),
    biography text,
    date_created date,
    profile_pic blob,
    primary key(id)
);

create table albums (
	id int auto_increment,
    artist_id int,
    title varchar(156) not null,
    release_date date not null,
    cover_art blob unique not null,
    primary key(id),
    foreign key(artist_id) references artists(id)
);

create table songs (
	id int auto_increment,
    artist_id int,
    album_id int default null,
    title varchar(50) not null,
    duration time not null,
    release_date date not null,
    genre varchar(37) not null,
    single boolean default false,
    primary key(id),
    foreign key(artist_id) references artists(id),
    foreign key(album_id) references albums(id)
);

create table playlists (
	id int auto_increment,
    user_id int,
    title varchar(30) not null,
    description text default null,
    date_created date not null,
    public bool default false,
    primary key(id),
    foreign key(user_id) references users(id)
);

create table user_follow_user (
	id int auto_increment,
    user1_id int,
    user2_id int,
    since datetime,
    primary key(id),
    foreign key(user1_id) references users(id),
	foreign key(user2_id) references users(id)
);

create table user_follow_artist (
	id int auto_increment,
    user_id int,
    artist_id int,
    since datetime,
    primary key(id),
    foreign key(user_id) references users(id),
	foreign key(artist_id) references artists(id)
);

create table liked_songs (
	id int auto_increment,
    user_id int,
    song_id int,
    since date,
    primary key(id),
	foreign key(user_id) references users(id),
    foreign key(song_id) references songs(id)
);

create table liked_albums (
	id int auto_increment,
    user_id int,
    album_id int,
    since date,
	primary key(id),
	foreign key(user_id) references users(id),
	foreign key(album_id) references albums(id)
);

create table liked_playlists (
	id int auto_increment,
    user_id int,
    playlist_id int,
    since date,
	primary key(id),
	foreign key(user_id) references users(id),
	foreign key(playlist_id) references playlists(id)
);

