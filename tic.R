get_stage("install") %>%
  add_step(step_install_github("trendecon/trendecon"))

get_stage("before_deploy") %>%
  add_step(step_setup_ssh()) %>%
  add_step(step_setup_push_deploy())

get_stage("deploy") %>%
  add_code_step(withr::with_package("trendecon", proc_trendecon_ch())) %>% I
  #add_step(step_do_push_deploy())