-- Oficina mecânica:

-- Criando o schema:
CREATE DATABASE oficina;
-- Usando o schema:
USE oficina;

-- Crianto e inserindo dados nas tabelas:
CREATE TABLE Cliente(
	id_cliente smallint auto_increment unique not null,
    cpf char(11) unique not null,
    primeiro_nome varchar(45) not null,
    nome_do_meio varchar(45) not null,
    ultimo_nome varchar(45) not null,
    telefone varchar(45) not null,
    constraint pk_cliente primary key (id_cliente)
);


INSERT INTO Cliente (cpf, primeiro_nome, nome_do_meio, ultimo_nome, telefone) VALUES
('12345678901', 'João', 'Carlos', 'Silva', '11987654321'),
('23456789012', 'Maria', 'Fernanda', 'Souza', '11976543210'),
('34567890123', 'Carlos', 'Eduardo', 'Lima', '11965432109');


CREATE TABLE IF NOT EXISTS Veiculo(
id_veiculo smallint auto_increment not null unique,
modelo varchar(45) not null,
placa char(7) unique not null,
id_cliente smallint not null,
constraint pk_veiculo primary key (id_veiculo),
foreign key (id_cliente) references Cliente(id_cliente) on delete cascade
);

INSERT INTO Veiculo (modelo, placa, id_cliente) VALUES
('Ford Ka', 'ABC1234', 1),
('Onix', 'XYZ5678', 2),
('Civic', 'JKL9012', 3);


CREATE TABLE IF NOT EXISTS Equipe_mecanicos(
	id_equipe smallint unique auto_increment not null primary key,
    nome_equipe varchar(45)
);

INSERT INTO Equipe_mecanicos (nome_equipe) VALUES
('Equipe Alfa'),
('Equipe Bravo');


CREATE TABLE IF NOT EXISTS Mecanico(
	id_mecanico smallint unique auto_increment not null primary key,
    primeiro_nome varchar(45) not null,
    ultimo_nome varchar(45) not null,
    cpf char(11) unique not null,
    endereco varchar(90),
    especialidade varchar(45),
    id_equipe smallint not null,
    foreign key (id_equipe) references Equipe_mecanicos(id_equipe) on delete cascade
);

INSERT INTO Mecanico (primeiro_nome, ultimo_nome, cpf, endereco, especialidade, id_equipe) VALUES
('Lucas', 'Moura', '11111111111', 'Rua das Flores, 100', 'Freios', 1),
('Bruno', 'Henrique', '22222222222', 'Av. Brasil, 200', 'Suspensão', 1),
('Rafael', 'Silva', '33333333333', 'Rua Verde, 300', 'Motor', 2),
('Tiago', 'Lopes', '44444444444', 'Rua Azul, 400', 'Transmissão', 2);


CREATE TABLE IF NOT EXISTS Ordem_de_servico(
id_ordem smallint unique auto_increment not null primary key,
valor float not null,
data_emissao date not null,
data_conclusao date not null,
id_veiculo smallint not null,
id_equipe smallint not null,
foreign key (id_veiculo) references Veiculo(id_veiculo) on delete cascade,
foreign key (id_equipe) references Equipe_mecanicos(id_equipe) on delete cascade
);

-- Alterando o atributo "data_conclusao" para permitir valores nulos:
ALTER TABLE Ordem_de_servico
MODIFY COLUMN data_conclusao DATE NULL;

INSERT INTO Ordem_de_servico (valor, data_emissao, data_conclusao, id_veiculo, id_equipe) VALUES
(850.00, '2025-03-01', null, 1, 1),
(320.00, '2025-03-10', '2025-03-12', 2, 1),
(1400.00, '2025-03-15', '2025-03-20', 3, 2);



CREATE TABLE IF NOT EXISTS Servico(
id_servico smallint unique auto_increment not null primary key,
tipo_servico varchar(45),
id_ordem smallint not null,
id_veiculo smallint not null,
id_equipe smallint not null,
foreign key (id_veiculo) references Veiculo(id_veiculo) on delete cascade,
foreign key (id_equipe) references Equipe_mecanicos(id_equipe) on delete cascade,
foreign key (id_ordem) references Ordem_de_servico(id_ordem) on delete cascade
);

INSERT INTO Servico (tipo_servico, id_ordem, id_veiculo, id_equipe) VALUES
('Troca de pastilhas de freio', 1, 1, 1),
('Alinhamento e balanceamento', 2, 2, 1),
('Revisão geral', 3, 3, 2);


CREATE TABLE IF NOT EXISTS Peca(
	id_peca smallint unique auto_increment not null primary key,
	valor_peca float not null,
    descricao_peca varchar(90)
);

INSERT INTO Peca (valor_peca, descricao_peca) VALUES
(120.50, 'Pastilha de freio dianteira'),
(89.90, 'Filtro de óleo'),
(45.00, 'Velas de ignição'),
(250.00, 'Bateria 60Ah'),
(320.00, 'Amortecedor traseiro'),
(15.75, 'Parafuso de roda'),
(210.00, 'Radiador'),
(35.90, 'Correia dentada'),
(60.00, 'Filtro de ar'),
(500.00, 'Kit embreagem completo');


CREATE TABLE IF NOT EXISTS Relacao_Peca_Servico(
	id_peca smallint not null,
    id_servico smallint not null,
    id_equipe smallint not null,
	foreign key (id_peca) references Peca(id_peca) on delete cascade,
    foreign key (id_servico) references Servico(id_servico) on delete cascade,
    foreign key (id_equipe) references Equipe_mecanicos(id_equipe) on delete cascade,
    primary key (id_peca, id_servico, id_equipe)
);

INSERT INTO Relacao_Peca_Servico (id_peca, id_servico, id_equipe) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 2);


-- SELECTS para o retorno de dados:
-- Trazendo lista de clientes cadastrados:
SELECT cpf, concat(primeiro_nome, ' ', nome_do_meio, ' ', ultimo_nome) as nome_completo, telefone FROM Cliente;

-- Filtro com where para retornar um veiculo com base no valor do CPF do cliente:
SELECT v.modelo, v.placa
FROM Veiculo v
JOIN Cliente c ON v.id_cliente = c.id_cliente
WHERE c.cpf = '12345678901';

-- Atributos derivados:

-- Ordenando serviços pelo valor (order by):
SELECT valor, data_emissao, tipo_servico
FROM Ordem_de_servico os
LEFT JOIN Servico s on os.id_ordem = s.id_ordem
ORDER BY valor DESC;

-- Retorna equipes que já realizaram mais de 1 OS:
SELECT  nome_equipe, COUNT(*) as total_os
FROM Ordem_de_servico os
LEFT JOIN Equipe_mecanicos ec ON os.id_equipe = ec.id_equipe
GROUP BY os.id_equipe
HAVING COUNT(*) > 1;

-- Retorna dados dos serviços realizados junto com as peças utilizadas e seus respectivos valores:

SELECT 
    s.tipo_servico,
    p.descricao_peca,
    p.valor_peca,
    e.nome_equipe
FROM Servico s
JOIN Relacao_Peca_Servico rps ON s.id_servico = rps.id_servico
JOIN Peca p ON rps.id_peca = p.id_peca
JOIN Equipe_mecanicos e ON rps.id_equipe = e.id_equipe;

