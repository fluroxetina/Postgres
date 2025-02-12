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
