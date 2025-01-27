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

insert into usuario values (1, 'Joao', 'joao@gmail.com');
insert into usuario values (2, 'Maria', 'mariagamer@gmail.com');

select * from usuario;

insert into cargo values(1, 'Pedreiro', 1, 100.00);
insert into cargo values(2, 'Pedreiro', 1, 100.00);

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