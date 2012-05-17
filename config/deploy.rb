require "bundler/capistrano"

set :application, "RESTTalk"
set :repository,  "."
set :scm, :none
set :branch, "master"
set :scm_verbose, true

set :deploy_to, "/opt/deploy/talk"
set :user, "deploy"
set :deploy_via, :copy
set :default_shell, "/bin/bash"
set :use_sudo, false

namespace :bundle do
  task :install, :roles=>:app do
       run <<-CMD
        cd #{release_path} &&
        #{sudo} bundle install --system
      CMD

  end
end

namespace :db do
  task :show_tasks do
    run("cd #{deploy_to}/current; /usr/local/bin/rake -T")
  end

  task :seed do
    run("cd #{deploy_to}/current; /usr/local/bin/rake db:seed")
  end

  task :automigrate do
    run("cd #{deploy_to}/current; /usr/local/bin/rake db:automigrate")
  end

  task :autoupgrade do
    run("cd #{deploy_to}/current; /usr/local/bin/rake db:autoupgrade")
  end

  task :dump_data do
      run("cd #{deploy_to}/current; /usr/local/bin/rake db:dump_data")
  end


end

namespace :deploy do
  task :restart, :roles =>:app do
    run "#{sudo} /etc/init.d/thin restart"
  end
  # This will make sure that Capistrano doesn't try to run rake:migrate (this is not a Rails project!)
  task :cold do
    deploy.update
    deploy.start
  end
end

desc "run tasks in production"
task :production do
  set :default_environment, {
      'RACK_ENV' => "production"
  }
  server "deploy_server", :web, :app
end


desc "run tasks in production"
task :dev do
  set :default_environment, {
    'RACK_ENV' => "dev"
  }
  server "dev_deploy_server", :web, :app
end
