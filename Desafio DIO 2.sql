create database oficina_mecanica;
use oficina_mecanica;

#tabela que irá fazer o armazenamento dos enreços cadastrados no sistema
create table endereco(
idEndereco int not null unique primary key,
cep varchar(10),
logradouro varchar(45),
bairro varchar(45),
cidade varchar(45),
estado varchar(45)
);

create table mecanico(
idMecanico int not null unique primary key,
nome varchar(45) not null,
especialidade varchar(45),
idEndereco int,

foreign key(idEndereco) references endereco(idEndereco)
);

create table equipe(
idEquipe int not null unique primary key,
quantidade int not null default 1
);

#aqui serão associados os mecanicos e suas equipes 
create table equipe_mecanicos(
idEquipeMecanicos int not null auto_increment primary key,
idMecanico int not null,
idEquipe int not null,

foreign key(idMecanico) references mecanico(idMecanico),
foreign key(idEquipe) references equipe(idEquipe)
);

create table cliente(
idCliente int not null auto_increment,
nome varchar(45),
enderecoCod int,

primary key (idCliente),
foreign key (enderecoCod) references endereco(idEndereco)
);

#os tipos de cada peça sera cadastrada aqui
create table tipo_peca(
idTipoPeca int not null auto_increment primary key,
descricao varchar(150)
);

#uma peça tem um tipo
create table pecas(
idPecas int not null auto_increment primary key,
nome varchar(45),
precoCompra decimal(10,4) not null default 0,
quantidadeEstoque int not null default 0,
codTipo int not null,

foreign key (codTipo) references tipo_peca (idTipoPeca)
);

#as ordem de serviços serão o cerne de todo o sistema
create table ordem_servico(
idOrdemServico int not null auto_increment primary key,
dataEmissao datetime not null,
precoTotal decimal(10,4) not null,
status enum('Aberta', 'Em andamento', 'Pendente', 'Concluída', 'Cancelada', 'Aguardando aprovação', 'Em revisão', 'Atrasada', 'Rejeitada') 
not null default "Aberta",
dataConclusao date
);

#uma ordem de servico pode usar varias peças em vice versa
#essa tabela vai gerenciar o relacionamento de muitos para muitos dentre essas entidades
#o mesmo vale para serviços e equipes
create table ordem_servico_pecas(
idRelOspecas int not null auto_increment primary key,
codOs int not null,
codPeca int not null,

foreign key (codOs) references ordem_servico(idOrdemServico),
foreign key (codPeca) references pecas(idPecas)
);

create table servico(
idServico int not null auto_increment primary key,
nome varchar(45),
preco decimal(10,4)
);

create table servico_ordem_servico(
idServicoOrdem_Servico int not null auto_increment primary key,
idServico int not null,
idOrdemServico int not null,

foreign key(idServico) references servico(idServico),
foreign key(idOrdemServico) references ordem_servico(idOrdemServico)
);

create table equipe_ordem_servico(
idEquipeOrdem_Servico int not null auto_increment primary key,
idEquipe int not null,
idOrdemServico int not null,

foreign key(idEquipe) references equipe(idEquipe),
foreign key(idOrdemServico) references ordem_servico(idOrdemServico)
);


-- Dados para a tabela endereco
INSERT INTO endereco (idEndereco, cep, logradouro, bairro, cidade, estado) VALUES
(1, '12345-678', 'Rua A', 'Centro', 'Cidade A', 'Estado A'),
(2, '54321-876', 'Avenida B', 'Bairro X', 'Cidade B', 'Estado B'),
(3, '98765-432', 'Rua C', 'Bairro Y', 'Cidade C', 'Estado C'),
(4, '11111-111', 'Avenida D', 'Bairro Z', 'Cidade D', 'Estado D'),
(5, '22222-222', 'Rua E', 'Centro', 'Cidade E', 'Estado E');

-- Dados para a tabela mecanico
INSERT INTO mecanico (idMecanico, nome, especialidade, idEndereco) VALUES
(1, 'João Silva', 'Motor', 1),
(2, 'Maria Oliveira', 'Freios', 2),
(3, 'José Pereira', 'Suspensão', 3),
(4, 'Ana Souza', 'Transmissão', 4),
(5, 'Carlos Santos', 'Elétrica', 5);

