ALTER TABLE OPERACION.SOLOTPTOEQU ADD(PEP_PE05 VARCHAR2(40), PEPLEASING_PE05 VARCHAR2(40), CENTROSAP_PE05 VARCHAR2(40));
ALTER TABLE OPERACION.SOLOTPTOEQUCMP ADD(PEP_PE05 VARCHAR2(40), PEPLEASING_PE05 VARCHAR2(40));
ALTER TABLE OPERACION.SOLOTPTOETAACT ADD(PEP_PE05 VARCHAR2(40));
ALTER TABLE OPERACION.SOLOTPTOETAMAT ADD(PEPINVERSION_PE05 VARCHAR2(40));
ALTER TABLE OPERACION.DESPACHO_MASIVO ADD(PEP_PE05 VARCHAR2(40), PEPLEASING_PE05 VARCHAR2(40), CENTROSAP_PE05 VARCHAR2(40));
ALTER TABLE OPERACION.SOLOT_PEP_ANTERIOR ADD ELEMENTOPEP_PE05 VARCHAR2(40);



