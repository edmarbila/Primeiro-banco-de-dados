# As tarefas foram feitas na tabela esquema_estrutural
# com os comando UPDATE, DELETE E INSERT
# e o comando SELECT FROM tambem feito nesta tabela para validação
# ao executar o script vai possuir apenas 2 IDs na tabela esquema_estrutural pois
# o ID 3 é criado e logo após é excluido com o comando DELETE.

# REGRAS
# Relacionamento 1 - n onde possibilita 1 cliente ter varios projetos porem 1 projeto
# para apenas um cliente, assim como terreno, orçamento e materiais que um projeto
#pode ter varios materiais porém os materias só pode ter 1 projeto vinculado.

# Na tabela laudos os campos são validados com 0 para Reprovado e 1 para Aprovado

DROP DATABASE IF EXISTS arquiteto; 
CREATE DATABASE arquiteto;
USE  arquiteto;

#----------------------------------------------------------------------------
# CRIAÇÃO DAS TABELAS
#----------------------------------------------------------------------------

DROP TABLE IF EXISTS clientes;

CREATE TABLE IF NOT EXISTS clientes (

clientes_id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR (50) NOT NULL,
sobrenome VARCHAR (50) NOT NULL,
cpf VARCHAR (14) DEFAULT "000.000.000-00" NOT NULL,
telefones VARCHAR (28) DEFAULT "(00)00000-0000" NOT NULL,
email VARCHAR (100) DEFAULT "dhrouseestouapanhando@dh.com" NOT NULL,
logradouro VARCHAR (150) DEFAULT "Rua Municipal"  NOT NULL,
cidade VARCHAR (100) DEFAULT "Franco da Rocha" NOT NULL,
estado VARCHAR (2) DEFAULT "SP" NOT NULL,
cep VARCHAR (9) DEFAULT "00000-000" NOT NULL NOT NULL,

    PRIMARY KEY ( clientes_id )
);

DROP TABLE IF EXISTS terreno;

CREATE TABLE IF NOT EXISTS terreno (

terreno_id INT NOT NULL AUTO_INCREMENT,
metragem DECIMAL (6,2) NOT NULL,
topografia VARCHAR (15),
nivel_rua DECIMAL (4,2),
nivel_fundos DECIMAL (4,2),
logradouro VARCHAR (150) DEFAULT "Rua Municipal" NOT NULL,
estado VARCHAR (2) DEFAULT "SP" NOT NULL,
cidade VARCHAR (100) DEFAULT "SP" NOT NULL,
cep VARCHAR (9) DEFAULT "00000-000" NOT NULL,
clientes_id INT,

    PRIMARY KEY ( terreno_id ),
  
     CONSTRAINT FK_terrenocliente
       FOREIGN KEY  ( clientes_id )
         REFERENCES clientes ( clientes_id )
);

DROP TABLE IF EXISTS projetos;

CREATE TABLE IF NOT EXISTS projetos (

projetos_id INT NOT NULL AUTO_INCREMENT,
CA TINYINT  NOT NULL,
taxa_ocupacao DECIMAL (6,2) NOT NULL,
TP  VARCHAR (3),
Area_Total DECIMAL (6,2) NOT NULL,
Area_Maxima DECIMAL (6,2) NOT NULL,
Pavimentos VARCHAR (20),
tipo_projeto VARCHAR (20),
recuo_frontal  DECIMAL (4,2) NOT NULL,
recuo_fundos DECIMAL (4,2) NOT NULL,
recuo_lateral_dir DECIMAL (4,2) NOT NULL,
recuo_lateral_esq DECIMAL (4,2) NOT NULL,
direcao_fachada VARCHAR (10),
terreno_id INT,
arquiteto_id INT,
clientes_id INT,

   PRIMARY KEY ( projetos_id ),
   
     CONSTRAINT FK_terreproje
	   FOREIGN KEY ( terreno_id )
          REFERENCES terreno ( terreno_id ),
          
   
     CONSTRAINT FK_clienproje
	   FOREIGN KEY ( clientes_id )
          REFERENCES clientes ( clientes_id )
);

