-- player_scoreテーブルのインデックス
-- 最も頻繁に使用されるクエリに合わせたインデックス
CREATE INDEX IF NOT EXISTS idx_player_score_tenant_competition_player ON player_score (tenant_id, competition_id, player_id, row_num);

-- competitionテーブルのインデックス
-- 大会の一覧取得時に使用されるインデックス
CREATE INDEX IF NOT EXISTS idx_competition_tenant_created_at ON competition (tenant_id, created_at);