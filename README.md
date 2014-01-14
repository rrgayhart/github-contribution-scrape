Github Scraper

Sinatra Application that Pulls Public Github Contribution Information.

Production link is: http://github-history.herokuapp.com

To see the open source contribution history for a user, visit '/users/:githubusername'

**Testing**

Testing for the application is run with MiniTest

```
rake test
```

**Database**

The application uses Postgres in all environments. We also use the Sinatra Active Record gem

1. Install postgresql with: `brew install postgresql` or `apt-get install postgresql-9.2`
2. Presuming you have Postgres installed (if not: `brew install postgres`):
3. Run the database migrations with `rake db:migrate

![alt text](https://github.com/rrgayhart/github-contribution-scrape/blob/presentation/screenshot1.jpg?raw=true "Title")