# README

## Passos iniciais:

```
rake import_cities:run
```

## Tasks que devem ser agendadas

```
# Ativação dos usuários (todo dia)
users_still_active:verify

# Verificar pagamento do boleto (a cada 6h)
payment:check

# Remover pedidos com boleto vencido (todo dia)
payment:expired

# Limpar pedidos no abandonados carrinho (todo dia)
shopping:clear_cart
```
