
USE locadora;

-- Relatorio e historico filtram vendas por periodo (data_venda): evita ler a tabela inteira.
CREATE INDEX idx_venda_data ON venda (data_venda);

-- A view v_carros_disponiveis filtra por status = 'DISPONIVEL' a cada pesquisa de carros.
CREATE INDEX idx_carro_status ON carro (status);

-- As listagens e caixas de selecao de clientes ordenam por nome.
CREATE INDEX idx_cliente_nome ON cliente (nome);

SHOW INDEX FROM venda;
SHOW INDEX FROM carro;
SHOW INDEX FROM cliente;
