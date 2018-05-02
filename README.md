# README

Passos iniciais:

* Rodar migrações
* Adicionar admin
* AdminUser.create!(email: 'guilhermekfe@outlook.com', password: '111111', password_confirmation: '111111')
* Rodar rake import_products:run
* Rodar rake import_users:run

`heroku pg:copy futuremotors-production::DATABASE DATABASE -a futuremotors-staging`
