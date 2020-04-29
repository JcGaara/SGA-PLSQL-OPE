-- Create table
create table OPERACION.SIAC_POSTVENTA_PROCESO
(
  idprocess     NUMBER not null,
  cod_id        CHAR(10),
  customer_id   VARCHAR2(15),
  tipo_trans    VARCHAR2(30),
  cod_intercaso VARCHAR2(30),
  tipo_via      NUMBER(2),
  nom_via       VARCHAR2(60),
  num_via       VARCHAR2(50),
  tip_urb       NUMBER(4),
  nomurb        VARCHAR2(50),
  manzana       VARCHAR2(5),
  lote          VARCHAR2(5),
  ubigeo        CHAR(10),
  codzona       NUMBER(3),
  codplano      VARCHAR2(10),
  codedif       NUMBER(8),
  referencia    VARCHAR2(340),
  observacion   VARCHAR2(4000),
  fec_prog      DATE,
  franja_hor    VARCHAR2(50),
  num_carta     NUMBER(15),
  operador      NUMBER,
  presuscrito   NUMBER,
  publicar      NUMBER,
  tmcode        NUMBER,
  lst_tipequ    VARCHAR2(4000),
  lst_coser     VARCHAR2(4000),
  lst_sncode    VARCHAR2(4000),
  lst_spcode    VARCHAR2(4000),
  usureg        VARCHAR2(15),
  fecreg        DATE
)
;
-- Add comments to the columns 
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.idprocess
  is 'Identificador del Procesos';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.cod_id
  is 'Codigo agrupador proyectos de BSCS';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.customer_id
  is 'Codigo agrupador de Cliente de BSCS';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.tipo_trans
  is 'Tipo de Venta Menor';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.cod_intercaso
  is 'Intercaso';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.tipo_via
  is 'Tipo de Via';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.nom_via
  is 'Nombre de Via';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.num_via
  is 'Numero de Via';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.tip_urb
  is 'Tipo de Urbanizacion';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.nomurb
  is 'Nombre de Urbanizacion';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.manzana
  is 'Manzana';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.lote
  is 'Lote';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.ubigeo
  is 'Codido de UBIGEO';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.codzona
  is 'Codigo de Zona';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.codplano
  is 'Codigo de Plano';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.codedif
  is 'Codigo de Edificacion';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.referencia
  is 'Referencia';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.observacion
  is 'Observacion';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.fec_prog
  is 'Fecha de Programacion';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.franja_hor
  is 'Franja de Hora';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.num_carta
  is 'Numero de Carta';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.operador
  is 'Operador';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.presuscrito
  is 'Flg Presuscrito';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.publicar
  is 'Flg Publicar';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.tmcode
  is 'Planes';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.lst_tipequ
  is 'Lista de equipos a instanciar';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.lst_coser
  is 'COSER';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.lst_sncode
  is 'Lista de Servicios a Instanciar';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.lst_spcode
  is 'SPCODE';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.usureg
  is 'Usuario Registro';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.fecreg
  is 'Fecha de Registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SIAC_POSTVENTA_PROCESO
  add constraint PK_SIAC_POSTVENTA primary key (IDPROCESS);
