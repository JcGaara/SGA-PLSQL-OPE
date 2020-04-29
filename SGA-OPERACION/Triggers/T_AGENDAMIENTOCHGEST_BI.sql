CREATE OR REPLACE TRIGGER OPERACION.T_AGENDAMIENTOCHGEST_BI
BEFORE INSERT
ON OPERACION.AGENDAMIENTOCHGEST
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_AGENDAMIENTO_AIUD
   PROPOSITO:  Genera codigo secuencial de agendamiento

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2010  Marcos Echevarria REQ. 107706: Se Inserta el codigo secuencial en cambio de estado de agendamiento
   **************************************************************************/
BEGIN
    if :new.idseq is null then
      select SQ_AGENDAMIENTOCHEST.nextval into :new.idseq from dummy_ope;
  end if;
END;
/