DROP TABLE IF EXISTS arquiteto_responsavel;

CREATE TABLE IF NOT EXISTS arquiteto_responsavel (

arquiteto_id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR (50),
sobrenome VARCHAR (50),
cau TINYINT (15),
Especialidade VARCHAR (50) NOT NULL,
telefones VARCHAR (28) ,
email VARCHAR (100),
projetos_id INT,

   PRIMARY KEY ( arquiteto_id ),
   
     CONSTRAINT FK_arquiproje
       FOREIGN KEY ( projetos_id )
         REFERENCES projetos ( projetos_id )
);

#--------------------------------------------------------------
# Inserção de dados na tabela arquiteto_responsavel
#--------------------------------------------------------------

INSERT INTO arquiteto_responsavel
            (nome, sobrenome, cau, Especialidade, 
             telefones, email)
             
        VALUES ("Edmar", "Bila", "0000000000","Projetista",
                "(11)90000-0000", "arquitetobila@dh.com");



DROP TABLE IF EXISTS orcamento;

CREATE TABLE IF NOT EXISTS orcamento (

orcamento_id INT NOT NULL AUTO_INCREMENT,
custo_materiais DECIMAL (8,2) NOT NULL,
custo_projeto DECIMAL (8,2) NOT NULL,
custo_esquadrias DECIMAL (8,2) NOT NULL,
custo_hidraulica DECIMAL (8,2) NOT NULL,
custo_eletrica DECIMAL (8,2) NOT NULL,
valor_total DECIMAL (9,2) NOT NULL,
projetos_id INT,
clientes_id INT,
arquiteto_id INT,

   PRIMARY KEY ( orcamento_id ),
   
   CONSTRAINT FK_orpro
	   FOREIGN KEY ( projetos_id )
          REFERENCES projetos ( projetos_id ),
        
	 CONSTRAINT FK_orcli
	   FOREIGN KEY ( clientes_id )
		  REFERENCES clientes ( clientes_id ),
            
	 CONSTRAINT FK_orarq
	   FOREIGN KEY ( arquiteto_id )
		  REFERENCES arquiteto_responsavel ( arquiteto_id )
);

DROP TABLE IF EXISTS prazo;

CREATE TABLE IF NOT EXISTS prazo (

prazo_id  INT NOT NULL AUTO_INCREMENT,
data_inicial DATETIME,
data_prevista DATE,
data_entrega DATETIME,
projetos_id INT,

   PRIMARY KEY ( prazo_id ),
   
   CONSTRAINT FK_prapro
	   FOREIGN KEY ( projetos_id )
		  REFERENCES projetos ( projetos_id)
);

DROP TABLE IF EXISTS laudo_aprovacoes;

CREATE TABLE IF NOT EXISTS laudo_aprovacoes (

laudo_aprovacoes_id  INT NOT NULL AUTO_INCREMENT,
laudo_prefeitura TINYINT NOT NULL,
laudo_bombeiros TINYINT NOT NULL,
status_liberação_projeto TINYINT NOT NULL,
arquiteto_id INT NOT NULL,
projetos_id INT NOT NULL,

   PRIMARY KEY ( laudo_aprovacoes_id ),
   
   CONSTRAINT FK_lauarq
	   FOREIGN KEY ( arquiteto_id )
		  REFERENCES arquiteto_responsavel ( arquiteto_id),
          
     CONSTRAINT FK_laupro
	   FOREIGN KEY ( projetos_id)
		  REFERENCES projetos ( projetos_id)
          
# USAR 0 PARA REPROVADO E 1 PARA APROVADO PARA CONTROLE 
# DE APEOVAÇÕES.
);

DROP TABLE IF EXISTS esquema_estrutural;

CREATE TABLE IF NOT EXISTS esquema_estrutural (

esquema_estrutural_id INT NOT NULL AUTO_INCREMENT,
material_estrutura VARCHAR (40) NOT NULL,
material_paredes VARCHAR (40) NOT NULL,
material_laje VARCHAR (40) NOT NULL,
meterial_vedacao VARCHAR (40) NOT NULL,
Area_Maxima VARCHAR (10) NOT NULL,
projetos_id INT,

   PRIMARY KEY ( esquema_estrutural_id ),
   
   CONSTRAINT FK_esqpro 
      FOREIGN KEY (projetos_id) 
        REFERENCES projetos (projetos_id)
);

