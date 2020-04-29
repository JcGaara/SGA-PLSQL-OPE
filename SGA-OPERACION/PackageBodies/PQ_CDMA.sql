CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CDMA AS
  /************************************************************
  NOMBRE:     PQ_CDMA
  PROPOSITO:

  REVISIONES:
  Version   Fecha        Autor                   Descripcisn
  --------- ----------  ---------------        ------------------------
  1.0    18/12/2012  Edilberto Astulle
  ***********************************************************/

 /************************************************************
  NOMBRE:     PQ_CDMA
  PROPOSITO:

  REVISIONES:
  Version   Fecha        Autor                   Descripcisn
  --------- ----------  ---------------        ------------------------
  1.0    18/12/2012  Edilberto Astulle
  ***********************************************************/

PROCEDURE p_envio_rown(n_row number,
   i_mensaje out number,
   o_mensaje out gc_salida) IS
   l_cont     number;
   l_seq_lote number;
   cursor cur_int is
      select codsolot,idcdma
      from operacion.trscdma
      where rownum <= n_row and est_envio = 0 order by codsolot;
  begin
    select  OPERACION.SEQ_LOTE_CDMA.nextval into l_seq_lote from dual;
    select count(1) into l_cont
    from operacion.trscdma
    where rownum <= n_row and est_envio = 0
     order by codsolot;
    if l_cont > 0 then
      for c_int in cur_int loop
        begin
          update operacion.trscdma
          set est_envio = 1,
          SEQ_LOTE_CDMA = l_seq_lote,FECACT = sysdate
          where codsolot = c_int.codsolot and idcdma = c_int.idcdma;
        exception
          when others then
            null;
        end;
        commit;
      end loop;
    end if;
      OPEN o_mensaje FOR
        select 1 REQ_TYPE,'BST' AS NE_TYPE, a.idcdma ORDER_NO,
        5 PRIORITY,DECODE(a.TIPTRS, 1, 1,
                                    3, 5,
                                    4, 3,
                                    5, 9) AS ACTIONID,
        'SGA' AS CLIENTE,'CDMA' AS SCENARIO_NAME,'TLP001' AS SERVICE_CODE,
        0 AS COMODIN, a.imsi IMSI1, a.codnumtel MSISDN1,
        DECODE(a.TIPTRS,1,TO_CHAR(a.NUMEROSERIE) || a.AKEY || TO_CHAR(7),NULL) AS PARAMS_CDMA
        from operacion.trscdma a
        where a.est_envio = 1 and a.SEQ_LOTE_CDMA = l_seq_lote
        order by codsolot;
       i_mensaje := 0;


  exception
    when others then
      o_mensaje := null;
      i_mensaje := 1;
      rollback;
  end;

PROCEDURE P_ACT_ROWN(A_IDSEQ     NUMBER,
                       A_RESPUESTA NUMBER,
                       O_IDERROR   out NUMBER,
                       O_IDMENSAJE out VARCHAR2)
IS

    l_cont  number;
    l_cont1 number;
  BEGIN
    select count(1)
      into l_cont
      from operacion.trscdma
     where idcdma = A_IDSEQ;
    if l_cont > 0 then
      select count(1)
        into l_cont1
        from operacion.trscdma
       where idcdma = A_IDSEQ;
      if l_cont1 > 0 then
        begin

				IF A_RESPUESTA = 0 THEN
					update operacion.trscdma
								 set est_envio = 2,
										 FECACT = sysdate
							 where idcdma = A_IDSEQ;
							O_IDERROR   := 1;
							O_IDMENSAJE := '0';
              COMMIT;
				ELSE
					update operacion.trscdma
								 set est_envio = 3,
										 FECACT = sysdate
							 where idcdma = A_IDSEQ;
							O_IDERROR   := 0;
							O_IDMENSAJE := 'Error en la Plataforma';
					COMMIT;

				END IF;



        exception
          when others then

            O_IDERROR   := 1;
            O_IDMENSAJE := 'Error' ;

        end;
      else
        O_IDERROR   := 1;
        O_IDMENSAJE := 'El comando no fue enviado a HLR';
      end if;

    else
      O_IDERROR   := 1;
      O_IDMENSAJE := 'No existen datos a actualizar';
    end if;

  EXCEPTION
    when others then
      O_IDERROR   := 1;
      O_IDMENSAJE := 'Error :' || SQLERRM;

  END;

PROCEDURE p_carga_trscdma
  (a_idtareawf in number,
   a_idwf      in number,
   a_tarea     in number,
   a_tareadef  in number)
IS
  l_cont number;
  l_valida number;
  l_codsolot number;

  cursor cur_cdma is
SELECT DISTINCT A.CODSOLOT,
       E.CODINSSRV,
       T.TIPTRS,
       B.PID,
       I.NUMERO CODNUMTEL,
       I.NUMEROSERIE,
       I.IMSI,
       G.FECCOM,
       G.TIPTRA,
       I.AKEY
  FROM SOLOTPTO A,
       INSPRD B,
       INSSRV E,
       TYSTABSRV C,
       SOLOT G,
       TIPTRABAJO T,
       WF D,
       SIMCAR I
 WHERE A.CODSOLOT = l_codsolot
   AND A.CODINSSRV = E.CODINSSRV
   AND E.CODINSSRV = B.CODINSSRV
   AND A.CODSOLOT = G.CODSOLOT
   AND E.CODSRV = C.CODSRV
   AND B.FLGPRINC = 1
   AND E.TIPINSSRV = 3
	 AND I.NUMERO = E.NUMERO
   AND G.CODSOLOT = D.CODSOLOT
   AND T.TIPTRA = G.TIPTRA;
BEGIN
  select codsolot into l_codsolot from wf where idwf = a_idwf;
  l_valida :=0;
  for cc_msg in cur_cdma loop
     l_valida :=1;
     insert into operacion.trscdma(codinssrv,tiptra,tiptrs,codsolot,fecprog,
     IMSI,CODNUMTEL,NUMEROSERIE,AKEY )
     values(cc_msg.codinssrv,cc_msg.tiptra,cc_msg.tiptrs,l_codsolot, cc_msg.feccom,
     cc_msg.imsi,cc_msg.codnumtel,cc_msg.NUMEROSERIE,cc_msg.akey);
  end loop;
  if l_valida = 1 then
    null;
  end if;
EXCEPTION
     when others then
     raise_application_error(-20001,'Error: ' || sqlerrm);
END;

END;
/