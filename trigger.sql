CREATE TABLE trg.time (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE trg.partida (
    id SERIAL PRIMARY KEY,
    time_1 INTEGER,
    time_2 INTEGER,
    time_1_gols INTEGER,
    time_2_gols INTEGER,
    FOREIGN KEY(time_1) REFERENCES trg
.time(id),
    FOREIGN KEY(time_2) REFERENCES trg
.time(id)
);

INSERT INTO trg.time (nome) VALUES
('CORINTHIANS'),
('SÃO PAULO'),
('CRUZEIRO'),
('ATLÉTICO MINEIRO'),
('PALMEIRAS');


INSERT INTO trg.partida (time_1, time_2, time_1_gols, time_2_gols)
VALUES  (4,1,0,4),
        (3,2,0,1),
        (1,3,3,0),
        (3,4,0,1),
        (1,2,0,0),
        (2,4,2,2),
        (1,5,1,2),
        (5,2,1,2);



create table trg.logPartida(

    id serial PRIMARY KEY,
    partidaId int not null,
    acao varchar(20),
    data TIMESTAMP DEFAULT current_timestamp
);



create or replace function trg.logPartida() RETURNS TRIGGER AS $$
BEGIN
    insert into trg.logPartida(partidaId, acao) values (NEW.id, 'Inserida');
    return NEW;
END;
$$ LANGUAGE plpgsql;

create Trigger logPartidaTrigger
after insert on trg.partida   
for each row
execute function trg.logPartida();


insert into trg.partida (time_1, time_2, time_1_gols, time_2_gols)
values (1,4,1,4);

select * from trg.logPartida;

create or replace function trg.insertPartida() RETURNS TRIGGER as $$
BEGIN
    if new.time_1 = new.time_2 then 
        raise exception 'Não é permitido jogos entre o mesmo time';
    end if;
    return new;
end;
$$ LANGUAGE plpgsql;

create trigger insertPartida
before insert on partida
for each row 
execute function trg.insertPartida();

insert into partida(time_1, time_2, time_1_gols, time_2_gols)
values (1,1,1,1);

create view trg.partidaV as
select id, time_1, time_2, time_1_gols, time_2_gols from trg.partida;

create or replace FUNCTION trg.insertpartidav() returns trigger as $$
begin 
    insert into trg.partida (time_1, time_2, time_1_gols, time_2_gols) values 
    (new.time_1, new.time_2, new.time_1_gols, new.time_2_gols);
    return new; -- não quero inserir na visão diretamente 
end;
$$ language plpgsql;

CREATE TRIGGER insert_partidaV
INSTEAD OF INSERT ON trg.partidaV
FOR EACH ROW 
EXECUTE FUNCTION trg.insertpartidav();


INSERT INTO trg.partidaV (time_1, time_2, time_1_gols, time_2_gols)
VALUES (1, 2, 1, 0);



create or replace FUNCTION trg.upadatePartida() returns trigger as $$   
begin
    insert into trg.log_partida(partidaId, acao) values (new.id, 'Alterada');
    return new;
end;
$$ language plpgsql;

create trigger updatePartida
AFTER update on partida
for each row 
execute function trg.upadatePartida();

update trg.partida set time_1_gols = 2 where id = 11;

select * from trg.log_partida;


-- 1 fazer triguer que impessa de fazer update em partidas que ja foram finalizadas

create or replace function trg.ImpedirUpdate() returns trigger as $$
begin
    if new.time_1_gols is not null and new.time_2_gols is not null THEN
        raise exception 'Partida já foi finalizado';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger ImpedirUpdatePartdia
before update on trg.partida
for each row
execute function trg.ImpedirUpdate();


update trg.partida set time_1_gols = 2 where id = 1;