#-----------------------------------------------------------
#inserção de dados tabela esquema estrutural
#-----------------------------------------------------------

INSERT INTO esquema_estrutural 
            (material_estrutura, material_paredes,
            material_laje,  meterial_vedacao, Area_Maxima)
 
     VALUES ("estrutura em ferro", "alvenaria em tijolos", 
              "laje tipo cogumelo, 60cm expessura", 
              "vedação acustica em EPS", "5,000 m²"
		     );
             
             INSERT INTO esquema_estrutural 
            (material_estrutura, material_paredes,
            material_laje,  meterial_vedacao, Area_Maxima)
 
     VALUES ("estrutura em concreto", "alvenaria em blocos", 
              "laje tipo cogumelo, 60cm expessura", 
              "vedação acustica em EPS", "5,000 m²"
		     );
             
             INSERT INTO esquema_estrutural 
            (material_estrutura, material_paredes,
            material_laje,  meterial_vedacao, Area_Maxima)
 
     VALUES ("estrutura em madeira", "alvenaria em madeira", 
              "laje tipo cogumelo, 60cm expessura", 
              "vedação acustica em EPS", "5,000 m²"
		     );
#-----------------------------------------------------------  
 # Atualização de dados tabela esquema_estrutural
#-----------------------------------------------------------

    UPDATE esquema_estrutural SET material_laje = "Concreto industrial"
       WHERE esquema_estrutural_id = 1;
	
#----------------------------------------------------------
# Exclusão de dados tabela esquema_estrutural
#----------------------------------------------------------

    DELETE FROM  esquema_estrutural 
      WHERE esquema_estrutural_id = "3";

#----------------------------------------------------------

DROP TABLE IF EXISTS materiais_internos;

CREATE TABLE IF NOT EXISTS materiais_internos (

materiais_internos_id INT NOT NULL AUTO_INCREMENT,
suite VARCHAR (40) NOT NULL,
quarto_hospedes VARCHAR (40) NOT NULL,
dormitorio_1 VARCHAR (40) NOT NULL,
dormitorio_2 VARCHAR (40) NOT NULL,
sala VARCHAR (40) NOT NULL,
cozinha VARCHAR (40) NOT NULL,
area_servicos VARCHAR (40) NOT NULL,
area_lazer VARCHAR (40) NOT NULL,
banheiros VARCHAR (40) NOT NULL,
projetos_id INT,

   PRIMARY KEY ( materiais_internos_id ),
   
   CONSTRAINT FK_matinpro
      FOREIGN KEY (projetos_id)
        REFERENCES projetos (projetos_id)
);

DROP TABLE IF EXISTS materiais_externos;

CREATE TABLE IF NOT EXISTS materiais_externos (

materiais_externos_id INT NOT NULL AUTO_INCREMENT,
fachada  VARCHAR (40) NOT NULL,
fundos   VARCHAR (40) NOT NULL,
laterais VARCHAR (40) NOT NULL,
telhado  VARCHAR (40) NOT NULL,
garagem  VARCHAR (40) NOT NULL,
limites  VARCHAR (40) NOT NULL,
area_servicos VARCHAR (40) NOT NULL,
area_lazer VARCHAR (40) NOT NULL,
banheiros VARCHAR (40) NOT NULL,
projetos_id INT,

   PRIMARY KEY ( materiais_externos_id ),
    
     CONSTRAINT fk_matexpro
      FOREIGN KEY (projetos_id)
        REFERENCES projetos (projetos_id)
);

ALTER TABLE projetos ADD CONSTRAINT FK_ARQRESPONSA_PROJETO FOREIGN KEY (arquiteto_id) REFERENCES arquiteto_responsavel (arquiteto_id);


  SELECT * FROM esquema_estrutural;
