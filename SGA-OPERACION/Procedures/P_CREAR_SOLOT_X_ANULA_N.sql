CREATE OR REPLACE PROCEDURE OPERACION.P_CREAR_SOLOT_X_ANULA_N(a_codsolot      IN NUMBER,
                                                              a_codsolotnuevo OUT NUMBER) IS
  /**********************************************************************
  Genera la copia del SOT que pasa a estado RECHAZADO
  20070815 Roy Concepcion Creación del procedimiento
  20071213 Sergio Le Roux tabla de relacion
  20091210 Luis Patiño se agrego para encontrar tipo de trabajo. CDMA
  **********************************************************************/
  l_codsolot NUMBER;
  --l_codsolotpto NUMBER;
  r_solot    solot%ROWTYPE;
  r_det      solot%ROWTYPE;
  r_solotpto solotpto%ROWTYPE;
  l_punto    NUMBER;

  ln_num  NUMBER;
  ln_num2 NUMBER;
  ln_num3 NUMBER;

BEGIN

  SELECT * INTO r_det FROM solot WHERE codsolot = a_codsolot;

  -- Paquetes Pymes
  SELECT COUNT(*)
    INTO ln_num
    FROM vtadetptoenl ve, vtatabslcfac p
   WHERE p.numslc = ve.numslc
     AND p.tipsrv = '0058'
     AND ve.numslc = r_det.numslc
     AND ve.idinsxpaq IS NOT NULL;

  -- Paquetes Cable
  SELECT COUNT(*)
    INTO ln_num3
    FROM vtadetptoenl ve, vtatabslcfac p
   WHERE p.numslc = ve.numslc
     AND p.tipsrv = '0061'
     AND ve.numslc = r_det.numslc;

  -- Paquetes TPI
  SELECT COUNT(*)
    INTO ln_num2
    FROM vtadetptoenl ve, proyecto_tpi tp
   WHERE ve.numslc = r_det.numslc
     AND ve.numslc = tp.numslc;

  /*  if ln_num > 0 then
     r_solot.tipsrv := '0058';
     r_solot.tiptra := 370; --Paquetes Pymes
  elsif ln_num2 >0 then
     r_solot.tipsrv := '0059';
     r_solot.tiptra := 371;  -- TPI
  elsif ln_num3 >0 then
     r_solot.tipsrv := '0061';
     r_solot.tiptra := 373;  -- CABLE
  else
     r_solot.tipsrv := r_det.tipsrv;
     r_solot.tiptra := 117;
  end if;*/

  if ln_num3 > 0 then
    r_solot.tipsrv := '0061';
    r_solot.tiptra := 373; -- CABLE
  elsif ln_num2 > 0 then
    r_solot.tipsrv := '0059';
    r_solot.tiptra := 371; -- TPI
  elsif ln_num > 0 then
    r_solot.tipsrv := '0058';
    r_solot.tiptra := 370; --Paquetes Pymes
  else
    r_solot.tipsrv := r_det.tipsrv;

  --20091210 Luis Patiño se agrego para encontrar tipo de trabajo. CDMA
    if r_det.tipsrv='0064'then
       select tiptranuevo into r_solot.tiptra
       from generabajas
       where tipsrv=r_det.tipsrv
       and  tiptra=r_det.tiptra;
    else
  -- fin 20091210 Luis Patiño se agrego para encontrar tipo de trabajo. CDMA
      r_solot.tiptra := 117;
    end if;
  end if;

  r_solot.codmotot := r_det.codmotot;
  r_solot.estsol   := 11;
  --r_solot.tipsrv := r_det.tipsrv;
  --r_solot.numslc      := r_det.numslc;
  r_solot.codcli      := r_det.codcli;
 -- r_solot.feccom      := r_det.feccom;
  r_solot.recosi      := r_det.recosi;
  r_solot.observacion := r_det.observacion;

  l_codsolot := null;

  pq_solot.p_insert_solot(r_solot, l_codsolot);

 /* INSERT INTO TMP_SOLOT_CODIGO
    (CODSOLOT, ESTADO, USUARIO, FECHAREGISTRO, FECHAEJECUCION)
  VALUES
    (l_codsolot, 0, user, sysdate, sysdate);*/

  DECLARE

    CURSOR r_detpto IS
      SELECT l_codsolot codsolot,
             tiptrs,
             codsrvant,
             bwant,
             codsrvnue,
             bwnue,
             codinssrv,
             cid,
             descripcion,
             direccion,
             tipo,
             estado,
             visible,
             puerta,
             pop,
             codubi,
             fecini,
             fecfin,
             fecinisrv,
             feccom,
             tiptraef,
             tipotpto,
             efpto,
             pid,
             pid_old,
             cantidad,
             codpostal,
             codinssrv_tra,
             flgmt
        FROM solotpto
       WHERE codsolot = a_codsolot;

  BEGIN

    FOR cur IN r_detpto LOOP
      r_solotpto.codsolot      := cur.codsolot;
      r_solotpto.tiptrs        := cur.tiptrs;
      r_solotpto.codsrvant     := cur.codsrvant;
      r_solotpto.bwant         := cur.bwant;
      r_solotpto.codsrvnue     := cur.codsrvnue;
      r_solotpto.bwnue         := cur.bwnue;
      r_solotpto.codinssrv     := cur.codinssrv;
      r_solotpto.cid           := cur.cid;
      r_solotpto.descripcion   := cur.descripcion;
      r_solotpto.direccion     := cur.direccion;
      r_solotpto.tipo          := cur.tipo;
      r_solotpto.estado        := cur.estado;
      r_solotpto.visible       := cur.visible;
      r_solotpto.puerta        := cur.puerta;
      r_solotpto.pop           := cur.pop;
      r_solotpto.codubi        := cur.codubi;
      r_solotpto.fecini        := cur.fecini;
      r_solotpto.fecfin        := cur.fecfin;
      r_solotpto.fecinisrv     := cur.fecinisrv;
      r_solotpto.feccom        := cur.feccom;
      r_solotpto.tiptraef      := cur.tiptraef;
      r_solotpto.tipotpto      := cur.tipotpto;
      r_solotpto.efpto         := cur.efpto;
      r_solotpto.pid           := cur.pid;
      r_solotpto.pid_old       := cur.pid_old;
      r_solotpto.cantidad      := cur.cantidad;
      r_solotpto.codpostal     := cur.codpostal;
      r_solotpto.codinssrv_tra := cur.codinssrv_tra;
      r_solotpto.flgmt         := cur.flgmt;

      pq_solot.p_insert_solotpto(r_solotpto, l_punto);

    END LOOP;
  END;

  a_codsolotnuevo := l_codsolot;
END;
/


