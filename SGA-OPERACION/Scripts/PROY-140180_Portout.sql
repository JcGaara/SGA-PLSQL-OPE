 -- Add/modify columns 
alter table OPERACION.SGAT_PORTOUTCORPLOG add pocv_ases_email  varchar2(100) ;
alter table OPERACION.SGAT_PORTOUTCORPLOG add pocv_superv_email  varchar2(100);
alter table OPERACION.SGAT_PORTOUTCORPLOG add POCD_FECIN date default SYSDATE  ;
alter table OPERACION.SGAT_PORTOUTCORPLOG add POCN_ESTADO NUMBER(1)  ;

-- Add comments to the columns 
comment on column OPERACION.SGAT_PORTOUTCORPLOG.pocv_ases_email
  is 'Correo del ejecutivo ';
comment on column OPERACION.SGAT_PORTOUTCORPLOG.pocv_superv_email
  is 'Correo del supervisor ';
comment on column OPERACION.SGAT_PORTOUTCORPLOG.pocn_estado
  is '1 Se envió mensaje,
0 No se envió mensaje
';
comment on column OPERACION.SGAT_PORTOUTCORPLOG.pocd_fecin
  is 'Fecha de envió ';
/