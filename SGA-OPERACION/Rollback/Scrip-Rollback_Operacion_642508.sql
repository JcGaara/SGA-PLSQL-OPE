-- Add/modify columns 
alter table OPERACION.OPE_RESERVAHFC_BSCS modify respuestaxml VARCHAR2(600);

--elimanos tabla creada
drop table OPERACION.POSTVENTASIAC_LOG;

--eliminamos el sequence

drop sequence OPERACION.SQ_POSTVENTASIAC_LOG;

COMMIT;
/