-- Dados para a tabela equipe
INSERT INTO equipe (idEquipe, quantidade) VALUES
(1, 5),
(2, 3),
(3, 4),
(4, 2),
(5, 6);

-- Dados para a tabela equipe_mecanicos
INSERT INTO equipe_mecanicos (idEquipeMecanicos, idMecanico, idEquipe) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 2),
(4, 4, 2),
(5, 5, 3);

-- Dados para a tabela cliente
INSERT INTO cliente (idCliente, nome, enderecoCod) VALUES
(1, 'Cliente A', 1),
(2, 'Cliente B', 2),
(3, 'Cliente C', 3),
(4, 'Cliente D', 4),
(5, 'Cliente E', 5);

-- Dados para a tabela tipo_peca
INSERT INTO tipo_peca (idTipoPeca, descricao) VALUES
(1, 'Motor'),
(2, 'Freios'),
(3, 'Suspensão'),
(4, 'Transmissão'),
(5, 'Elétrica');

-- Dados para a tabela pecas
INSERT INTO pecas (idPecas, nome, precoCompra, quantidadeEstoque, codTipo) VALUES
(1, 'Vela de Ignição', 10.50, 100, 5),
(2, 'Pastilha de Freio', 30.00, 50, 2),
(3, 'Amortecedor', 120.00, 20, 3),
(4, 'Embreagem', 200.00, 10, 4),
(5, 'Alternador', 150.00, 30, 5);

-- Dados para a tabela ordem_servico
INSERT INTO ordem_servico (idOrdemServico, dataEmissao, precoTotal, status, dataConclusao) VALUES
(1, '2023-01-01 08:00:00', 150.00, 'Aberta', NULL),
(2, '2023-02-15 10:30:00', 300.00, 'Em andamento', NULL),
(3, '2023-03-20 14:45:00', 50.00, 'Concluída', '2023-03-22'),
(4, '2023-04-10 09:15:00', 80.00, 'Pendente', NULL),
(5, '2023-05-05 11:00:00', 200.00, 'Aguardando aprovação', NULL);

-- Dados para a tabela ordem_servico_pecas
INSERT INTO ordem_servico_pecas (idRelOspecas, codOs, codPeca) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 3, 4),
(5, 4, 5);

-- Dados para a tabela servico
INSERT INTO servico (idServico, nome, preco) VALUES
(1, 'Troca de Óleo', '50.00'),
(2, 'Alinhamento', '80.00'),
(3, 'Balanceamento', '30.00'),
(4, 'Troca de Correia', '120.00'),
(5, 'Limpeza de Bicos', '60.00');

-- Dados para a tabela servico_ordem_servico
INSERT INTO servico_ordem_servico (idServicoOrdem_Servico, idServico, idOrdemServico) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

-- Dados para a tabela equipe_ordem_servico
INSERT INTO equipe_ordem_servico (idEquipeOrdem_Servico, idEquipe, idOrdemServico) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

select nome, especialidade from mecanico;
select * from ordem_servico;

select os.dataEmissao, os.precoTotal, mc.nome from ordem_servico os 
join servico_ordem_servico so on (so.idOrdemServico = os.idOrdemServico)
join servico s on (s.idServico = so.idServico)
join equipe_ordem_servico es on(os.idOrdemServico = es.idOrdemServico)
join Equipe eq on(eq.idEquipe = es.idEquipe)
join equipe_mecanicos eqm on (eq.idEquipe = eqm.idEquipe)
join mecanico mc on (mc.idMecanico = eqm.idMecanico)
where os.status = 'Aberta';

#lista todos as ordens de servico do maio para o menor preco
select * from ordem_servico order by precoTotal desc;

#agrupando todas as OS pendentes
select os.idOrdemServico, dataEmissao, precoTotal as precoTotalOS, status, dataConclusao, nome as nomeServico from ordem_servico os 
join servico_ordem_servico so on (so.idOrdemServico = os.idOrdemServico)
join servico s on (s.idServico = so.idServico) 
group by status having status = 'Pendente';
