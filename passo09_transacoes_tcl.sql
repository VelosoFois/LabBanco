
USE locadora;

-- ---------------------------------------------------------------------
-- 1) TRANSACAO COM COMMIT
-- Aluga o Argo (carro 2) por 3 dias, cliente 2, usuario 1, em 2 parcelas.
-- Os triggers preenchem a data/devolucao e marcam o carro como ALUGADO.
-- ---------------------------------------------------------------------
SELECT * FROM sequencias;                 -- antes

SET autocommit = 0;                       -- cancela o autocommit
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;                        -- inicia a transacao

SET @id_venda = fn_id_venda();            -- ID gerado pela funcao

INSERT INTO venda (id_venda, id_cliente, id_carro, id_usuario, dias, valor_total, qtd_parcelas)
VALUES (@id_venda, 2, 2, 1, 3, fn_total_com_juros(450.00, 2), 2);

INSERT INTO parcela (id_parcela, id_venda, numero, valor, vencimento)
VALUES (fn_id_parcela(), @id_venda, 1, 225.00, CURDATE()),
       (fn_id_parcela(), @id_venda, 2, 225.00, DATE_ADD(CURDATE(), INTERVAL 1 MONTH));

COMMIT;                                   -- confirma a transacao

SELECT * FROM v_historico_vendas;
SELECT * FROM v_carros_disponiveis;       -- o Argo nao aparece mais

-- ---------------------------------------------------------------------
-- 2) TRANSACAO COM ROLLBACK
-- Tenta alugar o Polo (carro 4), mas desfaz tudo: o carro continua disponivel
-- e o contador de IDs tambem volta (nao sobram "buracos" na numeracao).
-- ---------------------------------------------------------------------
SELECT * FROM sequencias WHERE nome = 'venda';

START TRANSACTION;

SET @id_venda2 = fn_id_venda();
INSERT INTO venda (id_venda, id_cliente, id_carro, id_usuario, dias, valor_total, qtd_parcelas)
VALUES (@id_venda2, 3, 4, 1, 5, fn_total_com_juros(850.00, 1), 1);

SELECT id_carro, modelo, status FROM carro WHERE id_carro = 4;   -- ALUGADO (trigger)

ROLLBACK;                                 -- cancela a transacao

SELECT id_carro, modelo, status FROM carro WHERE id_carro = 4;   -- voltou para DISPONIVEL
SELECT * FROM sequencias WHERE nome = 'venda';                    -- contador voltou

SET autocommit = 1;                       -- volta ao normal















-- ---------------------------------------------------------------------
-- 3) TRIGGERS DE SITUACAO
-- Finalizar a venda do Argo libera o carro.
-- ---------------------------------------------------------------------
UPDATE venda SET situacao = 'FINALIZADA' WHERE id_venda = @id_venda;
SELECT id_carro, modelo, status FROM carro WHERE id_carro = 2;   -- DISPONIVEL

