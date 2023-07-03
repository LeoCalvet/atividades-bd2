# Atividades do Projeto de Banco de Dados 2
Atividades separadas em 4, sendo cada possuinda tópicos específicos

1. Estudo Sobre Índices
2. Fragmentação/Particionamento Horizontal
3. Processamento de Consultas
4. Programação no PostgreSQL
___
## Descrição atividade 1: Estudo Sobre Índices
Nessa tarefa vocês irão trabalhar com um dataset de dados de criminalidade do Estado de São Paulo chamado [PolRoute-DS](https://doi.org/10.5753/jidm.2022.2355). O PolRoute-DS é criado a partir da junção espacial da geometria da malha viária da cidade com dados de ocorrências de crimes, disponibilizadas por fontes externas. O PolRoute-DS pode ser obtido em: https://osf.io/mxrgu/.

No PolRoute-DS a cidade é representada como um grafo de vias segmentadas, i.e., cada rua da cidade é particionada em segmentos de 100 a 200 metros e entre dois ou mais segmentos sempre há um vértice.

A base de dados se encontra em formato CSV e possui 6 arquivos:

- crime.csv (262,9 MB): Contém o total de crimes de cada tipo por segmento em um dado dia/horário. Os atributos segment_id se referem ao segmento da cidade e time_id ao tempo em que os crimes ocorreram.
- segment.csv (45,7 MB): contém os segmentos de vias de uma cidade. Cada tupla dessa tabela possui um vértice inicial, vértice final, uma indicação se é mão única ou mão dupla e um tamanho.
- vertice.csv (3,9 MB): contém os vértices do grafo da cidade. Cada vértice possui um distrito, uma vizinhança e uma zona.
- district.csv (5 MB): contém os distritos de uma cidade, seu nome e sua geometria espacial
- neighborhood.csv (2 MB): contém as vizinhanças da cidade, seu nome e sua geometria espacial.
- time.csv (850 KB): contém os períodos de tempo considerados para a análise criminal

O schema do PolRoute-DS será realizada com o SGBD ***PostgreSQL***

No schema que você criar, deve desenvolver consultas SQL para responder às seguintes questões:

1. Qual o total de crimes por tipo e por segmento das ruas do distrito de IGUATEMI durante o ano de 2016?
2. Qual o total de crimes por tipo e por segmento das ruas do distrito de IGUATEMI entre 2006 e 2016?
3. Qual o total de ocorrências de Roubo de Celular e roubo de carro no bairro de SANTA EFIGÊNIA em 2015?
4. Qual o total de crimes por tipo em vias de mão única da cidade durante o ano de 2012?
5. Qual o total de roubos de carro e celular em todos os segmentos durante o ano de 2017?
6. Quais os IDs de segmentos que possuíam o maior índice criminal (soma de ocorrências de todos os tipos de crimes), durante o mês de Novembro de 2010?
7. Quais os IDs dos segmentos que possuíam o maior índice criminal (soma de ocorrências de todos os tipos de crimes) durante os finais de semana do ano de 2018?

O PolRoute-DS obviamente não possui índices para acelerar as consultas uma vez que é representado em formato CSV. A sua tarefa será propor uma série de índices para melhorar o desempenho das consultas propostas nesse trabalho. Cada aluno(a) deve instanciar dois schemas no SGBD escolhido: um deles com o uso de índices e o outro sem o uso de índices.

Deve entregar os dois esquemas (com e sem índice) e um relatório comparativo mostrando o resultado do comando EXPLAIN para cada consulta e a análise do tempo de processamento da consulta.
## Descrição atividade 2: Fragmentação/Particionamento Horizontal
Considere o esquema a seguir:

% Tabela com pessoas %
Pessoa(CodPessoa, Nome, idade, UF) -- CodPessoa é chave primária
% Tabela com as receitas. CodPessoa indica a Pessoa que postou a receita no site %
Receita(CodReceita, DataPostagem, Título, ModoPreparo, CodPessoa) -- CodReceita é chave primária
CodPessoa referencia Pessoa (CodPessoa)
% Tabela que informa os ingredientes %
Ingrediente(CodIngrediente, Descrição, Unidade) - CodIngrediente é chave primária
% Tabela que informa os ingredientes de uma determinada receita %
Ingrediente_Receita (CodReceita, CodIngrediente, Quantidade) - (CodReceita,CodIngrediente) é chave primária
CodReceita referencia Receita (CodReceita)
CodIngrediente referencia Ingrediente (CodIngrediente)

Usando essa base de dados, faça a fragmentação horizontal usando os algoritmos de fragmentação horizontal primária e derivada apresentados hoje em aula. Mostre todos os passos do projeto. Considere as consultas a seguir como consultas frequentes nessa base de dados. Não usar mais tabelas que o estritamente necessário!

- Uma consulta que retorna os códigos das receitas que foram postadas por pessoas com menos de 14 anos.
- Uma consulta que retorna os códigos das receitas que foram postadas por pessoas com mais de 18 anos.
- Um consulta que retorna os nomes das pessoas que residem no Rio de Janeiro (UF = "RJ")
- Um consulta que retorna os nomes das pessoas que residem em São Paulo (UF = "SP")

a. Mostrar a representação de dono (owner) e membro (member) das tabelas da aplicação. Fazer a escolha das tabelas que irão adotar FHP ou FHD.

b. Aplicar o algoritmo visto em aula de FHP para cada tabela escolhida para FHP. Apresentar os predicados simples, a geração dos mintermos, implicações e apresentar a definição de cada fragmento gerado para cada tabela de fragmentação primária. Mostrar explicitamente a eliminação de predicados contraditórios, i.e. que geram fragmentos vazios. Explique o porquê da eliminação e da simplificação dos predicados.

c. Apresente e justifique as fragmentações derivadas.
## Descrição atividade 3: Processamento de Consultas
**Questão 1**. Considere a execução de uma consulta envolvendo uma seleção em um atributo que possui um índice. É sempre mais eficiente usar o índice do atributo no processamento? Se a tabela possuir índices desnecessários, isso pode atrapalhar o processamento da consulta? Justifique sua resposta.


**Questão 2**. Considere as seguintes tabelas e consulta:
- Aluno(mat, nome, id_dept) - mat é PK e id_dept FK para Departamento
- Departamento(id_dept, nome_dept) id_dept é PK
- SELECT mat, nome, nome_dept
  FROM Aluno, Departamento
  WHERE Aluno.id_dept = Departamento.id_dept;


1. Apresente a parse-tree dessa consulta.
2. Apresente a árvore modificada após a etapa de reescrita da consulta.
3. Faça estimativas de custo de QEP segundo os slides, para a consulta acima. Não há índices criados.


Considere as seguintes tabelas:
- R(A,B,C,D)
- S(E,F,G,H) - E é chave-estrangeira que referencia R(A)


Desenhe uma árvore otimizada para a consulta: SELECT A from R, S WHERE A=5 AND G=7 AND E=A;
## Descrição atividade 4: Programação no PostgreSQL
Como todos sabem, o estado do Rio de Janeiro bem passando uma por uma severa crise financeira. Dessa forma, o governo estadual cogita diminuir horas de trabalho e salários de muitos funcionários. (fonte: http://oglobo.globo.com/rio/rj-estuda-reduzir-jornada-salarios-de-servidores-do-estado-20358106)

Você foi contratado para atualizar o banco de dados dos funcionários estaduais de acordo com as novas diretrizes. Considere a tabela FUNCIONARIO apresentada como base para os itens a seguir. As respostas podem ser dadas para os SGBDs mySQL, SQL Server, Oracle e PostgreSQL. Cada discente deve enviar um zip ou rar com os scripts de criação dos objetos.
```
CREATE TABLE `funcionario` (

`nome` VARCHAR( 60 ) NOT NULL ,

`email` VARCHAR( 60 ) NOT NULL ,

`sexo` VARCHAR( 10 ) NOT NULL ,

`ddd` INT( 2 ) ,
'salario' NUMBER (2),


`telefone` VARCHAR ( 8 ) ,
'ativo' VARCHAR(1),


`endereco` VARCHAR( 70 ) NOT NULL ,
'cpf'VARCHAR (11) NOT NULL,


`cidade` VARCHAR( 20 ) NOT NULL ,

`estado` VARCHAR( 2 ) NOT NULL ,

`bairro` VARCHAR( 20 ) NOT NULL ,

`pais` VARCHAR( 20 ) NOT NULL ,

`login` VARCHAR( 12 ) NOT NULL ,

`senha` VARCHAR( 12 ) NOT NULL ,

`news` VARCHAR( 8 ) ,

`id` INT( 200 ));
```
1. Implemente uma função para diminuir o salário de um funcionário em um determinado percentual. A sua função deve se chamar DiminuirSalario e deve receber como parâmetros de entrada o CPF do funcionário e um valor inteiro que representa o percentual de redução.

2. Além da redução de salários, o governo prevê demissões para funcionários que faltem sem justificativa apresentada. Esse tipo de controle não existe hoje no banco de dados. Sua tarefa é desenvolver um mecanismo que controle as faltas de cada um dos funcionários. A partir da 5a (quinta) falta sem justificativa o campo ATIVO da tabela funcionário deve ser setado para 'N" significando que ele foi demitido.

> Sugestão: criem uma tabela que controle as faltas e justificativas e uma trigger associada a essa tabela para verificar a quantidade de faltas.

3. O governo do estado também deseja controlar todas as promoções dos funcionários ao longo do anos. Assim como no caso das faltas, esse mecanismo não se encontra implementado no banco de dados. É sua responsabilidade implementar esse controle. Cada funcionário possui um cargo (que por simplificação pode variar entre CARGO1, CARGO2 e CARGO 3) e seu nível pode variar entre 1 e 7. Ou seja, o funcionário pode ter o CARGO1 e Nível 5 no momento, e, na próxima promoção ele terá o CARGO1 (que não muda) e Nível 6, e assim por diante. Lembrando que cada funcionário só pode aumentar seu nível de 3 em 3 anos e não pode haver interseção de períodos entre dois níveis. Além disso, um funcionário só pode ser promovido para o nível imediatamente superior ao atual, logo uma promoção do Nível 1 para o Nível 3 é proibida. Desenvolva uma função que implemente a promoção de um determinado funcionário. Sua função deve receber o CPF do funcionário e o nível para promoção como parâmetros de entrada.
___
