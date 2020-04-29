declare 
v_idcfg number;

v_tipopedd number;
v_idopedd number;

begin

select nvl(max(IDCFG),0) +1 into v_idcfg from  operacion.CFG_ENV_CORREO_CONTRATA;

insert into operacion.CFG_ENV_CORREO_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU, TIPOFORMATO, CONDICION1, CAMPOFECHA, CAMPOSOT, CAMPOPROY, PUBLICA, TITULO, DATAWINDOW, ORDEN, QUERY, SYNTAXDW)
values (v_idcfg, 'VALIDA_DESPACHO', '', '', '', '', '', 0, '', 'SOLOT', 1, SYSDATE, USER, 'SQL', '', '', '', '', 0, '', '', 1, 'SELECT * FROM TABLE', '');

select nvl(max(IDCFG),0) +1 into v_idcfg from  operacion.CFG_ENV_CORREO_CONTRATA;

insert into operacion.CFG_ENV_CORREO_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU, TIPOFORMATO, CONDICION1, CAMPOFECHA, CAMPOSOT, CAMPOPROY, PUBLICA, TITULO, DATAWINDOW, ORDEN, QUERY, SYNTAXDW)
values (v_idcfg, 'PRESUPUESTO_MASIVO', '', '', '', '', '', 0, '', 'SOLOT', 1, SYSDATE, USER, 'SQL', '', '', '', '', 0, '', '', 1, 'SELECT * FROM TABLE', '');


select nvl(max(TIPOPEDD),0) +1 into v_tipopedd from operacion.tipopedd;

insert into operacion.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values (v_tipopedd, 'Descarga Automática Materiales', 'REINTENTOS_DESPACHO');


select nvl(max(IDOPEDD),0) +1 into v_idopedd from operacion.opedd;

insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (v_idopedd, '', 5, 'reintentos de Presupuesto', 'PRESUPUESTO', v_tipopedd, null);


select nvl(max(IDOPEDD),0) +1 into v_idopedd from operacion.opedd;

insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (v_idopedd, '', 5, 'reintentos de Despacho', 'DESPACHO', v_tipopedd, null);
 
commit;

end;
/
 
