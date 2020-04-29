--CONFIGURACIONES
insert into tipopedd (tipopedd,descripcion,abrev) values ((select max(tipopedd)+1 from tipopedd),'Tipo Trabajo Inst. HFC','TIPTRA_ANULA_SOT_INST_HFC');
insert into opedd (codigoc,codigon,descripcion,tipopedd)
values ('ACTIVO',424,'HFC - Instalación de paquetes TODO CLARO Digital',(select max(tipopedd) from tipopedd));

insert into tipopedd (tipopedd,descripcion,abrev) values ((select max(tipopedd)+1 from tipopedd),'Días para anular SOT INST HFC','DIAS_ANULA_SOT_INST_HFC');
insert into opedd (codigoc,codigon,descripcion,tipopedd)
values ('UNICO',30,'Cantidad de días para anular Sot de Instalación HFC Rechazada',(select max(tipopedd) from tipopedd));

insert into tipopedd (tipopedd,descripcion,abrev) values ((select max(tipopedd)+1 from tipopedd),'Emails Trabajo Inst. HFC','EMAIL_ANULA_SOT_INST_HFC');
insert into opedd (codigoc,codigon,descripcion,tipopedd)
values ('ACTIVO',1,'maria.espinoza@claro.com.pe',(select max(tipopedd) from tipopedd));

insert into tipopedd (tipopedd,descripcion,abrev) values ((select max(tipopedd)+1 from tipopedd),'UTL FILE Trabajo Inst. HFC','UTL_FILE_ANULA_SOT_INST_HFC');
insert into opedd (codigoc,codigon,descripcion,tipopedd)
values ('ACTIVO',1,'/u03/oracle/PESGAPRD/UTL_FILE',(select max(tipopedd) from tipopedd));

commit;

-- Add/modify columns 
alter table OPERACION.SOLOT add n_sec_proc_shell number(8);
-- Add comments to the columns 
comment on column OPERACION.SOLOT.n_sec_proc_shell
  is 'Numero secuencial del proceso shell de anulacion de sots rechazadas de instalacion hfc';


