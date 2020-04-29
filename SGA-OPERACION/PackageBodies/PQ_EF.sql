CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_EF AS
  /******************************************************************************
  Version     Fecha       Autor            Solicitado por  Descripción.
  ---------  ----------  ---------------   --------------  ---------------------------------
  1.0        FASES:  CNL : Canalización
                     FCT : Factibilidad
                     DSN : Diseño
                     TAF : Tendido Acceso Fusión
                     PINT: Planta Interna
  2.0        13/10/2010  Marcos Echevarria                 Req. 115746: se modificó p_envia_correo_contrata, se cambio ruta de servidor y apuntó a los correos correctamente
  3.0        25/10/2010  Alfonso Pérez                     REQ. 116241
  4.0        10/03/2010  Alfonso Pérez                     Req:120974 Error en reporte SGA Operaciones - Control costos
  5.0        29/04/2010  Marcos Echevarria                 REQ-123713: El comentario final de las sots se movió al pie de página
  6.0        22/10/2010  Alexander Yong          REQ-138937: Creación de procedimiento p_envia_correo_pry_sot
  7.0        14/06/2011  Antonio Lagos     Alberto Miranda REQ-159778: Modificar dirección
  8.0        23/03/2012  Edilberto Astulle         PROY-2787_Modificacion modulo de control de tareas SGA Operaciones
  9.0        26/05/2012  Edilberto Astulle         PROY-3574_Mejoras en la generacion de pedido en el SGA
  10.0       26/02/2013  Miriam Mandujano         PROY-6887_Reporte automatizado de Instalaciones HFC
  11.0       26/03/2013  Miriam Mandujano          PROY-6254_Recojo de decodificador
  12.0        26/07/2013  Edilberto Astulle         PROY-6471 IDEA-6433 - Agendamiento de Fecha serv Post
  13.0       14/11/2013  Miriam Mandujano          PROY-11692 - Envios manuales con etiqueta de copia
  14.0       13/09/2017  Servicio Fallas-HITSS     INC000000903157
******************************************************************************/
PROCEDURE p_envia_correo_contrata(a_codcon in number, a_fase in varchar2)

IS
f_doc utl_file.file_type;
v_ruta varchar2(200);
v_cuerpo varchar2(4000);
vNomArch varchar2(400);
v_contrata varchar(300);
n_filas number; --<3.0>

Cursor cur_email is
SELECT codigon codcon,codigoc etapa , OPEDD.DESCRIPCION email
 FROM  opedd where tipopedd= 214
 and codigoc = a_fase and codigon = a_codcon
union all --Usuario de Telmex tiene que recibir el correo <3.0> SE AGREGA EL UNION ALL
SELECT codigon codcon,codigoc etapa , OPEDD.DESCRIPCION email
 FROM  opedd where tipopedd= 214
 and codigoc = a_fase and codigon = 1; --<3.0> FIN

Cursor cur_FCT is --Factibilidad
 SELECT rownum ContFilas,--<3.0> se agrega linea
        EFPTO.CODEF PROYECTO,
        VTATABCLI.NOMCLI cliente,
        EFPTO.DIRECCION direccion,
        VTATABDST.NOMDST distrito,
        EFPTO.DESCRIPCION descripcion,
        TYSTABSRV.DSCSRV observacion,
        TYSTIPSRV.DSCTIPSRV,
        EFPTO.FECCONASIG
   FROM EFPTO, VTATABDST, EF, VTATABCLI, TYSTABSRV, TYSTIPSRV, vtatabslcfac
  WHERE (efpto.codubi = vtatabdst.codubi(+))
    and (efpto.codsrv = tystabsrv.codsrv(+))
    and (EFPTO.CODEF = EF.CODEF)
    and (ef.tipsrv = tystipsrv.tipsrv(+))
    and (EF.CODCLI = VTATABCLI.CODCLI)
    and ef.codef = vtatabslcfac.numslc(+)
    and efpto.codcon = a_codcon
    and to_char(EFPTO.FECCONASIG_SOP, 'yyyymmdd') = to_char(sysdate, 'yyyymmdd');--<3.0>

Cursor cur_DSN is --Diseño
 select rownum ContFilas,--<3.0>
        preubi.codsolot sot,
        solot.numslc proyecto,
        vtatabcli.nomcli cliente,
        preubi.dirobra direccion,
        vtatabdst.nomdst distrito,
        preubi.descripcion descripcion,
        tystabsrv.dscsrv observacion,
        tystipsrv.dsctipsrv dsctipsrv
   from preubi, solot, vtatabcli, VTATABDST, tystipsrv, solotpto, tystabsrv
  where preubi.codsolot = solot.codsolot
    and solot.codcli = vtatabcli.codcli
    and preubi.disobra = vtatabdst.codubi
    and solot.tipsrv = tystipsrv.tipsrv
    and preubi.punto = solotpto.punto
    and solotpto.codsolot = solot.codsolot
    and solotpto.codsrvnue = tystabsrv.codsrv
    and preubi.codcon=a_codcon
    and to_char(preubi.FECASIG, 'yyyymmdd') = to_char(sysdate, 'yyyymmdd');

--CLIENTE-INSTALACION DE ACCESO PEX-MANO DE OBRA-CANALIZACION 639 CNLC
--RED-AMPLIACION DE PEX-MANO DE OBRA-CANALIZACIÓN 654 CNLR
--CLIENTE-INSTALACION DE ACCESO PEX-MANO DE OBRA-TENDIDO 638 TAFC
--RED-AMPLIACION DE PEX-MANO DE OBRA-TENDIDO 653 TAFR
Cursor cur_CNL_TAF is --Canalizacion  Tendido Acceso Fusion
select rownum ContFilas,--<3.0>
       solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in
     (SELECT DISTINCT ABREVIACION CODETA FROM OPEDD
      WHERE TIPOPEDD =214 AND CODIGOC = a_fase)
   and solotptoeta.codcon=a_codcon
   and to_char(solotptoeta.FECCON, 'yyyymmdd') = to_char(sysdate, 'yyyymmdd');

Cursor cur_PINT is --Planta Interna
 select rownum ContFilas,--<6.0>
 --ini 7.0
 pint.* from (
 select distinct
 --fin 7.0
        SOLOTPTO_ID.codsolot sot,
        solot.numslc proyecto,
        vtatabcli.nomcli cliente,
        solotpto.direccion direccion,
        vtatabdst.nomdst distrito,
        SOLOTPTO_ID.observacion descripcion,
        --ini 7.0
        --tystabsrv.dscsrv observacion,
        --fin 7.0
        tystipsrv.dsctipsrv dsctipsrv
   from SOLOTPTO_ID, solot, vtatabcli, VTATABDST, tystipsrv, solotpto, tystabsrv
  where SOLOTPTO_ID.codsolot = solot.codsolot
    and solot.codcli = vtatabcli.codcli
    and solotpto.codubi = vtatabdst.codubi
    and solot.tipsrv = tystipsrv.tipsrv
    and SOLOTPTO_ID.punto = solotpto.punto
    and solotpto.codsolot = solot.codsolot
    and solotpto.codsrvnue = tystabsrv.codsrv
    and SOLOTPTO_ID.codcon=a_codcon
    and to_char(SOLOTPTO_ID.FECASIGcon, 'yyyymmdd') = to_char(sysdate, 'yyyymmdd')
 --ini 7.0
 ) pint;

 cursor cur_pint_det(a_codsolot solot.codsolot%type) is
   select distinct
          tystabsrv.dscsrv observacion
     from SOLOTPTO_ID, solot, vtatabcli, VTATABDST, tystipsrv, solotpto, tystabsrv
    where SOLOTPTO_ID.codsolot = solot.codsolot
      and solot.codcli = vtatabcli.codcli
      and solotpto.codubi = vtatabdst.codubi
      and solot.tipsrv = tystipsrv.tipsrv
      and SOLOTPTO_ID.punto = solotpto.punto
      and solotpto.codsolot = solot.codsolot
      and solotpto.codsrvnue = tystabsrv.codsrv
      and SOLOTPTO_ID.codcon = a_codcon
      and solot.codsolot = a_codsolot
      and to_char(SOLOTPTO_ID.FECASIGcon, 'yyyymmdd') = to_char(sysdate, 'yyyymmdd');
 --fin 7.0


BEGIN
  n_filas:=0; --<3.0>
  v_cuerpo := '';
  v_cuerpo := v_cuerpo || 'Telmex Operaciones' || chr(13); --<3.0>
  v_cuerpo := v_cuerpo || '' || chr(13);
  v_cuerpo := v_cuerpo || 'Asignación de Contrata' || chr(13);
  select nombre into v_contrata from contrata where codcon = a_codcon;

  vNomArch:= 'AS-' || a_fase || '-'|| to_char(a_codcon) ||'-' || to_char(sysdate,'yyyymmdd')|| '.txt';
