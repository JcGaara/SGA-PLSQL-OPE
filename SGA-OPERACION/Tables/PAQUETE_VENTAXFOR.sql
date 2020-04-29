
-- Create table
create table OPERACION.PAQUETE_VENTAXFOR
( CODFOR NUMBER  not null,
  IDPAQ NUMBER  not null,
  FECUSU DATE DEFAULT SYSDATE,
  CODUSU VARCHAR2(30) DEFAULT USER
) ;
-- Add comments to the table 
comment on table OPERACION.PAQUETE_VENTAXFOR
  is 'Tabla para instanciar las formulas por el paquete de venta de la SOT';
-- Add comments to the columns 
comment on column OPERACION.PAQUETE_VENTAXFOR.CODFOR
  is 'Codigo de formula';
comment on column OPERACION.PAQUETE_VENTAXFOR.IDPAQ
  is 'Id Paquete';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.PAQUETE_VENTAXFOR
  add constraint PK_PAQUETE_VENTAXFOR primary key (CODFOR, IDPAQ);
  
alter table OPERACION.PAQUETE_VENTAXFOR
  add constraint FK_PAQUETE_VENTAXFOR_FORMULA foreign key (CODFOR)
  references OPERACION.FORMULA (CODFOR);
 