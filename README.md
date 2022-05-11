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
# Live Reload
  "Live reload make the rails aplication auto refresh after a edition in one of its files"
SETUP  
- Run the command: 
* bundle
START
- Run the commands:
* rails s
* bundle exec guard
DEPENDENCYS
- Instal extension for the browser:
* For Chrome: https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei
* For Mozila Firefox: https://addons.mozilla.org/pt-BR/firefox/addon/livereload-web-extension/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search
* For other browsers: Search for a extension named "Livereload"
```
