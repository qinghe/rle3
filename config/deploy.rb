set :application, "RLE3"

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :repository,  "git@github.com:qinghe/rle3.git"
set :scm, :git
set :scm_passphrase, "a12345z"  # The deploy user's password
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "root"
set :use_sudo, false
set :deploy_to, "/var/www"

server "114.112.177.227", :app, :web, :db, :primary => true
#role :web, "114.112.177.227"                          # Your HTTP server, Apache/etc
#role :app, "114.112.177.227"                          # This may be the same as your `Web` server
#role :db,  "114.112.177.227", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"
ssh_options[:forward_agent] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end