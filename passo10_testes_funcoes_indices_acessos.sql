
USE locadora;

-- ---------------------------------------------------------------------
-- 4) FUNCTIONS E PROCEDURES
-- ---------------------------------------------------------------------
SELECT fn_total_com_juros(1000, 5) AS total_5x, fn_total_com_juros(1000, 8) AS total_8x;

CALL sp_relatorio_vendas('2026-10-01', '2026-11-30', 'TODAS');
CALL sp_resumo_por_usuario('2026-10-01', '2026-11-30', 'TODAS');

CALL sp_pagar_parcela(1000, 1);
SELECT * FROM v_parcelas_venda WHERE id_venda = 1000;

-- ---------------------------------------------------------------------
-- 5) INDICES: veja o plano de execucao (coluna "key" mostra o indice usado)
-- ---------------------------------------------------------------------
SHOW INDEX FROM venda;
EXPLAIN SELECT * FROM venda
WHERE data_venda >= '2026-10-01' AND data_venda < '2026-11-01';

EXPLAIN SELECT * FROM carro WHERE status = 'DISPONIVEL';

-- ---------------------------------------------------------------------
-- 6) CONTROLE DE ACESSO
-- ---------------------------------------------------------------------
SHOW GRANTS FOR 'locadora_admin'@'localhost';
SHOW GRANTS FOR 'locadora_app'@'localhost';
SHOW GRANTS FOR 'locadora_consulta'@'localhost';

-- Teste no Workbench: abra uma conexao nova com o usuario locadora_consulta e rode:
--   SELECT CURRENT_USER();                 -- mostra locadora_consulta@localhost
--   SELECT * FROM v_carros_disponiveis;    -- funciona
--   SELECT * FROM cliente;                 -- ERRO: acesso negado (sem permissao na tabela)
-- Com o usuario locadora_app:
--   DROP TABLE parcela;                    -- ERRO: a aplicacao nao pode apagar tabelas
