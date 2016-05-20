# Deploy hook forker

Many hosting services, like Heroku, only allow you to have one HTTP deploy hook. We needed more so we wrote this app. This app accepts a post to /:app and forwards the post and its params to all the urls listed for that app in the config file.

# Usage

### Clone this app

```sh
git clone https://github.com/deadlyicon/deploy-hook-forker.git
cd deploy-hook-forker
```

### Modify the config file

```yaml
your-heroku-app-name:
  slack: https://other.slack.com/services/hooks/heroku?token=<%= ENV["SLACK_TOKEN"] %>
  appsignal: https://push.appsignal.com/1/markers/heroku?api_key=<%= ENV["APP_SIGNAL_API_KEY"] %>
  honeybadger: https://api.honeybadger.io/v1/deploys?deploy[environment]=production&api_key=<%= ENV["HONEYBADGER_API_KEY"] %>
another-heroku-app-name:
  honeybadger: https://api.honeybadger.io/v1/deploys?deploy[environment]=staging&api_key=<%= ENV["HONEYBADGER_API_KEY"] %>
```

### Push it up to heroku

```sh
heroku apps:create ${COMPANY_NAME}-deploy-hook-forker
```

### Point your app's HTTP deploy hook to the new deploy hook forker app

```sh
heroku addons:create deployhooks:http --url=https://${COMPANY_NAME}-deploy-hook-forker.herokuapp.com
```


## References

[Heroku deploy hook docs](https://devcenter.heroku.com/articles/deploy-hooks)
