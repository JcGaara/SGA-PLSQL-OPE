CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CONSULTAS_SGA_SIAC IS
  --------------------------------------------------------------------------------
  PROCEDURE SGASS_DETA_SOLOT(pi_codsolot    number,
                                po_dato        out sys_refcursor,
                                po_cod_error   out int,
                                po_des_error   out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_DETA_SOLOT TAB1
    * Propósito         : Obtener DETALLE de una SOT para SGA EN SIAC
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : -
    * Fec Creación      : 09/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;
    v_codsolot number;

  begin
    if pi_codsolot is null then
      raise v_error1;
    else
      v_codsolot := pi_codsolot;
    end if;

    open po_dato for
      SELECT SOLOTPTO.FECINISRV FECINISRV_TPTO,   
			       SOLOTPTO.CODSOLOT,   
             SOLOTPTO.PUNTO,   
			       (SELECT TYSTABSRV.DSCSRV  FROM TYSTABSRV 
	             WHERE TYSTABSRV.CODSRV=SOLOTPTO.CODSRVNUE)|| 
             (select ' (Doble Velocidad F).' from billcolper.fidelizacion
               where codsolot   = solotpto.codsolot
                 and codinssrv  = solotpto.codinssrv
                 and codsrv_ori = solotpto.codsrvnue 
                 and estado     = 2) || 
   	         (SELECT decode(vtaequcom.dscequ, null, '', '-' || vtaequcom.dscequ)
      	        FROM insprd, vtaequcom
	             WHERE insprd.codequcom = vtaequcom.codequcom(+)
	               AND solotpto.pid = insprd.pid(+)
	               AND rownum=1) ||
			       (SELECT ID_IDENT 
			          FROM CUSPER.TMP_MIGRACION 
		           WHERE CAMPO2 = SOLOTPTO.CODINSSRV 
			           AND CAMPO1 = SOLOTPTO.CODSRVNUE ) SERVICIO,
				    decode(( select count(*) from billcolper.fidelizacion
                      where codsolot   = solotpto.codsolot
                        and codinssrv  = solotpto.codinssrv
                        and codsrv_ori = solotpto.codsrvnue 
                        and estado     = 2),1,solotpto.bwnue * 2,solotpto.bwnue) BWNUE,   
         INSSRV.DESCRIPCION DESCRIPCION_SRV,   
         INSSRV.TIPINSSRV,   
         INSSRV.NUMERO,   
         INSSRV.DIRECCION DIRECCION_SRV,   
         INSSRV.POP,   
         INSSRV.CODUBI CODUBI_SRV, 
         SOLOTPTO.CODINSSRV,   
         SOLOTPTO.CID,   
         SOLOTPTO.DESCRIPCION DESCRIPCION_TPTO,   
         SOLOTPTO.DIRECCION DIRECCION_TPTO,   
         SOLOTPTO.TIPO,   
         SOLOTPTO.ESTADO,   
         SOLOTPTO.VISIBLE,   
         SOLOTPTO.PUERTA,   
         SOLOTPTO.POP,   
         SOLOTPTO.CODUBI CODUBI_TPTO,   
         SOLOTPTO.FECINI,   
         SOLOTPTO.FECFIN,   
         SOLOTPTO.FECINISRV,   
         SOLOTPTO.FECCOM,   
         SOLOTPTO.TIPTRAEF,   
         SOLOTPTO.TIPOTPTO,   
         SOLOTPTO.EFPTO,   
         SOLOTPTO.PID,   
         SOLOTPTO.PID_OLD,   
         SOLOTPTO.CANTIDAD  
    FROM SOLOTPTO,   
         INSSRV
   WHERE 
         ( inssrv.codinssrv (+) = solotpto.codinssrv) and  
         ( ( nvl( inssrv.tipinssrv, 0 ) <> 6 ) AND  
         ( solotpto.codsolot = v_codsolot ) )    ;
    
    po_cod_error := 0;  
    po_des_error := 'Operación Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  --------------------------------------------------------------------------------
  PROCEDURE SGASS_DETA_TAREA(pi_codsolot    number,
                             po_dato        out sys_refcursor,
                             po_cod_error   out number,
                             po_des_error   out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_DETA_TAREA TAB2
    * Propósito         : Obtener DETALLE de TAREA de SOLOT para SGA EN SIAC
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : -
    * Fec Creación      : 09/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;
    pi_idwf    number;
  begin
    if pi_codsolot is null then
      raise v_error1;
    else
      select F_GET_WF_SOLOT ( pi_codsolot ) into pi_idwf from dual ;
    end if;

    open po_dato for
       SELECT 0 flg,
         v_tareawf.idtareawf,   
         v_tareawf.tarea_desc,   
         v_tareawf.area_desc,   
         v_tareawf.responsable_desc,   
         v_tareawf.estado_desc,   
         v_tareawf.tipoestado_desc,   
         v_tareawf.fecinisys,   
         v_tareawf.fecfinsys,   
         v_tareawf.fecini,   
         v_tareawf.fecfin,   
         v_tareawf.feccom,   
         v_tareawf.opcional,   
         v_tareawf.usufin  
       FROM v_tareawf  
      WHERE v_tareawf.idwf = PI_idwf    
      union all   
       select   1,
         c.idtareawf, 
         c.descripcion, 
         a.descripcion,  
         c.responsable,
         '',
         '',
         to_date(null),
         to_date(null),
         to_date(null),
         to_date(null),
         to_date(null),
         c.opcional,
         ''
         from tareawfcpy c, areaope a
        where c.area = a.area(+)  
          and idwf = pi_idwf 
          and c.idtareawf not in (select idtareawf from tareawf where idwf = PI_idwf  );
    
    po_cod_error := 0;  
    po_des_error := 'Operación Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
   -------------------------------------------------------------------------------
   PROCEDURE SGASS_DETA_ESTADO(pi_codsolot    number,
                               po_dato        out sys_refcursor,
                               po_cod_error   out number,
                               po_des_error   out varchar2) is

    /*
    ****************************************************************
    * Nombre SP         : SGASS_DETA_ESTADO TAB3
    * Propósito         : Obtener DETALLE de ESTADOS DE SOLOT para SGA EN SIAC
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : -
    * Fec Creación      : 09/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;    
  begin
    if pi_codsolot is null then
      raise v_error1;    
    end if;

    open po_dato for
        SELECT estsol.descripcion,
               solotchgest.fecha,   
               solotchgest.codusu,   
               solotchgest.tipo,
               solotchgest.observacion  
          FROM solot,   
               estsol,   
               solotchgest  
         WHERE solot.codsolot = solotchgest.codsolot  and  
               solotchgest.estado = estsol.estsol  and  
               solotchgest.tipo = 1 and
               SOLOT.CODSOLOT = PI_codsolot     
         union ALL
        SELECT estsolope.descripcion,
               solotchgest.fecha,   
               solotchgest.codusu,   
               solotchgest.tipo,
               solotchgest.observacion  
          FROM solot,   
               estsolope,   
               solotchgest  
         WHERE solot.codsolot = solotchgest.codsolot  and  
               solotchgest.estado = estsolope.estsolope  and  
               solotchgest.tipo = 2 and
               SOLOT.CODSOLOT = PI_codsolot ;

     po_cod_error := 0;  
     po_des_error := 'Operación Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
        po_cod_error := 2;
        po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
        po_cod_error := '-1';
        po_des_error := 'ERROR: ' || sqlerrm;
  end;
  
  /************************************************************************************************/
  PROCEDURE SGASS_DETA_TPENDIENTE(pi_codsolot    number,
                                  po_dato        out sys_refcursor,
                                  po_cod_error   out number,
                                  po_des_error   out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_DETA_TPENDIENTE TAB4
    * Propósito         : Obtener DETALLE de TAREA PENDIENTE para SGA EN SIAC
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : -
    * Fec Creación      : 09/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;
    pi_idwf    number;
    begin
        if pi_codsolot is null then
          raise v_error1;
        else
          select F_GET_WF_SOLOT ( pi_codsolot ) into pi_idwf from dual ;
        end if;

    open po_dato for
       SELECT 0 flg,
         v_tareawf.idtareawf,   
         v_tareawf.tarea_desc,   
         v_tareawf.area_desc,   
         v_tareawf.responsable_desc,   
         v_tareawf.estado_desc,   
         v_tareawf.tipoestado_desc,   
         v_tareawf.fecinisys,   
         v_tareawf.fecfinsys,   
         v_tareawf.fecini,   
         v_tareawf.fecfin,   
         v_tareawf.feccom,   
         v_tareawf.opcional,   
         v_tareawf.usufin  
    FROM v_tareawf  
   WHERE V_TAREAWF.TIPESTTAR NOT IN(4,5) 
   		 AND v_tareawf.idwf = PI_idwf    
        union all   
        select   1,
         c.idtareawf, 
         c.descripcion, 
         a.descripcion,  
         c.responsable,
         '',
         '',
         to_date(null),
         to_date(null),
         to_date(null),
         to_date(null),
         to_date(null),
         c.opcional,
         ''
        from tareawfcpy c, areaope a
        where c.area = a.area(+)  
        and idwf = PI_idwf 
        and c.idtareawf not in (select idtareawf from tareawf where idwf = PI_idwf);
              
    po_cod_error := 0;  
    po_des_error := 'Operación Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  /************************************************************************************************/
   PROCEDURE SGASS_DETA_ANOTACIONES(pi_codsolot    number,
                                    po_dato        out sys_refcursor,
                                    po_cod_error   out number,
                                    po_des_error   out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_DETA_ANOTACIONES TAB5
    * Propósito         : Obtener DETALLE de ANOTACIONES para SGA EN SIAC
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : -
    * Fec Creación      : 19/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;
    v_codsolot number;

  begin
    if pi_codsolot is null then
      raise v_error1;
    else
      v_codsolot := pi_codsolot;
    end if;

    open po_dato for
      SELECT "TAREAWFSEG"."IDSEQ",   
         "TAREAWFSEG"."IDTAREAWF",   
         "TAREAWFSEG"."OBSERVACION",   
         "TAREAWFSEG"."FECUSU",   
         "TAREAWFSEG"."CODUSU",   
         "TAREADEF"."DESCRIPCION",   
         "TAREAWFSEG"."FLAG"  
    FROM "TAREAWFSEG",   
         "TAREAWF",   
         "TAREADEF"  ,
         wf
   WHERE ( tareawf.tareadef = tareadef.tareadef (+)) and  
         ( "TAREAWFSEG"."IDTAREAWF" = "TAREAWF"."IDTAREAWF" ) and  
         wf.idwf = tareawf.idwf  and
         wf.codsolot = v_codsolot
         AND  wf.valido = 1;
    
    po_cod_error := 0;  
    po_des_error := 'Operación Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  /************************************************************************************************/
  PROCEDURE SGASS_DETA_CTREQU (pi_codsolot    number,
                               po_dato        out sys_refcursor,
                               po_cod_error   out number,
                               po_des_error   out varchar2) IS
   /*
    ****************************************************************
    * Nombre SP         : SGASS_DETA_CTRL_EQUIPOS TAB6
    * Propósito         : Obtener DETALLE de EQUIPOS PARA YUNA SOLOT para SGA EN SIAC
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : -
    * Fec Creación      : 09/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;
    v_codsolot number;

  begin
    if pi_codsolot is null then
      raise v_error1;
    else
      v_codsolot := pi_codsolot;
    end if;

    open po_dato for
      SELECT /*+rule */ SOLOTPTOEQU.CODETA,
       ETAPA.DESCRIPCION DESCRIPCION_ETAPA,
       SOLOTPTOEQU.CODSOLOT,
       SOLOTPTOEQU.PUNTO,
       SOLOTPTOEQU.ORDEN,
       SOLOTPTOEQU.TIPEQU,
       SOLOTPTOEQU.CANTIDAD,
       SOLOTPTOEQU.TIPPRP,
       SOLOTPTOEQU.COSTO,
       SOLOTPTOEQU.NUMSERIE,
       SOLOTPTOEQU.MAC,
       SOLOTPTOEQU.INSTALADO,
       SOLOTPTOEQU.ESTADO,
       SOLOTPTOEQU.TIPO,
       SOLOTPTOEQU.OBSERVACION,
       TIPEQU.DESCRIPCION DESCRIPCION_TIPEQU,
       SOLOTPTOEQU.FLGSOL,
       SOLOTPTOEQU.FLGREQ,
       ALMTABMAT.COD_SAP cod_sap,
       SOLOTPTOEQU.FECFDIS,
       SOLOTPTO.DESCRIPCION DESCRIPCION_TPTO,
       SOLOTPTOEQU.CODUSUDIS,
       SOLOTPTOEQU.NRO_RES,
       SOLOTPTOEQU.pep pep,
       SOLOTPTOEQU.pep_leasing pep_leasing
  FROM SOLOTPTOEQU, SOLOTPTO, TIPEQU, ALMTABMAT, ETAPA, solot
 WHERE (SOLOTPTOEQU.CODSOLOT = SOLOTPTO.CODSOLOT)
   AND (SOLOTPTOEQU.TIPEQU = TIPEQU.TIPEQU)
   AND (SOLOTPTOEQU.codeta = etapa.codeta(+))
   AND (SOLOTPTOEQU.PUNTO = SOLOTPTO.PUNTO)
   AND TIPEQU.CODTIPEQU = ALMTABMAT.CODMAT(+)
   AND solotpto.codsolot = solot.codsolot
   AND (solot.codsolot = v_codsolot );
    
    po_cod_error := 0;  
    po_des_error := 'Operación Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;                                 
  /************************************************************************************************/
  PROCEDURE SGASS_DETA_AGENDAMIENTO (pi_codsolot    number,
                                     po_dato        out sys_refcursor,
                                     po_cod_error   out number,
                                     po_des_error   out varchar2) IS

     /*
    ****************************************************************
    * Nombre SP         : SGASS_DETA_AGENDAMIENTO TAB7
    * Propósito         : Obtener DETALLE de AGENDAMIENTO DE una SOT para SGA EN SIAC
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : -
    * Fec Creación      : 09/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;
    v_codsolot number;
    an_codcon NUMBER;
  begin
    if pi_codsolot is null then
      raise v_error1;
    else
      v_codsolot := pi_codsolot;
    end if;
    an_codcon := null;
    open po_dato for
      select idagenda,
             c.nombre,
             e.nomcli,
             a.codsolot solot, a.codcon, 
             a.direccion,
             v.dist_desc distrito,
             a.fecreg fecregistro,
             s.descripcion estado,
             a.numslc proyecto,
             fecha_instalacion,
             a.observacion,  
             a.referencia,
             fecagenda fecha,
             t.descripcion tipo_agenda,
             a.acta_instalacion,
             a.usureg,
             a.usumod,
             a.fecmod,
             a.codincidence  	
        from agendamiento       a,
             vtatabdst       v,
             contrata            c,
             tipo_agenda         t,
             marketing.vtatabcli e,
             estagenda           s, solot sot, opedd d
       where a.codubi = v.codubi(+)
         and a.codcon = c.codcon(+)
         and a.tipo_agenda = t.tipo_agenda(+)
         and a.codcli = e.codcli(+)
         and a.estage = s.estage(+)
         and a.codsolot=v_codsolot
      and ( (an_codcon is null  )  or  (an_codcon is not null and a.codcon = nvl(an_codcon , a.codcon)))
      and a.codsolot = sot.codsolot
      and not d.codigon= sot.tiptra
      and d.tipopedd=565;
    
    po_cod_error := 0;  
    po_des_error := 'Operación Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end; 
                                  
  /************************************************************************************************/                                   
  PROCEDURE SGASS_DETALLE_AGENDA (pi_idagenda    number,
                                  po_dato        out sys_refcursor,
                                  po_cod_error   out number,
                                  po_des_error   out varchar2) IS
   /*
    ****************************************************************
    * Nombre SP         : SGASS_DETALLE_AGENDA TAB7
    * Propósito         : Obtener DETALLE de AGENDA DE una AGENDAMIENTO para SGA EN SIAC
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : -
    * Fec Creación      : 09/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;
  begin
    if pi_idagenda is null then
      raise v_error1;    
    end if;
        
    open po_dato for
      select b.descripcion, a.usureg,a.fecreg, a.observacion
       from  agendamientochgest a, estagenda b
       where idagenda = pi_idagenda
       and a.estado = b.estage;
    
    po_cod_error := 0;  
    po_des_error := 'Operación Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;                                   
  /************************************************************************************************/
                                     
  PROCEDURE SGASS_DETA_TRANS (pi_codsolot    number,
                                   po_dato        out sys_refcursor,
                                   po_cod_error   out number,
                                   po_des_error   out varchar2) IS
      /*
    ****************************************************************
    * Nombre SP         : SGASS_DETA_TRANSACCIONES TAB8
    * Propósito         : Obtener DETALLE de TRANSACCIONES DE una SOT para SGA EN SIAC
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : -
    * Fec Creación      : 09/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;
    v_codsolot number;
    
  begin
    if pi_codsolot is null then
      raise v_error1;
    else
      v_codsolot := pi_codsolot;
    end if;
    
    open po_dato for     
        SELECT TRSSOLOT.CODTRS,
         TRSSOLOT.CODINSSRV,
         TRSSOLOT.CODSOLOT,
         TRSSOLOT.TIPO,
         TRSSOLOT.TIPTRS,
         TRSSOLOT.ESTTRS,
         TRSSOLOT.ESTINSSRV,
         TRSSOLOT.ESTINSSRVANT,
         TRSSOLOT.CODSRVNUE,
         TRSSOLOT.BWNUE,
         TRSSOLOT.CODSRVANT,
         TRSSOLOT.BWANT,
         TRSSOLOT.FECEJE,
         TRSSOLOT.FECTRS,
         TRSSOLOT.NUMSLC,
         TRSSOLOT.NUMPTO,
         TRSSOLOT.IDADD,
         TYSTABSRV.DSCSRV,
         VTADETPTOENL.DESCPTO,
         TRSSOLOT.CODUSUEJE,
         VTAEQUCOM.DSCEQU,
         VTADETSLCFACEQU.CNDEQU,
         TRSSOLOT.FLGBIL,
         (select distinct usuope.nombre
            from ope_solicitud_fecha_retro_cab ope, usuarioope usuope
           where ope.codsolot = trssolot.codsolot
             and ope.usu_aprob = usuope.usuario
             and rownum = 1) usu_aprob
    FROM TRSSOLOT,
         TYSTABSRV,
         VTADETPTOENL,
         VTADETSLCFACEQU,
         VTAEQUCOM
   WHERE (vtadetptoenl.numslc(+) = trssolot.numslc)
     and (vtadetptoenl.numpto(+) = trssolot.numpto)
     and (vtadetslcfacequ.numslc(+) = trssolot.numslc)
     and (vtadetslcfacequ.idadd(+) = trssolot.idadd)
     and (tystabsrv.codsrv(+) = trssolot.codsrvnue)
     and (vtaequcom.codequcom(+) = vtadetslcfacequ.codequcom)
    and (TRSSOLOT.CODSOLOT = v_codsolot);
    
    po_cod_error := 0;  
    po_des_error := 'Operación Exitosa'; 
    /*FETCH PO_DATO INTO V_REGISTER ;         
        if po_dato%NOTFOUND then
          RAISE NO_DATA_FOUND;      
        else      
             
        end if; 
     CLOSE PO_DATO;*/
  exception
    when NO_DATA_FOUND then
      po_cod_error := '-2';  
      po_des_error := 'No hay Datos para la sot '||v_codsolot;
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;                                 
  /************************************************************************************************/ 
  
   procedure SGASS_IMP_REDIRECCIONA (pi_codsolot        number, 
                                   pi_usuario         varchar2,
                                   po_cursor      out sys_refcursor,
                                   po_cod_error   out number,
                                   po_des_error   out varchar2) is
    /*
     ****************************************************************
    * Nombre SP         : SGASS_IMP_REDIRECCIONA
    * Propósito         : Envia datos del reclamo.
    * Input             : pi_codsolot --> SOT
                          pi_usuario  --> Usuario que accede
    * Output            : Envia cursor con datos del reclamo.
    * Creado por        : Diana Chunqui.
    * Fec Creación      : 26/04/2018
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_idTransaccion varchar2(20);
    v_ipAplicacion  varchar2(20);
    v_Aplicacion    varchar2(10);
    v_opcion        varchar2(10);
    v_ipCliente     varchar2(10);
    v_ipServOrigen  varchar2(10);
    v_nro_caso      varchar2(32);
    v_nro_contrato  varchar2(32);
    v_opcionjason   varchar2(100);
    v_estadoform    varchar2(100);
    v_tipocasoint   varchar2(100);
    v_aplicacion_siacrec varchar2(10);
    
  begin
    
    v_idTransaccion := to_char(sysdate, 'YYYYMMDDHHMISS');
    v_ipAplicacion  := OPERACION.PQ_SOLOT.sgafun_get_parametro('reclamos', 'param_req', 1);
    v_Aplicacion    := operacion.pq_solot.sgafun_get_parametro('reclamos', 'param_req', 2);
    v_opcion        := operacion.pq_solot.sgafun_get_parametro('reclamos', 'param_req', 3);
    v_ipcliente     := operacion.pq_solot.sgafun_get_parametro('reclamos', 'param_req', 4);
    v_ipservorigen  := operacion.pq_solot.sgafun_get_parametro('reclamos', 'param_req', 5);
    v_opcionjason   := operacion.pq_solot.sgafun_get_parametro('reclamos', 'param_req', 6);
    v_estadoform    := operacion.pq_solot.sgafun_get_parametro('reclamos', 'param_req', 7);
    v_tipocasoint   := operacion.pq_solot.sgafun_get_parametro('reclamos', 'param_req', 8);
    v_aplicacion_siacrec   := operacion.pq_solot.sgafun_get_parametro('reclamos', 'param_req', 9);

    select t.rsotv_nro_caso
      into v_nro_caso
      from operacion.sgat_reclamo_sot t
     where t.rsotv_nro_sot = pi_codsolot;

    v_nro_contrato := null;

    open po_cursor for
      select v_nro_caso           casointeraccionid, 
             v_Aplicacion         tipoapp,
             v_nro_contrato       coid, 
             v_opcionjason        opcionjason,
             v_estadoform         estadoform,
             v_tipocasoint        tipocasointeraccion,
             v_idTransaccion      idTransaccion,
             v_ipAplicacion       ipAplicacion,
             pi_usuario           usuarioAplicacion,
             v_opcion             opcion,     
             v_aplicacion_siacrec aplicacion,
             v_ipcliente          ipcliente,
             v_ipservorigen       ipservorigen          
      from dual; 
      
    po_cod_error := 0;
    po_des_error := 'Operación Exitosa'; 
    
    exception
    when others then
      open po_cursor for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;       

  end;
    
 /************************************************************************************************/
                              
END;
/


