ALTER TABLE operacion.sgat_df_transaccion_det
    ADD CONSTRAINT fk_trsd_trsc FOREIGN KEY ( trsdn_idtrs )
        REFERENCES operacion.sgat_df_transaccion_cab ( trscn_idtrs );
