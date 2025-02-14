select abs(-10) -- retorna o valor absoluto

select round(10.5)

select trunc (12.7)

select power(2, 3) -- retorna o valor da potencia

select ln(4) -- retorna o logaritmo natural

select cos(30) -- retorna o cosseno

select atan(0.5) -- retorna o arctangente

select asinh(0.5) -- retorna o arco seno

select sing(9) -- retorna o sinal do numero


select concat('Ola ', 'Mundo') -- concatena strings

select length('Ola Mundo')

select lower("FFF")

select upper("fff")

select substring('Ola Mundo', 4, 3)

select replace('Ola Mundo', 'Mundo', 'Mundo Novo')

select reverse('Ola Mundo')

select ltrim('     Ola Mundo')

select rtrim('Ola Mundo ')

select trim('   Ola Mundo   ')

select lpad('asfa', 5, '*')


select current_date;

select current_time;

select extract(year from current_date);

select age('2025-02-12', '2006-02-26')

select interval '1 day'

-- criar uma funcao no postgres
create function soma(a int , b int) returns int as $$
begin
    return a + b;
end
$$ language plpgsql;

-- criar uma funcao no mysql

-- DELIMITER $$
-- CREATE FUNCTION soma(a INT, b INT) RETURNS INT
-- deterministic
-- BEGIN
--     RETURN a + b;
-- END
-- $$
-- DELIMITER;


select soma(1, 2)

create or replace function consulta_time() returns time as  
$$
begin
    return current_time;
end
$$ language plpgsql;

select consulta_time();

create or replace function consultaVencedor(id_partida int) returns varchar(50) as $$
declare vencedor varchar(50);
begin 
    select case 
        when time_1_gols > time_2_gols then (select nome from time where id = time_1)
        when time_1_gols < time_2_gols then (select nome from time where id = time_2)
        else 'EMPATE'
    end into vencedor
    from partida 
        where id = id_partida;
        return vencedor;
end
$$ language plpgsql;

select consultaVencedor(1);


CREATE OR REPLACE FUNCTION consultaVencedor(id_partida INT) RETURNS VARCHAR(50) AS $$
DECLARE vencedor VARCHAR(50);
BEGIN
    SELECT CASE 
        WHEN time_1_gols > time_2_gols THEN (SELECT nome FROM time WHERE id = time_1)
        WHEN time_1_gols < time_2_gols THEN (SELECT nome FROM time WHERE id = time_2)
        ELSE 'EMPATE'
    END INTO vencedor
    FROM partida 
    WHERE id = id_partida;

    RETURN vencedor;
END;
$$ LANGUAGE plpgsql;


-- Tabela temporaria: elas são paara dados temporários e que são de unica sessão de banco de dados




