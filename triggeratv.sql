CREATE TABLE Usuarios (
    ID_Usuario INT PRIMARY KEY NOT NULL,
    Password VARCHAR(255),
    Nome_Usuario VARCHAR(255),
    Ramal INT,
    Especialidade VARCHAR(255)
);

CREATE TABLE Maquina (
    Id_Maquina INT PRIMARY KEY NOT NULL,
    Tipo VARCHAR(255),
    Velocidade INT,
    HardDisk INT,
    Placa_Rede INT,
    Memoria_Ram INT,
    Fk_Usuario INT,
    FOREIGN KEY (Fk_Usuario) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Software (
    Id_Software INT PRIMARY KEY NOT NULL,
    Produto VARCHAR(255),
    HardDisk INT,
    Memoria_Ram INT,
    Fk_Maquina INT,
    FOREIGN KEY (Fk_Maquina) REFERENCES Maquina(Id_Maquina)
);

INSERT INTO Usuarios (ID_Usuario, Password, Nome_Usuario, Ramal, Especialidade) VALUES
(1, '123', 'Joao', 123, 'TI'),
(2, '456', 'Maria', 456, 'RH'),
(3, '789', 'Jose', 789, 'Financeiro'),
(4, '101', 'Ana', 101, 'TI');

INSERT INTO Maquina (Id_Maquina, Tipo, Velocidade, HardDisk, Placa_Rede, Memoria_Ram, Fk_Usuario) VALUES
(1, 'Desktop', 2, 500, 1, 4, 1),
(2, 'Notebook', 1, 250, 1, 2, 2),
(3, 'Desktop', 3, 1000, 1, 8, 3),
(4, 'Notebook', 2, 500, 1, 4, 4);

insert into Maquina (Id_Maquina, Tipo, Velocidade, HardDisk, Placa_Rede, Memoria_Ram, Fk_Usuario) VALUES
(5, 'Desktop', 2, 500, 1, 4, 1),
(6, 'Notebook', 1, 250, 1, 2, 2),
(7, 'Desktop', 3, 1000, 1, 8, 3),
(8, 'Notebook', 2, 500, 1, 4, 4);

INSERT INTO Software (Id_Software, Produto, HardDisk, Memoria_Ram, Fk_Maquina) VALUES
(1, 'Windows', 100, 2, 1),
(2, 'Linux', 50, 1, 2),
(3, 'Windows', 200, 4, 3),
(4, 'Linux', 100, 2, 4);

create table Registro_Auditoria (
    idResgistro serial not null primary key,
    idMaquina int not null

);

-- 1. Criar um Trigger para Auditoria de Exclusão de Máquinas: Criar um trigger que
-- registre quando um registro da tabela Maquina for excluído.
create or replace function ResgistrarExclusaoMaquina() returns trigger as $$
begin
    insert into Registro_Auditoria (idMaquina) values (old.Id_Maquina);
    return old;
end;
$$ language plpgsql;

create trigger RegistrarExclusao 
after delete on Maquina 
for each row
execute function ResgistrarExclusaoMaquina();

delete from Maquina where Id_Maquina = 7;

select * from registro_auditoria;

-- 2. Criar um Trigger para Evitar Senhas Fracas: Criar um BEFORE INSERT trigger para
-- impedir que um usuario seja cadastrado com uma senha menor que 6 caracteres.

create or replace function VerificarSenha() returns trigger as $$
begin 
    if length(new.Password) < 6 then 
        raise exception 'Senha fraca';
    end if;
end;
$$ language plpgsql;


create trigger VerificarSenhaTrigger
before insert on Usuarios
for each row
execute function VerificarSenha();

insert into Usuarios (ID_Usuario, Password, Nome_Usuario, Ramal, Especialidade) values
(5, '123', 'Joao', 123, 'TI');

-- 3. Criar um Trigger para Atualizar Contagem de Softwares em Cada Máquina: Criar um
-- AFTER INSERT trigger que atualiza uma tabela auxiliar Maquina Software_Count que
-- armazena a quantidade de softwares instalados em cada máquina.

create or replace function 

-- 4. Criar um Trigger para Evitar Remoção de Usuários do Setor de TI: Objetivo: Impedir a
-- remoção de usuários cuja Especialidade seja 'TI.



-- 5. Criar um Trigger para Calcular o Uso Total de Memória por Máquina: Criar um AFTER
-- INSERT e AFTER DELETE trigger que calcula a quantidade total de memória RAM ocupada
-- pelos softwares em cada máquina.



-- 6. Criar um Trigger para Registrar Alterações de Especialidade em Usuários: Criar um
-- trigger que registre as mudanças de especialidade dos usuários na tabela Usuarios.



-- 7. Criar um Trigger para Impedir Exclusão de Softwares Essenciais Criar um BEFORE
-- DELETE trigger que impeça a exclusão de softwares considerados essenciais (ex:
-- Windows).