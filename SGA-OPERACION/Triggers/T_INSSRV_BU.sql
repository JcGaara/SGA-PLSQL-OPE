CREATE OR REPLACE TRIGGER OPERACION.T_INSSRV_BU
BEFORE UPDATE
ON OPERACION.INSSRV
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_INSSRV_BU
  PROPOSITO:
  REVISIONES:
  Ver     Fecha       Autor             Solicitado por        Descripcion
  ------  ----------  ---------------   -----------------     -----------------------------------
  1.0     17/12/2010  Widmer Quispe     Edilberto Astulle     Req: 123054 y 123052, Asignación de plataforma por default.
  2.0     17/09/2012  Edilberto Astulle Edilberto Astulle     PROY-4854_Modificación de work flow de Wimax y HFC Claro Empresas
  3.0     04/09/2015  Dorian Sucasaca   Giovanni Vasquez      SD_426907
  ***********************************************************************************************/

DECLARE

as_cliente vtatabcli.nomcli%type;
lc_tipsrv tystipsrv.tipsrv%type;
lc_proy	  solot.numslc%type; --3.0

BEGIN
  if updating('CID') and :new.tipinssrv = 1 then
      if :new.cid is not null then
         :new.numero := 'CID.'||trim(to_char(:new.cid));
      end if;

    --return;
   end if;

   if :new.codsrv is null or :new.codsrv = '0000' then
     :new.codsrv := :old.codsrv;
   end if;

   if updating('numero') then
       update caminored
       set descripcion = :new.numero
       where codinssrv = :new.codinssrv;
  end if;

  begin
    select tipsrv into lc_tipsrv
     from vtatabslcfac
    where numslc = :new.numslc;
  exception
     when others then
        lc_tipsrv := '0000';
  end;

  if lc_tipsrv not in ('0061','0062') then

    --Esta linea fue agregado para la asignacion de pop.
    if :new.codelered is null then

        if :new.tipinssrv = 1 or (:new.tipinssrv = 3 and :new.cid is not null) then
          select nomcli into as_cliente from vtatabcli where codcli = :new.codcli;
        :new.codelered := F_CREAR_ELERED(18, as_cliente || '   ' || :new.descripcion, :new.direccion);
        end if;

    end if;

  end if;
--
  -- ini 3.0
  if lc_tipsrv = '0073' and :new.tipinssrv = 3 and :new.estinssrv = 1 and :old.estinssrv = 4 then
    lc_proy := operacion.f_get_proy(:new.numslc,1);
    insert into operacion.inssrv_janus values ( :new.codinssrv, :new.numero, lc_proy ); 
  end if;
  -- fin 3.0


  insert into inssrv_his
    (CODINSSRV,
     CODCLI,
     CODSRV,
     ESTINSSRV,
     TIPINSSRV,
     DESCRIPCION,
     DIRECCION,
     FECINI,
     FECACTSRV,
     FECFIN,
     NUMERO,
     CODSUC,
     BW,
     POP,
     NUMSLC,
     NUMPTO,
     CODELERED,
     CODUBI,
     TIPSRV,
     CID,
     idplataforma --<1.0>
     ,TIPCLI ,CO_ID,CUSTOMER_ID ,CUST_CODE ,BILLCYCLE ,IMEI ,SIMCARD  --2.0
     )
  values
    (:old.CODINSSRV,
     :old.CODCLI,
     :old.CODSRV,
     :old.ESTINSSRV,
     :old.TIPINSSRV,
     :old.DESCRIPCION,
     :old.DIRECCION,
     :old.FECINI,
     :old.FECACTSRV,
     :old.FECFIN,
     :old.NUMERO,
     :old.CODSUC,
     :old.BW,
     :old.POP,
     :old.NUMSLC,
     :old.NUMPTO,
     :old.CODELERED,
     :old.CODUBI,
     :old.TIPSRV,
     :old.CID,
     :old.idplataforma --<1.0>
     ,:old.TIPCLI ,:old.CO_ID,:old.CUSTOMER_ID ,:old.CUST_CODE ,:old.BILLCYCLE ,:old.IMEI ,:old.SIMCARD  --2.0
     );

  If Updating('CID') then
     Update inssrv_atention Set CID = :new.cid Where codinssrv = :new.codinssrv;
  End If;

END;
/