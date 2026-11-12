USE locadora;

INSERT INTO grupos_usuarios (nome, descricao) VALUES
('Administrador', 'Acesso total: cadastros, usuarios, vendas e relatorios'),
('Atendente',     'Realiza vendas, cadastra clientes e consulta relatorios');

-- logins: admin@locadora.com / 123   e   maria@locadora.com / 123  (senha guardada com SHA-256)
INSERT INTO usuarios (id_usuario, nome, email, senha, id_grupo) VALUES
(fn_id_usuario(), 'Admin Locadora',  'admin@locadora.com', SHA2('123', 256), 1),
(fn_id_usuario(), 'Maria Atendente', 'maria@locadora.com', SHA2('123', 256), 2);

INSERT INTO categoria (nome, descricao) VALUES
('Econômico',     'Carros compactos e de baixo consumo'),
('Intermediário', 'Hatches e sedãs de porte médio'),
('SUV',           'Utilitários esportivos'),
('Executivo',     'Sedãs de luxo e conforto');

INSERT INTO cliente (id_cliente, nome, email, telefone) VALUES
(fn_id_cliente(), 'João Pereira', 'joao@email.com',   '61999990001'),
(fn_id_cliente(), 'Ana Souza',    'ana@email.com',    '61999990002'),
(fn_id_cliente(), 'Carlos Lima',  'carlos@email.com', '61999990003');

INSERT INTO carro (id_carro, id_categoria, marca, modelo, ano, placa, valor_diaria) VALUES
(fn_id_carro(), 1, 'Fiat',       'Mobi',     2022, 'ABC1D23', 120.00),
(fn_id_carro(), 1, 'Fiat',       'Argo',     2023, 'BCD2E34', 150.00),
(fn_id_carro(), 2, 'Chevrolet',  'Onix',     2023, 'CDE3F45', 160.00),
(fn_id_carro(), 2, 'Volkswagen', 'Polo',     2022, 'DEF4G56', 170.00),
(fn_id_carro(), 3, 'Volkswagen', 'T-Cross',  2024, 'EFG5H67', 250.00),
(fn_id_carro(), 2, 'Hyundai',    'HB20',     2023, 'FGH6I78', 155.00),
(fn_id_carro(), 4, 'Toyota',     'Corolla',  2024, 'GHI7J89', 300.00),
(fn_id_carro(), 3, 'Jeep',       'Renegade', 2023, 'HIJ8K90', 280.00);

-- Venda 1000 (hoje): Mobi, 3 dias, 2x sem juros
INSERT INTO venda (id_venda, id_cliente, id_carro, id_usuario, dias, valor_total, qtd_parcelas)
VALUES (fn_id_venda(), 1, 1, 1, 3, fn_total_com_juros(360.00, 2), 2);
INSERT INTO parcela (id_parcela, id_venda, numero, valor, vencimento) VALUES
(fn_id_parcela(), 1000, 1, 180.00, CURDATE()),
(fn_id_parcela(), 1000, 2, 180.00, DATE_ADD(CURDATE(), INTERVAL 1 MONTH));

-- Venda 1001 (12/10/2026): Onix, 5 dias, 4x sem juros, FINALIZADA (carro volta a ficar disponivel)
INSERT INTO venda (id_venda, id_cliente, id_carro, id_usuario, dias, valor_total, qtd_parcelas)
VALUES (fn_id_venda(), 2, 3, 2, 5, fn_total_com_juros(800.00, 4), 4);
UPDATE venda SET data_venda = '2026-10-12 09:30:00', situacao = 'FINALIZADA' WHERE id_venda = 1001;
INSERT INTO parcela (id_parcela, id_venda, numero, valor, vencimento, status) VALUES
(fn_id_parcela(), 1001, 1, 200.00, '2026-10-12', 'PAGA'),
(fn_id_parcela(), 1001, 2, 200.00, '2026-11-12', 'PAGA'),
(fn_id_parcela(), 1001, 3, 200.00, '2026-12-12', 'PENDENTE'),
(fn_id_parcela(), 1001, 4, 200.00, '2027-01-12', 'PENDENTE');

-- Venda 1002 (28/10/2026): Corolla, 2 dias, 1x sem juros
INSERT INTO venda (id_venda, id_cliente, id_carro, id_usuario, dias, valor_total, qtd_parcelas)
VALUES (fn_id_venda(), 3, 7, 1, 2, fn_total_com_juros(600.00, 1), 1);
UPDATE venda SET data_venda = '2026-10-28 14:00:00' WHERE id_venda = 1002;
INSERT INTO parcela (id_parcela, id_venda, numero, valor, vencimento) VALUES
(fn_id_parcela(), 1002, 1, 600.00, '2026-10-28');

-- Venda 1003 (02/11/2026): T-Cross, 4 dias, 8x COM juros (1000 x 1,04^8 = 1368,57)
INSERT INTO venda (id_venda, id_cliente, id_carro, id_usuario, dias, valor_total, qtd_parcelas)
VALUES (fn_id_venda(), 1, 5, 2, 4, fn_total_com_juros(1000.00, 8), 8);
UPDATE venda SET data_venda = '2026-11-02 11:15:00' WHERE id_venda = 1003;
INSERT INTO parcela (id_parcela, id_venda, numero, valor, vencimento) VALUES
(fn_id_parcela(), 1003, 1, 171.07, '2026-11-02'),
(fn_id_parcela(), 1003, 2, 171.07, '2026-12-02'),
(fn_id_parcela(), 1003, 3, 171.07, '2027-01-02'),
(fn_id_parcela(), 1003, 4, 171.07, '2027-02-02'),
(fn_id_parcela(), 1003, 5, 171.07, '2027-03-02'),
(fn_id_parcela(), 1003, 6, 171.07, '2027-04-02'),
(fn_id_parcela(), 1003, 7, 171.07, '2027-05-02'),
(fn_id_parcela(), 1003, 8, 171.08, '2027-06-02');






















-- ---------------------------------------------------------------------
-- CONFERENCIA
-- ---------------------------------------------------------------------
SELECT * FROM sequencias;
SELECT id_carro, modelo, status FROM carro;       -- 1, 5 e 7 ALUGADO (triggers); 3 DISPONIVEL (venda finalizada)
SELECT * FROM v_carros_disponiveis;
SELECT * FROM v_historico_vendas;
CALL sp_relatorio_vendas('2026-10-01', '2026-11-30', 'TODAS');
CALL sp_resumo_por_usuario('2026-10-01', '2026-11-30', 'TODAS');
