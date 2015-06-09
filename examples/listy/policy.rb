policy 'sdf-gen-listy-1.0' do
  # Protects the webapp
  webapp_service = resource "webservice", "webapp"
  # Protects the backend
  backend_service = resource "webservice", "backend"

  # User group who can use the webapp
  group "users" do
    %w(read create update).each do |privilege|
      can privilege, webapp_service
    end
  end

  # Machines in the webapp
  layer 'webapp' do
    # webapp can read, create, update the backend
    %w(read create update).each do |privilege|
      can privilege, backend_service
    end
  end
end