--  v_ruta := '/u02/oracle/PESGAUAT/UTL_FILE';
--  v_ruta := '/u03/oracle/PESGAPRD/UTL_FILE/'; --<2.0>
    v_ruta := '/u03/oracle/PESGAPRD/UTL_FILE'; --<2.0>
  f_doc := utl_file.fopen( v_ruta , vNomArch, 'w');
  --ini 7.0
  --utl_file.put_line(f_doc, 'Miraflores, ' || to_char(sysdate,'dd/mm/yyyy')  || chr(13));
  utl_file.put_line(f_doc, 'La Victoria, ' || to_char(sysdate,'dd/mm/yyyy')  || chr(13));
  --fin 7.0
  utl_file.put_line(f_doc, '' || chr(13));
  utl_file.put_line(f_doc, 'Señores:' || chr(13));
  utl_file.put_line(f_doc, v_contrata || chr(13));
  utl_file.put_line(f_doc, 'Presente.-' || chr(13));
  utl_file.put_line(f_doc, '' || chr(13));
  utl_file.put_line(f_doc, 'REF. : ' || a_fase || chr(13)); --<3.0>
  utl_file.put_line(f_doc, '' || chr(13));
  utl_file.put_line(f_doc, 'De nuestra consideración:' || chr(13));
  utl_file.put_line(f_doc, '' || chr(13));
  utl_file.put_line(f_doc, 'Por medio de la presente, les estamos asignando las siguientes obras para su ejecución:' || chr(13));
  utl_file.put_line(f_doc, '' || chr(13));
  utl_file.put_line(f_doc, '' || chr(13));
  if a_fase = 'FCT' then
    for c_f in cur_FCT loop
      n_filas:= c_f.ContFilas; --<3.0>
      utl_file.put_line(f_doc, '------------------------------' || chr(13));
      utl_file.put_line(f_doc, 'PROYECTO     :' || c_f.proyecto || chr(13));
      utl_file.put_line(f_doc, 'CLIENTE      :' || c_f.cliente || chr(13));
      utl_file.put_line(f_doc, 'DIRECCION    :' || c_f.direccion || chr(13));
      utl_file.put_line(f_doc, 'DISTRITO     :' || c_f.distrito ||  chr(13));
      utl_file.put_line(f_doc, 'DESCRIPCION  :' || c_f.descripcion || chr(13));
      utl_file.put_line(f_doc, 'OBSERVACION  :' || c_f.observacion || chr(13));
      utl_file.put_line(f_doc, 'TIPO SERVICIO:' || c_f.dsctipsrv || chr(13));
      utl_file.put_line(f_doc, ''|| chr(13)); --<4.0>
      --<5.0>
      /*utl_file.put_line(f_doc, ''|| chr(13)); --<4.0>
      utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en la oficina del Ing. Adolfo Martínez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinchón 910 ¿ San Isidro, teléfono 6102332.'|| chr(13));--<4.0>
       */
       --</5.0>
    end loop;
      --<5.0>
      utl_file.put_line(f_doc, ''|| chr(13));
      utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en la oficina del Ing. Adolfo Martínez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinchón 910 - San Isidro, teléfono 6102332.'|| chr(13));--<4.0>
      --</5.0>
  elsif a_fase = 'DSN' then
    for c_d in cur_DSN loop
      n_filas:= c_d.ContFilas; --<3.0>
      utl_file.put_line(f_doc, '------------------------------' || chr(13));
      utl_file.put_line(f_doc, 'SOT          :' || c_d.sot || chr(13));
      utl_file.put_line(f_doc, 'PROYECTO     :' || c_d.proyecto || chr(13));
      utl_file.put_line(f_doc, 'CLIENTE      :' || c_d.cliente || chr(13));
      utl_file.put_line(f_doc, 'DIRECCION    :' || c_d.direccion || chr(13));
      utl_file.put_line(f_doc, 'DISTRITO     :' || c_d.distrito ||  chr(13));
      utl_file.put_line(f_doc, 'DESCRIPCION  :' || c_d.descripcion || chr(13));
      utl_file.put_line(f_doc, 'OBSERVACION  :' || c_d.observacion || chr(13));
      utl_file.put_line(f_doc, 'TIPO SERVICIO:' || c_d.dsctipsrv || chr(13));
      utl_file.put_line(f_doc, ''|| chr(13));--<4.0>
      --<5.0>
      /*utl_file.put_line(f_doc, ''|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en la oficina del Ing. Adolfo Martínez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinchón 910 ¿ San Isidro, teléfono 6102332.'|| chr(13));--<4.0>
      */
      --</5.0>
    end loop;
    --<5.0>
      utl_file.put_line(f_doc, ''|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en la oficina del Ing. Adolfo Martínez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinchón 910 - San Isidro, teléfono 6102332.'|| chr(13));--<4.0>
    --<5.0>

  elsif a_fase = 'CNLC' or a_fase = 'CNLR' or a_fase = 'TAFC' or a_fase = 'TAFR' then
    for c_c in cur_CNL_TAF loop
      n_filas:= c_c.ContFilas;--<3.0>
      utl_file.put_line(f_doc, '------------------------------' || chr(13));
      utl_file.put_line(f_doc, 'SOT          :' || c_c.sot || chr(13));
      utl_file.put_line(f_doc, 'PROYECTO     :' || c_c.proyecto || chr(13));
      utl_file.put_line(f_doc, 'CLIENTE      :' || c_c.cliente || chr(13));
      utl_file.put_line(f_doc, 'DIRECCION    :' || c_c.direccion || chr(13));
      utl_file.put_line(f_doc, 'DISTRITO     :' || c_c.distrito ||  chr(13));
      utl_file.put_line(f_doc, 'DESCRIPCION  :' || c_c.descripcion || chr(13));
      utl_file.put_line(f_doc, 'OBSERVACION  :' || c_c.observacion || chr(13));
      utl_file.put_line(f_doc, ''|| chr(13));--<4.0>
      --<5.0>
      /*utl_file.put_line(f_doc, ''|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en las oficinas de Planta Externa ubicada en Jr. Chinchón 910 ¿ San Isidro.'|| chr(13));--<4.0>
      */
      --</5.0>
    end loop;
    --<5.0>
      utl_file.put_line(f_doc, ''|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en las oficinas de Planta Externa ubicada en Jr. Chinchón 910 - San Isidro.'|| chr(13));--<4.0>
    --</5.0>
  elsif a_fase = 'PINT' then  --6.0
    for c_c in cur_PINT loop
      n_filas:= c_c.ContFilas;--<3.0>
      utl_file.put_line(f_doc, '------------------------------' || chr(13));
      utl_file.put_line(f_doc, 'SOT          :' || c_c.sot || chr(13));
      utl_file.put_line(f_doc, 'PROYECTO     :' || c_c.proyecto || chr(13));
      utl_file.put_line(f_doc, 'CLIENTE      :' || c_c.cliente || chr(13));
      utl_file.put_line(f_doc, 'DIRECCION    :' || c_c.direccion || chr(13));
      utl_file.put_line(f_doc, 'DISTRITO     :' || c_c.distrito ||  chr(13));
      utl_file.put_line(f_doc, 'DESCRIPCION  :' || c_c.descripcion || chr(13));
      --ini 7.0
      for reg_det in cur_pint_det(c_c.sot) loop
      --fin 7.0
        utl_file.put_line(f_doc, 'OBSERVACION  :' || reg_det.observacion || chr(13));
      --ini 7.0
      end loop;
      --fin 7.0
      utl_file.put_line(f_doc, ''|| chr(13));--<4.0>
      --<5.0>
      /*utl_file.put_line(f_doc, ''|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en las oficinas de Planta Externa ubicada en Jr. Chinchón 910 ¿ San Isidro.'|| chr(13));--<4.0>
      */
      --</5.0>
    end loop;
    --<5.0>
      utl_file.put_line(f_doc, ''|| chr(13));--<4.0>
      --ini 7.0
      --utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
      --utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en las oficinas de Planta Externa ubicada en Jr. Chinchón 910 - San Isidro.'|| chr(13));--<4.0>
      utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional o cualquier consulta con el Ing. Melvin Martel al número 610-2941,'|| chr(13));
      utl_file.put_line(f_doc, 'para cualquier problema que se suscite con la asignación favor comunicarse con las siguientes personas,'|| chr(13));
      utl_file.put_line(f_doc, 'Nidya Alonzo al 613-1000 anexo 8863.'|| chr(13));
      --fin 7.0
    --</5.0>
  end if;
  utl_file.put_line(f_doc, ''|| chr(13));
  utl_file.put_line(f_doc, ''|| chr(13));
  --<4.0>
  /*utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));
  utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en la oficina del Ing. Adolfo Martínez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinchón 910 - San Isidro, teléfono 6102332.'|| chr(13));
  utl_file.put_line(f_doc, ''|| chr(13));
  utl_file.put_line(f_doc, ''|| chr(13));*/ --</4.0>
  utl_file.put_line(f_doc, 'Atentamente,'|| chr(13));
  utl_file.put_line(f_doc, ''|| chr(13));
  --utl_file.put_line(f_doc, 'Rocío Castilla Rubio'|| chr(13));
  utl_file.put_line(f_doc, 'Nelson Moscoso'|| chr(13)); --6.0
  --utl_file.put_line(f_doc, 'Directora de Soporte a la Operación'|| chr(13));
  utl_file.put_line(f_doc, 'Gerente de Control de Gestión'|| chr(13)); --6.0
  --ini 7.0
  --utl_file.put_line(f_doc, 'Dirección de Soporte a la Operación'|| chr(13)); --6.0
  utl_file.put_line(f_doc, 'Dirección de Mercado Masivo Alámbrico'|| chr(13)); --6.0
  --fin 7.0
  utl_file.fclose(f_doc);

  for c_e in cur_email loop
    --<3.0 se modifica y se agrega condicional>
    if n_filas > 0 then
      p_envia_correo_c_attach(vNomArch,c_e.email,v_cuerpo,SendMailJPkg.ATTACHMENTS_LIST(v_ruta||'/'||vNomArch),'TELMEX-SGA'); --<2.0>
    end if;
    --<3.0>
  end loop;

END;



  /******************************************************************************
  Version     Fecha       Autor            Descripción.
  ---------  ----------  ---------------   ------------------------------------
  1.0        26/08/2009  Raul Pari         Envio de Correos en base a configuracion en SGA OPeraciones
  ******************************************************************************/

PROCEDURE p_envia_correo_contrata_p(a_codcon in number, a_fase in varchar2)

IS
v_cuerpo varchar2(4000);
vNomArch varchar2(400);
v_contrata varchar(300);
n_filas number;
Cursor cur_email is
SELECT codigon codcon,codigoc etapa , OPEDD.DESCRIPCION email
 FROM  opedd where tipopedd= 214
 and codigoc = a_fase and codigon = a_codcon
union all --Usuario de Telmex tiene que recibir el correo
SELECT codigon codcon,codigoc etapa , OPEDD.DESCRIPCION email
 FROM  opedd where tipopedd= 214
 and codigoc = a_fase and codigon = 1;

Cursor cur_FCT is --Factibilidad
 SELECT rownum ContFilas,
        EFPTO.CODEF PROYECTO,
        VTATABCLI.NOMCLI cliente,
        EFPTO.DIRECCION direccion,
        VTATABDST.NOMDST distrito,
        EFPTO.DESCRIPCION descripcion,
        TYSTABSRV.DSCSRV observacion,
        TYSTIPSRV.DSCTIPSRV,
        EFPTO.FECCONASIG
   FROM EFPTO, VTATABDST, EF, VTATABCLI, TYSTABSRV, TYSTIPSRV, vtatabslcfac
  WHERE (efpto.codubi = vtatabdst.codubi(+))
    and (efpto.codsrv = tystabsrv.codsrv(+))
    and (EFPTO.CODEF = EF.CODEF)
    and (ef.tipsrv = tystipsrv.tipsrv(+))
    and (EF.CODCLI = VTATABCLI.CODCLI)
    and ef.codef = vtatabslcfac.numslc(+)
    and efpto.codcon = a_codcon
    and to_char(EFPTO.FECCONASIG_SOP, 'yyyymmdd') = to_char(sysdate, 'yyyymmdd');

Cursor cur_DSN is --Diseño
 select rownum ContFilas,
        preubi.codsolot sot,
        solot.numslc proyecto,
        vtatabcli.nomcli cliente,
        preubi.dirobra direccion,
        vtatabdst.nomdst distrito,
        preubi.descripcion descripcion,
        tystabsrv.dscsrv observacion,
        tystipsrv.dsctipsrv dsctipsrv
   from preubi, solot, vtatabcli, VTATABDST, tystipsrv, solotpto, tystabsrv
  where preubi.codsolot = solot.codsolot
    and solot.codcli = vtatabcli.codcli
    and preubi.disobra = vtatabdst.codubi
    and solot.tipsrv = tystipsrv.tipsrv
    and preubi.punto = solotpto.punto
    and solotpto.codsolot = solot.codsolot
    and solotpto.codsrvnue = tystabsrv.codsrv
    and preubi.codcon=a_codcon
    and to_char(preubi.FECASIG, 'yyyymmdd') = to_char(sysdate, 'yyyymmdd');

--CLIENTE-INSTALACION DE ACCESO PEX-MANO DE OBRA-CANALIZACION 639 CNLC
--RED-AMPLIACION DE PEX-MANO DE OBRA-CANALIZACIÓN 654 CNLR
--CLIENTE-INSTALACION DE ACCESO PEX-MANO DE OBRA-TENDIDO 638 TAFC
--RED-AMPLIACION DE PEX-MANO DE OBRA-TENDIDO 653 TAFR
Cursor cur_CNL_TAF is --Canalizacion  Tendido Acceso Fusion
select rownum ContFilas,
        solotptoeta.codsolot sot,
       solot.numslc proyecto,
       vtatabcli.nomcli cliente,
       solotpto.direccion direccion,
       vtatabdst.nomdst distrito,
       tiptrabajo.descripcion,
       solot.observacion
  from solotptoeta, solotpto, solot, vtatabcli, vtatabdst, tiptrabajo
 where solotptoeta.codsolot = solotpto.codsolot
   and solotptoeta.punto = solotpto.punto
   and solotptoeta.codsolot = solot.codsolot
   and solot.codcli = vtatabcli.codcli
   and solotpto.codubi = vtatabdst.codubi
   and solot.tiptra = tiptrabajo.tiptra
   and solotptoeta.codeta in
     (SELECT DISTINCT ABREVIACION CODETA FROM OPEDD
      WHERE TIPOPEDD =214 AND CODIGOC = a_fase)
   and solotptoeta.codcon=a_codcon
   and to_char(solotptoeta.FECCON, 'yyyymmdd') = to_char(sysdate, 'yyyymmdd');

BEGIN
  n_filas:=0;
  v_cuerpo := '';
  v_cuerpo := v_cuerpo || 'SGA Operaciones' || chr(13);
  v_cuerpo := v_cuerpo || '' || chr(13);
  v_cuerpo := v_cuerpo || 'Asignación de Contrata' || chr(13);
  select nombre into v_contrata from contrata where codcon = a_codcon;

  vNomArch:= 'AS-' || a_fase || '-'|| to_char(a_codcon) ||'-' || to_char(sysdate,'yyyymmdd')|| '.txt';

  v_cuerpo:=v_cuerpo ||'Miraflores, ' || to_char(sysdate,'dd/mm/yyyy')  || chr(13);
  v_cuerpo:=v_cuerpo || '' || chr(13);
  v_cuerpo:=v_cuerpo || 'Señores:' || chr(13);
  v_cuerpo:=v_cuerpo || v_contrata || chr(13);
  v_cuerpo:=v_cuerpo || 'Presente.-' || chr(13);
  v_cuerpo:=v_cuerpo || '' || chr(13);
  v_cuerpo:=v_cuerpo || 'REF. : ' || a_fase  || chr(13);
  v_cuerpo:=v_cuerpo || '' || chr(13);
  v_cuerpo:=v_cuerpo || 'De nuestra consideración:' || chr(13);
  v_cuerpo:=v_cuerpo || '' || chr(13);
  v_cuerpo:=v_cuerpo || 'Por medio de la presente, les estamos asignando las siguientes obras para su ejecución:' || chr(13);
  v_cuerpo:=v_cuerpo || '' || chr(13);
  v_cuerpo:=v_cuerpo || '' || chr(13);
  if a_fase = 'FCT' then
    for c_f in cur_FCT loop
      n_filas:= c_f.ContFilas;
      v_cuerpo:=v_cuerpo || '------------------------------' || chr(13);
      v_cuerpo:=v_cuerpo || 'PROYECTO     :' || c_f.proyecto || chr(13);
      v_cuerpo:=v_cuerpo || 'CLIENTE      :' || c_f.cliente || chr(13);
      v_cuerpo:=v_cuerpo || 'DIRECCION    :' || c_f.direccion || chr(13);
      v_cuerpo:=v_cuerpo || 'DISTRITO     :' || c_f.distrito ||  chr(13);
      v_cuerpo:=v_cuerpo || 'DESCRIPCION  :' || c_f.descripcion || chr(13);
      v_cuerpo:=v_cuerpo || 'OBSERVACION  :' || c_f.observacion || chr(13);
      v_cuerpo:=v_cuerpo || 'TIPO SERVICIO:' || c_f.dsctipsrv || chr(13);
    end loop;
  elsif a_fase = 'DSN' then
    for c_d in cur_DSN loop
      n_filas:= c_d.ContFilas;
      v_cuerpo:=v_cuerpo || '------------------------------' || chr(13);
      v_cuerpo:=v_cuerpo || 'SOT          :' || c_d.sot || chr(13);
      v_cuerpo:=v_cuerpo || 'PROYECTO     :' || c_d.proyecto || chr(13);
      v_cuerpo:=v_cuerpo || 'CLIENTE      :' || c_d.cliente || chr(13);
      v_cuerpo:=v_cuerpo || 'DIRECCION    :' || c_d.direccion || chr(13);
      v_cuerpo:=v_cuerpo || 'DISTRITO     :' || c_d.distrito ||  chr(13);
      v_cuerpo:=v_cuerpo || 'DESCRIPCION  :' || c_d.descripcion || chr(13);
      v_cuerpo:=v_cuerpo || 'OBSERVACION  :' || c_d.observacion || chr(13);
      v_cuerpo:=v_cuerpo || 'TIPO SERVICIO:' || c_d.dsctipsrv || chr(13);
    end loop;
  elsif a_fase = 'CNLC' or a_fase = 'CNLR' or a_fase = 'TAFC' or a_fase = 'TAFR' then
    for c_c in cur_CNL_TAF loop
      n_filas:= c_c.ContFilas;
      v_cuerpo:=v_cuerpo || '------------------------------' || chr(13);
      v_cuerpo:=v_cuerpo || 'SOT          :' || c_c.sot || chr(13);
      v_cuerpo:=v_cuerpo || 'PROYECTO     :' || c_c.proyecto || chr(13);
      v_cuerpo:=v_cuerpo || 'CLIENTE      :' || c_c.cliente || chr(13);
      v_cuerpo:=v_cuerpo || 'DIRECCION    :' || c_c.direccion || chr(13);
      v_cuerpo:=v_cuerpo || 'DISTRITO     :' || c_c.distrito ||  chr(13);
      v_cuerpo:=v_cuerpo || 'DESCRIPCION  :' || c_c.descripcion || chr(13);
      v_cuerpo:=v_cuerpo || 'OBSERVACION  :' || c_c.observacion || chr(13);
    end loop;
  end if;
  v_cuerpo:=v_cuerpo || ''|| chr(13);
  v_cuerpo:=v_cuerpo || ''|| chr(13);
  v_cuerpo:=v_cuerpo || 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13);
  v_cuerpo:=v_cuerpo || 'Agradeceremos recoger información adicional en la oficina del Ing. Adolfo Martínez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinchón 910 - San Isidro, teléfono 6102332.'|| chr(13);
  v_cuerpo:=v_cuerpo || ''|| chr(13);
  v_cuerpo:=v_cuerpo || ''|| chr(13);
  v_cuerpo:=v_cuerpo || 'Atentamente,'|| chr(13);
  v_cuerpo:=v_cuerpo || ''|| chr(13);
  --v_cuerpo:=v_cuerpo || 'Rocío Castilla Rubio'|| chr(13);
  v_cuerpo:=v_cuerpo || 'Nelson Moscoso'|| chr(13); --6.0
  --v_cuerpo:=v_cuerpo || 'Directora de Soporte a la Operación'|| chr(13);
  v_cuerpo:=v_cuerpo || 'Gerente de Control de Gestión'|| chr(13);
  v_cuerpo:=v_cuerpo || 'Dirección de Soporte a la Operación'|| chr(13);
  for c_e in cur_email loop
    if n_filas > 0 then
       P_ENVIA_CORREO_DE_TEXTO_ATT(vNomArch, c_e.email, v_cuerpo );
    end if;
  end loop;
END;

  /******************************************************************************
  Version     Fecha       Autor            Descripción.
  ---------  ----------  ---------------   ------------------------------------
  1.0        26/08/2009  Raúl Pari         Proceso para el envio diario de correos a las contratas por asignacion
  ******************************************************************************/
PROCEDURE p_proceso_envia_contratas

IS
  /************************************************************
  NOMBRE: p_proceso_envia_contratas
  PROPOSITO: Proceso para el envio diario de correos a las
             contratas por asignacion
  PROGRAMADO EN JOB: SI
  REVISIONES:
  Versión    Fecha      Autor           Descripción
  ---------  ---------- --------------- -----------------------
  1.0        13/10/2009 Raúl Pari       Creación.
  ************************************************************/

  ------------------------------------
  --VARIABLES PARA EL ENVIO DE CORREOS
  c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE := 'OPERACION.PQ_EF.p_proceso_envia_contratas';
  c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE := '347';
  c_sec_grabacion float := fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
  --------------------------------------------------

Cursor cur_correos is
select idcfg
from operacion.CFG_ENV_CORREO_CONTRATA
WHERE  ESTADO = 1
ORDER BY ORDEN ASC;--12.0
v_contenido varchar2(4000);--8.0
/* SELECT distinct codigon codcon,codigoc fase , contrata.nombre
 FROM  opedd , contrata where tipopedd= 214
 and opedd.codigon = contrata.codcon and not codigon = 1;*/--8.0
BEGIN
  for c_c in cur_correos loop
--     p_envia_correo_contrata(c_c.codcon,c_c.fase); --<8.0>
     p_envia_correo_cfg(c_c.idcfg,1,v_contenido); --<8.0>
  end loop;

  --------------------------------------------------
  --Este codigo se debe poner en todos los stores
  --que se llaman con un job
  --para ver si termino satisfactoriamente
  sp_rep_registra_error
     (c_nom_proceso, c_id_proceso,
      sqlerrm , '0', c_sec_grabacion);
  ------------------------
  exception
    when others then
        sp_rep_registra_error
           (c_nom_proceso, c_id_proceso,
            sqlerrm , '1',c_sec_grabacion );
        raise_application_error(-20000,sqlerrm);

END;

/******************************************************************************
  Version     Fecha       Autor            Descripción.
  ---------  ----------  ---------------   ------------------------------------
  1.0        26/08/2009  Raúl Pari         Creación Solicitud asociada a un area
  ******************************************************************************/
PROCEDURE p_proceso_ef_area(
an_codef       solefxarea.codef%type,
as_accion      varchar2,
pError         out varchar2)
IS
ls_numslc      solefxarea.numslc%type;
ln_estsolef    solefxarea.estsolef%type;
ls_observacion solefxarea.observacion%type;
ln_area        solefxarea.area%type;
BEGIN

  select numslc
    into ls_numslc
    from ef
   where codef = an_codef;

  pError := ' ';
  ls_observacion := 'Creación automática de Solicitud';
  ln_area := 8;

  if as_accion = 'I' then
     ln_estsolef := 1;
     INSERT INTO solefxarea
     (codef, numslc, estsolef, observacion, area)
     VALUES
     (an_codef, ls_numslc, ln_estsolef, ls_observacion, ln_area);
  elsif as_accion = 'U' then
     ln_estsolef := 2;
     update solefxarea
        set estsolef = ln_estsolef,
            fecfin = sysdate
      where codef =  an_codef
        and area = ln_area;
  end if;

EXCEPTION
  WHEN OTHERS THEN
    if as_accion = 'I' then
       pError := 'No se pudo crear la solicitud asociada a Logística ' || SQLERRM;
    elsif as_accion = 'U' then
       pError := 'No se pudo concluir la solicitud asociada a Logistica' || SQLERRM;
    end if;
    RETURN;
END ;

  /******************************************************************************
  Version     Fecha       Autor            Descripción.
  ---------  ----------  ---------------   ------------------------------------
  1.0        26/08/2009  Raúl Pari         Funcion que verifica si ya existe registros
                                           en la tabla solefxarea
  ******************************************************************************/
FUNCTION F_VERIFICA_EF_AREA(an_codef ef.codef%type) RETURN NUMBER IS
  ln_valor NUMBER;
  ln_cantidad NUMBER;
BEGIN

  SELECT COUNT(*)
    INTO ln_cantidad
    FROM SOLEFXAREA
   WHERE CODEF = an_codef
     AND AREA = 8;

  IF ln_cantidad > 0 THEN
     ln_valor := 0;
  ELSE
     ln_valor := 1;
  END IF;

  RETURN ln_valor;
END;

-- Ini 6.0
PROCEDURE p_envia_correo_pry_sot(a_codigo in varchar2, a_tipo in varchar2, a_fase in varchar2)

IS
f_doc utl_file.file_type;
v_ruta varchar2(200);
v_cuerpo varchar2(4000);
vNomArch varchar2(400);
v_contrata varchar2(300);
n_filas number;
n_codcon number;
n_cont number;

Cursor cur_data is
select 1 ContFilas,sot,proyecto,cliente,direccion,
distrito,fase,descripcion, tipo_Servicio, obs_sot, con_asig,
fec_asig,usu_asig,con_reagenda,fec_reagenda,usu_reagenda,codcon
 from operacion.v_asig_correo_contrata
 where ((sot =a_Codigo and a_tipo = 1) or (proyecto = a_codigo and a_tipo = 2))
 and fase =a_fase;

Cursor cur_email is
SELECT codigon codcon,codigoc etapa , OPEDD.DESCRIPCION email
 FROM  opedd where tipopedd= 214
 and codigoc = a_fase and codigon = n_codcon
union all
SELECT codigon codcon,codigoc etapa , OPEDD.DESCRIPCION email
 FROM  opedd where tipopedd= 214
 and codigoc = a_fase and codigon = 1;


BEGIN
  n_filas:=0;
  v_cuerpo := '';
  v_cuerpo := v_cuerpo || a_codigo || chr(13);
  v_cuerpo := v_cuerpo || 'Asignación de Contrata' || chr(13);

  for c_d in cur_data loop
    n_codcon := c_d.codcon;
    select nombre into v_contrata from contrata where codcon = n_codcon;

    vNomArch:= 'AS-' || c_d.fase || '-'|| to_char(n_codcon) ||'-' || to_char(sysdate,'yyyymmdd')|| '.txt';
      v_ruta := '/u03/oracle/PESGAPRD/UTL_FILE';
--    v_ruta := '/u03/oracle/PESGADES/UTL_FILE';

    f_doc := utl_file.fopen( v_ruta , vNomArch, 'w');
    --ini 7.0
    --utl_file.put_line(f_doc, 'Miraflores, ' || to_char(sysdate,'dd/mm/yyyy')  || chr(13));
    utl_file.put_line(f_doc, 'La Victoria, ' || to_char(sysdate,'dd/mm/yyyy')  || chr(13));
    --fin 7.0
    utl_file.put_line(f_doc, '' || chr(13));
    utl_file.put_line(f_doc, 'Señores:' || chr(13));
    utl_file.put_line(f_doc, v_contrata || chr(13));
    utl_file.put_line(f_doc, 'Presente.-' || chr(13));
    utl_file.put_line(f_doc, '' || chr(13));
    utl_file.put_line(f_doc, 'REF. : ' || a_fase || chr(13));
    utl_file.put_line(f_doc, '' || chr(13));
    utl_file.put_line(f_doc, 'De nuestra consideración:' || chr(13));
    utl_file.put_line(f_doc, '' || chr(13));
    utl_file.put_line(f_doc, 'Por medio de la presente, les estamos asignando las siguientes obras para su ejecución:' || chr(13));
    utl_file.put_line(f_doc, '' || chr(13));
    utl_file.put_line(f_doc, '' || chr(13));
    if a_fase = 'FCT' then
        n_filas:= c_d.ContFilas;
        utl_file.put_line(f_doc, '------------------------------' || chr(13));
        utl_file.put_line(f_doc, 'PROYECTO     :' || c_d.proyecto || chr(13));
        utl_file.put_line(f_doc, 'CLIENTE      :' || c_d.cliente || chr(13));
        utl_file.put_line(f_doc, 'DIRECCION    :' || c_d.direccion || chr(13));
        utl_file.put_line(f_doc, 'DISTRITO     :' || c_d.distrito ||  chr(13));
        utl_file.put_line(f_doc, 'DESCRIPCION  :' || c_d.descripcion || chr(13));
        utl_file.put_line(f_doc, 'OBSERVACION  :' || c_d.obs_sot || chr(13));
        utl_file.put_line(f_doc, 'TIPO SERVICIO:' || c_d.tipo_Servicio || chr(13));
        utl_file.put_line(f_doc, ''|| chr(13));

        utl_file.put_line(f_doc, ''|| chr(13));
        utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
        utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en la oficina del Ing. Adolfo Martínez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinchón 910 - San Isidro, teléfono 6102332.'|| chr(13));--<4.0>
    elsif a_fase = 'DSN' then
        n_filas:= c_d.ContFilas;
        utl_file.put_line(f_doc, '------------------------------' || chr(13));
        utl_file.put_line(f_doc, 'SOT          :' || c_d.sot || chr(13));
        utl_file.put_line(f_doc, 'PROYECTO     :' || c_d.proyecto || chr(13));
        utl_file.put_line(f_doc, 'CLIENTE      :' || c_d.cliente || chr(13));
        utl_file.put_line(f_doc, 'DIRECCION    :' || c_d.direccion || chr(13));
        utl_file.put_line(f_doc, 'DISTRITO     :' || c_d.distrito ||  chr(13));
        utl_file.put_line(f_doc, 'DESCRIPCION  :' || c_d.descripcion || chr(13));
        utl_file.put_line(f_doc, 'OBSERVACION  :' || c_d.obs_sot || chr(13));
        utl_file.put_line(f_doc, 'TIPO SERVICIO:' || c_d.tipo_Servicio || chr(13));
        utl_file.put_line(f_doc, ''|| chr(13));
        utl_file.put_line(f_doc, ''|| chr(13));
        utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
        utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en la oficina del Ing. Adolfo Martínez, Jefe de Proyectos de Clientes, ubicada en Jr. Chinchón 910 - San Isidro, teléfono 6102332.'|| chr(13));--<4.0>
    elsif a_fase = 'CNLC' or a_fase = 'CNLR' or a_fase = 'TAFC' or a_fase = 'TAFR' then
        n_filas:= c_d.ContFilas;
        utl_file.put_line(f_doc, '------------------------------' || chr(13));
        utl_file.put_line(f_doc, 'SOT          :' || c_d.sot || chr(13));
        utl_file.put_line(f_doc, 'PROYECTO     :' || c_d.proyecto || chr(13));
        utl_file.put_line(f_doc, 'CLIENTE      :' || c_d.cliente || chr(13));
        utl_file.put_line(f_doc, 'DIRECCION    :' || c_d.direccion || chr(13));
        utl_file.put_line(f_doc, 'DISTRITO     :' || c_d.distrito ||  chr(13));
        utl_file.put_line(f_doc, 'DESCRIPCION  :' || c_d.descripcion || chr(13));
        utl_file.put_line(f_doc, 'OBSERVACION  :' || c_d.obs_sot || chr(13));
        utl_file.put_line(f_doc, ''|| chr(13));
        utl_file.put_line(f_doc, ''|| chr(13));
        utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
        utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en las oficinas de Planta Externa ubicada en Jr. Chinchón 910 - San Isidro.'|| chr(13));--<4.0>
    elsif a_fase = 'PINT' then
        n_filas:= c_d.ContFilas;
        utl_file.put_line(f_doc, '------------------------------' || chr(13));
        utl_file.put_line(f_doc, 'SOT          :' || c_d.sot || chr(13));
        utl_file.put_line(f_doc, 'PROYECTO     :' || c_d.proyecto || chr(13));
        utl_file.put_line(f_doc, 'CLIENTE      :' || c_d.cliente || chr(13));
        utl_file.put_line(f_doc, 'DIRECCION    :' || c_d.direccion || chr(13));
        utl_file.put_line(f_doc, 'DISTRITO     :' || c_d.distrito ||  chr(13));
        utl_file.put_line(f_doc, 'DESCRIPCION  :' || c_d.descripcion || chr(13));
        utl_file.put_line(f_doc, 'OBSERVACION  :' || c_d.obs_sot || chr(13));
        utl_file.put_line(f_doc, ''|| chr(13));
        utl_file.put_line(f_doc, ''|| chr(13));
        --ini 7.0
        --utl_file.put_line(f_doc, 'Cabe destacar que las condiciones comerciales se regirán a través de su contrato vigente, asimismo le indicamos que la recepción de la presente es señal de aceptación de las obras.'|| chr(13));--<4.0>
        --utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional en las oficinas de Planta Externa ubicada en Jr. Chinchón 910 - San Isidro.'|| chr(13));--<4.0>
        utl_file.put_line(f_doc, 'Agradeceremos recoger información adicional o cualquier consulta con el Ing. Melvin Martel al número 610-2941,'|| chr(13));
        utl_file.put_line(f_doc, 'para cualquier problema que se suscite con la asignación favor comunicarse con las siguientes personas,'|| chr(13));
        utl_file.put_line(f_doc, 'Nidya Alonzo al 613-1000 anexo 8863.'|| chr(13));
        --fin 7.0
    end if;
    utl_file.put_line(f_doc, ''|| chr(13));
    utl_file.put_line(f_doc, ''|| chr(13));

    utl_file.put_line(f_doc, 'Atentamente,'|| chr(13));
    utl_file.put_line(f_doc, ''|| chr(13));
    utl_file.put_line(f_doc, 'Nelson Moscoso'|| chr(13));
    utl_file.put_line(f_doc, 'Gerente de Control de Gestión'|| chr(13));
    --ini 7.0
    --utl_file.put_line(f_doc, 'Dirección de Soporte a la Operación'|| chr(13));
    utl_file.put_line(f_doc, 'Dirección de Mercado Masivo Alámbrico'|| chr(13));
    --fin 7.0
    utl_file.fclose(f_doc);

  end loop;

  for c_e in cur_email loop
    if n_filas > 0 then
      --Logica para poder registrar los correos enviados.
      select SQ_COLA_SEND_MAIL_JOB.nextval into n_cont from DUMMY_OPWF;
      insert into cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env)
      values (n_cont,'CLARO-SGA',vNomArch,c_e.email,v_cuerpo ,'1');

      p_envia_correo_c_attach(vNomArch,c_e.email,v_cuerpo,SendMailJPkg.ATTACHMENTS_LIST(v_ruta||'/'||vNomArch),'TELMEX-SGA');
    end if;
  end loop;

