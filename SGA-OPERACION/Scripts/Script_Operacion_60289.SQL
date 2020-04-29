-- Adicionar Tipo de Trabajo para Altas 
insert into operacion.opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
     values ( 'PIM', 658, 'Trabajo para SOT de Alta para Portabilidad Masiva HFC', 'TWA',( select tp.tipopedd from operacion.tipopedd tp where tp.abrev = 'PARAM_PORTA'));
commit;     
