SimpleCov.start 'rails' do
  # any custom configs like groups and filters can be here at a central place
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Long files" do |src_file|
    src_file.lines.count > 100
  end
  add_group "Multiple Files", ["app/models", "app/controllers"] # You can also pass in an array
  #add_group "Short files", LineFilter.new(5) # Using the LineFilter class defined in Filters section above

end
