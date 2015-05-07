#!/bin/bash
APP_PATH=/var/www
RVM_WRAPPERS_PATH=/usr/local/rvm/wrappers/ruby-2.1.0@ecommerce
RVM_SUDO_PATH=/usr/local/rvm/bin/rvmsudo

RAILS_ENV=$1
DATABASE_URL=postgres://ecommerce_user:ecommerce_pass@localhost:5432/ecommerce

if [ -z $RAILS_ENV ]; then
  RAILS_ENV=development
fi

#Create environment
su - vagrant -c "cd $APP_PATH; echo \"2.1.0\" > .ruby-version"
su - vagrant -c "cd $APP_PATH; echo \"ecommerce\" > .ruby-gemset"
su - vagrant -c "cd $APP_PATH; echo $RAILS_ENV > .ruby-env"

database=sqlite
if [ "$RAILS_ENV" == "production" ]; then
  database=postgresql
fi

su - vagrant -c "cd $APP_PATH; echo 'RAILS_ENV=$RAILS_ENV' > .env"
su - vagrant -c "cd $APP_PATH; echo 'RAILS_DB=$database' >> .env"

#Setup project
su - vagrant -c "cd $APP_PATH; $RVM_WRAPPERS_PATH/gem install bundler"
su - vagrant -c "cd $APP_PATH; rm .bundle/config"

if [ "$RAILS_ENV" == "production" ]; then
  su - vagrant -c "cd $APP_PATH; echo 'DATABASE_URL=$DATABASE_URL' >> .env"
  su - vagrant -c "cd $APP_PATH; $RVM_WRAPPERS_PATH/bundle install --without development test"
else
  su - vagrant -c "cd $APP_PATH; $RVM_WRAPPERS_PATH/bundle install --without production"
fi

if [ -z $SECRET_KEY_BASE ]; then
  su - vagrant -c "cd $APP_PATH; $RVM_WRAPPERS_PATH/rake secret > .ruby-secret"
  SECRET_KEY_BASE=`cat $APP_PATH/.ruby-secret`
  su - vagrant -c "cd $APP_PATH; echo 'SECRET_KEY_BASE=$SECRET_KEY_BASE' >> .env"
fi

if [ "$RAILS_ENV" == "production" ]; then
  project_parameters=`echo " RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE=$SECRET_KEY_BASE RAILS_DB=$database DATABASE_URL=$DATABASE_URL "`
else
  project_parameters=`echo " RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE=$SECRET_KEY_BASE RAILS_DB=$database "`
  su - vagrant -c "cd $APP_PATH; $RVM_WRAPPERS_PATH/rake db:create $project_parameters"
fi

su - vagrant -c "cd $APP_PATH; $RVM_WRAPPERS_PATH/rake db:migrate $project_parameters"
su - vagrant -c "cd $APP_PATH; $RVM_WRAPPERS_PATH/rake db:seed $project_parameters"

if [ "$RAILS_ENV" == "production" ]; then
  su - vagrant -c "cd $APP_PATH; $RVM_WRAPPERS_PATH/rake assets:precompile $project_parameters"
fi


#Set foreman file
su - vagrant -c "echo 'web: $RVM_WRAPPERS_PATH/bundle exec unicorn -c $APP_PATH/config/unicorn.rb -E $RAILS_ENV' > $APP_PATH/Procfile"
su - vagrant -c "echo 'nginx: /usr/sbin/nginx -c /etc/nginx/nginx.conf' >> $APP_PATH/Procfile"

su - vagrant -c "cd $APP_PATH; $RVM_SUDO_PATH $RVM_WRAPPERS_PATH/bundle exec foreman export upstart --app=ecommerce --user=root /etc/init"
su -c "start ecommerce"