
create table atv6.instrutor(

    idInstrutor serial primary key,
    RG int not null,
    nome varchar(45),
    nascimento date,
    titulacao int 

);

create table atv6.telefoneInstrutor(

    idTelefone serial primary key, 
    numero int not null, 
    tipo varchar(45),
    instrutorIdInstrutor int not null,
    foreign key (instrutorIdInstrutor) references atv6.instrutor(idInstrutor)

);


create table atv6.atividade(

    idAtividade serial primary key,
    nome varchar(100) not null

);

create table atv6.turma(

    idTurma serial primary key,
    horario time not null,
    duracao int not null,
    dataInicion date not null,
    dataFim date not null,
    atividadeIdAtividade int not null,
    intrutorIdIntrutor int not null,
    foreign key (atividadeIdAtividade) references atv6.atividade(idAtividade),
    foreign key (intrutorIdIntrutor) references atv6.instrutor(idInstrutor)

);

create table atv6.aluno(

    codMatricula serial primary key,
    turmaIdTurma int not null,
    dataMatricula date not null,
    nome varchar(45) not null,
    endereco text,
    telefone int, 
    dataNascimento date,
    altura float,
    peso int,
    foreign key (turmaIdTurma) references atv6.turma(idTurma)

    
);

create table atv6.chamada(

    idChamada serial primary key,
    data date not null,
    presente BOOLEAN not null,
    matriculaAlunoCodMatricula int not null,
    matriculaTurmaIdTurma int not null,
    foreign key (matriculaAlunoCodMatricula) references atv6.aluno(codMatricula),
    foreign key (matriculaTurmaIdTurma) references atv6.turma(idTurma)

);

INSERT INTO atv6.instrutor (RG, nome, nascimento, titulacao) VALUES
(123456789, 'João Silva', '1980-05-15', 1),
(987654321, 'Maria Oliveira', '1985-10-20', 2),
(456789123, 'Carlos Souza', '1990-03-25', 3)
(111111111, 'Pedro Alves', '1988-12-10', 1),
(222222222, 'Ana Costa', '1992-07-05', 2),
(333333333, 'Lucas Oliveira', '1989-04-20', 3);


INSERT INTO atv6.telefoneInstrutor (numero, tipo, instrutorIdInstrutor) VALUES
(999999999, 'Celular', 1),
(888888888, 'Residencial', 2),
(777777777, 'Celular', 3);

INSERT INTO atv6.atividade (nome) VALUES
('Crossfit'),
('Yoga'),
('Pilates'),
('Musculação');

INSERT INTO atv6.turma (horario, duracao, dataInicion, dataFim, atividadeIdAtividade, intrutorIdIntrutor) VALUES
('08:00:00', 60, '2023-01-01', '2023-12-31', 1, 1), 
('10:00:00', 60, '2023-01-01', '2023-12-31', 2, 2), 
('12:00:00', 60, '2023-01-01', '2023-12-31', 1, 1), 
('14:00:00', 60, '2023-01-01', '2023-12-31', 3, 3);  

INSERT INTO atv6.aluno (turmaIdTurma, dataMatricula, nome, endereco, telefone, dataNascimento, altura, peso) VALUES
(1, '2023-01-10', 'Ana Costa', 'Rua A, 123', 111111111, '2000-05-10', 1.65, 60),
(1, '2023-01-10', 'Pedro Rocha', 'Rua B, 456', 222222222, '1999-08-15', 1.75, 70),
(2, '2023-01-10', 'Luiza Lima', 'Rua C, 789', 333333333, '2001-02-20', 1.60, 55),
(2, '2023-01-10', 'Marcos Santos', 'Rua D, 101', 444444444, '1998-11-25', 1.80, 80),
(3, '2023-01-10', 'Carla Mendes', 'Rua E, 202', 555555555, '2002-07-30', 1.70, 65),
(4, '2023-01-10', 'Fernando Alves', 'Rua F, 303', 666666666, '1997-04-05', 1.85, 90);


INSERT INTO atv6.chamada (data, presente, matriculaAlunoCodMatricula, matriculaTurmaIdTurma) VALUES
('2023-01-15', TRUE, 1, 1),  
('2023-01-15', TRUE, 2, 1), 
('2023-01-15', FALSE, 3, 2), 
('2023-01-15', TRUE, 4, 2), 
('2023-01-15', TRUE, 5, 3),  
('2023-01-15', TRUE, 6, 4);  

