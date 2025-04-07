insert into currency values
 ('EUR','Euro', 'â‚¬')
,('USD','US Dollar', '$')
,('GBP','Pound Sterling', 'Â£')
,('JPY','Yen', 'Â¥')
;

INSERT INTO tipi_movimento (name, amm_role_req) values 
 ('ACQUISTO_PRODOTTO', FALSE)
,('VENDITA_PRODOTTO', FALSE)
,('ACQUISTO_SERVIZIO', FALSE)
,('VENDITA_SERVIZIO', FALSE)
,('DEPOSITO_CONTANTI', FALSE)
,('PRELIEVO_CONTANTI', FALSE)
,('BONIFICO_ENTRATA', FALSE)
,('BONIFICO_USCITA', FALSE)
,('DEPOSITO_CON_CARTA', FALSE)
,('PRELIEVO_CON_CARTA', FALSE)
,('DEPOSITO_DA_WALLET', FALSE)
,('PRELIEVO_DA_WALLET', FALSE)
,('TRASF_USCITA_DA_WALLETT', FALSE)
,('TRASF_INGRESSO_DA_WALLETT', FALSE)
,('ADJUSTMENT_POSITIVO', TRUE)
,('ADJUSTMENT_NEGATIVO', TRUE)
;

insert levels (LEVEL_COD, LEVEL_NAME) values
('N', 'New'),
('A', 'Affluence'),
('R', 'Retail'),
('P', 'Premiere'),
('V', 'Vip'),
('VP', 'Vip-Plus'),
('O', 'Other');
