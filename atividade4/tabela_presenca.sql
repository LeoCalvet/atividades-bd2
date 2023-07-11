CREATE TABLE presenca (
    cpf VARCHAR(11) NOT NULL,
    data_presenca DATE NOT NULL,
    justificativa TEXT,
    FOREIGN KEY (cpf) REFERENCES funcionario(cpf)
);
