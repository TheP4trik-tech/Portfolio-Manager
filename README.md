# Personal Finance Manager
*About
Portfolio summary application, that automatically fetches the data of your stock brokers (currently Etoro and Trading212).
Converts that into unified EUR snapshots and displays them in Lightweight chart and notifies user via Mail, even if the API fetch goes wrong.


## Tech used
* Rails 8
* Devise + googleauth2 (authentication)
* CanCanCan (authorization)
* Resend API (used for sending mails)
* Solid Queue (background jobs)
* Tailwindcss & DaisyUI (frontend design)
* Faraday (API calls)
* RSpec, Faker, Factory bot, webmock (testing)
* rackattack (security)
* Deployed via Kamal and Hetzner VPS -> http://railsfinancemanager.online


## Main functionality
* API connections via User broker API keys
* Automatic snapshot currency to EUR exchange (Franfurt API)
* Automatic backgrounds jobs (each hour) once user enter this API creds.
* Cash snapshots review 


## Setup
1. Clone repo
2. rename.env.example to .env
3. Generate Active Record Encryption keys (optional, more in .env.example)
4. `docker compose up --build`
5. console - docker compose exec web bin/rails console, bash - docker compose exec web bash
6. Thats it :)

## Notes
- Google OAuth doesnt work unless you create yours https://developers.google.com/identity/protocols/oauth2
- Mails are caught in mailcatcher, you can visit it there http://localhost:1080
- Rails console: `docker compose exec web bin/rails console` (jobs are running when docker compose command used)

# If you have any issues or ideas, write them in discussion, ill be glad to hear that :)