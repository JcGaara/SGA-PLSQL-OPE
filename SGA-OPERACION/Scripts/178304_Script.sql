alter table OPERACION.AGENDAMIENTO add nodo VARCHAR2(30);
comment on column OPERACION.AGENDAMIENTO.nodo
  is 'Nodo/Anillo';

-- Add/modify columns 
alter table OPERACION.SOLOTPTODOC add orden_sot NUMBER;
-- Add comments to the columns 
comment on column OPERACION.SOLOTPTODOC.orden_sot
  is 'Orden SOLOTPTOETA';