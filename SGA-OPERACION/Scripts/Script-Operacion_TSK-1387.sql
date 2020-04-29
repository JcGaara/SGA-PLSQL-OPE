alter table operacion.trssolot add idtipenv number;
alter table operacion.trssolot add codemail number;
alter table operacion.trssolot add feccodemail date;
ALTER TABLE operacion.trssolot MODIFY FECCODEMAIL DEFAULT SYSDATE;
comment on column operacion.TRSSOLOT.IDTIPENV is 'Identificador del tipo de envío de recibo';
comment on column operacion.TRSSOLOT.CODEMAIL is 'Identificador del correo';
comment on column operacion.TRSSOLOT.FECCODEMAIL is 'Fecha de registro de correo';

declare
  ln_tipopedd number;
begin

  select max(tipopedd) + 1 into ln_tipopedd from tipopedd;

  insert into tipopedd(tipopedd,descripcion,abrev) 
  values (ln_tipopedd,'Incidencia por tabgrupo mail','INC_TABGRUPO_MAIL');
  
  insert into opedd(codigon,codigoc,abreviacion,tipopedd) values (1,'1','codchannel',ln_tipopedd);  
  insert into opedd(codigon,codigoc,abreviacion,tipopedd) values (2,'2','codsubtype',ln_tipopedd);
  insert into opedd(codigon,codigoc,abreviacion,tipopedd) values (5,'5','codstatus',ln_tipopedd); 
  insert into opedd(codigon,codigoc,abreviacion,tipopedd) values (62,'0062','codtypeservice',ln_tipopedd);
  insert into opedd(codigon,codigoc,abreviacion,tipopedd) values (630,'630','codcase',ln_tipopedd); 
  insert into opedd(codigoc,abreviacion,tipopedd) values ('0','codtypeatention',ln_tipopedd);
  insert into opedd(codigoc,abreviacion,tipopedd) values ('1','flagfounded',ln_tipopedd);
  insert into constante(constante,tipo,valor,descripcion) values('FAM_PYME','C','0073','Codigo de Familia Paquetes Pyme en HFC');
  insert into constante(constante,tipo,valor,descripcion) values('AFIL_PYME','N','4782','Concepto de Descuento por afiliación de recibo por correo electrónico CE_HFC');
  insert into constante(constante,tipo,valor,descripcion) values('AFIL_MAS','N','4777','Concepto de Descuento por afiliación de recibo por correo electrónico');
  insert into constante(constante,tipo,valor,descripcion) values('DIR_AFIL','C','REC_DTH','Nombre de directorio en dba_directories para afiliacion electronica');                                
end; 
/
commit;