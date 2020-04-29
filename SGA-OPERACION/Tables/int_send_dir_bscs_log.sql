create table OPERACION.INT_SEND_DIR_BSCS_LOG
(
  id_send         NUMBER(8),
  tipo_instancia  VARCHAR2(100),
  resultado       VARCHAR2(2),
  mensaje         VARCHAR2(1000),
  customer_id     VARCHAR2(15),
  dirsuc          VARCHAR2(1000),
  idplano         VARCHAR2(10),
  ubigeo          VARCHAR2(6),  
  referencia      VARCHAR2(340),
  nomdst          VARCHAR2(40),
  nompvc          VARCHAR2(40),
  codpos          VARCHAR2(20),
  nomest          VARCHAR2(40),
  nompai          VARCHAR2(80),
  codsolot        NUMBER(8),  
  idtareawf       NUMBER(8),
  codcli          VARCHAR2(8) ,
  codsuc          VARCHAR2(10),
  usureg          VARCHAR2(30) DEFAULT USER NOT NULL,
  fecreg          DATE DEFAULT SYSDATE NOT NULL      
);
alter table OPERACION.INT_SEND_DIR_BSCS_LOG
  add constraint PK_ID_SEND primary key (id_send);