create table diretor (

    idDiretor serial primary key,
    Nome varchar(50) not null
  
);

create table genero (   

    idGenero serial primary key,
    Nome varchar(50) not null

);

create table filme (

    id serial primary key,
    NomeBR varchar(50) not null,
    NomeEN varchar(50),
    anoLancamento int not null,
    diretorIdDirector int not null,
    sinopse varchar(500),
    generoIdGenero int not null,
    foreign key (diretorIdDirector) references diretor(idDiretor),
    foreign key (generoIdGenero) references genero(idGenero)

);


create table premiacao(

    idPremiacao serial primary key,
    NomePremiacao varchar(50) not null,
    ano int not null   

);

create table sala (

    idSala serial primary key,
    NomeSala varchar(50) not null,
    capacidade int not null

);

create table horario (

    idHorario serial primary key,   
    horario time not null

);

create table filmeHasPremiacao(

    filmeId int not null,
    premiacaoIdPremiacao int not null,
    Ganhou BOOLEAN not null,
    foreign key (filmeId) references filme(id),
    foreign key (premiacaoIdPremiacao) references premiacao(idPremiacao)
);



create table filmeExibidoSala(
    
    filmeIdFilme int not null,
    salaIdSala int not null,
    horarioIdHorario int not null,
    foreign key (filmeIdFilme) references filme(id),
    foreign key (salaIdSala) references sala(idSala),
    foreign key (horarioIdHorario) references horario(idHorario)

);


create table funcao(
    idFuncao serial primary key,
    NomeFuncao varchar(50) not null

);

create table funcionario(
    idFuncionario serial primary key,
    NomeFuncionario varchar(50) not null,
    carteiraTrabalho int not null,
    dataContratacao date not null,
    salario decimal(10,2) not null

);

create table horarioTrabalhoFuncionario(
    horarioIdHorario int not null,
    funcionarioIdFuncionario int not null,
    funcaoIdFuncao int not null,
    foreign key (horarioIdHorario) references horario(idHorario),
    foreign key (funcionarioIdFuncionario) references funcionario(idFuncionario),
    foreign key (funcaoIdFuncao) references funcao(idFuncao)
);

INSERT INTO diretor (Nome) VALUES
('Christopher Nolan'),
('Quentin Tarantino'),
('Steven Spielberg'),
('Greta Gerwig'),
('Martin Scorsese');

INSERT INTO genero (Nome) VALUES
('Ação'),
('Drama'),
('Comédia'),
('Ficção Científica'),
('Suspense');

INSERT INTO filme (NomeBR, NomeEN, anoLancamento, diretorIdDirector, sinopse, generoIdGenero) VALUES
('Interestelar', 'Interstellar', 2014, 1, 'Um grupo de exploradores viaja através de um buraco de minhoca no espaço.', 4),
('Pulp Fiction', 'Pulp Fiction', 1994, 2, 'As vidas de dois assassinos da máfia, um boxeador e um casal se entrelaçam.', 5),
('O Resgate do Soldado Ryan', 'Saving Private Ryan', 1998, 3, 'Durante a invasão da Normandia, um grupo de soldados parte em missão para resgatar um soldado.', 2),
('Lady Bird', 'Lady Bird', 2017, 4, 'Uma jovem navega pelos desafios do último ano do ensino médio.', 3),
('O Irlandês', 'The Irishman', 2019, 5, 'Um veterano da Segunda Guerra Mundial relembra sua vida como assassino da máfia.', 2);

INSERT INTO premiacao (NomePremiacao, ano) VALUES
('Oscar', 2020),
('Globo de Ouro', 2019),
('BAFTA', 2018),
('Cannes', 2017),
('Sundance', 2016);

INSERT INTO sala (NomeSala, capacidade) VALUES
('Sala 1', 100),
('Sala 2', 150),
('Sala 3', 200),
('Sala 4', 120),
('Sala 5', 180);

INSERT INTO horario (horario) VALUES
('10:00:00'),
('13:00:00'),
('16:00:00'),
('19:00:00'),
('22:00:00');

INSERT INTO filmeHasPremiacao (filmeId, premiacaoIdPremiacao, Ganhou) VALUES
(1, 1, TRUE),
(2, 2, TRUE),
(3, 3, FALSE),
(4, 4, TRUE),
(5, 5, FALSE);

