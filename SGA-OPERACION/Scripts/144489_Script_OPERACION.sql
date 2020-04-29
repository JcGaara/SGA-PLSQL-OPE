alter table OPERACION.SOLOT add NUMSEC NUMBER(20);
comment on column OPERACION.SOLOT.NUMSEC
  is 'ID del registro de la venta del servicio en el SISACT';
alter table OPERACION.TRS_WS_SGA add ID_CLIENTE VARCHAR2(30);
comment on column OPERACION.TRS_WS_SGA.ID_CLIENTE
  is 'Código de cliente';

-- Add/modify columns 
alter table OPERACION.SOLOT add FLG_RETENCION number(1);
-- Add comments to the columns 
comment on column OPERACION.SOLOT.FLG_RETENCION
  is '1: Cliente solo retencion 2: Cliente retencion y Downgrade';
