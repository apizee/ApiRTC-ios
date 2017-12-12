require 'xcodeproj'
path_to_project = "ApiRTCApp.xcodeproj"
project = Xcodeproj::Project.open(path_to_project)
main_target = project.targets.first
phase = main_target.new_shell_script_build_phase("Strip framework")
phase.shell_script = "sh ${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/ApiRTC.framework/strip.sh"
project.save()