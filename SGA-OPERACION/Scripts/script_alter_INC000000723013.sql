-- Add/modify columns 
alter table OPERACION.OPE_SP_MAT_EQU_DET add id_tecnologia VARCHAR2(200);
alter table OPERACION.OPE_SP_MAT_EQU_DET add id_cod_sitio VARCHAR2(100);
alter table OPERACION.OPE_SP_MAT_EQU_DET add name_sitio VARCHAR2(4000);
-- Add comments to the columns 
comment on column OPERACION.OPE_SP_MAT_EQU_DET.id_tecnologia
  is 'ID_TECNOLOGIA';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.id_cod_sitio
  is 'CODIGO DE SITIO DE SAP';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.name_sitio
  is 'NOMBRE DE SITIO DE SAP';

  /*********  Insertar Constantes ************/
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,tipopedd,codigon_aux)
values ('1', 7, 'Pdte. UT', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),0);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,tipopedd,codigon_aux)
values ('1', 8, 'Pdte. PEP', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),0);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,tipopedd,codigon_aux)
values ('1', 9, 'Observado UT', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),0);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,tipopedd,codigon_aux)
values ('1', 10, 'Observado Req', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),0);

commit;