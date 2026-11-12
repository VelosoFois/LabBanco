
DROP DATABASE IF EXISTS locadora;
CREATE DATABASE locadora;
USE locadora;

CREATE TABLE grupos_usuarios (
    id_grupo  INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome      VARCHAR(50) UNIQUE  NOT NULL,
    descricao VARCHAR(150)
);

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY NOT NULL,                 -- gerado pela funcao fn_id_usuario()
    nome       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    senha      CHAR(64)     NOT NULL,        
    id_grupo   INT NOT NULL,
    
    CONSTRAINT FK_UsuarioGrupo
        FOREIGN KEY (id_grupo) REFERENCES grupos_usuarios(id_grupo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome         VARCHAR(50) UNIQUE NOT NULL,
    descricao    VARCHAR(150)
);

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY NOT NULL,                 
    nome       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    telefone   VARCHAR(20)  NOT NULL
);

CREATE TABLE carro (
    id_carro     INT PRIMARY KEY NOT NULL,               
    id_categoria INT NOT NULL,
    marca        VARCHAR(50) NOT NULL,
    modelo       VARCHAR(50) NOT NULL,
    ano          INT NOT NULL,
    placa        VARCHAR(10) UNIQUE NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    status       VARCHAR(15) NOT NULL DEFAULT 'DISPONIVEL',
    CHECK (valor_diaria > 0),
    
    CONSTRAINT FK_CarroCategoria
        FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE venda (
    id_venda       INT PRIMARY KEY NOT NULL,             -- gerado pela funcao fn_id_venda() (comeca em 1000)
    id_cliente     INT NOT NULL,
    id_carro       INT NOT NULL,
    id_usuario     INT NOT NULL,             -- usuario (atendente) que realizou a venda
    data_venda     DATETIME,
    data_devolucao DATE,
    dias           INT NOT NULL,
    valor_total    DECIMAL(10,2) NOT NULL,   -- ja com juros (acima de 5 parcelas)
    qtd_parcelas   INT NOT NULL,
    situacao       VARCHAR(15) NOT NULL DEFAULT 'ATIVA',  -- ATIVA, FINALIZADA ou CANCELADA
    CHECK (dias > 0),
    
    CONSTRAINT FK_VendaCliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    CONSTRAINT FK_VendaCarro
        FOREIGN KEY (id_carro) REFERENCES carro(id_carro)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    CONSTRAINT FK_VendaUsuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE parcela (
    id_parcela INT PRIMARY KEY NOT NULL,                
    id_venda   INT NOT NULL,
    numero     INT NOT NULL,
    valor      DECIMAL(10,2) NOT NULL,
    vencimento DATE NOT NULL,
    status     VARCHAR(15) NOT NULL DEFAULT 'PENDENTE',
    
    CONSTRAINT FK_ParcelaVenda
        FOREIGN KEY (id_venda) REFERENCES venda(id_venda)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);



SHOW TABLES;
DESCRIBE venda;
SHOW CREATE TABLE venda;      
SHOW CREATE TABLE carro;
