# Define a policy, with a unique identifier. 
#
# The policy id is prefixed by a "collection" parameter. Typical values
# for the collection are:
# 
# * myname@localhost - a development policy
# * ci - continuous integration
# * production - production policy
#
# Therefore, multiple copies of this policy can be created, each with 
# a different collection prefix corresponding to the deployment environment.
# 
# A policy is itself a role, which owns all the records created in the policy document.
# The policy role is in turn owned by the "owner" command-line parameter specified 
# in the CLI command "conjur policy load". Therefore, the owner owns the policy, and the
# policy owns everything in the policy. The owner transitively owns all these things too.
policy 'sdf-gen-listy-1.1' do
  # Define a 'webservice' resource to protect the webapp.
  # Inbound requests to the webapp will be intercepted by a gatekeeper, which will 
  # check that the inbound role has the necessary privilege corresponding to the HTTP method.
  webapp_service = resource "webservice", "webapp"
  # Define a 'webservice' resource to protect the backend.
  backend_service = resource "webservice", "backend"

  # User group who can 'admin' the webapp.
  # This group can read, create, and update.
  group "admin" do
    %w(read create update).each do |privilege|
      can privilege, webapp_service
    end
  end

  # User group who can 'use' the webapp.
  # This group can only read.
  group "users" do
    %w(read create update).each do |privilege|
      can privilege, webapp_service
    end
  end

  # Machines in the webapp. These machines are privileged to read,
  # create, and update the backend.
  layer 'webapp' do
    %w(read create update).each do |privilege|
      can privilege, backend_service
    end
  end
end
