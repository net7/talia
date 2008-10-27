config.cache_classes = true
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = true
# Make sure to add the proper value for your host, i.e. talia.local could be replaced with localhost.
# Then make sure to add assets0 to assets3 to your /etc/hosts and flush the DNS cache of your Operating System
config.action_controller.asset_host                  = "http://assets%d.talia.local"
