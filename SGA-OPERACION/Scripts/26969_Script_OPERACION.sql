/**************************************************************************
Propósito          : Script para la inserción de datos en Tablas
Creado por         : QSoftGroup 
Fec. Creación      : 07/04/2017
Fec. Actualización : -
***************************************************************************/

-- TABLAS: OPERACION.TIPOPEDD y OPERACION.OPEDD
declare V_MAX_T number;
        V_MAX_O number;

begin
  V_MAX_T:=0;
  SELECT MAX(TIPOPEDD)
  INTO V_MAX_T
  FROM OPERACION.TIPOPEDD;

  V_MAX_T:=V_MAX_T+1;
  
  insert into OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV) VALUES(V_MAX_T, 'PARAMETROS IP6',	'IP6');
  
  V_MAX_O:=0;
  SELECT MAX(IDOPEDD)
  INTO V_MAX_O
  FROM OPERACION.OPEDD;

  V_MAX_O:=V_MAX_O+1;
  insert into OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX) VALUES(V_MAX_O,null,120,	'RANGO MINIMO PARA IP WAN',	'RANGO_WAN',	V_MAX_T,	0);
  V_MAX_O:=V_MAX_O+1;  
  insert into OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX) VALUES(V_MAX_O,null,56,	'RANGO MAXIMO PARA IP LAN',	'RANGO_LAN',	V_MAX_T,	0);
  V_MAX_O:=V_MAX_O+1;  
  insert into OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX) VALUES(V_MAX_O,null,123,'RANGO MAXIMO PARA IP WAN',	'RANGOMAX_WAN',	V_MAX_T,	0);
  V_MAX_O:=V_MAX_O+1;  
  insert into OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX) VALUES(V_MAX_O,null,126,'RANGO MAXIMO PARA IP WAN',	'RANGO_MAXWAN',	V_MAX_T,	0);
  V_MAX_O:=V_MAX_O+1;  
  insert into OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX) VALUES(V_MAX_O,null,120,'RANGO PARA LOOPBACK',	'RANGO_LOOP',	V_MAX_T,	0);
  V_MAX_O:=V_MAX_O+1;  
  insert into OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX) VALUES(V_MAX_O,null,126,'RANGO PARA LOOPBACK'	,'RANGO_LOOP',	V_MAX_T,	0);
  commit;
 end;
/