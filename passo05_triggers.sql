
USE locadora;

-- 1) e-mail sempre em minusculo
CREATE TRIGGER trg_cliente_email
BEFORE INSERT ON cliente
FOR EACH ROW
SET NEW.email = LOWER(NEW.email);

CREATE TRIGGER trg_usuario_email
BEFORE INSERT ON usuarios
FOR EACH ROW
SET NEW.email = LOWER(NEW.email);

-- 2) antes de inserir venda: data e hora atual + data de devolucao prevista
CREATE TRIGGER trg_venda_insert
BEFORE INSERT ON venda
FOR EACH ROW
SET NEW.data_venda = NOW(),
    NEW.data_devolucao = DATE_ADD(CURDATE(), INTERVAL NEW.dias DAY);

-- 3) antes de alterar venda: recalcula a devolucao (data da venda + dias)
CREATE TRIGGER trg_venda_update
BEFORE UPDATE ON venda
FOR EACH ROW
SET NEW.data_devolucao = DATE_ADD(DATE(NEW.data_venda), INTERVAL NEW.dias DAY);

-- 4) depois de inserir venda: carro fica ALUGADO
CREATE TRIGGER trg_venda_alugar
AFTER INSERT ON venda
FOR EACH ROW
UPDATE carro SET status = 'ALUGADO' WHERE id_carro = NEW.id_carro;

-- 5) depois de alterar a situacao da venda: ATIVA = ALUGADO, FINALIZADA/CANCELADA = DISPONIVEL
CREATE TRIGGER trg_venda_situacao
AFTER UPDATE ON venda
FOR EACH ROW
UPDATE carro
SET status = IF(NEW.situacao = 'ATIVA', 'ALUGADO', 'DISPONIVEL')
WHERE id_carro = NEW.id_carro
  AND (OLD.situacao = 'ATIVA' OR NEW.situacao = 'ATIVA');

-- 6) depois de excluir uma venda ATIVA: carro volta a ficar DISPONIVEL
CREATE TRIGGER trg_venda_excluir
AFTER DELETE ON venda
FOR EACH ROW
UPDATE carro SET status = 'DISPONIVEL'
WHERE id_carro = OLD.id_carro AND OLD.situacao = 'ATIVA';





















-- ---------------------------------------------------------------------
-- TESTE --------------------------------------------------------------
-- ---------------------------------------------------------------------
START TRANSACTION;
INSERT INTO cliente (id_cliente, nome, email, telefone)
VALUES (fn_id_cliente(), 'Teste', 'TESTE@EMAIL.COM', '61000000000');
SELECT id_cliente, nome, email FROM cliente;      -- e-mail ficou em minusculo
ROLLBACK;

SHOW TRIGGERS;
