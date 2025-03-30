DELETE FROM tenant WHERE id > 100;
DELETE FROM visit_history WHERE created_at >= '1654041600';
UPDATE id_generator SET id=2678400000 WHERE stub='a';
ALTER TABLE id_generator AUTO_INCREMENT=2678400000;

-- テナントの初期化
TRUNCATE TABLE competition;
TRUNCATE TABLE player;
TRUNCATE TABLE player_score;

INSERT INTO competition
SELECT * FROM tmp_competition;

INSERT INTO player
SELECT * FROM tmp_player;

INSERT INTO player_score
SELECT * FROM tmp_player_score;