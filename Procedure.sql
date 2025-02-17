CREATE TABLE pcd.time (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE pcd.partida (
    id SERIAL PRIMARY KEY,
    time_1 INTEGER,
    time_2 INTEGER,
    time_1_gols INTEGER,
    time_2_gols INTEGER,
    FOREIGN KEY(time_1) REFERENCES pcd.time(id),
    FOREIGN KEY(time_2) REFERENCES pcd.time(id)
);

INSERT INTO pcd.time (nome) VALUES
('CORINTHIANS'),
('SÃO PAULO'),
('CRUZEIRO'),
('ATLÉTICO MINEIRO'),
('PALMEIRAS');


INSERT INTO pcd.partida (time_1, time_2, time_1_gols, time_2_gols)
VALUES  (4,1,0,4),
        (3,2,0,1),
        (1,3,3,0),
        (3,4,0,1),
        (1,2,0,0),
        (2,4,2,2),
        (1,5,1,2),
        (5,2,1,2);


create or replace procedure pcd.inserirPartida(time_1 int, time_2 int, time_1_gols int, time_2_gols int) as $$
begin 
    insert into pcd.partida (time_1, time_2, time_1_gols, time_2_gols) values (time_1, time_2, time_1_gols, time_2_gols);
end;
$$ language plpgsql;

call pcd.inserirPartida(1,2,2,1);

SELECT * FROM pcd.partida;


create or replace procedure pcd.AlterarNomeTime(idTime int, time_1 varchar) as $$
begin 

    update pcd.time set nome = time_1 where id =  idTime;
    if not found id then
        raise exception'Time nao encontrado';
    end if;

end;
$$ language plpgsql;



call pcd.AlterarNomeTime(4,'OPERARIO');

SELECT * FROM pcd.time ORDER BY id; 

create or replace procedure pcd.ExcluirPartida(idPartida int) as $$
begin 
    delete from pcd.partida where id = idPartida;
    if not found id then 
        raise exception 'Partida nao encontrada';
    end if;
end; 
$$ language plpgsql;

call pcd.ExcluirPartida(1);

SELECT * FROM pcd.partida;