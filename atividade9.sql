CREATE TABLE atv9.Departamento (
    NomeDep VARCHAR(50),
    NumDep INT PRIMARY KEY NOT NULL,
    CPFGer BIGINT,
    DataInicioGer DATE
);

CREATE TABLE atv9.Empregado (
    Nome VARCHAR(50),
    Endereco VARCHAR(500),
    CPF BIGINT PRIMARY KEY NOT NULL,
    DataNasc DATE,
    Sexo CHAR(1),
    CartTrab BIGINT,
    Salario DECIMAL(10,2),
    NumDep INT,
    CPFSup BIGINT,
    FOREIGN KEY (NumDep) REFERENCES atv9.Departamento(NumDep)
);

CREATE TABLE atv9.Projeto (
    NomeProj VARCHAR(50),
    NumProj INT PRIMARY KEY NOT NULL,
    Localizacao VARCHAR(50),
    NumDep INT,
    FOREIGN KEY (NumDep) REFERENCES atv9.Departamento(NumDep)
);

CREATE TABLE atv9.Dependente (
    idDependente INT PRIMARY KEY NOT NULL,
    CPFE BIGINT,
    NomeDep VARCHAR(50),
    Sexo CHAR(1),
    Parentesco VARCHAR(50),
    FOREIGN KEY (CPFE) REFERENCES atv9.Empregado(CPF)
);

CREATE TABLE atv9.Trabalha_Em (
    CPF BIGINT,
    NumProj INT,
    HorasSemana INT,
    FOREIGN KEY (CPF) REFERENCES atv9.Empregado(CPF),
    FOREIGN KEY (NumProj) REFERENCES atv9.Projeto(NumProj)
);

-- Inserção de dados corrigida
INSERT INTO atv9.Departamento VALUES ('Dep1', 1, NULL, '1990-01-01');
INSERT INTO atv9.Departamento VALUES ('Dep2', 2, NULL, '1990-01-01');
INSERT INTO atv9.Departamento VALUES ('Dep3', 3, NULL, '1990-01-01');

INSERT INTO atv9.Empregado VALUES ('Joao', 'Rua 1', 123, '1990-01-01', 'M', 123, 1000.00, 1, NULL);
INSERT INTO atv9.Empregado VALUES ('Maria', 'Rua 2', 456, '1990-01-01', 'F', 456, 2000.00, 2, NULL);
INSERT INTO atv9.Empregado VALUES ('Jose', 'Rua 3', 789, '1990-01-01', 'M', 789, 3000.00, 3, NULL);

UPDATE atv9.Departamento SET CPFGer = 123 WHERE NumDep = 1;
UPDATE atv9.Departamento SET CPFGer = 456 WHERE NumDep = 2;
UPDATE atv9.Departamento SET CPFGer = 789 WHERE NumDep = 3;

INSERT INTO atv9.Projeto VALUES ('Proj1', 1, 'Local1', 1);
INSERT INTO atv9.Projeto VALUES ('Proj2', 2, 'Local2', 2);
INSERT INTO atv9.Projeto VALUES ('Proj3', 3, 'Local3', 3);

INSERT INTO atv9.Dependente VALUES (1, 123, 'Dep1', 'M', 'Filho');
INSERT INTO atv9.Dependente VALUES (2, 456, 'Dep2', 'F', 'Filha');
INSERT INTO atv9.Dependente VALUES (3, 789, 'Dep3', 'M', 'Filho');

INSERT INTO atv9.Trabalha_Em VALUES (123, 1, 40);
INSERT INTO atv9.Trabalha_Em VALUES (456, 2, 40);
INSERT INTO atv9.Trabalha_Em VALUES (789, 3, 40);


-- 1. Função que retorna o salario de um empregado dado o CPF

create or replace function atv9.obterSalario1(CPF_emp BIGINT) returns DECIMAL(10,2) as $$
begin
    return(select e.Salario from atv9.Empregado e where e.CPF = CPF_emp);
end;
$$ language plpgsql;

select * from atv9.obterSalario1(123);

-- 2. Função que retorna o nome do departamento de um empregado dado o CPF

create or replace function atv9.obterDepartamento(CPFEmp BIGINT) returns VARCHAR(50) as $$
begin 
    return(select d.NomeDep from atv9.Departamento d join atv9.Empregado e on e.numdep = d.numdep where e.CPF = CPFEmp);
end;
$$ language plpgsql;

select * from atv9.obterDepartamento(123);

-- 3. Função que retorna o nome do gerente de um departamento dado o NumDep

create or replace function atv9.obterGerente(NumDep1 int) returns varchar as $$
begin
    return(select e.Nome from atv9.empregado e where e.Numdep = NumDep1);
end;
$$ language plpgsql;

SELECT * FROM atv9.obterGerente(3);
  
-- 4. Função que retorna o nome do projeto de um empregado dado o CPF

create or replace function atv9.obterProj(CpfEmpre BIGINT) returns VARCHAR(50) as $$
begin 
    return (select p.NomeProj from atv9.Projeto p join atv9.trabalha_em t on p.NumProj = t.NumProj where t.cpf = CpfEmpre);
end;
$$ language plpgsql;

select * from atv9.obterProj(123);

-- 5. Função que retorna o nome do dependente de um empregado dado o CPF

create or replace function atv9.ObterDep(CpfEmpre BIGINT) returns VARCHAR(50) as $$
begin
    return (select d.NomeDep from atv9.Dependente d where d.CPFE = CpfEmpre);
end;
$$ language plpgsql;

select * from atv9.ObterDep(123);

-- 6. Função que retorna o nome do gerente de um empregado dado o CPF

create or replace function atv9.obterGerente(CPFemp BIGINT) returns VARCHAR(50) as $$
begin
    return (select e.Nome from atv9.Empregado e where e.CPF = CPFemp);
end;
$$ language plpgsql;

select * from atv9.obterGerente(123);

-- 7. Função que retorna a quantidade de horas que um empregado trabalha em um projeto dado o CPF

create or replace function atv9.ObterHoras(CPFemp BIGINT) returns INT as $$
begin 
    return(select t.HorasSemana from atv9.trabalha_em t where t.cpf = CPFemp);
end;
$$ language plpgsql;

SELECT * FROM atv9.ObterHoras(123);

-- 8. Função com Exception que retorna o salario de um empregado dado o CPF

CREATE OR REPLACE FUNCTION atv9.obterSalario2(CPFemp BIGINT) 
RETURNS FLOAT AS $$
DECLARE
    v_salario FLOAT;
BEGIN
    SELECT e.Salario INTO v_salario FROM atv9.Empregado e WHERE e.CPF = CPFemp;

    IF v_salario IS NULL THEN
        RAISE EXCEPTION 'CPF nao encontrado';
    END IF;

    RETURN v_salario;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro ao obter salario: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;





select * from atv9.obterSalario2(1212);


