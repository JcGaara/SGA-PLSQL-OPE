ALTER TABLE OPERACION.ACCESO_DETALLE_URL ADD (
  CONSTRAINT ACCESO_DETALLE_URL_FK 
 FOREIGN KEY (CID) 
 REFERENCES METASOLV.ACCESO (CID)
    ON DELETE CASCADE);
