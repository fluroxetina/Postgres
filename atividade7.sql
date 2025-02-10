create table atv7.predio(
    idPredio serial primary key,
    numAndares int not null,
    apPorAndar int not null

);

create table atv7.casa(

    idCasa serial primary key,
    numCasa int not null,   
    casasSobrado BOOLEAN

);



create table atv7.pessoa(

    idPessoa serial primary key,
    nome varchar(100) not null,
    cpf varchar(11) not null,
    Endereco varchar(100) not null

);

create table atv7.engenheiro(

    idEngenheiro serial primary key,   
    crea varchar(100) not null,
    pessoaIdPessoa int not null,
    foreign key (pessoaIdPessoa) references atv7.pessoa(idPessoa)

);


create table atv7.unidadeResidencial(

    idUnidade serial primary key,
    numQuartos int not null,
    numBanheiros int not null,
    pessoaIdPessoa int not null,
    foreign key (pessoaIdPessoa) references atv7.pessoa(idPessoa)
);

create table atv7.edificacao(

    idEdificacao serial primary key,
    nomeResponsavel varchar(100) not null,
    Endereco varchar(100) not null,
    Metragem decimal(10,2) not null,
    Unidade varchar(100) not null,
    predioIdPredio int not null,
    casaIdCasa int not null,
    engenheiroIdEngenheiro int not null,
    foreign key (predioIdPredio) references atv7.predio(idPredio),
    foreign key (casaIdCasa) references atv7.casa(idCasa),
    foreign key (engenheiroIdEngenheiro) references atv7.engenheiro(idEngenheiro)

);



INSERT INTO atv7.predio (numAndares, apPorAndar) VALUES
(10, 4),
(15, 6),
(20, 8),
(5, 2);


INSERT INTO atv7.casa (numCasa, casasSobrado) VALUES
(101, TRUE),
(102, FALSE),
(103, TRUE),
(104, FALSE);

INSERT INTO atv7.pessoa (nome, cpf, Endereco) VALUES
('João Silva', '12345678901', 'Rua A, 123'),
('Maria Oliveira', '98765432100', 'Rua B, 456'),
('Carlos Souza', '45678912345', 'Rua C, 789'),
('Ana Costa', '22233344455', 'Rua D, 321');

INSERT INTO atv7.engenheiro (crea, pessoaIdPessoa) VALUES
('CREA12345', 1),
('CREA67890', 2);


INSERT INTO atv7.unidadeResidencial (numQuartos, numBanheiros, pessoaIdPessoa) VALUES
(2, 1, 1),
(3, 2, 2),
(4, 3, 3),
(1, 1, 4);


INSERT INTO atv7.edificacao (nomeResponsavel, Endereco, Metragem, Unidade, predioIdPredio, casaIdCasa, engenheiroIdEngenheiro) VALUES
('João Silva', 'Rua A, 123', 150.50, 'm²', 1, 1, 1),
('Maria Oliveira', 'Rua B, 456', 200.75, 'm²', 2, 2, 2),
('Carlos Souza', 'Rua C, 789', 300.20, 'm²', 3, 3, 1),
('Ana Costa', 'Rua D, 321', 120.30, 'm²', 4, 4, 2);

SELECT ur.idUnidade, p.nome AS proprietario, p.Endereco 
FROM atv7.unidadeResidencial ur
JOIN atv7.pessoa p ON ur.pessoaIdPessoa = p.idPessoa
order by atv7.edificacao.Metragem;