END;
--Fin 6.0

--Inicio 8.0
PROCEDURE p_envia_correo_cfg(a_idcfg in number,a_tipo number, a_contenido out varchar2)

IS
f_doc utl_file.file_type;
v_ruta varchar2(200);
n_filas number;
v_tabla varchar2(300);
v_NomArch varchar2(400);
v_NombreArch varchar2(400);
v_cabecera varchar2(4000);
v_cabeceraArch varchar2(4000);
v_cuerpo varchar2(4000);
v_cuerpo2 varchar2(4000);
v_detalle1 varchar2(4000);
v_detalle2 varchar2(4000);
--ini 13.0
v_query    varchar2(32767);--varchar2(5000);--11.0
v_querybd  varchar2(32767);--varchar2(4000);
--fin 13.0
v_contenido varchar2(32767);
v_contrata varchar2(400);
v_tipoformato  varchar2(4); --10.0
n_idcfgcon number;
src_cur1 INTEGER;
n_cant_cols number;
n_cont number;
v_columna DBMS_SQL.varchar2s;
v_valor DBMS_SQL.varchar2s;
rec_tab dbms_sql.desc_tab;


--Inicio 10.0
l_colCnt       number := 0;
l_separator    varchar2(1);
l_columnValue  varchar2(4000);
v_fila         varchar2(4000);
l_counter      number := 0;
l_max_rows     number := 65000; -- 65536 maximo de filas en excel
l_ind          number := 1; -- nro para nombrar los archivos nuevos
v_titulos      varchar2(4000);
v_condicion    varchar2(400);
--Fin 10.0