CREATE TABLE time (
    id INTEGER PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE partida (
    id INTEGER PRIMARY KEY,
    time_1 INTEGER,
    time_2 INTEGER,
    time_1_gols INTEGER,
    time_2_gols INTEGER,
    FOREIGN KEY(time_1) REFERENCES time(id),
    FOREIGN KEY(time_2) REFERENCES time(id)
);

create temp table temp_time as select * from time;
create temp table temp_Jogo as select * from partida;

insert into temp_Jogo select * from partida where time_1 = 1 or time_2 = 1;
    
SELECT * FROM temp_time;
SELECT * FROM temp_Jogo;

--Oprações nas funções no Postgres

create or replace function operacao_funcao() RETURNS void as $$ 
declare
    v_id int;
    v_nome varchar(50);
begin
    Atribuindo valores nas variaveis 
    v_id :=1;
    v_nome := 'CORINTHIANS';
    raise notice 'Id: %, Nome: %', v_id, v_nome;

    v_id :=  v_id +1 ;
    raise notice 'Soma: %', 1+1;
    raise notice 'Subtração: %', 1-1;
    raise notice 'Multiplicação: %', 1*1;
    raise notice 'Divisão: %', 1/1;

    Operações de comparação
    raise notice 'Maior: %', 1 > 1;
    raise notice 'Maior ou Igual: %', 1 >= 1;
    raise notice 'Menor: %', 1 < 1;
    raise notice 'Menor ou Igual: %', 1 <= 1;
    raise notice 'Igual: %', 1 = 1;
    raise notice 'Diferente: %', 1 != 1;

    Operações logicas
    raise notice 'AND: %', true and true;
    raise notice 'OR: %', true or false;
    raise notice 'NOT: %', not true;
    

    Operações concatenação
    raise notice 'Concatenação: %', 'Ola ' || 'Mundo';

    Manipulação de strings
    raise notice 'Substituição: %', replace('Ola Mundo', 'Mundo', 'Mundo Novo');
    raise notice 'Tamanho: %', length('Ola Mundo');
    raise notice 'Posição: %', position('Mundo' in 'Ola Mundo');
    raise notice 'Substring: %', substring('Ola Mundo', 4, 3);
    raise notice 'Maiuscula: %', upper('ola mundo');
    raise notice 'Minuscula: %', lower('OLA MUNDO');
    raise notice 'Primeira letra maiúscula: %', initcap('ola mundo');

    manipulação de datas
    raise notice 'Data atual: %', now();
    raise notice 'Ano atual: %', extract(year from now());
    raise notice 'Mês atual: %', extract(month from now());
    raise notice 'Dia atual: %', extract(day from now());
    raise notice 'Hora atual: %', extract(hour from now());
    raise notice 'Minuto atual: %', extract(minute from now());
    raise notice 'Segundo atual: %', extract(second from now());
    raise notice 'Diferenca de datas: %', age('2025-02-12', '2006-02-26');

    Manipulação de arrays
    raise notice 'Array: %', array[1, 2, 3, 4, 5];  
    raise notice 'Array: %', array['Ola', 'Mundo'];
    raise notice 'Array: %', array['Aula', 1, true];
    raise notice 'Matriz: %', array[[1,2,3],[4,5,6]];
    raise notice 'Matriz tridimensional : %', array[[[1,2,3],[4,5,6]], [[7,8,9],[10,11,12]]];

    Manipulação de JSON
    raise notice 'JSON: %', '{ "nome": "Joao", "idade": 20 }';
     

end;
$$ language plpgsql;

select operacao_funcao();

create or replace function obterNomeTime(p_id int) returns 
varchar as $$
declare 
    v_nome varchar(50);
begin
    select nome into v_nome from time where id = p_id;
    return v_nome;
end;
$$ language plpgsql;

select obterNomeTime(1);


INSERT INTO time(id, nome) VALUES
(1,'CORINTHIANS'),
(2,'SÃO PAULO'),
(3,'CRUZEIRO'),
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');

INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES  (1,4,1,0,4),
        (2,3,2,0,1),
        (3,1,3,3,0),
        (4,3,4,0,1),
        (5,1,2,0,0),
        (6,2,4,2,2),
        (7,1,5,1,2),
        (8,5,2,1,2);


--Funcão de criação de loops

create or replace function obterTime() returns setof time as $$
declare
    i int :=1;
begin
    Loop -- Equivalente ao while
        exit when i > 5;
        raise notice  'Valor de i:%', i;
        i := i + 1;
    end loop;
end;
$$ language plpgsql;

select * from obterTime();

create or replace function obterTime() returns setof time as $$
declare
    i int :=1;
begin
    for i in 1..5 loop
        raise notice  'Valor de i:%', i;
        i := i + 1;
    end loop;
end;
$$ language plpgsql;

select * from obterTime();


-- 4 Criar função que percorre uma tabela usando return next

create or replace function obterTimeDados() returns setof time as $$
declare 
    v_time time%rowtype; -- rowtype é para pegar o tipo da variavel da tabela
begin
    for v_time in select * from time loop
        return next v_time;
    end loop;
end;
$$ language plpgsql;    

select * from obterTimeDados();


-- 5 Funcao que traalha condições

create or replace function gols() returns setof time as $$
declare
    v_gols int;
begin
    select time_1_gols into v_gols from partida where id = 1;
    if v_gols > 2 then 
        raise notice 'Time marcou mais de 2 gols';
    else
        raise notice 'Time marcou menos de 2 gols';
    end if;
end;
$$ language plpgsql;

SELECT * FROM gols();

create or replace function obterNomeTime1(idtime int) returns varchar as $$
declare 
    v_nome varchar(50);
begin
    select nome into v_nome from time where id = idtime;
    return v_nome;
    Exception 
        when No_Data_Found then
        raise notice 'Time nao encontrado';
end;    
$$ language plpgsql;

SELECT * FROM obterNomeTime1(10);