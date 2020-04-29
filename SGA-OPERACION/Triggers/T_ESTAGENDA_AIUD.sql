CREATE OR REPLACE TRIGGER OPERACION.T_ESTAGENDA_AIUD
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.ESTAGENDA
  FOR EACH ROW

  /***************************************************************************
   NOMBRE    : t_estagenda_aiud
   PROPOSITO : Genera log de operacion.estagenda
   
   REVISIONES:
   Ver.    Fecha       Autor                 Descripción 
   ------  ----------  --------------------  ------------------------------
   1.0     06/03/2020  Janpierre Benito      Creación de Trigger
  ***************************************************************************/

declare
  n_idseq NUMBER;
begin

  SELECT historico.sq_estagenda_log.NEXTVAL INTO n_idseq FROM DUAL;

  IF INSERTING THEN
  
    INSERT INTO HISTORICO.ESTAGENDA_LOG
      (idseq,
       estage,
       descripcion,
       fecusu,
       codusu,
       abrevi,
       activo,
       estfinal,
       envia_mail,
       reagenda,
       tipestage,
       pre_proc,
       pos_proc,
       flg_liquidamo,
       flg_liquidamat,
       acc_log)
    VALUES
      (n_idseq,
       :NEW.estage,
       :NEW.descripcion,
       :NEW.fecusu,
       :NEW.codusu,
       :NEW.abrevi,
       :NEW.activo,
       :NEW.estfinal,
       :NEW.envia_mail,
       :NEW.reagenda,
       :NEW.tipestage,
       :NEW.pre_proc,
       :NEW.pos_proc,
       :NEW.flg_liquidamo,
       :NEW.flg_liquidamat,
       'I');
  
  ELSIF UPDATING THEN
  
    INSERT INTO HISTORICO.ESTAGENDA_LOG
      (idseq,
       estage,
       descripcion,
       fecusu,
       codusu,
       abrevi,
       activo,
       estfinal,
       envia_mail,
       reagenda,
       tipestage,
       pre_proc,
       pos_proc,
       flg_liquidamo,
       flg_liquidamat,
       acc_log)
    VALUES
      (n_idseq,
       :NEW.estage,
       :NEW.descripcion,
       :NEW.fecusu,
       :NEW.codusu,
       :NEW.abrevi,
       :NEW.activo,
       :NEW.estfinal,
       :NEW.envia_mail,
       :NEW.reagenda,
       :NEW.tipestage,
       :NEW.pre_proc,
       :NEW.pos_proc,
       :NEW.flg_liquidamo,
       :NEW.flg_liquidamat,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO HISTORICO.ESTAGENDA_LOG
      (idseq,
       estage,
       descripcion,
       fecusu,
       codusu,
       abrevi,
       activo,
       estfinal,
       envia_mail,
       reagenda,
       tipestage,
       pre_proc,
       pos_proc,
       flg_liquidamo,
       flg_liquidamat,
       acc_log)
    VALUES
      (n_idseq,
       :OLD.estage,
       :OLD.descripcion,
       :OLD.fecusu,
       :OLD.codusu,
       :OLD.abrevi,
       :OLD.activo,
       :OLD.estfinal,
       :OLD.envia_mail,
       :OLD.reagenda,
       :OLD.tipestage,
       :OLD.pre_proc,
       :OLD.pos_proc,
       :OLD.flg_liquidamo,
       :OLD.flg_liquidamat,
       'D');
  
  END IF;

end;
/
