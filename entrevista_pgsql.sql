-- Lista de funcionários ordenando pelo salário decrescente.
select nome, cargo, salario, data_admissao, inativo from vendedores order by salario desc;

-- Lista de pedidos de vendas ordenado por data de emissão.
select id_pedido, id_empresa, id_cliente, valor_total, data_emissao, situacao from pedido order by data_emissao;

-- Valor de faturamento por cliente.
select sum(valor_total) from pedido group by id_cliente
-- Valor de faturamento por empresa.
select sum(valor_total) from pedido group by id_empresa
-- Valor de faturamento por vendedor.

SELECT 
    v.id_vendedor,
    v.nome AS nome_vendedor,
    SUM(ip.preco_praticado * ip.quantidade) AS faturamento_total
FROM 
    itens_pedido ip
inner join
	config_preco_produto cp on cp.id_produto = ip.id_produto
inner join 
	pedido p on p.id_pedido = ip.id_pedido
inner join
    clientes c ON p.id_cliente = c.id_cliente
inner join
	vendedores v on c.id_cliente = v.id_vendedor
GROUP BY 
    v.id_vendedor, v.nome;



SELECT 
    p.id_produto,
    p.descricao AS descricao_produto,
    c.id_cliente,
    c.razao_social AS rs_cliente,
    emp.id_empresa,
    emp.razao_social AS rs_empresa,
    v.id_vendedor,
    v.nome AS nome_vendedor,
    MIN(cp.preco_minimo) AS min_config,
    MAX(cp.preco_maximo) AS max_config,
    COALESCE(MAX(ip.preco_praticado), MIN(cp.preco_minimo)) AS preco_base
FROM 
    CLIENTES c
INNER JOIN 
    PEDIDO pd ON c.id_cliente = pd.id_cliente
INNER JOIN 
    ITENS_PEDIDO ip ON pd.id_pedido = ip.id_pedido
INNER JOIN 
    PRODUTOS p ON ip.id_produto = p.id_produto
LEFT JOIN 
    CONFIG_PRECO_PRODUTO cp ON ip.id_produto = cp.id_produto 
LEFT JOIN 
    EMPRESA emp ON cp.id_empresa = emp.id_empresa

LEFT JOIN 
    VENDEDORES v ON cp.id_vendedor = v.id_vendedor
LEFT JOIN 
    (
        SELECT 
            id_produto,
            MAX(data_emissao) AS ultima_data_emissao
        FROM 
            PEDIDO pd
        INNER JOIN 
            ITENS_PEDIDO ip ON pd.id_pedido = ip.id_pedido
        GROUP BY 
            id_produto
    ) ultima_data ON ip.id_produto = ultima_data.id_produto AND pd.data_emissao = ultima_data.ultima_data_emissao
GROUP BY 
    p.id_produto, c.id_cliente, emp.id_empresa, v.id_vendedor;


