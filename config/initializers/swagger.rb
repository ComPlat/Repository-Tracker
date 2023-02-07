# Overwrites the defaults for the Swagger UI
GrapeSwaggerRails.options.tap do |options|
  options.url = "api/swagger_doc.json"
  options.app_url = ENV["HOST_URI"]
end
