insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (10, 'CNLR', 'CNLR-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (718)
      and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : CNLR

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO CNLR 718', 'solotptoeta', 1, to_date('10-04-2012 15:05:46', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (8, 'CNLC', 'CNLC-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (654)
      and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : CNLC

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO CNLC 654', 'solotptoeta', 1, to_date('10-04-2012 14:39:23', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (9, 'CNLR', 'CNLR-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (654)
       and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : CNLR

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO CNLR 654', 'solotptoeta', 1, to_date('10-04-2012 15:05:07', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (11, 'TAFC', 'TAFC-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (653)
   and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate-204, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : FCT

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO TAFC 653', 'solotptoeta', 1, to_date('11-04-2012 15:00:59', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (12, 'TAFR', 'TAFR-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (653)
      and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : TAFR

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO TAFR 653', 'solotptoeta', 1, to_date('11-04-2012 15:18:05', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (13, 'TAFR', 'TAFR-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (717)
       and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : TAFR

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO TAFR 717', 'solotptoeta', 1, to_date('11-04-2012 15:18:26', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (5, 'PINT', 'PINT-', 'SGA Operaciones

Asignaci�n de Contrata
', ' select SOLOTPTO_ID.codsolot sot,
        solot.numslc proyecto,
        vtatabcli.nomcli cliente,
        solotpto.direccion direccion,
        vtatabdst.nomdst distrito,
        SOLOTPTO_ID.observacion descripcion,
        tystabsrv.dscsrv observacion,
        tystipsrv.dsctipsrv dsctipsrv
   from SOLOTPTO_ID, solot, vtatabcli, VTATABDST, tystipsrv, solotpto, tystabsrv
  where SOLOTPTO_ID.codsolot = solot.codsolot
    and solot.codcli = vtatabcli.codcli
    and solotpto.codubi = vtatabdst.codubi
    and solot.tipsrv = tystipsrv.tipsrv
    and SOLOTPTO_ID.punto = solotpto.punto
    and solotpto.codsolot = solot.codsolot
    and solotpto.codsrvnue = tystabsrv.codsrv
    and to_char(SOLOTPTO_ID.FECASIGcon, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : PINT

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Agradeceremos recoger informaci�n adicional o cualquier consulta con el Ing. Melvin Martel al n�mero 610-2941,
para cualquier problema que se suscite con la asignaci�n favor comunicarse con las siguientes personas,
Nidya Alonzo al 613-1000 anexo 8863.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO PINT', 'SOLOTPTO_ID', 1, to_date('10-04-2012 09:47:47', 'dd-mm-yyyy hh24:mi:ss'), 'MIGRACION');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (1, 'CNLC', 'CNLC-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (639)
      and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : CNLC

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO CNLC 639', 'solotptoeta', 1, to_date('10-04-2012 09:47:47', 'dd-mm-yyyy hh24:mi:ss'), 'MIGRACION');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (2, 'CNLR', 'CNLR-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (654,718,639)
       and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : CNLR

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO CNLR 639', 'solotptoeta', 1, to_date('10-04-2012 09:47:47', 'dd-mm-yyyy hh24:mi:ss'), 'MIGRACION');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (3, 'DSN', 'DSN-', 'SGA Operaciones

Asignaci�n de Contrata
', ' select preubi.codsolot SOT,
        solot.numslc proyecto,
        vtatabcli.nomcli cliente,
        preubi.dirobra direccion,
        vtatabdst.nomdst distrito,
        preubi.descripcion descripcion,
        tystabsrv.dscsrv observacion,
        tystipsrv.dsctipsrv dsctipsrv,rownum ContFilas
   from preubi, solot, vtatabcli, VTATABDST, tystipsrv, solotpto, tystabsrv
  where preubi.codsolot = solot.codsolot
    and solot.codcli = vtatabcli.codcli
    and preubi.disobra = vtatabdst.codubi
    and solot.tipsrv = tystipsrv.tipsrv
    and preubi.punto = solotpto.punto
    and solotpto.codsolot = solot.codsolot
    and solotpto.codsrvnue = tystabsrv.codsrv
    and to_char(preubi.FECASIG, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'');', 'La Victoria, #

Se�ores:@

Presente.-

REF. : DSN

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en la oficina del Ing. Adolfo Mart�nez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinch�n 910 - San Isidro, tel�fono 6102332.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO DSN', 'PREUBI', 1, to_date('10-04-2012 09:47:47', 'dd-mm-yyyy hh24:mi:ss'), 'MIGRACION');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (4, 'FCT', 'FCT-', 'SGA Operaciones

Asignaci�n de Contrata
', ' SELECT EFPTO.CODEF PROYECTO,
        VTATABCLI.NOMCLI cliente,
        EFPTO.DIRECCION direccion,
        VTATABDST.NOMDST distrito,
        EFPTO.DESCRIPCION descripcion,
        TYSTABSRV.DSCSRV observacion,
        TYSTIPSRV.DSCTIPSRV,
        EFPTO.FECCONASIG,rownum ContFilas
   FROM EFPTO, VTATABDST, EF, VTATABCLI, TYSTABSRV, TYSTIPSRV, vtatabslcfac
  WHERE (efpto.codubi = vtatabdst.codubi(+))
    and (efpto.codsrv = tystabsrv.codsrv(+))
    and (EFPTO.CODEF = EF.CODEF)
    and (ef.tipsrv = tystipsrv.tipsrv(+))
    and (EF.CODCLI = VTATABCLI.CODCLI)
    and ef.codef = vtatabslcfac.numslc(+)
    and to_char(EFPTO.FECCONASIG_SOP, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : FCT

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en la oficina del Ing. Adolfo Mart�nez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinch�n 910 - San Isidro, tel�fono 6102332.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO FCT', 'EFPTO', 1, to_date('10-04-2012 09:47:47', 'dd-mm-yyyy hh24:mi:ss'), 'MIGRACION');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (7, 'TAFR', 'TAFR-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (638)
      and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : TAFR

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO TAFR 638', 'solotptoeta', 1, to_date('10-04-2012 09:47:47', 'dd-mm-yyyy hh24:mi:ss'), 'MIGRACION');

insert into operacion.CFG_ENV_correo_CONTRATA (IDCFG, FASE, NOMARCH, CUERPO, QUERY, CABECERA, DETALLE1, DETALLE2, CANT_COLUMNAS, GRUPO, TABLA, ESTADO, FECUSU, CODUSU)
values (6, 'TAFC', 'TAFC-', 'SGA Operaciones

Asignaci�n de Contrata
', 'select solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion,rownum ContFilas
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in (638)
      and to_char(solotptoeta.FECCON, ''yyyymmdd'') = to_char(sysdate, ''yyyymmdd'')', 'La Victoria, #

Se�ores:@

Presente.-

REF. : FCT

De nuestra consideraci�n:

Por medio de la presente, les estamos asignando las siguientes obras para su ejecuci�n:', 'Cabe destacar que las condiciones comerciales se regir�n a trav�s de su contrato vigente, asimismo le indicamos que la recepci�n de la presente es se�al de aceptaci�n de las obras.
Agradeceremos recoger informaci�n adicional en las oficinas de Planta Externa ubicada en Jr. Chinch�n 910 - San Isidro.
', 'Atentamente,

Nelson Moscoso
Gerente de Control de Gesti�n
Direcci�n de Mercado Masivo Al�mbrico', 5, 'GRUPO TAFC 638', 'solotptoeta', 1, to_date('10-04-2012 09:47:47', 'dd-mm-yyyy hh24:mi:ss'), 'MIGRACION');


commit;