INSERT INTO filmeExibidoSala (filmeIdFilme, salaIdSala, horarioIdHorario) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

INSERT INTO funcao (NomeFuncao) VALUES
('Gerente'),
('Atendente'),
('Projecionista'),
('Limpeza'),
('Segurança');

INSERT INTO funcionario (NomeFuncionario, carteiraTrabalho, dataContratacao, salario) VALUES
('João Silva', 123456, '2020-01-15', 3000.00),
('Maria Oliveira', 654321, '2019-05-20', 2500.00),
('Carlos Souza', 987654, '2021-03-10', 2800.00),
('Ana Costa', 456789, '2018-07-01', 3200.00),
('Pedro Rocha', 321654, '2022-02-25', 2700.00);

INSERT INTO horarioTrabalhoFuncionario (horarioIdHorario, funcionarioIdFuncionario, funcaoIdFuncao) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(1, 5, 3),
(1, 5, 2);

-- 1 Retornar a média dos salários dos funcionários.

select avg(salario) from funcionario;

create view mediaSalario as
select avg(salario) from funcionario;

-- chamar a view

select * from mediaSalario;

-- 2 Listar os funcionários e suas funções, incluindo aqueles sem função definida.

SELECT f.NomeFuncionario, fu.NomeFuncao
from funcionario f, funcao fu, horarioTrabalhoFuncionario h
where h.funcionarioIdFuncionario = f.idfuncionario and h.funcaoIdFuncao = fu.idfuncao;

--coalesce funciona como se fosse um if ternario no sql 
select f.NomeFuncionario as funcionario,COALESCE(func.nomefuncao, 'Sem Função') as funcao from funcionario f
left join funcao func on f.idfuncionario = func.idfuncao;

-- 3 Retornar o nome de todos os funcionários que possuem o mesmo horário de trabalho que algum outro funcionário.

select distinct f1.NomeFuncionario as funcionario, f2.NomeFuncionario as funcionario2, h horario from horarioTrabalhoFuncionario ht1
join horarioTrabalhoFuncionario ht2 on ht1.horarioIdHorario = ht2.horarioIdHorario and 
ht1.funcionarioIdFuncionario <> ht2.funcionarioIdFuncionario
join funcionario f1 on ht1.funcionarioIdFuncionario = f1.idfuncionario
join funcionario f2 on ht2.funcionarioIdFuncionario = f2.idfuncionario
join horario h on ht1.horarioIdHorario = h.idHorario;

SELECT DISTINCT
    f1.NomeFuncionario AS funcionario,
    f2.NomeFuncionario AS funcionario2,
    h.horario
FROM horarioTrabalhoFuncionario ht1
JOIN horarioTrabalhoFuncionario ht2 ON ht1.horarioIdHorario = ht2.horarioIdHorario
    AND ht1.funcionarioIdFuncionario <> ht2.funcionarioIdFuncionario
JOIN funcionario f1 ON ht1.funcionarioIdFuncionario = f1.idFuncionario
JOIN funcionario f2 ON ht2.funcionarioIdFuncionario = f2.idFuncionario
JOIN horario h ON ht1.horarioIdHorario = h.idHorario;



-- 4 Encontrar filmes que foram exibidos em pelo menos duas salas diferentes.

select f.NomeBR from filme f, filmeExibidoSala fes
where f.id = fes.filmeIdFilme and fes.salaIdSala != fes.salaIdSala;

SELECT f.NomeBR AS NomeFilme
FROM filme f
JOIN filmeExibidoSala fes ON f.id = fes.filmeIdFilme
GROUP BY f.id, f.NomeBR
HAVING COUNT(DISTINCT fes.salaIdSala) >= 2;

-- 5 Listar os filmes e seus respectivos gêneros, garantindo que não haja duplicatas.
SELECT DISTINCT f.NomeBR, g.Nome from filme f
join genero g on f.generoIdGenero = g.idGenero;

-- 6 Encontrar os filmes que receberam prêmios e que tiveram exibição em pelo menos uma sala.
SELECT f.NomeBR, p.NomePremiacao from filme f, filmeHasPremiacao fh, premiacao p, 
filmeExibidoSala fes
where f.id = fh.filmeId and f.id = fes.filmeIdFilme and fh.Ganhou = TRUE;