--1 . Listar todos os alunos e os nomes das turmas em que estão matriculados.

select atv6.aluno.nome, atv6.turma.idturma, atv6.atividade.nome from atv6.aluno
join atv6.turma on atv6.aluno.turmaIdTurma = atv6.turma.idturma
join atv6.atividade on atv6.atividade.idatividade = atv6.turma.idturma;


-- 2  Contar quantos alunos estão matriculados em cada turma

select count(atv6.aluno.codMatricula), atv6.turma.idTurma, atv6.atividade.nome from atv6.aluno
join atv6.turma on atv6.aluno.turmaIdTurma = atv6.turma.idturma
join atv6.atividade on atv6.atividade.idAtividade = atv6.turma.atividadeIdAtividade
GROUP BY atv6.turma.idturma, atv6.atividade.nome;

-- 3 Mostrar a média de idade dos alunos em cada turma

select avg(JUSTIFY_INTERVAL(atv6.aluno.dataNascimento - now())), atv6.turma.idturma from atv6.aluno join atv6.turma on atv6.turma.idTurma = atv6.aluno.turmaIdTurma
GROUP BY idTurma;

-- 4  Encontrar as turmas com mais de 1 alunos matriculados

select atv6.turma.idTurma from atv6.turma
join atv6.aluno on atv6.aluno.turmaIdTurma = atv6.turma.idTurma
GROUP BY atv6.turma.idturma,atv6.aluno.nome
HAVING count(atv6.aluno.codMatricula) > 1;

-- 5 Exibir os instrutores que orientam turmas e os que ainda não possuem turmas

select atv6.instrutor.nome, COALESCE(atv6.atividade.nome
, 'sem função') from atv6.instrutor
LEFT JOIN atv6.telefoneInstrutor on atv6.instrutor.idInstrutor = atv6.telefoneInstrutor.instrutorIdInstrutor
LEFT JOIN  atv6.turma on atv6.instrutor.idInstrutor = atv6.turma.intrutorIdIntrutor
LEFT JOIN atv6.atividade on atv6.atividade.idAtividade = atv6.turma.atividadeIdAtividade;

-- 6 Encontrar alunos que frequentaram todas as aulas de sua turma

SELECT atv6.aluno.nome, atv6.turma.idturma, atv6.chamada.presente 
FROM atv6.aluno
join atv6.turma on atv6.aluno.turmaidturma = atv6.turma.idturma
join atv6.chamada on atv6.chamada.matriculaturmaidturma = atv6.turma.idturma
GROUP BY atv6.aluno.codMatricula, atv6.aluno.nome, atv6.turma.idturma
where atv6.chamada.presente = TRUE;

HAVING count(case when atv6.chamada.presente = TRUE then end ) = (select count(*) from atv6.chamada where atv6.chamada.matriculaturmaidturma = atv6.turma.idturma);




-- 7 Mostrar os instrutores que ministram turmas de "Crossfit" ou "Yoga"

select atv6.instrutor.nome from atv6.instrutor
join atv6.turma on atv6.turma.intrutoridintrutor = atv6.instrutor.idinstrutor
join atv6.atividade on atv6.atividade.idatividade = atv6.turma.atividadeIdAtividade
where atv6.atividade.nome = 'Crossfit' or atv6.atividade.nome = 'Yoga'; 

-- 8  Listar os alunos que estão matriculados em mais de uma turma

select atv6.aluno.nome from atv6.aluno
join atv6.turma on atv6.aluno.turmaIdTurma = atv6.turma.idTurma
GROUP BY atv6.aluno.codMatricula, atv6.aluno.nome
HAVING count(atv6.turma.idTurma) > 1;

-- 9  Encontrar as turmas que possuem a maior quantidade de alunos

select atv6.turma.idTurma, count(atv6.aluno.codMatricula) from atv6.turma
join atv6.aluno on atv6.aluno.turmaIdTurma = atv6.turma.idTurma
GROUP BY atv6.turma.idTurma
ORDER BY count(atv6.aluno.codMatricula) DESC
limit 1;

-- 10 Listar os alunos que não compareceram a nenhuma aula

SELECT atv6.aluno.nome, atv6.turma.idturma, atv6.chamada.presente 
FROM atv6.aluno
join atv6.turma on atv6.aluno.turmaidturma = atv6.turma.idturma
join atv6.chamada on atv6.chamada.matriculaturmaidturma = atv6.turma.idturma
where atv6.chamada.presente = FALSE;
