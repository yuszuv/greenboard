# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "gruenes-brett"
set :repo_url, "git@sternprodukt.de:gruenes-brett.git"

set :rvm_ruby_version, '3.0.2'      # Defaults to: 'default'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v12.18.3'
set :nvm_map_bins, %w{node npm yarn}

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, ".env.production"

# Default value for linked_dirs is []
append :linked_dirs,
  "log",
  "node_modules",
  "tmp/pids",
  "tmp/cache",
  "tmp/sockets",
  "public/uploads",
  "public/assets"

append :linked_dirs, '.bundle'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { hanami_env: 'production' }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc "Build assets with yarn"
  task :assets do
    on roles(:app) do |_host|
      within current_path do
        execute :yarn, 'install'
        execute :yarn, 'run build'
      end
    end
  end
end

after 'deploy:updated', 'deploy:assets'
after 'deploy:published', 'sidekiq:restart'
