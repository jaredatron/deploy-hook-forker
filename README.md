# Deploy hook forker

Many hosting services, like Heroku, only allow you to have one HTTP deploy hook. We needed more so we wrote this app. This app accepts a post to /:app and forward the post and it's params to all the urls listed for that app in the config file.

# Usage

### Clone this app

```sh
git clone https://github.com/deadlyicon/deploy-hook-forker.git
cd deploy-hook-forker
```

### Modify the config file

```yaml
your-heroku-app-name:
  slack: https://other.slack.com/services/hooks/heroku?token=INTENTIONALLY_LEFT_BLANK
  appsignal: https://push.appsignal.com/1/markers/heroku?api_key=INTENTIONALLY_LEFT_BLANK
  honeybadger: https://api.honeybadger.io/v1/deploys?deploy[environment]=production&api_key=INTENTIONALLY_LEFT_BLANK
another-heroku-app-name:
  honeybadger: https://api.honeybadger.io/v1/deploys?deploy[environment]=staging&api_key=INTENTIONALLY_LEFT_BLANK
```

### Push it up to heroku

```sh
heroku apps:create ${COMPANY_NAME}-deploy-hook-forker
```

### Point your apps HTTP deploy hook to the new deploy hook forker app

```sh
heroku addons:add deployhooks:http --url=http://${COMPANY_NAME}-deploy-hook-forker.herokuapp.com
```


## References

[Heroku deploy hook docs](https://devcenter.heroku.com/articles/deploy-hooks)
