output "user_ids" {
  description = "IDs des utilisateurs de service, par tier."
  value = {
    presentation = openstack_identity_user_v3.presentation.id
    application  = openstack_identity_user_v3.application.id
    data         = openstack_identity_user_v3.data.id
  }
}