col_cnt integer;

Cursor cur_email is
SELECT correo
 FROM  operacion.CFG_ENV_CORREO_CONTRATA_DET
 where idcfgcon = n_idcfgcon and estado = 1
union --Usuario de Claro que van a Recibir el correo
SELECT correo
 FROM  operacion.CFG_ENV_CORREO_CONTRATA_DET
 where idcfgcon in (select idcfgcon from operacion.CFG_ENV_CORREO_CONTRATA_CON
                             where codcon = 1 and idcfg = a_idcfg);

Cursor cur_contrata is
SELECT CODCON,IDCFGCON
 FROM  operacion.CFG_ENV_CORREO_CONTRATA_CON
 where idcfg  = a_idcfg and estado = 1;


BEGIN
  --Inicio 10.0
  select cuerpo , NomArch, cabecera, detalle1,detalle2, query,condicion1,cant_columnas,tabla,tipoformato
  into v_cuerpo2, v_NombreArch, v_cabeceraArch, v_detalle1,v_detalle2, v_querybd,v_condicion, n_cant_cols, v_tabla,v_tipoformato
  from operacion.CFG_ENV_CORREO_CONTRATA
  where idcfg=a_idcfg;
  --Fin 10.0

  n_filas:=0;
  --Revisar las contratas asociadas al grupo de envio
  for c_c in cur_contrata loop
    -- ARCHIVO TEXTO
    if v_tipoformato='TXT' then --10.0
         n_idcfgcon:= c_c.idcfgcon;
         select nombre into v_contrata from contrata where codcon = c_c.codcon;
         --Inicio 10.0
         if nvl(v_condicion,'x')='x' or length(trim(v_condicion))=0 then
            v_query := v_querybd;
         else
             v_query := v_querybd || ' ' || v_condicion;
         end if;

         --CUADRILLA PROPIA
         if c_c.codcon=1 then
            v_query:= v_query;
         else
            v_query:= v_query ||' and ' || v_tabla || '.codcon = ' || to_char(c_c.codcon );
         end if;
         --Fin 10.0

         v_NomArch :=  v_NombreArch || '-' || to_char(c_c.codcon ) ||'-' || to_char(sysdate,'yyyymmdd')|| '.txt';

         select trim(valor) into v_ruta
         from constante where constante = 'DIR_ENV_CONTRA';

         f_doc := utl_file.fopen( v_ruta , v_NomArch, 'w');
         --Asignar Cabecera
         v_contenido := '';
         v_cuerpo := '';
         v_cabecera:= replace(v_cabeceraArch, '@', v_contrata);
         v_cabecera:= replace(v_cabecera, '#', to_char(sysdate,'dd/mm/yyyy'));
         v_contenido :=  v_contenido || v_cabecera|| chr(13)|| chr(13);
         p_put_line(f_doc, v_cabecera|| chr(13));
         p_put_line(f_doc, chr(13));

         --Asignar Cuerpo de Correo
         src_cur1 := DBMS_SQL.OPEN_CURSOR;
         DBMS_SQL.PARSE(src_cur1, v_query, 1);
         v_columna.delete;
         v_valor.delete;
         for n_cont in 1..n_cant_cols +1 loop
           v_columna(n_cont) :='C'|| to_Char(n_cont);
           DBMS_SQL.DEFINE_COLUMN(src_cur1, n_cont, v_columna(n_cont), 2000);
         end loop;
         n_filas := DBMS_SQL.EXECUTE(src_cur1);
         dbms_sql.describe_columns(src_cur1, col_cnt, rec_tab);
         for n_cont in 1..n_cant_cols loop
            v_columna(n_cont):= rec_tab(n_cont).col_name;
         end loop;

        loop
         if DBMS_SQL.FETCH_ROWS(src_cur1) > 0 then
           for n_cont in 1..n_cant_cols loop
             DBMS_SQL.COLUMN_VALUE(src_cur1, n_cont, v_valor(n_cont));
             v_cuerpo := v_columna(n_cont) || ' : '|| v_valor(n_cont);
             v_contenido := v_contenido ||v_cuerpo|| chr(13);
             p_put_line(f_doc, v_cuerpo);
             n_filas := n_filas + 1;
           end loop;
           v_contenido := v_contenido || chr(13);
           p_put_line(f_doc, chr(13));
         else
            dbms_sql.close_cursor(src_cur1);
            exit;
         end if;
         end loop;

         --Asignar detalle de correo
         v_contenido := v_contenido ||v_detalle1|| chr(13);
         v_contenido := v_contenido ||v_detalle2|| chr(13);
         p_put_line(f_doc, v_detalle1|| chr(13));
         p_put_line(f_doc, v_detalle2|| chr(13));
         --p_put_line(f_doc, v_detalle2|| to_char(n_filas)); 9.0
         utl_file.fclose(f_doc);
    else
         --Archivo EXCEL
         --Inicio 10.0
         n_idcfgcon:= c_c.idcfgcon;
         select nombre into v_contrata from contrata where codcon = c_c.codcon;

         if nvl(v_condicion,'x')='x' or length(trim(v_condicion))=0 then
            v_query := v_querybd;
         else
            v_query := v_querybd || ' ' || v_condicion;
         end if;

         --CUADRILLA PROPIA
         if c_c.codcon=1 then
            v_query := v_query;
         else
            v_query := v_query ||' and ' || v_tabla || '.codcon = ' || to_char(c_c.codcon );
         end if;

         v_NomArch :=  v_NombreArch || '-' || to_char(c_c.codcon ) ||'-' || to_char(sysdate,'yyyymmdd')|| '.csv';

         select trim(valor) into v_ruta
         from constante where constante = 'DIR_ENV_CONTRA';

         f_doc := utl_file.fopen( v_ruta , v_NomArch, 'w', 32760);
         --Asignar Cabecera
         v_contenido := '';
         v_cuerpo := '';
         v_titulos:= '';
         v_cabecera:= replace(v_cabeceraArch, '@', v_contrata);
         v_cabecera:= replace(v_cabecera, '#', to_char(sysdate,'dd/mm/yyyy'));
         v_contenido :=  v_contenido || v_cabecera|| chr(13);

         v_cabecera:= replace(v_cabecera,',',' ');

         IF NVL(v_cabecera,'X')<>'X' AND length(TRIM(v_cabecera))>0 THEN
           p_put_line(f_doc, v_cabecera|| chr(13));
         END IF ;

         --Asignar Cuerpo de Correo
         src_cur1 := DBMS_SQL.OPEN_CURSOR;
         DBMS_SQL.PARSE(src_cur1, v_query, dbms_sql.native);
         DBMS_SQL.describe_columns( src_cur1, l_colCnt, rec_tab );

         l_separator:='';

         for i in 1 .. n_cant_cols loop
          v_titulos:= v_titulos || l_separator || '"' || to_char(rec_tab(i).col_name) || '"';
          dbms_sql.define_column( src_cur1, i, l_columnValue, 4000 );
          l_separator := ',';
         end loop;

         p_put_line(f_doc, v_titulos);

         n_filas := dbms_sql.execute(src_cur1);

         while ( dbms_sql.fetch_rows(src_cur1) > 0 ) loop
          l_separator := '';
          l_counter := l_counter + 1;
          v_fila:='';

          IF (l_counter = l_max_rows) THEN
            l_counter := 0;
            l_ind := l_ind + 1;
            utl_file.fclose( f_doc );
            f_doc := utl_file.fopen( v_ruta, v_NomArch , 'w', 32760 );

          END IF;

          for i in 1 .. n_cant_cols LOOP
            dbms_sql.column_value( src_cur1, i, l_columnValue );
            --Inicio 11.0
            v_fila:= v_fila  ||  l_separator || replace(replace(l_columnValue,',',' '),'"',' ') ;
            --Fin 11.0

            n_filas := n_filas + 1;
            l_separator := ',';
          end loop;
          --Inicio 11.0
          p_put_line_xls(f_doc, v_fila);
          --Fin 11.0
        end loop;

         --Asignar detalle de correo
         v_contenido := v_contenido ||v_detalle1|| chr(13);
         v_contenido := v_contenido ||v_detalle2|| chr(13);

         v_detalle1:= replace(v_detalle1,',',';');
         v_detalle2:= replace(v_detalle2,',',';');

         p_put_line(f_doc, v_detalle1|| chr(13));
         p_put_line(f_doc, v_detalle2|| chr(13));

         dbms_sql.close_cursor(src_cur1);
         utl_file.fclose(f_doc);

    end if;
    --FIN 10.0

     --Enviar Correos
     if a_tipo = 1 then --Envia Correos
       for c_e in cur_email loop
         if n_filas > 0 then
            p_envia_correo_c_attach(v_NomArch,c_e.correo,v_cuerpo2,SendMailJPkg.ATTACHMENTS_LIST(v_ruta||'/'||v_NomArch));
             --Inicio 10.0
             INSERT INTO HISTORICO.OPET_ENVIO_CORREO_LOG
               (OPETV_TIPO,OPETV_MAIL,OPETV_NOMBRE )
             VALUES ('M',substr(trim(c_e.correo),1,200),v_NomArch);
             --Fin 10.0
         end if;
       end loop;
     else--Obtiene texto de correo
       a_contenido := v_contenido;

     end if;
  end loop;
