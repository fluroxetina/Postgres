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

create table MaquinaSoftwareCount(
    Id_MaquinaSoftware serial not null primary key,
    NumMaquinaSoft int,
    MaquinaIdMaquina int not null,
    SoftwareIdSoftware int not null,
    foreign key (MaquinaIdMaquina) references Maquina(Id_Maquina),
    foreign key (SoftwareIdSoftware) references Software(Id_Software)
);


create or replace function ContarSoftwares() returns trigger as $$
declare 
    numSoftwares int;
begin 
    select count(*) + 1 into numSoftwares from software where Fk_Maquina = NEW.Fk_Maquina;

    insert into MaquinaSoftwareCount(NumMaquinaSoft, MaquinaIdMaquina, SoftwareIdSoftware)
    values (numSoftwares,  NEW.Fk_Maquina, NEW.Id_Software);
    return new;
end;
$$ language plpgsql;

create trigger CountSoftwares
after insert on Software
for each row 
execute function ContarSoftwares();

insert into Software (Id_Software, Produto, HardDisk, Memoria_Ram, Fk_Maquina) values
(9, 'Windows', 100, 2, 1),
(10, 'Linux', 50, 1, 2),
(11, 'Windows', 200, 4, 3),
(12, 'Linux', 100, 2, 4);


SELECT * from MaquinaSoftwareCount;

-- 4. Criar um Trigger para Evitar Remoção de Usuários do Setor de TI: Objetivo: Impedir a
-- remoção de usuários cuja Especialidade seja 'TI.

create or replace function ImpedirRemocao() returns trigger as $$
BEGIN
    if old.Especialidade = 'TI' THEN
        raise exception 'Usuário TI não pode ser removido';
    end if;
    return old;
END;
$$ language plpgsql;

create trigger ImperdirRemocaoTrigger
before delete on Usuarios
for each row 
execute function ImpedirRemocao();

delete from usuarios where Especialidade = 'TI';

select * from usuarios;


-- 5. Criar um Trigger para Calcular o Uso Total de Memória por Máquina: Criar um AFTER
-- INSERT e AFTER DELETE trigger que calcula a quantidade total de memória RAM ocupada
-- pelos softwares em cada máquina.

create table maquina_uso_memoria(
    id_maquina_uso_memoria serial not null primary key,
    uso_memoria int,
    id_maquina int not null,
    foreign key (id_maquina) references Maquina(Id_Maquina)
);


CREATE OR REPLACE FUNCTION CalcularUsoMemoria() 
RETURNS TRIGGER AS $$
DECLARE
    maquina_id INT;
    total_memoria INT;
BEGIN
    -- Determinar qual máquina foi afetada
    maquina_id := COALESCE(NEW.Fk_Maquina, OLD.Fk_Maquina);

    -- Calcular o total de memória utilizada pelos softwares da máquina
    SELECT COALESCE(SUM(Memoria_Ram), 0) INTO total_memoria
    FROM Software 
    WHERE Fk_Maquina = maquina_id;

    -- Atualizar a tabela Maquina
    UPDATE Maquina
    SET Memoria_Ram = total_memoria
    WHERE Id_Maquina = maquina_id;

    -- Inserir o novo uso de memória na tabela maquina_uso_memoria
    INSERT INTO maquina_uso_memoria (uso_memoria, id_maquina)
    VALUES (total_memoria, maquina_id);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER AtualizarMemoriaRam
AFTER INSERT OR DELETE OR UPDATE ON Software 
FOR EACH ROW 
EXECUTE FUNCTION CalcularUsoMemoria();

insert into Software (Id_Software, Produto, HardDisk, Memoria_Ram, Fk_Maquina) values
(14, 'Windows', 100, 2, 4);

SELECT * FROM maquina_uso_memoria;

-- 6. Criar um Trigger para Registrar Alterações de Especialidade em Usuários: Criar um
-- trigger que registre as mudanças de especialidade dos usuários na tabela Usuarios.

create table CargoAlterado(
    id_cargo_alterado serial not null primary key,
    cargo_anterior varchar(50),
    cargo_atual varchar(50),
    id_usuario int not null,
    foreign key (id_usuario) references Usuarios(Id_Usuario)
);

select * from CargoAlterado;

create or replace function RegistrarAlteracoes() returns trigger as $$
BEGIN
    insert into CargoAlterado(cargo_anterior, cargo_atual, id_usuario)
    values(old.Especialidade, new.Especialidade, old.ID_Usuario);
    return new;
END;
$$ language plpgsql;

create trigger RegistrarAlteracoesTrigger
after update on Usuarios
for each row 
execute function RegistrarAlteracoes();

update Usuarios set especialidade = 'Gueixo' where id_usuario = 1;

-- 7. Criar um Trigger para Impedir Exclusão de Softwares Essenciais Criar um BEFORE
-- DELETE trigger que impeça a exclusão de softwares considerados essenciais (ex:
-- Windows).

create or replace function ImpedirExclusaoSoftware() returns trigger as $$
BEGIN
    if old.Produto = 'Windows' or old.Produto = 'Linux' THEN
        raise exception 'Software essencial não pode ser excluído';
    end if;
    return old;
END;
$$ language plpgsql;

create trigger ImperdirExclusaoSoftwareTrigger
before delete on Software
for each row 
execute function ImpedirExclusaoSoftware();

delete from software where Produto = 'Windows' or Produto = 'Linux';

