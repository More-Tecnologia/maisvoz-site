# README

## Passos iniciais:

```
rake import_cities:run
```

`heroku pg:copy futuremotors-production::DATABASE DATABASE -a futuremotors-staging`

## Tasks que devem ser agendadas

```
rake users_still_active:verify (todo dia)
```
