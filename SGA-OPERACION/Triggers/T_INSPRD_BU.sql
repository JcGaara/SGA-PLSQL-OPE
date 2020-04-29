CREATE OR REPLACE TRIGGER OPERACION."T_INSPRD_BU"
  before update on OPERACION.INSPRD
  for each row
   /*********************************************************************************************
  NOMBRE:            OPERACION.T_INSPRD_BU
  PROPOSITO:
  REVISIONES:
  Ver     Fecha       Autor             Solicitado por        Descripcion
  ------  ----------  ---------------   -----------------     -----------------------------------
  1.0     05/07/2010  Alexander Yong    Creacion --Rq. 134083
  2.0     17/12/2010  Widmer Quispe     Edilberto Astulle     Req: 123054 y 123052, Asignación de plataforma por default.
  3.0     03/08/2011  Ivan Untiveros    -                     REQ-160463 Se corrige 2.0 IDDET POR IDPLATAFORMA y agrega 2 campos nuevos
  ***********************************************************************************************/
declare
  ls_log OPERACION.OPE_INSPRD_LOG.desclog%type;

begin
  ls_log:='';



  if updating('PID') or :old.PID<>:new.PID then
     ls_log:= ls_log || ' PID antiguo= ' || :old.PID || ' PID nuevo= ' || :new.PID || ', ';
  end if;

  if updating('DESCRIPCION') or :old.DESCRIPCION<>:new.DESCRIPCION then
     ls_log:= ls_log || ' DESCRIPCION antiguo= ' || :old.DESCRIPCION || ' DESCRIPCION nuevo= ' || :new.DESCRIPCION || ', ';
  end if;

  if updating('ESTINSPRD') or :old.ESTINSPRD<>:new.ESTINSPRD then
     ls_log:= ls_log || ' ESTINSPRD antiguo= ' || :old.ESTINSPRD || ' ESTINSPRD nuevo= ' || :new.ESTINSPRD || ', ';
  end if;

  if updating('CODSRV') or :old.CODSRV<>:new.CODSRV then
     ls_log:= ls_log || ' CODSRV antiguo= ' || :old.CODSRV || ' CODSRV nuevo= ' || :new.CODSRV || ', ';
  end if;

  if updating('CODINSSRV') or :old.CODINSSRV<>:new.CODINSSRV then
     ls_log:= ls_log || ' CODINSSRV antiguo= ' || :old.CODINSSRV || ' CODINSSRV nuevo= ' || :new.CODINSSRV || ', ';
  end if;

  if updating('FECINI') or :old.FECINI<>:new.FECINI then
     ls_log:= ls_log || ' FECINI antiguo= ' || :old.FECINI || ' FECINI nuevo= ' || :new.FECINI || ', ';
  end if;

  if updating('FECFIN') or :old.FECFIN<>:new.FECFIN then
     ls_log:= ls_log || ' FECFIN antiguo= ' || :old.FECFIN || ' FECFIN nuevo= ' || :new.FECFIN || ', ';
  end if;

  if updating('CANTIDAD') or :old.CANTIDAD<>:new.CANTIDAD then
     ls_log:= ls_log || ' CANTIDAD antiguo= ' || :old.CANTIDAD || ' CANTIDAD nuevo= ' || :new.CANTIDAD || ', ';
  end if;

  if updating('FLGPRINC') or :old.FLGPRINC<>:new.FLGPRINC then
     ls_log:= ls_log || ' FLGPRINC antiguo= ' || :old.FLGPRINC || ' FLGPRINC nuevo= ' || :new.FLGPRINC || ', ';
  end if;

  if updating('NUMSLC') or :old.NUMSLC<>:new.NUMSLC then
     ls_log:= ls_log || ' NUMSLC antiguo= ' || :old.NUMSLC || ' NUMSLC nuevo= ' || :new.NUMSLC || ', ';
  end if;

  if updating('NUMPTO') or :old.NUMPTO<>:new.NUMPTO then
     ls_log:= ls_log || ' NUMPTO antiguo= ' || :old.NUMPTO || ' NUMPTO nuevo= ' || :new.NUMPTO || ', ';
  end if;

  if updating('CODEQUCOM') or :old.CODEQUCOM<>:new.CODEQUCOM then
     ls_log:= ls_log || ' CODEQUCOM antiguo= ' || :old.CODEQUCOM || ' CODEQUCOM nuevo= ' || :new.CODEQUCOM || ', ';
  end if;

  if updating('TIPCON') or :old.TIPCON<>:new.TIPCON then
     ls_log:= ls_log || ' TIPCON antiguo= ' || :old.TIPCON || ' TIPCON nuevo= ' || :new.TIPCON || ', ';
  end if;

  if updating('IDDET') or :old.IDDET<>:new.IDDET then
     ls_log:= ls_log || ' IDDET antiguo= ' || :old.IDDET || ' IDDET nuevo= ' || :new.IDDET || ', ';
  end if;

  --<2.0
  if updating('IDPLATAFORMA') or :old.IDPLATAFORMA<>:new.IDPLATAFORMA then
     ls_log:= ls_log || ' IDPLATAFORMA antiguo= ' || :old.IDPLATAFORMA || ' IDPLATAFORMA nuevo= ' || :new.IDPLATAFORMA || ', ';
  end if;
  --2.0>
  --Ini 3.0
  if updating('FLG_CNR') or :old.FLG_CNR<>:new.FLG_CNR then
     ls_log:= ls_log || ' FLG_CNR antiguo= ' || :old.FLG_CNR || ' FLG_CNR nuevo= ' || :new.FLG_CNR || ', ';
  end if;

  if updating('ID') or :old.ID<>:new.ID then
     ls_log:= ls_log || ' ID antiguo= ' || :old.ID || ' ID nuevo= ' || :new.ID || ', ';
  end if;
  --Fin 3.0

  if length(ls_log)>0 then

     insert into OPERACION.OPE_INSPRD_LOG ( PID,desclog)
     values( :new.PID,ls_log);

  end if;

end;
/



