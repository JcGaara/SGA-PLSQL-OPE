/*Agregamos registro  "Telmex Negocio - Pymes ne HFC" en opedd*/

insert into opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX ) values (
60, 'Telmex Negocio - Pymes en HFC', '60', 
( select d.tipopedd from operacion.tipopedd d where d.abrev = 'CAMP_PORT_CORP' ), 1
);
   
commit;
/