END;

PROCEDURE p_put_line(a_file utl_file.file_type, a_cadena varchar2)

IS
l_pos number;
l_buffer VARCHAR2(32767);
l_chr10 PLS_INTEGER;
v_Cadena varchar2(32767);

BEGIN
  l_pos:=1;
  v_Cadena := a_Cadena;
  l_chr10:=1;
  WHILE 0 < l_chr10 LOOP
    l_buffer := DBMS_LOB.SUBSTR(v_Cadena, 32767, l_pos);
    EXIT WHEN l_buffer IS NULL;
    l_chr10  := INSTR(v_Cadena,CHR(10));
    IF l_chr10 != 0 THEN
      l_buffer := SUBSTR(l_buffer,1,l_chr10-1);
      v_Cadena := SUBSTR(v_Cadena,l_chr10+1);
    END IF;
    UTL_FILE.PUT_LINE(a_file, l_buffer || chr(13),TRUE);
    l_pos := 1;
  END LOOP;

END;
--Fin 8.0

--Inicio 10.0
PROCEDURE p_envia_correo_parcial_cfg(k_coneccion in number,k_idcfg in number)
IS
v_f_doc         utl_file.file_type;
v_ruta          varchar2(200);
v_n_filas       number;
v_NomArch       varchar2(400);
v_NombreArch    varchar2(400);
v_cabecera      varchar2(4000);
v_cabeceraArch  varchar2(4000);
v_cuerpo        varchar2(4000);
v_cuerpo2       varchar2(4000);
v_detalle1      varchar2(4000);
v_detalle2      varchar2(4000);
v_querycolum    varchar2(4000);
v_querybd       varchar2(4000);
v_query         varchar2(5000);--11.0
v_contrata      varchar2(400);
v_tipoformato   varchar2(4);
v_n_idcfgcon    number;
v_src_cur1      integer;
v_n_cant_cols   number;
v_n_cont        number;
v_columna       DBMS_SQL.varchar2s;
v_valor         DBMS_SQL.varchar2s;
v_valor_colum   DBMS_SQL.varchar2s;
v_rec_tab       DBMS_SQL.desc_tab;
v_l_colCnt      number := 0;
v_l_separator   varchar2(1);
v_l_counter     number := 0;
v_l_max_rows    number := 65000; -- 65536 maximo de filas en excel
v_l_ind         number := 1; -- nro para nombrar los archivos nuevos
v_titulos       varchar2(4000);
v_fila          varchar2(4000);
v_col_cnt       integer;
v_ln            integer;
v_lnt           integer;

