CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_FAXSERVER_XPLORA(a_codsolot in number) IS

l_codinssrv_old inssrv.codinssrv%type;
l_codinssrv inssrv.codinssrv%type;

BEGIN

/******************************************************************************

   	Ver        Fecha        Autor           Descripción
   	---------  ----------  ---------------  ------------------------
    1.0        07-03-2005  JC Lara	        El procedimiento Modifica Clona la
                                            instancia de servicio al Fax Server de X-plor@

******************************************************************************/


      select codinssrv into l_codinssrv_old from inssrv where codinssrv in (select codinssrv from solotpto where  codsrvnue = 3733 and  codsolot = a_codsolot );

      select max(nvl(codinssrv,0))+1 into l_codinssrv from inssrv;

      insert into inssrv (CODINSSRV, CODCLI, CODSRV, ESTINSSRV, TIPINSSRV, DESCRIPCION, DIRECCION, FECINI, CODSUC, BW, NUMSLC, NUMPTO, FECUSU,	CODUSU,	 CODUBI, TIPSRV, CID, CODPOSTAL)
      select l_codinssrv, CODCLI, CODSRV, ESTINSSRV, TIPINSSRV, DESCRIPCION, DIRECCION, FECINI, CODSUC, BW, NUMSLC, NUMPTO, FECUSU,	CODUSU,	 CODUBI, TIPSRV, CID, CODPOSTAL
      from inssrv
      where codinssrv = l_codinssrv_old ;

      commit;


      update  SOLOTPTO set codinssrv = l_codinssrv WHERE CODSOLOT = a_codsolot and codsrvnue = 3733 ;

      commit;


      update inssrv
      set codsrv = 3947
      where codinssrv in (l_codinssrv);

      commit;

END;
/


