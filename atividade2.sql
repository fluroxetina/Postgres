create table atividade1.aluno (
    idAluno int not null primary key,
    nomeAluno varchar(50),
    numGrau int

);

Create table atividade1.amigo(

    idAluno1 int not null,
    idAluno2 int not null,
    constraint fkAluno1 foreign key (idAluno1) references atividade1.aluno(idAluno),
    constraint fkAluno2 foreign key (idAluno2) references atividade1.aluno(idAluno)
)

create table atividade1.curtida(

    idAluno1 int not null,
    idAluno2 int not null,
    constraint fkAluno1 foreign key (idAluno1) references atividade1.aluno(idAluno),
    constraint fkAluno2 foreign key (idAluno2) references atividade1.aluno(idAluno)
)


insert into atividade1.aluno values(1, 'Joao', 1);
insert into atividade1.aluno values(2, 'Maria', 2);
insert into atividade1.aluno values(3, 'Pedro', 1);
insert into atividade1.aluno values(4, 'Ana', 2);

insert into atividade1.amigo values(1, 2);
insert into atividade1.amigo values(1, 3);
insert into atividade1.amigo values(2, 4);
insert into atividade1.amigo values(3, 4);

insert into atividade1.curtida values(1, 2);
insert into atividade1.curtida values(1, 3);
insert into atividade1.curtida values(2, 4);
insert into atividade1.curtida values(3, 4);


select * from atividade1.amigo
inner join atividade1.aluno on atividade1.amigo.idAluno1 = atividade1.aluno.idaluno
inner join atividade1.curtida on atividade1.curtida.idAluno1 = atividade1.aluno.idAluno;


SELECT * FROM atividade1.aluno;
SELECT * FROM atividade1.amigo;
SELECT * FROM atividade1.curtida;