Cursor cur_email is
  SELECT correo
  FROM   operacion.CFG_ENV_CORREO_CONTRATA_DET
  where  idcfgcon = v_n_idcfgcon and estado = 1
  union --Usuario de Claro que van a Recibir el correo
  SELECT correo
  FROM   operacion.CFG_ENV_CORREO_CONTRATA_DET
  where  idcfgcon in (select idcfgcon from operacion.CFG_ENV_CORREO_CONTRATA_CON
                      where  codcon = 1 and idcfg = k_idcfg);

Cursor cur_contrata is
 SELECT CODCON,IDCFGCON
 FROM  operacion.CFG_ENV_CORREO_CONTRATA_CON
 where idcfg  = k_idcfg and estado = 1;

BEGIN

  select cuerpo , NomArch, cabecera, detalle1,detalle2, cant_columnas, tipoformato
  into   v_cuerpo2, v_NombreArch, v_cabeceraArch, v_detalle1,v_detalle2, v_n_cant_cols,v_tipoformato
  from   operacion.CFG_ENV_CORREO_CONTRATA
  where  idcfg = k_idcfg;

   --ini 13.0
  v_NombreArch:= 'REENVIO_'|| v_NombreArch;
  --fin 13.0

  v_querybd:= 'SELECT ';

  for v_n_cont in 1..v_n_cant_cols loop
        v_querycolum:=v_querycolum||','||' CAMPO'||TO_CHAR(v_n_cont) ;
  end loop;

  for v_n_cont in 1..v_n_cant_cols loop
        v_querycolum:=v_querycolum||','||' TITULO'||TO_CHAR(v_n_cont) ;
  end loop;

  v_querycolum:=SUBSTR(v_querycolum,2,length(v_querycolum)) ;
  v_querybd:=v_querybd||v_querycolum||' FROM HISTORICO.T_TEMP_ENVIO_CORREO WHERE CONECCION= '||TO_CHAR(k_coneccion)||' AND FL_SELE='||chr(39)||'1'||chr(39) ;


  v_n_filas:=0;
  --Revisar las contratas asociadas al grupo de envio
  for c_c in cur_contrata loop
    -- ARCHIVO TEXTO
    if v_tipoformato='TXT' then
         v_n_idcfgcon:= c_c.idcfgcon;

         select nombre into v_contrata from contrata where codcon = c_c.CODCON;

         --CUADRILLA PROPIA
         if c_c.codcon=1 then
            v_query:= v_querybd;
         else
            v_query:= v_querybd ||' and filtro1 = ' ||chr(39)|| to_char(c_c.CODCON) ||chr(39);
         end if;

         v_NomArch :=  v_NombreArch || '-' || trim(to_char(c_c.CODCON)) ||'-' || to_char(sysdate,'yyyymmdd')|| '.txt';

         select trim(valor) into v_ruta
         from constante where constante = 'DIR_ENV_CONTRA';

         v_f_doc := utl_file.fopen( v_ruta , v_NomArch, 'w');
         --Asignar Cabecera
         v_cuerpo := '';
         v_cabecera:= replace(v_cabeceraArch, '@', v_contrata);
         v_cabecera:= replace(v_cabecera, '#', to_char(sysdate,'dd/mm/yyyy'));
         p_put_line(v_f_doc, v_cabecera|| chr(13));
         p_put_line(v_f_doc, chr(13));

         --Asignar Cuerpo de Correo
         v_src_cur1 := DBMS_SQL.OPEN_CURSOR;
         DBMS_SQL.PARSE(v_src_cur1, v_query, 1);
         v_columna.delete;
         v_valor.delete;

         v_l_separator:='';

         v_lnt:=v_n_cant_cols*2;

         for v_n_cont in 1..v_lnt loop
           v_columna(v_n_cont) :='C'|| to_Char(v_n_cont);
           DBMS_SQL.DEFINE_COLUMN(v_src_cur1, v_n_cont, v_columna(v_n_cont), 2000);
         end loop;

         v_n_filas := DBMS_SQL.EXECUTE(v_src_cur1);
         dbms_sql.describe_columns(v_src_cur1, v_col_cnt, v_rec_tab);
         for v_n_cont in 1..v_lnt loop
            v_columna(v_n_cont):= v_rec_tab(v_n_cont).col_name;
         end loop;

        loop
         if DBMS_SQL.FETCH_ROWS(v_src_cur1) > 0 then
           for v_n_cont in 1..v_n_cant_cols loop
             DBMS_SQL.COLUMN_VALUE(v_src_cur1, v_n_cont, v_valor(v_n_cont));
             v_ln:=v_n_cont +v_n_cant_cols ;
             DBMS_SQL.COLUMN_VALUE(v_src_cur1, v_ln, v_valor_colum(v_ln));
             v_cuerpo := v_valor_colum(v_ln) || ' : '|| v_valor(v_n_cont);
             p_put_line(v_f_doc, v_cuerpo);
             v_n_filas := v_n_filas + 1;
           end loop;
           p_put_line(v_f_doc, chr(13));
         else
            dbms_sql.close_cursor(v_src_cur1);
            exit;
         end if;
         end loop;

         --Asignar detalle de correo
         p_put_line(v_f_doc, v_detalle1|| chr(13));
         p_put_line(v_f_doc, v_detalle2|| chr(13));
         utl_file.fclose(v_f_doc);
    else
         --Archivo EXCEL

         v_n_idcfgcon:= c_c.idcfgcon;
         select nombre into v_contrata from contrata where codcon = c_c.CODCON;

         --CUADRILLA PROPIA
         if c_c.codcon=1 then
            v_query:= v_querybd;
         else
            v_query:= v_querybd ||' and filtro1 = ' ||chr(39)|| to_char(c_c.CODCON) ||chr(39);
         end if;

         v_NomArch :=  v_NombreArch || '-' || trim(to_char(c_c.CODCON)) ||'-' || to_char(sysdate,'yyyymmdd')|| '.csv';

         select trim(valor) into v_ruta
         from constante where constante = 'DIR_ENV_CONTRA';

         v_f_doc := utl_file.fopen( v_ruta , v_NomArch, 'w', 32760);
         --Asignar Cabecera
         v_cuerpo := '';
         v_titulos:= '';
         v_cabecera:= replace(v_cabeceraArch, '@', v_contrata);
         v_cabecera:= replace(v_cabecera, '#', to_char(sysdate,'dd/mm/yyyy'));

         v_cabecera:= replace(v_cabecera,',',' ');

         IF NVL(v_cabecera,'X')<>'X' AND length(TRIM(v_cabecera))>0 THEN
           p_put_line(v_f_doc, v_cabecera|| chr(13));
         END IF ;

         --Asignar Cuerpo de Correo
         v_src_cur1 := DBMS_SQL.OPEN_CURSOR;
         DBMS_SQL.PARSE(v_src_cur1, v_query, dbms_sql.native);
         DBMS_SQL.describe_columns( v_src_cur1, v_l_colCnt, v_rec_tab );

         v_columna.delete;
         v_valor.delete;

         v_l_separator:='';

         v_lnt:=v_n_cant_cols*2;

         for v_n_cont in 1..v_lnt loop
           v_columna(v_n_cont) :='C'|| to_Char(v_n_cont);
           DBMS_SQL.DEFINE_COLUMN(v_src_cur1, v_n_cont, v_columna(v_n_cont), 2000);
         end loop;

         v_l_counter:=0;

         v_n_filas := DBMS_SQL.EXECUTE(v_src_cur1);
         dbms_sql.describe_columns(v_src_cur1, v_col_cnt, v_rec_tab);
         for v_n_cont in 1..v_lnt loop
            v_columna(v_n_cont):= v_rec_tab(v_n_cont).col_name;
         end loop;

         --CONTENIDO DEL CORREO
         while ( dbms_sql.fetch_rows(v_src_cur1) > 0 ) loop
            v_l_separator := '';
            v_fila:=    '';
            v_l_counter := v_l_counter + 1;

            IF (v_l_counter = v_l_max_rows) THEN
              v_l_counter := 0;
              v_l_ind := v_l_ind + 1;
              utl_file.fclose( v_f_doc );
              v_f_doc := utl_file.fopen( v_ruta, v_NomArch , 'w', 32760 );

            END IF;

            for v_n_cont in 1 .. v_n_cant_cols LOOP
               DBMS_SQL.COLUMN_VALUE(v_src_cur1, v_n_cont, v_valor(v_n_cont));
               --Inicio 11.0
               v_fila:= v_fila || v_l_separator || '"' || replace(v_valor(v_n_cont),',',' ')|| '"';
               --Fin 11.0

               --Titulos
               if v_l_counter=1 then
                   v_ln:=v_n_cont +v_n_cant_cols ;
                   DBMS_SQL.COLUMN_VALUE(v_src_cur1, v_ln, v_valor_colum(v_ln));
                   v_titulos:= v_titulos || v_l_separator || '"' || v_valor_colum(v_ln) || '"';
                end if;

                v_l_separator:=',';
                v_n_filas := v_n_filas +1 ;

            end loop;

            if v_l_counter=1 then
                p_put_line(v_f_doc, v_titulos);
            end if;
            --Inicio 11.0
            p_put_line_xls(v_f_doc, v_fila);
             --Fin 11.0

        end loop;

         --Asignar detalle de correo

         v_detalle1:= replace(v_detalle1,',',';');
         v_detalle2:= replace(v_detalle2,',',';');

         p_put_line(v_f_doc, v_detalle1|| chr(13));
         p_put_line(v_f_doc, v_detalle2|| chr(13));

         dbms_sql.close_cursor(v_src_cur1);
         utl_file.fclose(v_f_doc);

    end if;

     --Enviar Correos
      for c_e in cur_email loop
         if v_n_filas > 0 then
            p_envia_correo_c_attach(v_NomArch,c_e.correo,v_cuerpo2,SendMailJPkg.ATTACHMENTS_LIST(v_ruta||'/'||v_NomArch));
            INSERT INTO HISTORICO.OPET_ENVIO_CORREO_LOG
            (OPETV_TIPO,OPETV_MAIL,OPETV_NOMBRE )
            VALUES ('P',substr(trim(c_e.correo),1,200),v_NomArch);
         end if;
      end loop;

  end loop;

