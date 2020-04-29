-- Adicionar columna
alter table operacion.CLRHT_TRMODELO add trv_modelo_inc varchar2(50);
-- Adicionar comentario a la columna nueva 
comment on column operacion.CLRHT_TRMODELO.trv_modelo_inc
  is 'Modelo del Incognito';
/