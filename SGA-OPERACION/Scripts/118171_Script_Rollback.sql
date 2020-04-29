
alter table operacion.agendamiento drop (codcuadrilla, numveces);
alter table operacion.agendamiento_log drop (codcuadrilla, numveces);
alter table OPERACION.CUADRILLAXCONTRATA modify CODCUADRILLA VARCHAR2(5);

