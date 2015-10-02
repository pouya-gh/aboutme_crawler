module AboutmeCrawler
  ##
  # This method is a helper for the executable.
  # It builds a session skeleton.
  # Example:
  #   >> AboutmeCrawler.make_project_skeleton('finding_private_ryan')
  # Arguments:
  #     prj_name: (String)
  def self.make_project_skeleton(prj_name)
    Dir.mkdir("./#{prj_name}")
    Dir.mkdir("./#{prj_name}/#{PROJECT_STRUCTURE[:dirs][0]}")
    File.open("./#{prj_name}/#{PROJECT_STRUCTURE[:files][0]}", 'w').puts(DEFAULT_SETTINGS)
  end
end
