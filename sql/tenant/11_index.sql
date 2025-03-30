-- player_scoreテーブルのインデックス
CREATE INDEX idx_player_score_tenant_competition_player ON player_score (tenant_id, competition_id, player_id);
CREATE INDEX idx_player_score_tenant_player ON player_score (tenant_id, player_id);
CREATE INDEX idx_player_score_competition ON player_score (competition_id);

-- competitionテーブルのインデックス
CREATE INDEX idx_competition_tenant ON competition (tenant_id);
CREATE INDEX idx_competition_tenant_created ON competition (tenant_id, created_at);

-- playerテーブルのインデックス
CREATE INDEX idx_player_tenant ON player (tenant_id); 