-- 7 Listar os filmes que não receberam nenhum prêmio.
select f.NomeBR from filme f, filmeHasPremiacao fh
where fh.Ganhou = FALSE and f.id = fh.filmeId;

-- 8 Exibir os diretores que dirigiram pelo menos dois filmes.
SELECT d.Nome from diretor d 
join filme f on d.idDiretor = f.diretorIdDirector
group by d.idDiretor, d.Nome
having count( DISTINCT f.id ) >= 2;

-- 9 Listar os funcionários e os horários que trabalham, ordenados pelo horário mais cedo.
SELECT f.NomeFuncionario, h.horario from funcionario f, horarioTrabalhoFuncionario htf, horario h
where h.idhorario = htf.horarioIdHorario and htf.funcionarioIdFuncionario = f.idfuncionario
ORDER BY h.horario ASC; 

-- 10 Listar os filmes que foram exibidos na mesma sala em horários diferentes.

select f.NomeBr from filme f, filmeExibidoSala fes
where f.id = fes.filmeIdFilme
group by f.id, f.NomeBr
having count( DISTINCT fes.salaIdSala ) >= 2;

SELECT f.NomeBR AS NomeFilme, s.NomeSala, COUNT(DISTINCT h.horario) AS TotalHorarios
FROM filme f
JOIN filmeExibidoSala fes ON f.id = fes.filmeIdFilme
JOIN sala s ON fes.salaIdSala = s.idSala
JOIN horario h ON fes.horarioIdHorario = h.idHorario
GROUP BY f.id, f.NomeBR, s.idSala, s.NomeSala
HAVING COUNT(DISTINCT h.horario) > 1;

-- 11 Unir os diretores e os funcionarios em uma única lista de pessoas.

select d.Nome from diretor d  union select f.NomeFuncionario from funcionario f ;

-- 12 Exibir todas as funções diferentes que os funcionários exercem e a quantidade de funcionários em cada uma.


SELECT fu.NomeFuncao, COUNT(DISTINCT f.idFuncionario) AS QuantidadeFuncionarios
FROM funcao fu
JOIN horarioTrabalhoFuncionario htf ON fu.idFuncao = htf.funcaoIdFuncao
JOIN funcionario f ON htf.funcionarioIdFuncionario = f.idFuncionario
GROUP BY fu.idFuncao, fu.NomeFuncao;

-- 13 Encontrar os filmes que foram exibidos em salas com capacidade superior à média de todas as salas.

select f.NomeBR, s.capacidade from filme f 
join filmeExibidoSala fe on f.id = fe.filmeidfilme
join sala s on s.idsala = fe.salaidsala
where s.capacidade > (select avg(s.capacidade) from sala s);

-- 14 Calcular o salário anual dos funcionários (considerando 12 meses).

select f.NomeFuncionario, f.Salario * 12 from funcionario f;

--15. Exibir a relação entre a capacidade da sala e o número total de filmes exibidos nela.

SELECT s.NomeSala, s.capacidade, COUNT(fes.filmeIdFilme) AS TotalFilmesExibidos, STRING_AGG(f.NomeBR, ', ') AS FilmesExibidos
FROM sala s
LEFT JOIN filmeExibidoSala fes ON s.idSala = fes.salaIdSala
LEFT JOIN filme f ON fes.filmeIdFilme = f.id
GROUP BY s.idSala, s.NomeSala, s.capacidade
ORDER BY s.capacidade DESC;

create view Salaa1 as  
SELECT s.NomeSala, s.capacidade, COUNT(fes.filmeIdFilme) AS TotalFilmesExibidos, STRING_AGG(f.NomeBR, ', ') AS FilmesExibidos
FROM sala s
LEFT JOIN filmeExibidoSala fes ON s.idSala = fes.salaIdSala
LEFT JOIN filme f ON fes.filmeIdFilme = f.id
GROUP BY s.idSala, s.NomeSala, s.capacidade
ORDER BY s.capacidade DESC;


select * from Salaa1;

drop view Salaa1;
                                                                                  