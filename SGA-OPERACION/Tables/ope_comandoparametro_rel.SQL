-- Create table
create table OPERACION.OPE_COMANDOPARAMETRO_REL
(
  IDDETALLE   NUMBER not null,
  IDCOMANDO   NUMBER not null,
  IDPARAMETRO NUMBER not null,
  FECMOD      DATE default SYSDATE,
  USUMOD      VARCHAR2(30) default USER,
  FECREG      DATE default SYSDATE,
  USUREG      VARCHAR2(30) default USER,
  VALOR       VARCHAR2(25),
  ESTADO      NUMBER default 1,
  FLG_XML     NUMBER
)
tablespace OPERACION_DAT
  ;
-- Add comments to the table 
comment on table OPERACION.OPE_COMANDOPARAMETRO_REL
  is 'TABLA RELACIONAL DE COMANDO POR PARAMETRO';
-- Add comments to the columns 
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.IDDETALLE
  is 'IDENTIFICADOR DE LA TABLA';
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.IDCOMANDO
  is 'CODIGO DE COMANDO';
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.IDPARAMETRO
  is 'CODIGO DE PARAMETRO';
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.FECMOD
  is 'FECHA DE CREACION';
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.USUMOD
  is 'USUARIO DE CREACION';
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.FECREG
  is 'FECHA DE CAMBIO';
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.USUREG
  is 'USUARIO DE CAMBIO';
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.VALOR
  is 'valor del campo';
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.ESTADO
  is 'ESTADO';
comment on column OPERACION.OPE_COMANDOPARAMETRO_REL.FLG_XML
  is '0: Indica que no va en el XML que se envia a Intraway, 1:Va en el XML que se envia a Intraway';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_COMANDOPARAMETRO_REL
  add constraint PK_COMANPARAM primary key (IDDETALLE)
  using index 
  tablespace OPERACION_DAT
 ;
alter table OPERACION.OPE_COMANDOPARAMETRO_REL
  add constraint FK_COMANPARA1 foreign key (IDCOMANDO)
  references OPERACION.OPE_COMANDO_REL (IDCOMANDO);
alter table OPERACION.OPE_COMANDOPARAMETRO_REL
  add constraint FK_COMANPARA2 foreign key (IDPARAMETRO)
  references OPERACION.OPE_PARAMETROS_DET (IDPARAMETRO);

grant delete on operacion.OPE_COMANDOPARAMETRO_REL to R_PROD;