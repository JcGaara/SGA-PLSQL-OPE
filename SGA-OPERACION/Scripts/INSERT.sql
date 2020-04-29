--TIPOPEDD
insert into operacion.tipopedd tp
  (tp.tipopedd, tp.descripcion, tp.abrev)
  select (select max(tipopedd) + 1 from operacion.tipopedd),
         'Conversion de MB a KB',
         'CON_MB_KB'
    from dual;

--OPEDD
insert into operacion.opedd op
  (op.idopedd,
   op.codigon,
   op.descripcion,
   op.abreviacion,
   op.tipopedd,
   op.codigon_aux)
  select (select max(idopedd) + 1 from operacion.opedd),
         1024,
         'Valor de equivalencia en Kb',
         'Valor Kb',
         (select tipopedd
            from operacion.tipopedd
           where descripcion = 'Conversion de MB a KB'
             and abrev = 'CON_MB_KB'),
         0
    from dual;
	
--CONFIGURACION
INSERT INTO operacion.parametro_det_adc (ID_PARAMETRO,CODIGOC,DESCRIPCION,ABREVIATURA,ESTADO,FECCRE,USUCRE,ID_DETALLE) VALUES
('7','XA_Activity_Notes_2','Notas observaciones_2 provenientes de SGA','XANO_2',1,SYSDATE,'IT_CONSULTA','288');

--OPEDD
insert into operacion.opedd op
  (op.idopedd,
   op.codigon,
   op.descripcion,
   op.abreviacion,
   op.tipopedd,
   op.codigon_aux)
  select (select max(idopedd) + 1 from operacion.opedd),
         (select t.tiptra from tiptrabajo t where t.descripcion = 'CLARO EMPRESAS HFC - SERVICIOS MENORES'),
         'CLARO EMPRESAS HFC - SERVICIOS MENORES',
         'HFC_CP',
         (select tipopedd
            from operacion.tipopedd
           where descripcion = 'IW Proceso automatico WS'),
         0
    from dual;
	
COMMIT
/
