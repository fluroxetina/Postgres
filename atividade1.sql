Create Table usuario (
	Id int primary key not null,
	nome varchar(50),
	email varchar(50)
);

Create Table cargo (
	Id int primary key not null,
	nome varchar(50),
	FkUsuario int,
	CONSTRAINT FkCargoUsuario foreign key (FkUsuario)
	references usuario(Id)
);


alter table cargo add column salario decimal (10,2);
alter table cargo alter column nome type varchar(100);
alter table cargo drop column salario;


alter table cargo add column salario decimal(10,2);

insert into usuario values (4, 'Bruno', 'brunogamer@gmail.com');
insert into usuario values (2, 'Maria', 'mariagamer@gmail.com');

select * from usuario;

insert into cargo values(3, 'Analista', 1, 1000.00);
insert into cargo values(4, 'Dev Front-End', 1, 1123123.00);

update cargo set salario = 6500.34 where id = 1;

update usuario set nome = 'KauaGueixo' where id = 1;

delete from usuario where id = 2;

drop table cargo;
drop table usuario;

-- Left Join
select * from usuario join cargo on cargo.FkUsuario = usuario.id;

-- Right Join
select * from cargo right join usuario on cargo.FkUsuario = usuario.id;

-- Inner Join
select * from usuario join cargo on cargo.FkUsuario = usuario.id;

SELECT * from usuario;
SELECT * from cargo;

SELECT cargo.nome from cargo;
SELECT c.nome, u.nome from cargo c, usuario u;

SELECT c.nome from cargo c where id = 3;

SELECT u.id from usuario u where u.nome = 'Joao';

SELECT u.nome from usuario u where u.id = 1  or u.id = 2;
SELECT u.nome from usuario u where u.id = 1  and  u.id = 2;

SELECT u.nome from usuario u where id in (1,2);

SELECT u.nome from usuario u where id not in (2);

SELECT u.nome from usuario u where id BETWEEN 1 and 2;

SELECT u.id, u.nome from usuario u where nome like 'Jo%';

SELECT u.id, u.nome from usuario u where id > 1 and id < 3;

select u.id, u.nome from usuario u order by nome asc;

select u.id, u.nome from usuario u order by id desc;

SELECT * from usuario limit 1;

SELECT c.nome, u.nome from usuario u, cargo c 
where u.id = c.FkUsuario  GROUP BY c.nome, u.id;

SELECT c.nome, u.nome, count(c.id) from usuario u, cargo c 
where u.id = c.FkUsuario  GROUP BY c.nome, u.id;