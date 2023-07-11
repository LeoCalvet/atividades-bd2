CREATE OR REPLACE FUNCTION DiminuirSalario(cpf_funcionario VARCHAR, percentual INT) RETURNS VOID AS $$
BEGIN
    UPDATE funcionario
    SET salario = salario - (salario * (percentual::numeric / 100))
    WHERE cpf = cpf_funcionario;
END;
$$ LANGUAGE plpgsql;
