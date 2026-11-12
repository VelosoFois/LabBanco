
--   v_carros_disponiveis: carros que podem ser alugados agora (tela principal e combo de vendas).

--   v_historico_vendas: historico PUBLICO, sem identificar o cliente.

--   v_parcelas_venda: parcelas de uma venda, sem expor outras colunas.

-- =====================================================================

USE locadora;

-- Carros que podem ser alugados agora (tela principal e combo de vendas)
CREATE VIEW v_carros_disponiveis AS
SELECT carro.id_carro, categoria.nome AS categoria, carro.marca, carro.modelo,
       carro.ano, carro.placa, carro.valor_diaria
FROM carro
INNER JOIN categoria ON carro.id_categoria = categoria.id_categoria
WHERE carro.status = 'DISPONIVEL';



-- Historico publico de vendas, sem identificar o cliente
CREATE VIEW v_historico_vendas AS
SELECT venda.id_venda, venda.data_venda, venda.data_devolucao,
       categoria.nome AS categoria, carro.marca, carro.modelo, carro.placa,
       venda.dias, venda.valor_total, venda.qtd_parcelas, venda.situacao
FROM venda
INNER JOIN carro ON venda.id_carro = carro.id_carro
INNER JOIN categoria ON carro.id_categoria = categoria.id_categoria;



CREATE VIEW v_parcelas_venda AS
SELECT id_venda, numero, valor, vencimento, status
FROM parcela;


-- ---------------------------------------------------------------------
-- CONFERENCIA (as views ficam vazias ate o passo 7 inserir os dados)
-- ---------------------------------------------------------------------
SHOW FULL TABLES WHERE Table_type = 'VIEW';
SELECT * FROM v_carros_disponiveis;
