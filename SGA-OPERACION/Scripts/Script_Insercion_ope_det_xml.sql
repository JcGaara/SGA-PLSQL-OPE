
insert into OPERACION.OPE_det_XML
  (IDCAB,
   IDSEQ,
   CAMPO,
   NOMBRECAMPO,
   TIPO,
   ESTADO,
   ORDEN,
   DESCRIPCION)
values
  ((select max(IDCAB) from OPERACION.OPE_CAB_XML ),
   (select max(IDSEQ) + 1 from OPERACION.OPE_det_XML ),
   'f_ipApplicacion',
   'select sys_context (''USERENV'',''IP_ADDRESS'') from dummy_ope',
   2,
   1,
   2,
   null);

insert into OPERACION.OPE_det_XML
  (IDCAB,
   IDSEQ,
   CAMPO,
   NOMBRECAMPO,
   TIPO,
   ESTADO,
   ORDEN,
   DESCRIPCION)
values
  ((select max(IDCAB) from OPERACION.OPE_CAB_XML ),
   (select max(IDSEQ) + 1 from OPERACION.OPE_det_XML ),
   'f_idTransaccion',
   'select to_number(to_char(sysdate, ''YYYYMMDDHH24MISS'')) from dummy_ope',
   2,
   0,
   1,
   null);

insert into OPERACION.OPE_det_XML
  (IDCAB,
   IDSEQ,
   CAMPO,
   NOMBRECAMPO,
   TIPO,
   ESTADO,
   ORDEN,
   DESCRIPCION)
values
  ((select max(IDCAB)from OPERACION.OPE_CAB_XML ),
   (select max(IDSEQ) + 1 from OPERACION.OPE_det_XML ),
   'f_usuarioAplicacion',
   'select user from dummy_ope',
   2,
   1,
   4,
   null);

insert into OPERACION.OPE_det_XML
  (IDCAB,
   IDSEQ,
   CAMPO,
   NOMBRECAMPO,
   TIPO,
   ESTADO,
   ORDEN,
   DESCRIPCION)
values
  ((select max(IDCAB)from OPERACION.OPE_CAB_XML ),
   (select max(IDSEQ) + 1 from OPERACION.OPE_det_XML ),
   'f_nroSerie',
   null,
   1,
   0,
   5,
   null);

insert into OPERACION.OPE_det_XML
  (IDCAB,
   IDSEQ,
   CAMPO,
   NOMBRECAMPO,
   TIPO,
   ESTADO,
   ORDEN,
   DESCRIPCION)
values
  ((select max(IDCAB) from OPERACION.OPE_CAB_XML ),
   (select max(IDSEQ) + 1 from OPERACION.OPE_det_XML ),
   'f_nombreAplicacion',
   'select sys_context(''USERENV'', ''MODULE'') from dummy_ope',
   2,
   1,
   3,
   null);
commit;
/