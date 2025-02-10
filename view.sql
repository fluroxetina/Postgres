
create table view.instrutor(

    idInstrutor serial primary key,
    RG int not null,
    nome varchar(45),
    nascimento date,
    titulacao int 

);

create table view.telefoneInstrutor(

    idTelefone serial primary key, 
    numero int not null, 
    tipo varchar(45),
    instrutorIdInstrutor int not null,
    foreign key (instrutorIdInstrutor) references view.instrutor(idInstrutor)

);


create table view.atividade(

    idAtividade serial primary key,
    nome varchar(100) not null

);

create table view.turma(

    idTurma serial primary key,
    horario time not null,
    duracao int not null,
    dataInicion date not null,
    dataFim date not null,
    atividadeIdAtividade int not null,
    intrutorIdIntrutor int not null,
    foreign key (atividadeIdAtividade) references view.atividade(idAtividade),
    foreign key (intrutorIdIntrutor) references view.instrutor(idInstrutor)

);

create table view.aluno(

    codMatricula serial primary key,
    turmaIdTurma int not null,
    dataMatricula date not null,
    nome varchar(45) not null,
    endereco text,
    telefone int, 
    dataNascimento date,
    altura float,
    peso int,
    foreign key (turmaIdTurma) references view.turma(idTurma)

    
);

create table view.chamada(

    idChamada serial primary key,
    data date not null,
    presente BOOLEAN not null,
    matriculaAlunoCodMatricula int not null,
    matriculaTurmaIdTurma int not null,
    foreign key (matriculaAlunoCodMatricula) references view.aluno(codMatricula),
    foreign key (matriculaTurmaIdTurma) references view.turma(idTurma)

);

INSERT INTO view.instrutor (RG, nome, nascimento, titulacao) VALUES
(123456789, 'João Silva', '1980-05-15', 1),
(987654321, 'Maria Oliveira', '1985-10-20', 2),
(456789123, 'Carlos Souza', '1990-03-25', 3),
(111111111, 'Pedro Alves', '1988-12-10', 1),
(222222222, 'Ana Costa', '1992-07-05', 2);



INSERT INTO view.telefoneInstrutor (numero, tipo, instrutorIdInstrutor) VALUES
(999999999, 'Celular', 1),
(888888888, 'Residencial', 2),
(777777777, 'Celular', 3);

INSERT INTO view.atividade (nome) VALUES
('Crossfit'),
('Yoga'),
('Pilates'),
('Musculação');

INSERT INTO view.turma (horario, duracao, dataInicion, dataFim, atividadeIdAtividade, intrutorIdIntrutor) VALUES
('08:00:00', 60, '2023-01-01', '2023-12-31', 1, 1), 
('10:00:00', 60, '2023-01-01', '2023-12-31', 2, 2), 
('12:00:00', 60, '2023-01-01', '2023-12-31', 1, 1), 
('14:00:00', 60, '2023-01-01', '2023-12-31', 3, 3);  

INSERT INTO view.aluno (turmaIdTurma, dataMatricula, nome, endereco, telefone, dataNascimento, altura, peso) VALUES
(1, '2023-01-10', 'Ana Costa', 'Rua A, 123', 111111111, '2000-05-10', 1.65, 60),
(1, '2023-01-10', 'Pedro Rocha', 'Rua B, 456', 222222222, '1999-08-15', 1.75, 70),
(2, '2023-01-10', 'Luiza Lima', 'Rua C, 789', 333333333, '2001-02-20', 1.60, 55),
(2, '2023-01-10', 'Marcos Santos', 'Rua D, 101', 444444444, '1998-11-25', 1.80, 80),
(3, '2023-01-10', 'Carla Mendes', 'Rua E, 202', 555555555, '2002-07-30', 1.70, 65),
(4, '2023-01-10', 'Fernando Alves', 'Rua F, 303', 666666666, '1997-04-05', 1.85, 90);


INSERT INTO view.chamada (data, presente, matriculaAlunoCodMatricula, matriculaTurmaIdTurma) VALUES
('2023-01-15', TRUE, 1, 1),  
('2023-01-15', TRUE, 2, 1), 
('2023-01-15', FALSE, 3, 2), 
('2023-01-15', TRUE, 4, 2), 
('2023-01-15', TRUE, 5, 3),  
('2023-01-15', TRUE, 6, 4);  


-- or replace é quando crio uma nova view ou substitui a view existente
create or replace view view.AlunoTurma as
select view.aluno.nome from view.aluno
join view.turma on view.aluno.turmaIdTurma = view.turma.idTurma
GROUP BY view.aluno.codMatricula, view.aluno.nome
HAVING count(view.turma.idTurma) > 1;

select * from view.alunoturma;
select aluno from view.alunoturma;

drop view view.AlunoTurma;

-- editar uma view
create or replace view view.AlunoTurma as
select view.aluno.nome from view.aluno
join view.turma on view.aluno.turmaIdTurma = view.turma.idTurma
GROUP BY view.aluno.codMatricula, view.aluno.nome
HAVING count(view.turma.idTurma) > 2;


create view view.MaiorTurma as 
select atv6.turma.idTurma, count(atv6.aluno.codMatricula) from atv6.turma
join atv6.aluno on atv6.aluno.turmaIdTurma = atv6.turma.idTurma
GROUP BY atv6.turma.idTurma
ORDER BY count(atv6.aluno.codMatricula) DESC
limit 1;

SELECT * from view.MaiorTurma;

-- viwes materializadas
-- views materializadas sao views que permanecem atualizadas mesmo quando a base de dados for alterada


create materialized view view.MediaIdadeTurma as
select avg(JUSTIFY_INTERVAL(atv6.aluno.dataNascimento - now())), atv6.turma.idturma from atv6.aluno join atv6.turma on atv6.turma.idTurma = atv6.aluno.turmaIdTurma
GROUP BY idTurma;

--simular view em MySQl

-- create table mvTotalPresencass(
--     aluno varchar(200),
--     idade numeric

-- );

-- insert into mvTotalPresencass
-- select avg(JUSTIFY_INTERVAL(atv6.aluno.dataNascimento - now())), atv6.turma.idturma from atv6.aluno join atv6.turma on atv6.turma.idTurma = atv6.aluno.turmaIdTurma
-- GROUP BY idTurma;