CREATE TABLE pcdatv.Usuarios (
    ID_Usuario INT PRIMARY KEY NOT NULL,
    Password VARCHAR(255),
    Nome_Usuario VARCHAR(255),
    Ramal INT,
    Especialidade VARCHAR(255)
);

CREATE TABLE pcdatv.Maquina (
    Id_Maquina INT PRIMARY KEY NOT NULL,
    Tipo VARCHAR(255),
    Velocidade INT,
    HardDisk INT,
    Placa_Rede INT,
    Memoria_Ram INT,
    Fk_Usuario INT,
    FOREIGN KEY (Fk_Usuario) REFERENCES pcdatv.Usuarios(ID_Usuario)
);

CREATE TABLE pcdatv.Software (
    Id_Software INT PRIMARY KEY NOT NULL,
    Produto VARCHAR(255),
    HardDisk INT,
    Memoria_Ram INT,
    Fk_Maquina INT,
    FOREIGN KEY (Fk_Maquina) REFERENCES pcdatv.Maquina(Id_Maquina)
);

INSERT INTO pcdatv.Usuarios (ID_Usuario, Password, Nome_Usuario, Ramal, Especialidade) VALUES
(1, '123', 'Joao', 123, 'TI'),
(2, '456', 'Maria', 456, 'RH'),
(3, '789', 'Jose', 789, 'Financeiro'),
(4, '101', 'Ana', 101, 'TI');

INSERT INTO pcdatv.Maquina (Id_Maquina, Tipo, Velocidade, HardDisk, Placa_Rede, Memoria_Ram, Fk_Usuario) VALUES
(1, 'Desktop', 2, 500, 1, 4, 1),
(2, 'Notebook', 1, 250, 1, 2, 2),
(3, 'Desktop', 3, 1000, 1, 8, 3),
(4, 'Notebook', 2, 500, 1, 4, 4);

INSERT INTO pcdatv.Software (Id_Software, Produto, HardDisk, Memoria_Ram, Fk_Maquina) VALUES
(1, 'Windows', 100, 2, 1),
(2, 'Linux', 50, 1, 2),
(3, 'Windows', 200, 4, 3),
(4, 'Linux', 100, 2, 4);




-- 1. Crie uma função chamada Espaco_Disponivel que recebe o ID da máquina e
-- retorna TRUE se houver espaço suficiente para instalar um software.
 
 create or replace function pcdatv.Espaco_Disponivel(idMquina int, idSoftware int) returns BOOLEAN 
 as $$ 
 declare
    vHardDiskMaquina int;
    vHardDiskSoftware int;
begin
    select HardDisk into vHardDiskMaquina from pcdatv.maquina WHERE id_maquina = idMquina;
    select HardDisk into vHardDiskSoftware from pcdatv.software WHERE id_software = idSoftware;

    if vHardDiskMaquina >= vHardDiskSoftware then 
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

select Espaco_Disponivel(1, 1);

-- 2. Crie uma procedure Instalar_Software que so instala um software se houver
-- espaço disponivel.

create or replace PROCEDURE pcdatv.IntalarSoftware(idMaquina int, idSoftware int) as $$
DECLARE
    vHardDiskMaquina int; 
    vHardDiskSoftware int;
begin 
    select HardDisk into vHardDiskMaquina from pcdatv.Maquina where id_maquina = idMaquina;
    select HardDisk into vHardDiskSoftware from pcdatv.Software where id_software = idSoftware;

    if vHardDiskMaquina >= vHardDiskSoftware then
        raise notice 'Espaco disponivel';
    
    ELSE
        raise notice 'Espaco insuficiente';
    
    end if;
end;
$$ language plpgsql;
    
call pcdatv.IntalarSoftware(1,1);

-- 3. Crie uma função chamada Maquinas_Do_Usuario que retorna uma lista de
-- máquinas associadas a um usuário.

CREATE OR REPLACE FUNCTION pcdatv.Maquinas_Do_Usuario(idUsuario INT)
RETURNS TABLE(
    Id_Maquina INT,
    Tipo VARCHAR(255),
    Velocidade INT,
    HardDisk INT,
    Placa_Rede INT,
    Memoria_Ram INT
) AS $$
BEGIN
    RETURN QUERY
        SELECT m.ID_Maquina, m.Tipo, m.Velocidade, m.HardDisk, m.Placa_Rede, m.Memoria_Ram
        FROM pcdatv.Maquina m
        JOIN pcdatv.Usuarios u
        ON u.ID_Usuario = m.Fk_Usuario
        WHERE u.ID_Usuario = idUsuario;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM pcdatv.Maquinas_Do_Usuario(1);


