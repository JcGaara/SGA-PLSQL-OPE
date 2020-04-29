-- Create table
create table OPERACION.INT_PLATAFORMA_BSCS
(
  idtrans           NUMBER(8) not null,
  codigo_cliente    VARCHAR2(15),
  codigo_cuenta     VARCHAR2(15),
  ruc               VARCHAR2(15),
  nombre            VARCHAR2(150),
  apellidos         VARCHAR2(150),
  tipdide           VARCHAR2(3),
  ntdide            VARCHAR2(15),
  razon             VARCHAR2(150),
  telefonor1        VARCHAR2(15),
  telefonor2        VARCHAR2(15),
  email             VARCHAR2(50),
  direccion         VARCHAR2(480),
  referencia        VARCHAR2(480),
  distrito          VARCHAR2(40),
  provincia         VARCHAR2(40),
  departamento      VARCHAR2(40),
  co_id             VARCHAR2(15),
  numero            VARCHAR2(15),
  imsi              VARCHAR2(15),
  ciclo             VARCHAR2(2),
  action_id         NUMBER(2),
  trama             VARCHAR2(1500),
  plan_base         NUMBER(8),
  plan_opcional     NUMBER(8),
  plan_old          NUMBER(8),
  plan_opcional_old NUMBER(8),
  numero_old        VARCHAR2(15),
  imsi_old          VARCHAR2(15),
  codusu            VARCHAR2(30) default USER not null,
  fecusu            DATE default SYSDATE not null,
  usumod            VARCHAR2(30),
  fecmod            DATE,
  resultado         VARCHAR2(5),
  message_resul     VARCHAR2(50)
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.INT_PLATAFORMA_BSCS
  add constraint PK_IDTRANS primary key (IDTRANS);
