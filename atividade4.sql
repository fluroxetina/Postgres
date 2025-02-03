create table Empregado (
    Nome varchar(50),
    Endereco varchar(500),
    CPF int primary key not null,
    DataNasc date,
    Sexo char(10),
    CartTrab int,
    Salario float,
    NumDep int,
    CPFSup int,
    foreign key (CPFSup) references Empregado(CPF) 
);


create table Departamento (
    NomeDep varchar(50),
    NumDep int primary key not null,
    CPFGer int,
    DataInicioGer date,
    foreign key (CPFGer) references Empregado(CPF)
);


alter table Empregado 
    add constraint fk_numdep foreign key (NumDep) references Departamento(NumDep);


create table Projeto (
    NomeProj varchar(50),
    NumProj int primary key not null,
    Localizacao varchar(50),
    NumDep int,
    foreign key (NumDep) references Departamento(NumDep)
);

create table Trabalha_Em (
    CPF int,
    NumProj int,
    HorasSemana int,
    foreign key (CPF) references Empregado(CPF),
    foreign key (NumProj) references Projeto(NumProj)
);

create table Dependente (
    idDependente int primary key not null,
    CPFE int,
    NomeDep varchar(50),
    Sexo char(10),
    Parentesco varchar(50),
    foreign key (CPFE) references Empregado(CPF) 
);



insert into Departamento values ('Dep1', 1, null, '1990-01-01'); 
insert into Departamento values ('Dep2', 2, null, '1990-01-01');
insert into Departamento values ('Dep3', 3, null, '1990-01-01');


insert into Empregado values ('Joao', 'Rua 1', 123, '1990-01-01', 'M', 123, 1000, 1, null);
insert into Empregado values ('Maria', 'Rua 2', 456, '1990-01-01', 'F', 456, 2000, 2, null);
insert into Empregado values ('Jose', 'Rua 3', 789, '1990-01-01', 'M', 789, 3000, 3, null);
insert into Empregado values ('Mario', 'Rua 4', 101, '1990-01-01', 'M', 101, 4000, 3, null);


update Departamento set CPFGer = 123 where NumDep = 1;
update Departamento set CPFGer = 456 where NumDep = 2;
update Departamento set CPFGer = 789 where NumDep = 3;

insert into Projeto values ('Proj1', 1, 'Local1', 1);
insert into Projeto values ('Proj2', 2, 'Local2', 2);
insert into Projeto values ('Proj3', 3, 'Local3', 3);

insert into Trabalha_Em values (123, 1, 8);
insert into Trabalha_Em values (456, 2, 8);
insert into Trabalha_Em values (789, 3, 8);

insert into Dependente values (1, 123, 'Dep1', 'M', 'Filho');
insert into Dependente values (2, 123, 'Dep2', 'F', 'Filha');
insert into Dependente values (3, 123, 'Dep3', 'M', 'Irmao');   


SELECT * from Departamento;
SELECT * from Empregado;    
SELECT * from Projeto;
SELECT * from Trabalha_Em;
SELECT * from Dependente;

select NomeProj from Projeto where NomeProj like 'P____';

-- a diff entre aspas simples e duplas as simples pegam String e as duplas são usadas para identificar o nome da tabela, coluna, etc


select e.Nome from Empregado e where e.Nome like 'J%';
select "nome" from Empregado e where "nome" like 'J%';

SELECT e.Nome, e.Salario *1.1 from Empregado e;

-- Da nome a coluna com o novo salario
SELECT e.Nome, e.Salario * 1.1 as NovoSalario from Empregado e;

-- Apenas os nomes sem repetição
SELECT DISTINCT e.Nome, e.CPF from Empregado e, Trabalha_Em t
where e.CPF = t.CPF;




-- UNION
(select DISTINCT NumProj from Projeto p, Departamento d, Empregado e where p.NumDep = d.NumDep and d.CPFGer = e.CPF and e.Nome = 'Joao') 
UNION 
(select p.NumProj from Projeto p, Empregado e, Trabalha_Em t where p.NumProj = t.NumProj and t.CPF = e.CPF and e.Nome = 'Joao');


-- uso do Intersect
select e.Nome from Empregado e
Intersect
select e.Nome from Empregado e, Departamento d 
where d.CPFGer = e.CPF;

-- Ultilizar o is Null

SELECT e.nome from Empregado e where e.CPFSup is null;
SELECT e.nome from Empregado e where e.CPFSup is not null;

-- Funções que já estão nativas 

--Média 
SELECT avg(salario) from Empregado;

--Maximo
SELECT max(salario) from Empregado;

--Minimo
SELECT min(salario) from Empregado;

--Soma
SELECT SUM(salario) from Empregado;


SELECT min(salario) from Empregado;


-- Selecionar o CPF de todos os empregados que trabalham no mesmo
-- projeto e com a mesma quantidade de horas que o empregado cujo
--CPF é 123.

SELECT DISTINCT CPF from trabalha_em 
where (NumProj, HorasSemana) in (select NumProj, HorasSemana from Trabalha_Em where cpf = 123 );

-- Selecionar o nome de todos os empregados que têm salário maior do que
-- todos os salários dos empregados do departamento 2

SELECT e.Nome From Empregado e
where e.Salario > (SELECT max(salario) from Empregado e, Departamento d where d.NumDep = 2 and d.NumDep = e.NumDep);

select nome from Empregado 
where salario > all (select salario from Empregado where NumDep = 2);