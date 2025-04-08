# bd_oficina_mecanica
Criação do schema "oficina" para a inserção de dados de uma oficina mecânica fictícia para o curso de Dados + Copilot da DIO

O presente projeto tem como objetivo modelar e estruturar logicamente um banco de dados relacional para gerenciar os processos operacionais e administrativos de uma oficina mecânica, visando automatizar o controle de clientes, veículos, ordens de serviço, peças, serviços executados e equipes de mecânicos.

👥 Clientes e Veículos
Cada cliente é identificado por dados pessoais (CPF, nome completo, telefone).

Um cliente pode possuir um ou mais veículos, cada um com informações como modelo e placa.

Essa relação permite rastrear o histórico de serviços por veículo e por cliente.

🧰 Equipes e Mecânicos
Os mecânicos são organizados em equipes de trabalho, cada uma com identificação própria.

Cada mecânico possui dados como CPF, nome, endereço e especialidade técnica.

A associação com equipes permite escalar serviços e registrar responsabilidades.

📄 Ordens de Serviço
Cada Ordem de Serviço (OS) está vinculada a um veículo e a uma equipe responsável pela execução.

A OS armazena dados importantes como: data de emissão, valor total, data prevista de conclusão.

O campo data_conclusao foi definido como opcional, permitindo o acompanhamento de serviços em andamento.

🔧 Serviços e Peças
Os serviços executados são vinculados a ordens, veículos e equipes.

Cada serviço pode utilizar diversas peças, cujo uso é registrado por meio da tabela associativa Relacao_Peca_Servico.

As peças possuem valor e descrição, sendo consideradas no cálculo do valor total da OS.

🔗 Relacionamentos
O modelo possui relacionamentos importantes:

Cliente 1:N Veículo

Equipe 1:N Mecânico

Veículo N:1 OS

Equipe N:1 OS

OS 1:N Serviço

Serviço N:M Peça (via tabela associativa com a equipe registrada)
