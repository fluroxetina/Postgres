CREATE TABLE viewatv.time (
    id INTEGER PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE viewatv.partida (
    id INTEGER PRIMARY KEY,
    time_1 INTEGER,
    time_2 INTEGER,
    time_1_gols INTEGER,
    time_2_gols INTEGER,
    FOREIGN KEY(time_1) REFERENCES viewatv.time(id),
    FOREIGN KEY(time_2) REFERENCES viewatv.time(id)
);

INSERT INTO viewatv.time(id, nome) VALUES
(1,'CORINTHIANS'),
(2,'SÃO PAULO'),
(3,'CRUZEIRO'),
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');

INSERT INTO viewatv.partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES  (1,4,1,0,4),
        (2,3,2,0,1),
        (3,1,3,3,0),
        (4,3,4,0,1),
        (5,1,2,0,0),
        (6,2,4,2,2),
        (7,1,5,1,2),
        (8,5,2,1,2);





-- C2.1 - Crie uma view vpartida que retorne a tabela de partida adicionando as colunas
-- nome_time_1 e nome_time_2 com o nome dos times.
-- Colunas esperadas: id, id_time_1, time_2, time_1_gols, time_2_gols, nome_time_1,
-- nome_time_2

create view viewatv.vpartida as
select p.id,p.time_1,p.time_2,p.time_1_gols,p.time_2_gols,
t1.nome as nome_time_1, 
t2.nome as nome_time_2
from viewatv.partida p
join viewatv.time t1 on p.time_1 = t1.id
join viewatv.time t2 on p.time_2 = t2.id

-- Ordenação: id ascendente
-- C2.2 - Realize uma consulta em vpartida que retorne somente os jogos times que
-- possuem nome que comecam com A ou C participaram.
-- Colunas esperadas: nome_time_1, nome_time_2, time_1_gols, time_2_gols
-- Ordenação: nome_time_1 e nome_time_2 ascendentes

create view viewatv.order as
select vp.nome_time_1, vp.nome_time_2, vp.time_1_gols, vp.time_2_gols  
from viewatv.vpartida vp
where vp.nome_time_1 like 'A%' or vp.nome_time_1 like 'C%' 
or 
    vp.nome_time_2 like 'A%' or vp.nome_time_2 like 'C%'
ORDER BY vp.nome_time_1, vp.nome_time_2;



-- C2.3 - Crie uma view, utilizando a view vpartida que retorne uma coluna de
-- classificacão com o nome do ganhador da partida, ou a palavra 'EMPATE' em caso de
-- empate.
-- Colunas esperadas: id_partida, nome_time_1, nome_time_2, classificacao_vencedor

create view viewatv.vpartida_classificacao as
select p.id, vp.nome_time_1, vp.nome_time_2,
case 
    when vp.time_1_gols > vp.time_2_gols then vp.nome_time_1
    when vp.time_1_gols < vp.time_2_gols then vp.nome_time_2
    else 'EMPATE'
end as classificacao_vencedor
from viewatv.vpartida vp
join viewatv.partida p on vp.id = p.id;

-- Ordenação: classificacao_vencedor descendente
-- C2.4 - Crie uma view vtime que retorne a tabela de time adicionando as colunas
-- partidas, vitorias, derrotas, empates e pontos.
-- Colunas esperadas: id, nome, partidas, vitorias, derrotas, empates, pontos

create view viewatv.vtime as 
select t.id, t.nome,
(select count(*) from viewatv.vpartida vp where vp.nome_time_1 = t.nome or vp.nome_time_2 = t.nome) as partidas,
(select count(*) from viewatv.vpartida vp where vp.nome_time_1 = t.nome and vp.time_1_gols > vp.time_2_gols) as vitorias,
(select count(*) from viewatv.vpartida vp where vp.nome_time_1 = t.nome and vp.time_1_gols < vp.time_2_gols) as derrotas,
(select count(*) from viewatv.vpartida vp where vp.nome_time_1 = t.nome and vp.time_1_gols = vp.time_2_gols) as empates,
(select count(*) from viewatv.vpartida vp where vp.nome_time_1 = t.nome and vp.time_1_gols > vp.time_2_gols) + 
(select count(*) from viewatv.vpartida vp where vp.nome_time_1 = t.nome and vp.time_1_gols = vp.time_2_gols) as pontos
from viewatv.time t 
group by t.id, t.nome;


-- Ordenação: pontos descendentes

-- C2.5- Realize uma consulta na view vpartida_classificacao


select vpc.nome_time_2, vpc.nome_time_1 from viewatv.vpartida_classificacao vpc 


-- C2.6 - Apague a view vpartida.

drop view viewatv.vpartida;