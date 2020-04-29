create or replace trigger operacion.T_TIPTRABAJO_BUID
before insert or update or delete on OPERACION.TIPTRABAJO
for each row
    /**********************************************************
    NOMBRE:       OPERACION.T_TIPTRABAJO_BUID
    PROPOSITO:

    REVISIONES:
    Ver        Fecha        Autor           Solicitado por  Descripcion
    ---------  ----------  ---------------  --------------  ----------------------

    1.0       26/01/2011  Alexander Yong  Miguel Londoña   REQ-120528: Creación
    2.0       29/04/2012  Edilberto Astulle    Edilberto Astulle     PROY-1483_Agendamiento para Mantenimiento e Instalaciones de proveedores
    3.0       29/04/2012  Edilberto Astulle    Edilberto Astulle     PROY_4191_Cambio Work Flow CE HFC
    4.0       09/02/2016  Emma Guzman          Lizbeth Portella      PROY- 22818 -IDEA-28605 Administración y manejo de cuadrillas  - TOA Fase 2 ¿ Claro Empresas
    ***********************************************************/

declare
    ls_accion     varchar2(3);
begin
  If updating Then
    ls_accion := 'UPD';
    INSERT INTO HISTORICO.TIPTRABAJO_LOG
    VALUES
      (:OLD.TIPTRA,
       :OLD.TIPTRS,
       :OLD.DESCRIPCION,
       SYSDATE,
       USER,
       :OLD.CUENTA,
       :OLD.CODDPT,
       :OLD.FLGCOM,
       :OLD.FLGPRYINT,
       :OLD.CODMOTINSSRV,
       :OLD.SOTFACTURABLE,
       :OLD.BLOQUEO_DESBLOQUEO,
       LS_ACCION,
       :OLD.CORPORATIVO, --2.0
       :OLD.SELPUNTOSSOT, --3.0
       :OLD.ID_TIPO_ORDEN, --4.0
       :OLD.ID_TIPO_ORDEN_CE -- 4.0
       );
  End If;
  If deleting Then
    ls_accion := 'DEL';
    INSERT INTO HISTORICO.TIPTRABAJO_LOG
    VALUES
      (:OLD.TIPTRA,
       :OLD.TIPTRS,
       :OLD.DESCRIPCION,
       SYSDATE,
       USER,
       :OLD.CUENTA,
       :OLD.CODDPT,
       :OLD.FLGCOM,
       :OLD.FLGPRYINT,
       :OLD.CODMOTINSSRV,
       :OLD.SOTFACTURABLE,
       :OLD.BLOQUEO_DESBLOQUEO,
       LS_ACCION,
       :OLD.CORPORATIVO, --2.0
       :OLD.SELPUNTOSSOT, --3.0
       :OLD.ID_TIPO_ORDEN, --4.0
       :OLD.ID_TIPO_ORDEN_CE -- 4.0
       );
  End If;
  If inserting Then
    ls_accion := 'INS';
    INSERT INTO HISTORICO.TIPTRABAJO_LOG
    VALUES
      (:NEW.TIPTRA,
       :NEW.TIPTRS,
       :NEW.DESCRIPCION,
       SYSDATE,
       USER,
       :NEW.CUENTA,
       :NEW.CODDPT,
       :NEW.FLGCOM,
       :NEW.FLGPRYINT,
       :NEW.CODMOTINSSRV,
       :NEW.SOTFACTURABLE,
       :NEW.BLOQUEO_DESBLOQUEO,
       LS_ACCION,
       :NEW.CORPORATIVO, --2.0
       :NEW.SELPUNTOSSOT, --3.0
       :NEW.ID_TIPO_ORDEN, --4.0
       :NEW.ID_TIPO_ORDEN_CE -- 4.0
       );
  End If;
end;
/