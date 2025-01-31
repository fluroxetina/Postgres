create table atividade2.Maquinas(
    IdMaquina int not null primary key,
    TipoMaquina varchar(50) not null ,
    Velocidade decimal(10,2) not null,
    HardDisk varchar(50) not null,
    PlacaRede varchar(50) not null,
    Ram varchar(50) not null

);

create table atividade2.Usuario(
    IdUsuario int not null primary key,
    NomeUsuario varchar(50) not null,
    Senha varchar(50) not null,
    Ramal varchar(50) not null,
    Especialidades varchar(50) not null

);

create table atividade2.Software(

    IdSoftware int not null primary key,
    Produto varchar(50) not null,
    HardDisk varchar(50) not null,
    MemoriaRam varchar(50) not null

);

create table atividade2.Possuem(
    IdUsuario int not null,
    IdMaquina int not null,
    constraint fkMaquina foreign key (IdMaquina) references atividade2.Maquinas(IdMaquina),
    constraint fkUsuario foreign key (IdUsuario) references atividade2.Usuario(IdUsuario)
);

create table atividade2.Contem(

    IdMaquina int not null,
    IdSoftware int not null,
    constraint fkMaquina2 foreign key (IdMaquina) references atividade2.Maquinas(IdMaquina),
    constraint fkSoftware2 foreign key (IdSoftware) references atividade2.Software(IdSoftware)

);




INSERT INTO atividade2.Maquinas (IdMaquina, TipoMaquina, Velocidade, HardDisk, PlacaRede, Ram) 
VALUES (6, 'Core II', 2.5, '500 GB', 'Intel', '8 GB'),
        (7, 'Pentium', 3.5, '1 TB', 'Intel', '16 GB');



INSERT INTO atividade2.Usuario (IdUsuario, NomeUsuario, Senha, Ramal, Especialidades) 
VALUES (1, 'João Silva', 'senha123', '1234', 'Desenvolvedor'),
        (2, 'Maria Oliveira', 'abc456', '5678', 'Analista de Sistemas'),
        (3, 'Carlos Souza', 'xyz789', '9101', 'Gerente de TI'),
        (4, 'Ana Costa', 'qwe321', '1121', 'Suporte Técnico'),
        (5, 'Pedro Rocha', 'rty654', '3141', 'DBA'),
        (6, 'KauaGueixo', '123456', '1234', 'Técnico');

INSERT INTO atividade2.Software (IdSoftware, Produto, HardDisk, MemoriaRam) 
VALUES (1, 'Windows 10', '20 GB', '4 GB'),
        (2, 'Linux Ubuntu', '10 GB', '2 GB'),
        (3, 'Microsoft Office', '5 GB', '4 GB'),
        (4, 'Visual Studio Code', '500 MB', '2 GB'),
        (5, 'MySQL', '1 GB', '1 GB'),
        (6, 'C++', '500 GB', '8 GB');


INSERT INTO atividade2.Possuem (IdUsuario, IdMaquina) 
VALUES (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5);


INSERT INTO atividade2.Contem (IdMaquina, IdSoftware) 
VALUES (1, 1),
        (1, 3),
        (2, 2),
        (3, 4),
        (4, 5),
        (5, 5);




select * from atividade2.Usuario where Especialidades like '%Técnico%';

SELECT DISTINCT TipoMaquina,Velocidade from atividade2.Maquinas ORDER BY TipoMaquina, Velocidade;

SELECT * from atividade2.Maquinas; 


SELECT DISTINCT TipoMaquina,Velocidade from atividade2.Maquinas where TipoMaquina = 'Core II' or TipoMaquina = 'Pentium' ;

SELECT DISTINCT IdMaquina, TipoMaquina, PlacaRede 
from atividade2.Maquinas 
WHERE CAST(HardDisk AS INT) < 10;

SELECT atividade2.Maquinas.TipoMaquina, atividade2.Usuario.NomeUsuario from atividade2.Possuem 
inner JOIN atividade2.Usuario on atividade2.Usuario.IdUSuario = atividade2.Possuem.IdUsuario
inner JOIN atividade2.Maquinas on atividade2.Maquinas.IdMaquina = atividade2.Possuem.IdMaquina 
where atividade2.Maquinas.TipoMaquina = 'Desktop';


SELECT IdSoftware from atividade2.Software where Produto = 'C++';


SELECT Ram, Produto, MemoriaRam
from atividade2.Contem
INNER JOIN atividade2.Maquinas on atividade2.Maquinas.IdMaquina = atividade2.Contem.IdMaquina
INNER JOIN atividade2.Software on atividade2.Software.IdSoftware = atividade2.Contem.IdSoftware;

SELECT NomeUsuario, Velocidade
from atividade2.Possuem
INNER JOIN atividade2.Maquinas on atividade2.Maquinas.IdMaquina = atividade2.Possuem.IdMaquina
inner join atividade2.Usuario on atividade2.Usuario.IdUsuario = atividade2.Possuem.IdUsuario

select idUsuario, NomeUsuario from atividade2.Usuario where idUsuario < 3;

SELECT count(atividade2.Maquinas.IdMaquina) from atividade2.Maquinas
where atividade2.Maquinas.Velocidade > 2.5;


SELECT c.nome, u.nome, count(c.id) from usuario u, cargo c 
where u.id = c.FkUsuario  GROUP BY c.nome, u.id;

SELECT NomeUsuario, count(atividade2.Maquinas.IdMaquina) from atividade2.Possuem
inner join atividade2.Maquinas on atividade2.Maquinas.IdMaquina = atividade2.Possuem.IdMaquina
inner join atividade2.Usuario on atividade2.Usuario.IdUsuario = atividade2.Possuem.IdUsuario
GROUP BY atividade2.Usuario.IdUsuario;

SELECT 
    M.TipoMaquina AS TipoMaquina,
    COUNT(U.IdUsuario) AS TotalUsuarios
FROM 
    atividade2.Maquinas M
LEFT JOIN 
    atividade2.Possuem P ON M.IdMaquina = P.IdMaquina
LEFT JOIN 
    atividade2.Usuario U ON P.IdUsuario = U.IdUsuario
GROUP BY 
    M.TipoMaquina;


SELECT TipoMaquina, count(atividade2.Maquinas.IdMaquina)
from atividade2.Maquinas
join atividade2.Possuem on atividade2.Possuem.IdMaquina = atividade2.Maquinas.IdMaquina
join atividade2.Usuario on atividade2.Usuario.IdUsuario = atividade2.Possuem.IdUsuario
where TipoMaquina = 'Desktop'
GROUP BY atividade2.Maquinas.IdMaquina;

SELECT SUM(CAST(REPLACE(HardDisk, ' GB', '') AS NUMERIC)) AS DiscoNecessario
FROM atividade2.Software
WHERE Produto IN ('Microsoft Office', 'C++');



SELECT AVG(CAST(REPLACE(Software.Hard_Disk, ' MB', '') AS INT)) AS Media_Hard_Disk FROM Software;

SELECT avg(cast(REPLACE(atividade2.Software.HardDisk, ' GB', '') AS NUMERIC)) from atividade2.Software;

SELECT TipoMaquina, count(atividade2.Maquinas.IdMaquina) from atividade2.Maquinas
group by TipoMaquina;


seke