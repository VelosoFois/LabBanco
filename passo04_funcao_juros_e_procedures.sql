
USE locadora;

DELIMITER $$

-- Regra de juros da locadora: ate 5 parcelas sem juros; acima disso 4% ao mes (composto).
-- Fica no banco para que toda a aplicacao use a mesma regra.

CREATE FUNCTION fn_total_com_juros(p_valor DECIMAL(10,2), p_parcelas INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
RETURN IF(p_parcelas > 5, ROUND(p_valor * POW(1.04, p_parcelas), 2), ROUND(p_valor, 2))$$

-- Relatorio de vendas por periodo (JOIN completo). Usada pela tela de relatorio.
-- Filtra por data_venda sem usar funcao na coluna, assim o indice idx_venda_data e aproveitado.

CREATE PROCEDURE sp_relatorio_vendas(IN p_inicio DATE, IN p_fim DATE, IN p_situacao VARCHAR(15))
BEGIN
    SELECT v.id_venda, v.data_venda, v.data_devolucao, v.dias, v.valor_total, v.qtd_parcelas, v.situacao,
           c.id_cliente, c.nome AS cliente,
           ca.id_carro, ca.marca, ca.modelo, ca.placa, ca.valor_diaria, ca.status,
           cat.nome AS categoria,
           u.id_usuario, u.nome AS usuario
    FROM venda v
    INNER JOIN cliente c     ON v.id_cliente = c.id_cliente
    INNER JOIN carro ca      ON v.id_carro = ca.id_carro
    INNER JOIN categoria cat ON ca.id_categoria = cat.id_categoria
    INNER JOIN usuarios u    ON v.id_usuario = u.id_usuario
    WHERE v.data_venda >= p_inicio
      AND v.data_venda < DATE_ADD(p_fim, INTERVAL 1 DAY)
      AND (p_situacao = 'TODAS' OR v.situacao = p_situacao)
    ORDER BY v.data_venda DESC;
END$$

-- Resumo por usuario (GROUP BY). Usada no rodape da tela de relatorio.

CREATE PROCEDURE sp_resumo_por_usuario(IN p_inicio DATE, IN p_fim DATE, IN p_situacao VARCHAR(15))
BEGIN
    SELECT u.nome, COUNT(v.id_venda) AS qtd_vendas, SUM(v.valor_total) AS total_vendido
    FROM venda v
    INNER JOIN usuarios u ON v.id_usuario = u.id_usuario
    WHERE v.data_venda >= p_inicio
      AND v.data_venda < DATE_ADD(p_fim, INTERVAL 1 DAY)
      AND (p_situacao = 'TODAS' OR v.situacao = p_situacao)
    GROUP BY u.nome
    ORDER BY SUM(v.valor_total) DESC;
END$$

-- Marca uma parcela como paga (tarefa repetitiva, centralizada no banco)

CREATE PROCEDURE sp_pagar_parcela(IN p_id_venda INT, IN p_numero INT)
UPDATE parcela SET status = 'PAGA' WHERE id_venda = p_id_venda AND numero = p_numero$$

DELIMITER ;










-- ---------------------------------------------------------------------
-- TESTE ---------------------------------------------------------------
-- ---------------------------------------------------------------------
SELECT fn_total_com_juros(1000, 5) AS total_5x_sem_juros,
       fn_total_com_juros(1000, 8) AS total_8x_com_juros;   -- 1000 e 1368.57

SHOW FUNCTION STATUS WHERE Db = 'locadora';
SHOW PROCEDURE STATUS WHERE Db = 'locadora';
-- As procedures de relatorio so mostram linhas depois do passo 7 (dados).