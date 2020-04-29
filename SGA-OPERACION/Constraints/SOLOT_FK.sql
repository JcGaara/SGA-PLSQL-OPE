ALTER TABLE OPERACION.SOLOT ADD (
  CONSTRAINT FK_PLANTRABAJO_SOLOT 
 FOREIGN KEY (PLAN) 
 REFERENCES OPERACION.PLANTRABAJO (PLAN),
  CONSTRAINT FK_SOLOT_AREA 
 FOREIGN KEY (AREASOL) 
 REFERENCES OPERACION.AREAOPE (AREA),
  CONSTRAINT FK_SOLOT_CLIENTEINT 
 FOREIGN KEY (CLIINT) 
 REFERENCES OPERACION.CLIENTEINT (CLIINT),
  CONSTRAINT FK_SOLOT_ESTSOL 
 FOREIGN KEY (ESTSOL) 
 REFERENCES OPERACION.ESTSOL (ESTSOL),
  CONSTRAINT FK_SOLOT_ESTSOLOPE 
 FOREIGN KEY (ESTSOLOPE) 
 REFERENCES OPERACION.ESTSOLOPE (ESTSOLOPE),
  CONSTRAINT FK_SOLOT_MOTOT 
 FOREIGN KEY (CODMOTOT) 
 REFERENCES OPERACION.MOTOT (CODMOTOT),
  CONSTRAINT FK_SOLOT_PRECIARIO 
 FOREIGN KEY (CODPREC) 
 REFERENCES OPERACION.PRECIARIO (CODPREC),
  CONSTRAINT FK_SOLOT_TIPTRABAJO 
 FOREIGN KEY (TIPTRA) 
 REFERENCES OPERACION.TIPTRABAJO (TIPTRA));
