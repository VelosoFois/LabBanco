-- =====================================================================


USE locadora;

DROP USER IF EXISTS 'locadora_admin'@'localhost';
DROP USER IF EXISTS 'locadora_app'@'localhost';
DROP USER IF EXISTS 'locadora_consulta'@'localhost';

-- Nivel 1 - administrador do banco: manutencao (tabelas, indices, backups). Nao e usado pela aplicacao.
CREATE USER 'locadora_admin'@'localhost' IDENTIFIED BY 'Admin@1234';
GRANT ALL PRIVILEGES ON locadora.* TO 'locadora_admin'@'localhost';


-- Nivel 2 - conta da aplicacao: so le/grava dados e executa funcoes/procedures.
-- Nao cria nem apaga tabelas, nao concede permissao a ninguem.
CREATE USER 'locadora_app'@'localhost' IDENTIFIED BY 'App@1234';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON locadora.* TO 'locadora_app'@'localhost';


-- Nivel 3 - consulta: so enxerga as views (sem dados de cliente nem senhas).
CREATE USER 'locadora_consulta'@'localhost' IDENTIFIED BY 'Consulta@1234';
GRANT SELECT ON locadora.v_carros_disponiveis TO 'locadora_consulta'@'localhost';
GRANT SELECT ON locadora.v_historico_vendas   TO 'locadora_consulta'@'localhost';
GRANT SELECT ON locadora.v_parcelas_venda     TO 'locadora_consulta'@'localhost';











SELECT user, host FROM mysql.user WHERE user LIKE 'locadora%';
SHOW GRANTS FOR 'locadora_admin'@'localhost';
SHOW GRANTS FOR 'locadora_app'@'localhost';
SHOW GRANTS FOR 'locadora_consulta'@'localhost';