END;

FUNCTION f_get_coneccion return number is
  k_coneccion number;
begin

  select  DISTINCT sid
  into    k_coneccion
  from    v$mystat
  where   rownum=1;

  return(k_coneccion);

end;

PROCEDURE p_carga_query_enviocorreo(k_coneccion in number,k_idcfg in number) IS
v_querybd      varchar2(4000);
v_querycolum   varchar2(4000);
v_queryvalor   varchar2(4000);
v_queryinsert  varchar2(4000);
v_queryupdate  varchar2(4000);
v_queryupdval  varchar2(4000);
v_n_cant_cols  number;
v_src_cur1     integer;
v_columna      DBMS_SQL.varchar2s;
v_valor        DBMS_SQL.varchar2s;
v_rec_tab      DBMS_SQL.desc_tab;
v_col_cnt      integer;
v_n_cont       number;
v_n_filas      number;
v_n_contador   number;
v_tabla        varchar2(300);
v_campofecha   varchar2(50);
v_camposot     varchar2(50);
v_campoproy    varchar2(50);
v_pos          integer;
v_long         integer;
--ini 13.0
v_valor_c      varchar2(4000);
--fin 13.0

BEGIN

     select query, cant_columnas, tabla,campofecha,camposot,campoproy
     into   v_querybd, v_n_cant_cols, v_tabla,v_campofecha,v_camposot,v_campoproy
     from   operacion.CFG_ENV_CORREO_CONTRATA
     where  idcfg = k_idcfg;

     DELETE FROM HISTORICO.T_TEMP_ENVIO_CORREO WHERE CONECCION=k_coneccion;

     v_pos := instr(UPPER(v_querybd),'SELECT');
     v_long:= v_pos + 6;

     v_querybd:= substr(v_querybd,v_long,length(v_querybd));
     v_querybd:= 'SELECT '|| v_tabla || '.codcon,' ||v_campofecha||','||v_camposot||','||v_campoproy ||','||v_querybd;
--     RAISE_APPLICATION_ERROR(-20500,  v_querybd   );


     v_src_cur1 := DBMS_SQL.OPEN_CURSOR;
     DBMS_SQL.PARSE(v_src_cur1, v_querybd, 1);
     v_columna.delete;
     v_valor.delete;

     for v_n_cont in 1..v_n_cant_cols + 4  loop
       v_columna(v_n_cont) :='C'|| to_Char(v_n_cont);
       DBMS_SQL.DEFINE_COLUMN(v_src_cur1, v_n_cont, v_columna(v_n_cont), 2000);
     end loop;

     v_n_filas := DBMS_SQL.EXECUTE(v_src_cur1);
     dbms_sql.describe_columns(v_src_cur1, v_col_cnt, v_rec_tab);
     v_querycolum:='';

     for v_n_cont in 1..v_n_cant_cols + 4 loop
        v_columna(v_n_cont):= v_rec_tab(v_n_cont).col_name;

        if v_n_cont>=1 and v_n_cont<=4 then
           v_querycolum:=v_querycolum||','||' FILTRO'||TO_CHAR(v_n_cont) ;
        else
           v_querycolum:=v_querycolum||','||' CAMPO'||TO_CHAR(v_n_cont-4) ;
        end if;

     end loop;

     v_querycolum:= ' CONECCION,REGISTRO ' ||v_querycolum ;

     v_n_contador := 0 ;
     while ( dbms_sql.fetch_rows(v_src_cur1) > 0 ) loop
           v_queryinsert :='INSERT INTO HISTORICO.T_TEMP_ENVIO_CORREO ('||v_querycolum||') VALUES (';
           v_queryvalor  :='';

           for v_n_cont in 1..v_n_cant_cols + 4 loop
             --INI 13.0
              DBMS_SQL.COLUMN_VALUE(v_src_cur1, v_n_cont, v_valor_c);

              --v_queryvalor:=  v_queryvalor ||','||chr(39)||SUBSTR( REPLACE(v_valor(v_n_cont),Chr(39),'') ,1,180)||chr(39);
              v_queryvalor:=  v_queryvalor ||','||chr(39)||SUBSTR( REPLACE(v_valor_c,Chr(39),'') ,1,180)||chr(39);
              --FIN 13.0
           end loop;
           v_n_contador:= v_n_contador +1 ;
           v_queryvalor:= to_char(k_coneccion)||','||to_char(v_n_contador) || v_queryvalor ;

           v_queryinsert:=v_queryinsert || v_queryvalor || ')';

           EXECUTE IMMEDIATE v_queryinsert;

     end loop;

     v_queryupdate:='UPDATE HISTORICO.T_TEMP_ENVIO_CORREO SET FL_SELE='||chr(39)||'0' ||chr(39);
     v_queryupdval:='';

     for v_n_cont in 1..v_n_cant_cols loop
         v_queryupdval:=  v_queryupdval ||','||' TITULO'||TO_CHAR(v_n_cont) ||'='||chr(39)||substr(v_columna(v_n_cont+4),1,20)||chr(39)  ;
     end loop;

     dbms_sql.close_cursor(v_src_cur1);

     v_queryupdate:=v_queryupdate  ||v_queryupdval||' WHERE CONECCION = '|| TO_CHAR(k_coneccion) ;

     EXECUTE IMMEDIATE v_queryupdate;

END;

