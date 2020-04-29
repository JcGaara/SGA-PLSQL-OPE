-- Add/modify columns 
alter table OPERACION.UBI_TECNICA add AREA_EMPRESA VARCHAR2(3);
alter table OPERACION.UBI_TECNICA add REGION VARCHAR2(3);
-- Add comments to the columns 
comment on column OPERACION.UBI_TECNICA.AREA_EMPRESA
  is 'Area de Empresa';
comment on column OPERACION.UBI_TECNICA.REGION
  is 'Codigo Departamento en de SGA homologado a SAP';

/*********  Insertar Constantes estados ************/
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 0, 'Generado', 'EST_SOL_PED_F',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),0);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 1, 'Pendiente', 'EST_SOL_PED_F',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),1);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 6, 'En proceso','EST_SOL_PED_F', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),2);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 12, 'Sp generada', 'EST_SOL_PED_F',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),3);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 13, 'PC generada','EST_SOL_PED_F', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),4);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 14, 'PC enviada', 'EST_SOL_PED_F',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),5);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 5, 'Concluido', 'EST_SOL_PED_F',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),6);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 10, 'Observado Req','EST_SOL_PED_F', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),7);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 3, 'Anulado','EST_SOL_PED_F', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),8);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 11, 'Pendiente PPTO','EST_SOL_PED_F', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),9);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 0, 'Generado', 'EST_SOL_PED_M',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),0);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 1, 'Pendiente', 'EST_SOL_PED_M',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),1);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 10, 'Observado Req','EST_SOL_PED_M', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),2);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 8, 'Pendiente PEP', 'EST_SOL_PED_M',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),3);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 7, 'Pendiente UT','EST_SOL_PED_M', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),4);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 15, 'UT creada', 'EST_SOL_PED_M',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),5);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 9, 'Observado UT', 'EST_SOL_PED_M',(select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),6);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 11, 'Pendiente PPTO','EST_SOL_PED_M', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),7);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 6, 'En Proceso','EST_SOL_PED_M', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),8);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 12, 'SP generada','EST_SOL_PED_M', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),9);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 13, 'PC generada','EST_SOL_PED_M', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),10);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 14, 'PC enviada','EST_SOL_PED_M', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),11);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 5, 'Concluido','EST_SOL_PED_M', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),12);

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd,codigon_aux)
values ('1', 3, 'Anulado','EST_SOL_PED_M', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOL_PED'),13);
commit;

/*********  Insertar Constantes usuarios ************/
insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('Confi. Atencion Requisicion', 'CON_ATT_REQ');
commit;     
     
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('C17333', 1, 'Barbara Oviedo Vidal', 'CON_ATT_REQ',(select t.tipopedd from tipopedd t where t.abrev = 'CON_ATT_REQ'));
     
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('C14576', 2, 'Katherine Ulfe Zavala', 'CON_ATT_REQ',(select t.tipopedd from tipopedd t where t.abrev = 'CON_ATT_REQ'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('C24812', 3, 'Leslie Milla', 'CON_ATT_REQ',(select t.tipopedd from tipopedd t where t.abrev = 'CON_ATT_REQ'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('C17733', 4, 'Lourdes Avalo Osorio', 'CON_ATT_REQ',(select t.tipopedd from tipopedd t where t.abrev = 'CON_ATT_REQ'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('C12292', 5, 'Mabel Carpio Arrospide', 'CON_ATT_REQ',(select t.tipopedd from tipopedd t where t.abrev = 'CON_ATT_REQ'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('C10723', 6, 'Segundo Olaya', 'CON_ATT_REQ',(select t.tipopedd from tipopedd t where t.abrev = 'CON_ATT_REQ'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('C14696', 7, 'Alfonso Dill¿erva', 'CON_ATT_REQ',(select t.tipopedd from tipopedd t where t.abrev = 'CON_ATT_REQ'));
commit;

/*********  Insertar Constantes grupo ************/
insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('Grupo Autorizaciones', 'GRUPO_AUTORIZACION');
commit; 


insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('SGPE', 1, 'SGPE', 'GRUPO_AUTORIZACION',(select t.tipopedd from tipopedd t where t.abrev = 'GRUPO_AUTORIZACION'));
     
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('MVP', 2, 'MVP', 'GRUPO_AUTORIZACION',(select t.tipopedd from tipopedd t where t.abrev = 'GRUPO_AUTORIZACION'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('FJPE', 3, 'FJPE', 'GRUPO_AUTORIZACION',(select t.tipopedd from tipopedd t where t.abrev = 'GRUPO_AUTORIZACION'));
commit; 

/*********  Insertar Constantes area_empresa ************/
insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('Area de Empresa', 'AREA_EMPRESA');
commit; 

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('P01', 1, 'RED', 'AREA_EMPRESA',(select t.tipopedd from tipopedd t where t.abrev = 'AREA_EMPRESA'));
     
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('P03', 2, 'COMERCIAL', 'AREA_EMPRESA',(select t.tipopedd from tipopedd t where t.abrev = 'AREA_EMPRESA'));
commit;
/
