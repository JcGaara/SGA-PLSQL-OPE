


--Agregar campos nuevos en tabla: agendamiento
alter table OPERACION.AGENDAMIENTO add 
( codcuadrilla varchar2(30),  numveces          NUMBER);
comment on column OPERACION.AGENDAMIENTO.codcuadrilla
  is 'codigo de cuadrilla tabla: OPERACION.CUADRILLAXCONTRATA';
comment on column OPERACION.AGENDAMIENTO.numveces
  is 'Numero de veces que se puede realizar reagendamientos : num max = 3';

--Agregar campos nuevos en tabla: agendamiento_log
alter table OPERACION.AGENDAMIENTO_LOG add 
( codcuadrilla varchar2(30),  numveces          NUMBER);
comment on column OPERACION.AGENDAMIENTO_LOG.codcuadrilla
  is 'codigo de cuadrilla tabla: OPERACION.CUADRILLAXCONTRATA';
comment on column OPERACION.AGENDAMIENTO_LOG.numveces
  is 'Numero de veces que se puede realizar reagendamientos : num max = 3';


-- Add/modify columns 
alter table OPERACION.CUADRILLAXCONTRATA modify CODCUADRILLA VARCHAR2(30);

-- Add comments to the columns 
comment on column OPERACION.TIPTRABAJO.AGENDABLE
  is '1: AGENDAMIENTO EN LINEA , 0 : NORMAL 2: AGENDAMIENTO X RANGOS';

