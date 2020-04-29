-- Create table
create table OPERACION.TRSOAC
(
  IDTRSOAC     NUMBER not null,
  CODCLI       VARCHAR2(10),
  IDFAC        VARCHAR2(10),
  NUMSLC       VARCHAR2(10),
  IDGRUPOCORTE NUMBER,
  USUARIO      VARCHAR2(50),
  CODSOLOT     NUMBER,
  EST_ENVIO    NUMBER default 0,
  FECUSU       DATE default SYSDATE,
  CODUSU       VARCHAR2(30) default USER,
  AUD_PC       VARCHAR2(30) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  AUD_IP       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  IDOAC        NUMBER,
  IDTRANCORTE  NUMBER,
  FECINIEJE    DATE
)
tablespace OPERACION_DAT ;
-- Add comments to the table 
comment on table OPERACION.TRSOAC
  is 'Transacciones de OAC';
-- Add comments to the columns 
comment on column OPERACION.TRSOAC.IDTRSOAC
  is 'ID PK';
comment on column OPERACION.TRSOAC.CODCLI
  is 'Codigo Cliente';
comment on column OPERACION.TRSOAC.IDFAC
  is 'ID Documento';
comment on column OPERACION.TRSOAC.NUMSLC
  is 'Numero Proyecto';
comment on column OPERACION.TRSOAC.IDGRUPOCORTE
  is 'Grupo de Corte';
comment on column OPERACION.TRSOAC.USUARIO
  is 'Usuario ';
comment on column OPERACION.TRSOAC.CODSOLOT
  is 'SOT';
comment on column OPERACION.TRSOAC.EST_ENVIO
  is 'Estado';
comment on column OPERACION.TRSOAC.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.TRSOAC.CODUSU
  is 'Usuario de Registro';
comment on column OPERACION.TRSOAC.AUD_PC
  is 'Es el nombre de la PC donde se registro la petición';
comment on column OPERACION.TRSOAC.AUD_IP
  is 'Es la direccion IP de la PC donde se registro la petición';
comment on column OPERACION.TRSOAC.IDOAC
  is 'Ticket de OAC';
comment on column OPERACION.TRSOAC.IDTRANCORTE
  is 'Id Tran Corte';
comment on column OPERACION.TRSOAC.FECINIEJE
  is 'Fecha de Ejecucion SOT';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TRSOAC
  add constraint TRSOAC_PK primary key (IDTRSOAC)
  using index 
  tablespace OPERACION_DAT;
create index operacion.idx_codsolot01 on operacion.trsoac (CODSOLOT)
  tablespace operacion_idx;