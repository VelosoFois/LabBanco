
USE locadora;

CREATE TABLE sequencias (
    nome  VARCHAR(30) PRIMARY KEY NOT NULL,
    ultimo_valor INT NOT NULL
);

-- Regra propria de numeracao: usuario, cliente e carro comecam em 1;

-- venda comeca em 1000 e parcela em 10000 (numeros de venda com 4 digitos identificam melhor o comprovante).

INSERT INTO sequencias (nome, ultimo_valor) VALUES
('usuario', 0), ('cliente', 0), ('carro', 0), ('venda', 999), ('parcela', 9999);


DELIMITER $$

CREATE FUNCTION fn_proximo_id(p_nome VARCHAR(30)) RETURNS INT
MODIFIES SQL DATA
BEGIN
    UPDATE sequencias SET ultimo_valor = ultimo_valor + 1 WHERE nome = p_nome;
    RETURN (SELECT ultimo_valor FROM sequencias WHERE nome = p_nome);
END$$

-- Funcoes especificas de ID (uma por tabela)
CREATE FUNCTION fn_id_usuario() RETURNS INT
MODIFIES SQL DATA
RETURN fn_proximo_id('usuario')$$

CREATE FUNCTION fn_id_cliente() RETURNS INT
MODIFIES SQL DATA
RETURN fn_proximo_id('cliente')$$

CREATE FUNCTION fn_id_carro() RETURNS INT
MODIFIES SQL DATA
RETURN fn_proximo_id('carro')$$

CREATE FUNCTION fn_id_venda() RETURNS INT
MODIFIES SQL DATA
RETURN fn_proximo_id('venda')$$

CREATE FUNCTION fn_id_parcela() RETURNS INT
MODIFIES SQL DATA
RETURN fn_proximo_id('parcela')$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- TESTE: cada chamada devolve o proximo numero e o ROLLBACK desfaz o contador
-- ---------------------------------------------------------------------
SELECT * FROM sequencias;

START TRANSACTION;
SELECT fn_id_cliente() AS id_cliente_1, fn_id_venda() AS id_venda_1;
SELECT fn_id_cliente() AS id_cliente_2, fn_id_venda() AS id_venda_2;
SELECT * FROM sequencias;
ROLLBACK;

SELECT * FROM sequencias;     -- voltou ao que estava
SHOW FUNCTION STATUS WHERE Db = 'locadora';