-- 4. Crie uma procedure Atualizar_Recursos Maquina que aumenta a memoria RAM e
-- o espaço em disco de uma maquina específica.

create or replace procedure pcdatv.AtualizarRecursosMaquina(idMaquina int, MemoriaRam int, NewHardDisk int) as $$
begin
    update pcdatv.Maquina set memoria_ram = MemoriaRam, HardDisk = NewHardDisk where id_maquina = idMaquina;
end; 
$$ language plpgsql;

call pcdatv.AtualizarRecursosMaquina(1, 10, 20);

-- 5. Crie uma procedure chamada Transferir_Software que transfere um software de
-- uma máquina para outra. Antes de transferir, a procedure deve verificar se a
-- maquina de destino tem espaco suficiente para o software.

create or replace procedure pcdatv.TransferirSoftware(idSoftware int, idMaquinaOrigem int, idMaquinaDestino int) as $$
declare
    HardDiskMaquinaDestino int;
    HardDiskMaquinaSoftware int;
begin 
    select HardDisk into HardDiskMaquinaDestino from pcdatv.Maquina where id_maquina = idMaquinaDestino;
    select HardDisk into HardDiskMaquinaSoftware from pcdatv.Software where id_software = idSoftware;

    if HardDiskMaquinaSoftware <= HardDiskMaquinaDestino then 
        update pcdatv.Software set Fk_Maquina = idMaquinaDestino where id_software = idSoftware;
    else
        raise notice 'Espaco insuficiente';
    end if;
end;
$$ language plpgsql;

call pcdatv.TransferirSoftware(2, 1, 2);
call pcdatv.TransferirSoftware(2, 2, 3);
call pcdatv.TransferirSoftware(2, 2, 3);

select * from pcdatv.Software;

-- 6. Crie uma função Media_Recursos que retorna a média de Memória RAM e
-- HardDisk de todas as máquinas cadastradas.

-- Criação da função Media_Recursos
create or replace function pcdatv.Media_Recursos() 
returns table (Media_Ram float, HardDiskResp float) as $$
begin
    return query 
    select avg(Memoria_Ram), avg(HardDisk)
    from pcdatv.Maquina;
end;
$$ language plpgsql;

-- Executar a função para verificar os resultados
select * from pcdatv.Media_Recursos();



create or replace function pcdatv.Media_Recursos() returns table
( Media_Ram float, HardDiskResp float ) as $$
declare 
    media1 float;
    media2 float;
begin
    select avg(Memoria_Ram) into media1 from pcdatv.Maquina;
    select avg(HardDisk) into media2 from pcdatv.Maquina;
    return query select media1, media2;
end;
$$ language plpgsql;
drop FUNCTION pcdatv.Media_Recursos;

select * from pcdatv.Media_Recursos();
select pcdatv.Media_Recursos();

-- 7. Crie uma procedure chamada Diagnostico_Maquina que faz uma avaliação
-- completa de uma máquina e sugere um upgrade se os recursos dela não forem
-- suficientes para rodar os softwares instalados.

create or replace procedure pcdatv.Diagnostico_Maquina(idMaquina int) as $$
DECLARE
    RamSoftware int;
    HardDiskSoftware int;
    RamMaquina int;
    HardDiskMaquina int;
BEGIN
    SELECT Memoria_Ram INTO RamSoftware FROM pcdatv.Software WHERE Fk_Maquina = idMaquina;
    SELECT HardDisk INTO HardDiskSoftware FROM pcdatv.Software WHERE Fk_Maquina = idMaquina;
    SELECT Memoria_Ram INTO RamMaquina FROM pcdatv.Maquina WHERE id_maquina = idMaquina;
    SELECT HardDisk INTO HardDiskMaquina FROM pcdatv.Maquina WHERE id_maquina = idMaquina;

    if RamSoftware > RamMaquina or HardDiskSoftware > HardDiskMaquina then
        raise notice 'Upgrade necessario';
    
    else 
        raise notice 'Maquina ok';
    end if;
end;
$$ language plpgsql;

call pcdatv.Diagnostico_Maquina(1);


-- 1. Crie uma procedure chamada Diagnostico_Maquina que faz uma avaliação
-- completa de uma maquina e sugere um upgrade se os recursos dela nao forem
-- suficientes para rodar os softwares instalados.