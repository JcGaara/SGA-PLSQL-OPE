create or replace trigger OPERACION.T_AGENDAMIENTO_BIU
  before insert or update
ON OPERACION.AGENDAMIENTO REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_AGENDAMIENTO_BIU
   PROPOSITO:  Genera log de agendamiento

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        REQ 128635 141200
   2.0        PROY-5096  Christian R.       Evaluación y venta unificada con facturación 
   3.0        30/06/14   Lady Curay         Proy. Liberar recursos no utilizados de TPI GSM Urbano
   4.0        11/11/14   Edilberto Astulle  SD_120302 Problemas en actualizacion masiva Agenda workflow SGA - Sot de baja HFC
   **************************************************************************/
DECLARE
  nSecuencial number;
  ln_idwf   NUMBER;--3.0
  ln_tarea NUMBER; --3.0
  ln_tareadef NUMBER;--3.0 
  n_valida NUMBER;--4.0 
  
BEGIN
  /*Ini 2.0*/
  SELECT operacion.SQ_AGENDA_LOG.NEXTVAL INTO nSecuencial FROM dummy_ope;/*Fin 2.0*/
  IF INSERTING and :new.codcon is not null THEN
     INSERT INTO OPERACION.AGENDAMIENTO_LOG_AGE
     (IDSEQ, IDAGENDA, CODCONREAGENDA)
     VALUES
     (nSecuencial, :NEW.IDAGENDA, :NEW.CODCON);
     :new.fecreagenda := sysdate;
     :new.usureagenda := user;
     elsif updating('CODCON') and (:new.codcon <> nvl(:old.codcon, 0)) then
     INSERT INTO OPERACION.AGENDAMIENTO_LOG_AGE
     (IDSEQ, IDAGENDA, CODCONREAGENDA)
     VALUES
     (nSecuencial, :NEW.IDAGENDA, :NEW.CODCON);
     :new.fecreagenda := sysdate;
     :new.usureagenda := user;
  END IF;

  --3.0 ini

 /* Select tipsrv into lc_tipsrv 
  from cusbra.br_sel_wf where wfdef=1150 and tiptra = ln_tiptra;*/
  select count(1) into n_valida from tipopedd where abrev='ACTASIGNROTPIGSM';--4.0
  if :NEW.estage= 16 and TELEFONIA.PQ_TPI_GSM_URBANO.F_tpi_gsm(:new.codsolot)> 0 and 
     TELEFONIA.PQ_TPI_GSM_URBANO.F_No_asignado(:NEW.codinssrv)=0 and n_valida=1 then--4.0
    --agendamiento
    
    Select idwf,tarea,tareadef  into ln_idwf,ln_tarea,ln_tareadef 
    from tareawf where Idtareawf=:NEW.Idtareawf;

    
    TELEFONIA.PQ_TPI_GSM_URBANO.p_asig_numtelef_TPI(:NEW.Idtareawf,ln_idwf, ln_tarea, ln_tareadef );
    
  
  end if;

  --3.0 fin

END;
/
