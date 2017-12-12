require 'xcodeproj'

project_path = ARGV[0]

if project_path != nil 
	project = Xcodeproj::Project.open(project_path)
	main_target = project.targets.first
	phase = main_target.new_shell_script_build_phase("Strip framework")
	phase.shell_script = "sh ${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/ApiRTC.framework/strip.sh"
	project.save()
end


