#!/bin/bash

set -e # Exit on errors

# Variables
APP_NAME="your-app-name" # Replace with your desired Heroku app name

echo "==== Starting Heroku Deployment ===="

# Step 1: Login to Heroku
echo "Logging into Heroku..."
heroku login

# Step 2: Create Heroku App
echo "Creating Heroku app: $APP_NAME..."
heroku create $APP_NAME

# Step 3: Add Heroku Remote
echo "Adding Heroku remote..."
git remote add heroku https://git.heroku.com/$APP_NAME.git

# Step 4: Set Buildpacks
echo "Setting Heroku buildpacks..."
heroku buildpacks:set heroku/ruby
heroku buildpacks:add --index 1 heroku/nodejs

# Step 5: Update Database Configuration
echo "Updating production database configuration in config/database.yml..."
sed -i '' '/production:/,/pool:/c\
production:\n\
  adapter: postgresql\n\
  encoding: unicode\n\
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>\n\
  url: <%= ENV['DATABASE_URL'] %>
' config/database.yml

# Step 6: Install Required Gems
echo "Installing required gems..."
bundle install

# Step 7: Add Changes to Git
echo "Committing changes..."
git add .
git commit -m "Prepare app for Heroku deployment"

# Step 8: Push to Heroku
echo "Pushing code to Heroku..."
git push heroku main

# Step 9: Migrate Database
echo "Running database migrations on Heroku..."
heroku run rails db:migrate

# Step 10: Seed Database (Optional)
read -p "Do you want to seed the database? (y/n): " SEED_DB
if [[ $SEED_DB == "y" || $SEED_DB == "Y" ]]; then
  echo "Seeding database..."
  heroku run rails db:seed
fi

# Step 11: Open App
echo "Opening app in the browser..."
heroku open

# Step 12: Monitor Logs (Optional)
read -p "Do you want to view logs now? (y/n): " VIEW_LOGS
if [[ $VIEW_LOGS == "y" || $VIEW_LOGS == "Y" ]]; then
  echo "Monitoring logs..."
  heroku logs --tail
fi

echo "==== Deployment Completed Successfully! ===="