PROCEDURE p_actualiza_temp_env(k_coneccion in number,k_registro in number) IS
begin

  UPDATE HISTORICO.T_TEMP_ENVIO_CORREO
  SET    FL_SELE   = '1'
  WHERE  CONECCION = k_coneccion
  AND    REGISTRO  = k_registro;

end ;

--Fin 10.0
--Inicio 11.0
PROCEDURE p_put_line_xls(a_file utl_file.file_type, a_cadena varchar2)
IS
l_chr13  PLS_INTEGER;
l_chr10  PLS_INTEGER;
v_Cadena varchar2(32767);

BEGIN
  v_Cadena := a_Cadena;
  l_chr13:=1;
  WHILE 0 < l_chr13 LOOP
   l_chr13  := INSTR(v_Cadena,CHR(13));

   IF l_chr13 != 0 THEN
      v_Cadena := SUBSTR(v_Cadena,1,l_chr13-1)||' '||SUBSTR(v_Cadena,l_chr13+2,LENGTH(v_Cadena)  );
    END IF;
  END LOOP;

  l_chr10:=1;
  WHILE 0 < l_chr10 LOOP
   l_chr10  := INSTR(v_Cadena,CHR(10));

   IF l_chr10 != 0 THEN
      v_Cadena := SUBSTR(v_Cadena,1,l_chr10-1)||' '||SUBSTR(v_Cadena,l_chr10+1,LENGTH(v_Cadena)  );
    END IF;
  END LOOP;

  UTL_FILE.PUT_LINE(a_file, v_Cadena||CHR(13),TRUE);

END;
--Fin 11.0
--ini 13.0
procedure SP_GET_QUERY(as_idcfg in number,
                       as_query1 out varchar2,
                       as_query2 out varchar2,
                       as_query3 out varchar2,
                       as_query4 out varchar2,
                       as_query5 out varchar2,
                       as_query6 out varchar2,
                       as_query7 out varchar2,
                       as_query8 out varchar2,
                       as_query9 out varchar2)
is
lb_qa clob;

BEGIN


  begin
    select RTRIM(query)
      into lb_qa
      from operacion.CFG_ENV_CORREO_CONTRATA
     where idcfg = as_idcfg;
  exception
    when no_data_found then
      lb_qa := '';
  end;

as_query1:=substr(lb_qa,1,4000);
as_query2:=substr(lb_qa,4001,4000);
as_query3:=substr(lb_qa,8001,4000);
as_query4:=substr(lb_qa,12001,4000);
as_query5:=substr(lb_qa,16001,4000);
as_query6:=substr(lb_qa,20001,4000);
as_query7:=substr(lb_qa,24001,4000);
as_query8:=substr(lb_qa,28001,4000);
as_query9:=substr(lb_qa,32001,4000);

END;

procedure sp_act_query(an_idcfg in number, as_query in varchar2) is

begin

    update  operacion.CFG_ENV_CORREO_CONTRATA
    set     query = as_query
    where   idcfg = an_idcfg;

end;

--fin 13.0
  --Ini 14.0
  procedure get_proced(p_id      number,
                       p_cadena1 out varchar2,
                       p_cadena2 out varchar2,
                       p_cadena3 out varchar2,
                       p_cadena4 out varchar2,
                       p_cadena5 out varchar2,
                       p_cadena6 out varchar2,
                       p_cadena7 out varchar2,
                       p_cadena8 out varchar2) is
    l_proc clob;

  begin
    begin
      select RTRIM(t.preproc)
        into l_proc
        from operacion.efautomatico t
       where t.id = p_id;
    exception
      when no_data_found then
        l_proc := '';
    end;

    p_cadena1 := substr(l_proc, 1, 4000);
    p_cadena2 := substr(l_proc, 4001, 4000);
    p_cadena3 := substr(l_proc, 8001, 4000);
    p_cadena4 := substr(l_proc, 12001, 4000);
    p_cadena5 := substr(l_proc, 16001, 4000);
    p_cadena6 := substr(l_proc, 20001, 4000);
    p_cadena7 := substr(l_proc, 24001, 4000);
    p_cadena8 := substr(l_proc, 28001, 4000);
  end;

  procedure upd_proced(p_id number, p_proce varchar2) is
  begin
    update operacion.efautomatico t
       set t.preproc = p_proce
     where t.id = p_id;
  end;

  function valida_usuario(p_user varchar2) return number is
    l_count number;
  begin
    select count(1)
      into l_count
      from opedd    d,
           tipopedd c
     where c.tipopedd = d.tipopedd
       and c.abrev = 'USR_SQL_SEF-EF'
       and d.codigoc = p_user
       and d.codigon = 1;

    return l_count;
  end;
  --Fin 14.0
  function valida_statement(p_sentencias varchar2) return number is
    l_valida number;

    cursor cur_sentencias is
      select d.codigoc
        from tipopedd c,
             opedd    d
       where c.abrev = 'LIST_STATEMENT'
         and c.tipopedd = d.tipopedd
         and d.abreviacion = 'STATEMENT_VALID'
         and d.codigon_aux = 1;

  begin
    l_valida := 0;
    for c_sent in cur_sentencias
    loop
      l_valida := l_valida + instr(upper(p_sentencias), c_sent.codigoc);
    end loop;

    return l_valida;
  end;
  
   /******************************************************************************
    Aprueba automáticamente los proyectos de traslado interno
  ******************************************************************************/  
 procedure SGASI_APRO_T_I(n_numslc vtatabslcfac.numslc%type)  IS
 
  n_codef_dst NUMBER;
  CURSOR cur_ptospri IS
  SELECT DISTINCT tipo_vta,codsuc,grupo,idproducto,numpto,TO_NUMBER(numpto) pto, tiptra FROM vtadetptoenl WHERE numslc=n_numslc;
  l_cur_ptospri cur_ptospri%ROWTYPE;
  n_codef_ori NUMBER;
  n_count NUMBER;
  n_aux NUMBER;
  BEGIN
  n_codef_dst:=TO_NUMBER(n_numslc);
  n_count := 0;
  n_aux := 0;
  SELECT COUNT(DISTINCT NVL(idproducto,0)) INTO n_count FROM vtadetptoenl WHERE numslc=n_numslc;
  n_aux := n_aux + n_count;
  SELECT COUNT(DISTINCT NVL(tipo_vta,0)) INTO n_count FROM vtadetptoenl WHERE numslc=n_numslc;
  n_aux := n_aux + n_count;
  SELECT COUNT(DISTINCT NVL(tiptra,0)) INTO n_count FROM vtadetptoenl WHERE numslc=n_numslc;
  n_aux := n_aux + n_count;
  IF n_aux>3 THEN
    soporte.send_mail_att('soporteproyectos@claro.com.pe','innovacionysoportedelaoperacion@claro.com.pe','ERROR DAO - P.'||n_numslc,'Más de 01 producto, tipo de venta o tipo de trabajo - P.'||n_numslc);
    RETURN;
  END IF;
  n_count := 0;
  OPEN cur_ptospri;
  FETCH cur_ptospri INTO l_cur_ptospri;
  SELECT codigon INTO n_codef_ori FROM tipopedd t, opedd o WHERE t.tipopedd=o.tipopedd AND o.codigoc='1' AND t.abrev='TI_EFPLANTILLA' AND codigon_aux=l_cur_ptospri.tiptra;
  
    CLOSE cur_ptospri;
    SELECT COUNT(*) INTO n_count FROM solefxarea WHERE codef=n_codef_dst;
    IF n_count=0 THEN
      INSERT INTO solefxarea (codef, numslc, estsolef, esresponsable, fecini,fecfin,numdiapla,observacion,fecusu,codusu,fecapr,numdiaval,area,tipproyecto)
      SELECT n_codef_dst,n_numslc,sxa.estsolef,sxa.esresponsable,SYSDATE,SYSDATE,sxa.numdiapla,sxa.observacion,sxa.fecusu,sxa.codusu,SYSDATE,sxa.numdiaval,sxa.area,sxa.tipproyecto
      FROM solefxarea sxa WHERE sxa.codef=n_codef_ori;
      UPDATE tmp_vtatabslcfac_derivef SET estado=2 WHERE numslc=n_numslc;

      FOR row_pto IN cur_ptospri LOOP
        operacion.pq_ef_clonacion.p_clonar_etapas_x_punto(n_codef_ori,n_codef_dst,1,row_pto.pto);
        operacion.pq_ef_clonacion.p_clonar_actividades_x_punto(n_codef_ori,n_codef_dst,1,row_pto.pto);
        UPDATE efptoetaact
        SET cantidad=DECODE((SELECT durcon FROM vtatabpspcli_v WHERE numslc=n_numslc),-1,36,NULL,36,(SELECT durcon FROM vtatabpspcli_v WHERE numslc=n_numslc))
        WHERE codef=n_codef_dst AND punto=row_pto.pto;
      END LOOP;
      operacion.p_act_costo_ef(n_codef_dst);
      operacion.pq_ef_clonacion.p_registro_clonacion(n_codef_ori,n_codef_dst,0,0);
      UPDATE ef SET estef=2,observacion='EF aprobado automáticamente. Proyecto I'||CHR(38)||'S-DAO' WHERE numslc=n_numslc;
      operacion.p_verifica_rentabilidad(n_codef_dst);

    END IF;

  soporte.send_mail_att('soporteproyectos@claro.com.pe','innovacionysoportedelaoperacion@claro.com.pe','EF Aprobado por DAO - P.'||n_numslc,'EF Aprobado por DAO - P.'||n_numslc);
  COMMIT;
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN 
      soporte.send_mail_att('soporteproyectos@claro.com.pe','innovacionysoportedelaoperacion@claro.com.pe','ERROR DAO - P.'||n_numslc,'Too Many Rows - P.'||n_numslc);
      raise_application_error(-20011,'Too Many Rows');
      RETURN;
    WHEN NO_DATA_FOUND THEN
      soporte.send_mail_att('soporteproyectos@claro.com.pe','innovacionysoportedelaoperacion@claro.com.pe','ERROR DAO - P.'||n_numslc,'No Data Found - P.'||n_numslc);
      raise_application_error(-20011,'No Data Found');
      RETURN;
    WHEN OTHERS THEN
      soporte.send_mail_att('soporteproyectos@claro.com.pe','innovacionysoportedelaoperacion@claro.com.pe','ERROR DAO - P.'||n_numslc,'Unknown Exception V_SQL - P.'||n_numslc);
      raise_application_error(-20011,'Unknown Exception V_SQL');
      RETURN;
  END;
END PQ_EF;
/