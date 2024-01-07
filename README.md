API endpoints:
/transactions(.:format)      transactions#index    endpoint to grab all transactions
/transactions(.:format)      transactions#create   endpoint to create transaction
/transactions/:id(.:format)  transactions#show     endpoint to show transaction
/transactions/:id(.:format)  transactions#update   endpoint to update transaction
/transactions/:id(.:format)  transactions#destroy  endpoint to delete transaction

In order to add vue I have used following commands:
npm create vite@latest
and then selected 
client => vue => javascript
To make it run, I have run npm install
and when running npm run dev and go to http://localhost:5173/ page can be seen

I have created seed file to have already something in the database. 

I have also added Dockerfile for both app and client and by starting docker-compose build in main folder and then docker-compose up, it is possible to go to 
http://localhost:3000/transactions/
On page it is possible to click button to run migrations. After that page is visible with []
Seeds can be run with docker-compose run app rake db:seed
Now it is possible to go to http://localhost:5173/ and see application
In application it is possible to create new Transaction, edit or delete exisiting one.
When amount, description or date is missing, transaction is not created and warrning is displayed. 

Optimizations: format of date is not checked
Assumpions: amount can be both plus or minus, 0 is treated as missing amount.