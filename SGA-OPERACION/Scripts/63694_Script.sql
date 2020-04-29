-- drop trigger
drop trigger operacion.T_SECUENCIA_EST_AGENDA_BUID;
-- Crear columna
alter table OPERACION.SECUENCIA_ESTADOS_AGENDA add APLICA_CONTRATA number default 1;
comment on column OPERACION.SECUENCIA_ESTADOS_AGENDA.APLICA_CONTRATA
  is '1 : El cambio de estado lo puede realizar la Contrata 0 :  La contrata no puede visualizar el cambio de estado';


-- Crear columna
alter table HISTORICO.SECUENCIA_ESTADOS_AGENDA_LOG add APLICA_CONTRATA number default 1;
comment on column HISTORICO.SECUENCIA_ESTADOS_AGENDA_LOG.APLICA_CONTRATA
  is '1 : El cambio de estado lo puede realizar la Contrata 0 :  La contrata no puede visualizar el cambio de estado';


update OPERACION.OPEDD set codigoc ='DTA' where tipopedd = 209 and idopedd = 4612;
update INTRAWAY.configuracion_itw set codigo_ext ='PRIME DIGITAL' WHERE idconfigitw = 54;
COMMIT;
 