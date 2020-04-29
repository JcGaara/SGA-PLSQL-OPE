INSERT INTO OPERACION.OPE_TIPOMENSAJE_REL(NOMBRETIPO,ESTTIPO) VALUES('VENCIMIENTO',1);
INSERT INTO OPERACION.OPE_TIPOMENSAJE_REL(NOMBRETIPO,ESTTIPO) VALUES('ANTES SUSPENSION',1);              
INSERT INTO OPERACION.OPE_TIPOMENSAJE_REL(NOMBRETIPO,ESTTIPO) VALUES('DESPUES SUSPENSION',1);              

INSERT INTO OPERACION.OPE_CONFFECHA_DET(CAMPOFECHA) VALUES('FecPrg');
INSERT INTO OPERACION.OPE_CONFFECHA_DET(CAMPOFECHA) VALUES('FecGen');

insert into OPERACION.ope_parametros_det(parametro,valor,tipodedato,longitud) 
values('id_estado','1','Number',1); 

insert into OPERACION.ope_parametros_det(parametro,valor,tipodedato,longitud) 
values('idMensajeCRM','CORTEPF','Varchar(2)',100);

insert into OPERACION.OPE_ESTADOMENSAJE_DET (IDESTADO, NOMBRE, ACTIVO)
values (1, 'GENERADO', 1);

insert into OPERACION.OPE_ESTADOMENSAJE_DET (IDESTADO, NOMBRE, ACTIVO)
values (2, 'ENVIADO', 1);

insert into OPERACION.OPE_ESTADOMENSAJE_DET (IDESTADO, NOMBRE, ACTIVO)
values (3, 'APLICADO', 1);

insert into OPERACION.OPE_ESTADOMENSAJE_DET (IDESTADO, NOMBRE, ACTIVO)
values (4, 'CON ERROR', 1);

insert into OPERACION.OPE_ESTADOMENSAJE_DET (IDESTADO, NOMBRE, ACTIVO)
values (5, 'REVERTIDO', 1);

insert into OPERACION.OPE_ESTADOMENSAJE_DET (IDESTADO, NOMBRE, ACTIVO)
values (6, 'CANCELADO', 1);

commit;

declare
  ln_tipope number;
begin
  select max(tipopedd) into ln_tipope from operacion.tipopedd;

  insert into operacion.tipopedd (tipopedd, descripcion, abrev)
  values (ln_tipope + 1, 'Configurar Internet', 'OPE_INTERNET');

  insert into operacion.opedd (codigoc, descripcion, tipopedd)
  values ('0006', 'Servicio Internet', ln_tipope + 1);

  insert into operacion.tipopedd (tipopedd, descripcion, abrev)
  values (ln_tipope + 2, 'Comando Proceso', 'ITW_PROCESO');

  insert into operacion.opedd (codigon, descripcion, tipopedd)
  values (6, 'Proceso de Envio', ln_tipope + 2);

  commit;

exception
  when others then
    rollback;  
end;

/