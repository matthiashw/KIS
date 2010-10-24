# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_KIS.github_session',
  :secret      => '91f19748ce279d131eabe4a05ed2a65bee06432f784f9def63f03611152bcc89e62150ab3b7c6d709bedb5c5e0821a47cb322b42246f24de906e2e9b668f5241'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
